package main

import "io/ioutil"
import "unicode"
import "flag"
import "fmt"

type filedata struct {
	lines int
	words int
	bytes int
}

func main() {
	line := flag.Bool("l", false, "print number of newlines")
	words := flag.Bool("w", false, "Print number of words in file")
	bytes := flag.Bool("b", false, "Print number of bytes in a file")
	flag.Parse()

	for _, name := range flag.Args() {
		f := countFile(name)
		if *line {
			print(" ", f.lines)
		}
		if *words {
			print(" ", f.words)
		}
		if *bytes {
			print(" ", f.bytes)
		}

		if !(*line || *words || *bytes) {
			fmt.Printf("%+v", f)
		}
		println(" ", name)
	}
}

func countFile(filename string) filedata {
	f := filedata{}
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}
	f.bytes = len(content)
	w := false
	for _, b := range content {
		if unicode.IsSpace(rune(b)) {
			if b == 10 {
				f.lines++
			}
			if w {
				w = false
				f.words++
			}
		} else if b < 255 {
			w = true
		}
	}
	return f
}
