#!/bin/sh
# Telegram bot written in shell scripting
# Original authors by @topkecleon, Juan Potato (@awkward_potato) and RG72
# http://github.com/topkecleon/bashbot
# http://github.com/RG72/telegram-bot-bash
# http://github.com/viralex/telegram-bot.sh
# for ash you need to enable getopt option and -l option in busybox

PNAME=`basename $0`
VERSION="0.1"

#### init
pdir=$(dirname "$0")
[ -f $pdir/config.sh ] && source $pdir/config.sh || (echo "please configure: copy config.sh.orig => config.sh and set token." && exit 1)
[ -f $pdir/functions.sh ] && source $pdir/functions.sh || ( echo "err... sorry I must go!" && exit 1)

#### functions

opt_version()
{
  echo -e "$PNAME-$VERSION"
  exit 0
}

opt_help()
{
  echo -e "$PNAME-$VERSION"
  echo -e "\nhelp:\n"
  exit 0
}

run_daemon()
{
  echo "bot_dir: "$(pwd)

  get_name
  bot_username=$res
  echo "bot_username: $bot_username"
  #[ $enable_notify_login -eq 1 ] && send_message_all "$bot_username started"

  OFFSET=0
  PREV_TIME=0
  while true; do
  {
    while true; do
      get_message $OFFSET
      [ $? == 0 ] && break;
    done

    echo "recv: $FROM $MESSAGE"

    CURR_TIME=`date +%s` #CURR_TIME=$((10#`date +%s`))
    OFFSET=$((OFFSET+1))

    if [ ! "$FROM" == "\"$OWNER\"" ]; then
      echo "you are not the owner!"
      continue
    fi

    if [ $OFFSET != 1 ]; then
      echo "$OFFSET" > $last_offset_file
      # sorry, busybox's ash does not support arrays
      cmd=`echo $MESSAGE | awk '{print $1}'`
      args=`echo $MESSAGE | awk '{$1=""; print $0}' | cut -c2-`
      echo "cmd: \"$cmd\" args: \"$args\""
      command_found=no
      if [ $enable_commands -eq 1 ]; then
        for f in $pdir/$modules_dir/* ; do
            #f="$pdir/$modules_dir/"$(basename $f)
            [ -d $f ] && continue
            if grep -q "'$cmd')" "$f"; then  # or $cmd| or |$cmd
              echo "command found at: \"$f\"" #disable blocks of commands using exec bit
              command_found=yes
              [ -x $f ] && source $f || msg="command disabled"
              break
            fi
        done

        if [ $command_found == no ]; then
          echo "command not found"
          msg="command not found"
        fi
      fi

      if [ ! -z "$msg" ]; then
        PREV_TIME=$CURR_TIME
        send_message "$TARGET" "$msg" &>/dev/null
      fi
    fi

    #elapsed=$((CURR_TIME-PREV_TIME))
    #if [ $elapsed -le $standby ]; then
    #  if [ $cycle_sleep -gt 0 ]; then
        sleep $cycle_sleep
    #  fi
    #else
    #  sleep $standby_sleep
    #fi
  }
  done
}

opt_message()
{
  s=0
  chats=`ls $chat_dir"/"` &>/dev/null
  for chat in $chats; do
    stream=`cat "$chat_dir/$chat"`
    stream=$((10#$stream))

    if [ $s -eq $stream ]; then
      echo -e "---\nchat: $chat\nfile: \"$file\"\ntext: \"$text\"\n---\n"

      if [ $markdown_flag == no ]; then
        send_message "$chat" "$text" &>/dev/null
      else
        send_markdown_message "$chat" "$text" &>/dev/null
      fi

      if [ ! -z "$file" ]; then
        send_doc "$chat" "$file" &>/dev/null
      fi
    fi
  done
}

#### process parameters

quiet_flag=no
daemon_flag=yes
markdown_flag=no

if type "getopt" &> /dev/null; then
  if ! options=$(getopt -o hvqDmt:f: -l \
               help,version,quiet,daemon,markdown,text:,file:  -- "$@")
  then
      exit 1
  fi

  set -- $options

  while [ $# -gt 0 ]
  do
    case $1 in
      -t|--text) shift; text="$1";;
      -f|--file) shift; file="$*";;
      -h|--help) opt_help ;;
      -v|--version) opt_version ;;
      -q|--quiet) quiet_flag=yes;;
      -D|--daemon) daemon_flag=yes;;
      -m|--markdown) markdown_flag=yes;;
      (--) shift; break;;
      (-*) echo "$PNAME: error - unrecognized option $1" 1>&2; exit 1;;
      (*) break;;
    esac
    shift
  done

  #### execute actions

  if [ $daemon_flag == no ]; then
    opt_message
    exit 0
  fi
else
  echo -e "please, add getopt support.\nrunning in as daemon..."
fi

run_daemon
