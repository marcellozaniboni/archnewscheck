package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"runtime"
	"strings"

	"github.com/mmcdole/gofeed"
)

func main() {
	const webUrl string = "https://archlinux.org/news/"
	const rssUrl string = "https://archlinux.org/feeds/news/"

	fp := gofeed.NewParser()
	feed, err := fp.ParseURL(rssUrl)
	if err != nil {
		log.Fatalln("error while reading rss feed:", err)
	}
	fmt.Println(feed.Title)
	for i, item := range feed.Items {
		fmt.Printf("%d: %s - %s\n", i, item.Published[:16], item.Title)
	}
	if len(os.Args) == 2 && os.Args[1] == "i" {
		fmt.Printf("Do you want to try to open the default web browser to read the news (y/N)? ")
		if strings.ToLower(readString()) == "y" {
			fmt.Printf("opening default browser to %s ...", webUrl)
			openUrl(webUrl)
			fmt.Println("done!")
		}
	}
}

func openUrl(url string) {
	var err error
	switch runtime.GOOS {
	case "linux":
		err = exec.Command("xdg-open", url).Start()
	default:
		err = fmt.Errorf("this OS is not supported")
	}
	if err != nil {
		log.Fatalln("error while opening URL:", url, err)
	}
}

func readString() string {
	stdin := bufio.NewReader(os.Stdin)
	input, err := stdin.ReadString('\n')
	if err != nil {
		log.Fatalln("error while readin from standard input: ", err)
	}
	if len(input) > 0 && input[len(input)-1] == '\n' {
		input = input[:len(input)-1]
	}
	if len(input) > 0 && input[len(input)-1] == '\r' {
		input = input[:len(input)-1]
	}
	return input
}
