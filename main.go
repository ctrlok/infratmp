package main

import (
	"fmt"
	"log"

	"github.com/tidwall/evio"
)

// The program is IPv4 only for now
func main() {
	err := startServer()
	if err != nil {
		panic(err.Error())
	}
}

func startServer() error {
	var events evio.Events
	events.NumLoops = -1
	events.Data = func(c evio.Conn, in []byte) (out []byte, action evio.Action) {
		out = []byte(parseColonAndTranslateToMorze(c.RemoteAddr().String()))
		return
	}
	return evio.Serve(events, "tcp://0.0.0.0:5000")
}

const colon byte = 58
const period byte = 46

var periodStr []byte = []byte(".-.-.-")

// morze is a list of strings which are equal to 0..9 in morse code
var morze [][]byte = [][]byte{
	[]byte("-----"),
	[]byte(".----"),
	[]byte("..---"),
	[]byte("...--"),
	[]byte("....-"),
	[]byte("....."),
	[]byte("-...."),
	[]byte("--..."),
	[]byte("---.."),
	[]byte("----."),
}

// ipv4 only
// TODO: add ipv6 support
func parseColonAndTranslateToMorze(s string) (result []byte) {
	for _, c := range []byte(s) {
		// That "if" block is not in switch-case block because of readability reasons. BTW, changing switch-case block in the
		// future may break functionality if we change sequence of blocks.
		if c == colon {
			break
		}
		switch c {
		case period:
			result = append(result, periodStr...)
		case 48, 49, 50, 51, 52, 53, 54, 55, 56, 57:
			result = append(result, morze[c-48]...)
		default:
			err := fmt.Errorf("internal error: expected '1-9.:' symbol in address, but got %s", string(c))
			log.Print(err)
			result = []byte(err.Error())
			return
		}
	}
	return
}
