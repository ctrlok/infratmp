package main

import "testing"

func TestParseColon(t *testing.T) {
	addr := "127.0.0.1:123"
	var res []byte
	res = parseColonAndTranslateToMorze(addr)
	if string(res) != ".----..-----....-.-.------.-.-.------.-.-.-.----" {
		t.Fatalf("Expected %s, but got %s", addr, string(res))
	}

	addr2 := "123"
	var res2 []byte
	res2 = parseColonAndTranslateToMorze(addr2)
	if string(res2) != ".----..---...--" {
		t.Fatalf("Expected %s, but got %s", addr2, string(res2))
	}

	addr3 := "123t"
	var res3 []byte
	res3 = parseColonAndTranslateToMorze(addr3)
	if string(res3) != "internal error: expected '1-9.:' symbol in address, but got t" {
		t.Fatalf("Expected error message, but got %s", string(res3))
	}

}

