#!/bin/sh
# bashbot, the Telegram bot written in bash.
# Authors by @topkecleon, Juan Potato (@awkward_potato) and RG72
# http://github.com/topkecleon/bashbot
# http://github.com/RG72/bashbot
# http://github.com/viralex/bashbot

source ./global
echo "bot_dir: "$(pwd)

OFFSET=0
PREV_TIME=0

get_name &>/dev/null
bot_username=$res
echo "bot_username: $bot_username"

./sendNotify -s0 -t "$bot_username started"

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
    echo "from: $FROM Message: $MESSAGE"

    #args=($MESSAGE)
    #cmd=${args[0]}
    #OPTARG=${args[1]}
    #cmdAr=(${cmd//\@/ })
    #cmd=${cmdAr[0]}
    #toBot=${cmdAr[1]}
    #echo "c:$cmd t:$toBot"
    
    #if [ ! "$toBot" == "" ] && [ ! "$toBot" == "$bot_username" ]; then
    #  echo "To other bot $toBot"
    #  cmd=""
    #fi

    if [ $enable_commands -eq 1 ]; then
      source ./commands
    else
      msg="forbidden"
    fi

    if [ ! -z "$msg" ]; then
      PREV_TIME=$CURR_TIME
      send_message "$TARGET" "$msg"
    fi
  fi

echo $elapsed
  elapsed=$((CURR_TIME-PREV_TIME))
  if [ $elapsed -le $standby ]; then
    if [ $cycle_sleep -gt 0 ]; then
      sleep $cycle_sleep
    fi
  else
    echo "standby: sleep for $standby_sleep ..."
    sleep $standby_sleep
  fi
}
done
