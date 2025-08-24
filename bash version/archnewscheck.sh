#!/usr/bin/env bash
readonly URL="https://archlinux.org/feeds/news/"
readonly DATA_FILE="archnews_temp_rss.xml"
readonly NEWS_LIMIT=4

## returns 0 if the command is not found
function check_command() {
	local cmd=$(which "$1" 2> /dev/null)
	local retval=0
	if [ "$cmd" != "" ]; then
		retval=1
	fi
	echo $retval
}

if [ $(check_command "curl") -eq 0 -o \
	$(check_command "xmllint") -eq 0 -o \
	$(check_command "seq") -eq 0 -o \
	$(check_command "sed") -eq 0 ]; then
	echo "Error: one of the following commands not found: curl, sed, seq, xmllint"
	exit 1
fi

curl -s --retry 3 --retry-delay 5 --retry-all-errors "$URL" > $DATA_FILE
status=$?
if [ "$status" -ne "0" ]; then
	echo "Error: unable to read Arch news feed, try again later"
	exit 1
fi
n_news=$(xmllint --xpath 'count(//rss/channel/item/title/text())' "$DATA_FILE")
for i in $(seq 1 $n_news); do
	echo -n "${i}. "
	xpath_title="//rss/channel/item[$i]/title/text()"
	xpath_link="//rss/channel/item[$i]/link/text()"
	xpath_date="//rss/channel/item[$i]/pubDate/text()"
	title=$(xmllint --nocdata --xpath "$xpath_title" "$DATA_FILE" | sed -e 's/\&gt\;/>/g' | sed -e 's/\&lt\;/</g')
	pub_date=$(xmllint --nocdata --xpath "$xpath_date" "$DATA_FILE" | sed -e 's/ +0000//g')
	link=$(xmllint --nocdata --xpath "$xpath_link" "$DATA_FILE")
	echo "$title [$pub_date]"
	echo "   $link"
	echo
	if [ "$i" -ge "$NEWS_LIMIT" ]; then break; fi
done
rm -f "$DATA_FILE"
