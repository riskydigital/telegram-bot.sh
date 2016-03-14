#!/bin/sh

source ./global.sh

markdown=0
s=0

while getopts ":h :t: :f: :s: :m" opt; do
  case $opt in
    h)
      echo -e "Usage:\n  -t Text of message\n  -f path to file\n  -s stream"
      echo -e "  -n No description\n  -m Text as markdown"
      exit 0
      ;;
    t)
      text="$OPTARG";;
    m)
      markdown=1;;
    s)
      s=$((10#$OPTARG));;
    f)
      file="$OPTARG"
      if [ ! -f "$file" ]; then
        echo "$file not found"
        file=""
      fi
      ;;
    ?)
      echo "Unknown option $OPTARG"
      exit 1;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done

chats=`ls $chat_dir"/"` &>/dev/null
for chat in $chats; do
  stream=`cat "$chat_dir/$chat"`
  stream=$((10#$stream))

  if [ $s -eq $stream ]; then
    #echo -e "---\nchat:$chat\nfile:\"$file\"\nText:\"$msg\"\n---\n"
    if [ $markdown -eq 0 ]; then
      send_message "$chat" "$text" &>/dev/null
    else
      send_markdown_message "$chat" "$text" &>/dev/null
    fi
    if [ ! -z "$file" ]; then
      send_doc "$chat" "$file" &>/dev/null
    fi
  fi
done
