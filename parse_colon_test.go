package main

import (
	"testing"
)

func init() {
	go startServer()
}

func BenchmarkParseColon_RangeByte(b *testing.B) {
	for n := 0; n < b.N; n++ {
		var a []byte
		a = parseColonA("127.0.0.1:5000")
		_ = a
	}
}

func parseColonA(s string) (result []byte) {
	for _, c := range []byte(s) {
		if c == colon {
			return
		}
		result = append(result, c)
	}
	return
}


func BenchmarkParseColon_RangeString(b *testing.B) {
	for n := 0; n < b.N; n++ {
		var a []byte
		a = parseColonB("127.0.0.1:5000")
		_ = a
	}
}

const colonB rune = 58

func parseColonB(s string) (result []byte) {
	for _, c := range s {
		if c == colonB {
			return
		}
		result = append(result, byte(c))
	}
	return
}

