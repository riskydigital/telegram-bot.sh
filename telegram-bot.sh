#!/bin/sh
# Telegram bot written in shell scripting.
# Forked from RG72/telegram-bot-bash , topkecleon/telegram-bot-bash

SCRIPT_NAME=$(basename $0)
VERSION="0.2"

TOKEN=""
OWNER=""
OWNER_CHATID=""
DEVICE="$HOSTNAME"

SCRIPT_DIR=$(dirname $0)
CONFIG_DIR="$HOME/.config/tbot"
MODULE_DIR="$SCRIPT_DIR/modules"
CHAT_DIR="$CONFIG_DIR/chats"

CONFIG_FILE="$CONFIG_DIR/config"
LOCK_FILE="/tmp/lock"

NOTIFY_LOGIN=yes
NOTIFY_OWNER=yes
REPLY_ANYONE=yes
ENABLE_COMMANDS=yes
ENABLE_SLEEP=yes

CYCLE_SLEEP_TIME=2
STANDBY_SLEEP_TIME=1
STANDBY_TIME=30
TIMEOUT=10

#### text output functions #####################################################

QUIET_FLAG=no
DEBUG_FLAG=no

echoc ()
{
  [ $QUIET_FLAG = no ] && echo -e "\E["$1"m$2\E[0m"
}

debug () 
{
  [ $DEBUG_FLAG = yes ] && echoc 31 "$*"
}

info ()
{
  echoc 30 "$*"
}

error ()
{
  echoc 32 "$*"
}

#### telegram I/O functions ####################################################

JSON="$SCRIPT_DIR/JSON.sh"
URL_TELEGRAM='https://api.telegram.org/bot'
HTTPS_EXEC="wget -qO- --no-check-certificate -T $TIMEOUT"

telegram_exec()
{
  $HTTPS_EXEC --post-data="$2" ${URL_TELEGRAM}$TOKEN/$1
}

send_message()
{
  telegram_exec "sendMessage" "chat_id=$1&text=$2" &>/dev/null
}

send_message_all()
{
  CHATS=`ls $CHAT_DIR"/"` &>/dev/null
  for user in $CHATS; do
    source "$CHAT_DIR/$user"
    send_message "$CHATID" "$1"
  done
}

get_message()
{
  ret=$(telegram_exec "getUpdates?offset=$1&limit=1") &>/dev/null

  if [ ! "$ret" == '{"ok":true,"result":[]}' ]; then
    CHATID=$(echo $ret | $JSON | egrep '\["result",0,"message","chat","id"\]' | cut -f 2)
    FROM=$(echo $ret | $JSON | egrep '\["result",0,"message","from","username"\]' | cut -f 2 | cut -d '"' -f 2)
    OFFSET=$(echo $ret | $JSON | egrep '\["result",0,"update_id"\]' | cut -f 2)
    MESSAGE=$(echo $ret | $JSON -s | egrep '\["result",0,"message","text"\]' | cut -f 2 | cut -d '"' -f 2)
    MESSAGE_ID=$(echo $ret | $JSON | egrep '\["result",0,"message","message_id"\]' | cut -f 2 )
    return 0
  fi
  return 1
}

get_bot_username()
{
  ret=$(telegram_exec getMe | $JSON -s | egrep '\["result","username"\]' | cut -f 2 | cut -d '"' -f 2) &>/dev/null
  BOTNAME=$ret
  debug "bot username: $BOTNAME"
}

send_markdown_message()
{
  telegram_exec "$URL_TELEGRAM/sendMessage" "chat_id=$1&text=$2&parse_mode=markdown" &>/dev/null
}

send_doc()
{
  telegram_exec "sendDocument" "chat_id=$1&document=@$2" &>/dev/null
}

send_photo()
{
  telegram_exec "sendPhoto" "chat_id=$1&photo=@$2" &>/dev/null
}

#### option actions ############################################################

