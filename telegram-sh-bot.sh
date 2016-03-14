#!/bin/sh
# bashbot, the Telegram bot written in bash.
# Authors by @topkecleon, Juan Potato (@awkward_potato) and RG72
# http://github.com/topkecleon/bashbot
# http://github.com/RG72/bashbot
# http://github.com/viralex/bashbot

VERSION="0.1"


[ -f config.sh ] && source ./config.sh || (echo "please configure: copy config.sh.orig => config.sh and set token." && exit 1)

[ -f functions.sh ] && source ./functions.sh || ( echo "err... sorry I must go!" && exit 1)

echo "bot_dir: "$(pwd)

get_name &>/dev/null
bot_username=$res
echo "bot_username: $bot_username"
[ $enable_notify_login -eq 1 ] && ./notify.sh -s0 -t "$bot_username started"

OFFSET=0
PREV_TIME=0
while true; do
{
  new_message=0
  while [ $new_message -eq 0 ]; do
    {
      get_message $OFFSET
      if [ ! "$res" == '{"ok":true,"result":[]}' ]; then
        TARGET=$(echo $res | $JSON | egrep '\["result",0,"message","chat","id"\]' | cut -f 2)
        FROM=$(echo $res | $JSON | egrep '\["result",0,"message","from","username"\]' | cut -f 2)
        OFFSET=$(echo $res | $JSON | egrep '\["result",0,"update_id"\]' | cut -f 2)
        MESSAGE=$(echo $res | $JSON -s | egrep '\["result",0,"message","text"\]' | cut -f 2 | cut -d '"' -f 2)
        MESSAGE_ID=$(echo $res | $JSON | egrep '\["result",0,"message","message_id"\]' | cut -f 2 )
        new_message=1
      fi
    } &>/dev/null
  done

  CURR_TIME=$((10#`date +%s`))
  OFFSET=$((OFFSET+1))

  if [ $OFFSET != 1 ]; then
    echo "$OFFSET" > $last_offset_file
    cmd=${MESSAGE[0]}
    args=("${MESSAGE[@]:1}")
    echo "$FROM $MESSAGE"

    msg=""
    if [ $enable_commands -eq 1 ]; then
      for f in $command_dir/* ; do
          if grep -q "'$cmd')" "$f"; then
            echo "command found at: \"$f\"" #disable blocks of commands using exec bit
            [ -x $f ] && source ./$f || msg="command disabled"
            break
          fi
      done
    fi

    if [ ! -z "$msg" ]; then
      PREV_TIME=$CURR_TIME
      send_message "$TARGET" "$msg" &>/dev/null
    fi
  fi

  elapsed=$((CURR_TIME-PREV_TIME))
  if [ $elapsed -le $standby ]; then
    if [ $cycle_sleep -gt 0 ]; then
      sleep $cycle_sleep
    fi
  else
    sleep $standby_sleep
  fi
}
done