opt_run_daemon()
{
  get_bot_username

  [ $NOTIFY_LOGIN ] && send_message_all "$BOTNAME started"

  OFFSET=0
  PREV_TIME=0
  while true; do
    while true; do
      get_message $OFFSET
      [ $? -eq 0 ] && break;
    done

    [ -z "$FROM" ] && continue || echo "[$FROM] >> $MESSAGE"

    CURR_TIME=$(date +%s) #CURR_TIME=$((10#`date +%s`))
    OFFSET=$((OFFSET+1))

    if [ "$FROM" != "$OWNER" ]; then
      [ $NOTIFY_OWNER = yes ] && send_message "$OWNER_CHATID" "user is talking to me: \"$FROM\" => \"$MESSAGE\""
      # TODO reply only to selected users
      [ ! $REPLY_ANYONE = no ] && continue || \
      echo "CHATID=\"$CHATID\"" >> "$CHAT_DIR/$FROM"
    fi

    if [ $OFFSET != 1 ]; then
      # sorry, busybox's ash does not support arrays
      COMMAND=$(echo $MESSAGE | awk '{print $1}')
      ARGUMENTS=$(echo $MESSAGE | awk '{$1=""; print $0}' | cut -c2-)
      found=no
      if [ $ENABLE_COMMANDS = yes ]; then
        for module in $MODULE_DIR/* ; do
            [ -d $module ] && continue
            if grep -q "'$COMMAND')" "$module"; then
              found=yes
              [ -x $module ] && source $module || msg="\"$module\" is disabled"
              break
            fi
        done
        [ $found == no ] && (msg="command not found" && echo $msg)
      fi

      if [ -n "$msg" ]; then
        send_message "$CHATID" "$msg"
      fi
      PREV_TIME=$CURR_TIME
    fi

    #elapsed=$((CURR_TIME-PREV_TIME))
    #if [ $elapsed -le $STANDBY_TIME ]; then
    #  if [ $CYCLE_SLEEP_TIME -gt 0 ]; then
    sleep $CYCLE_SLEEP_TIME
    #  fi
    #else
    #  sleep $STANDBY_SLEEP_TIME
    #fi
  done
}

opt_message()
{
  if [ $ALL_FLAG ]; then
    send_message_all "$TEXT"
  else
    if [ -z $DEST_USER ]; then
      CHATID=$OWNER_CHATID
    else
      source "$CHAT_DIR/$DEST_USER"
    fi
    
    if [ -n "$TEXT" ]; then
      if [ $MARKDOWN_FLAG == no ]; then
        send_message "$CHATID" "$TEXT"
      else
        send_markdown_message "$CHATID" "$TEXT"
      fi
    elif [ -n "$FILE" ]; then
      send_doc "$CHATID" "$FILE"
    elif [ -n "$IMG" ]; then
      send_photo "$CHATID" "$IMG"
    fi
  fi
}

opt_version()
{
  echo "$SCRIPT_NAME-$VERSION"
  exit 0
}

opt_help()
{
  echo "$SCRIPT_NAME-$VERSION"
  echo -e "\nhelp: wip...\n"
  exit 0
}

#### process parameters ########################################################

DAEMON_FLAG=no
if ! type "getopt" &> /dev/null; then
  echo -e "no getopt support, running in as daemon..."
  DAEMON_FLAG=yes
else
  ALL_FLAG=no
  MARKDOWN_FLAG=no
  DEST_USER=""

  OPTIONS=$(getopt -o hvdqDmat:f:i:u: -l help,version,debug,quiet,daemon,markdown,all,text:,file:,img:,user: -- "$@")
  [ $? ] || exit 1
  set -- $OPTIONS

  while [ $# -gt 0 ]; do
    case $1 in
      -v|--version) opt_version;;
      -h|--help) opt_help;;
      -q|--quiet) QUIET_FLAG=yes;;    
      -d|--debug) DEBUG_FLAG=yes;;
      -t|--text) shift; TEXT="$1";;
      -a|--all) ALL_FLAG=yes;;
      -f|--file) shift; FILE="$*";;
      -i|--img) shift; IMG="$*";;
      -u|--user) shift; DEST_USER="$1";;
      -D|--daemon) DAEMON_FLAG=yes;;
      -m|--markdown) MARKDOWN_FLAG=yes;;
      (--) shift; break;;
      (-*) echo "unrecognized option $1" 1>&2; exit 1;;
      (*) break;;
    esac
    shift
  done
  [ -n "$TEXT" ] && DAEMON_FLAG=no
  [ -n "$FILE" ] && DAEMON_FLAG=no
  [ -n "$IMG"  ] && DAEMON_FLAG=no
fi

if [ -f ${CONFIG_FILE} ]; then
  source ${CONFIG_FILE}
  debug "Loading ${CONFIG_FILE} ..."
else
  debug "Please, configure \"${CONFIG_FILE}\" setting TOKEN,OWNER"
  exit 1
fi

[ $DAEMON_FLAG = yes ] && opt_run_daemon || (opt_message && exit 0)
