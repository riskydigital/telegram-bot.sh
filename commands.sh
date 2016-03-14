#!/bin/sh

case $cmd in
  '/lock')
    msg="Locked"
    echo "locked">$lock_file
    ;;
  '/unlock')
    msg="Unlocked"
    echo "unlocked">$lock_file
    ;;
  '/info'|'/start'|'/help')
  msg="Monitoring bot commands:"`cat commandsInfo`
  send_markdown_message "$TARGET" "$msg"
  PREV_TIME=$CURR_TIME
  #Disable simple send_message
  msg=""
  ;;
  '/md'|'raid_status')msg=`cat /proc/mdstat`;;
  '/chatid') msg="ChatId="$TARGET
  ;;
  '/ss'|'smbstatus')
    msg=""
    smbstatus>/tmp/smbstatus
    send_doc "$TARGET" "/tmp/smbstatus"
    PREV_TIME=$CURR_TIME
  ;;
  '/s'|'sensors'|'/sensors')msg=`sensors | sed -r "s/\s|\)+//g" | sed -r "s/\(high=|\(min=/\//" | sed -r "s/\,crit=|\,max=/\//"`;;
  '/free') msg=`free -h`;;
  '/pvs') msg=`pvs`;;
  '/ifconfig') msg=`ifconfig`;;
  '/vgs') msg=`vgs`;;
  '/lvs') msg=`lvs | sed -r "s/\s+/\n/g"`;;
  '/lvsd') msg=`lvs -a -o +devices | sed -r "s/\s+/\n/g"`;;
  '/smart'|'/smartctl')
    if [ "$OPTARG" == "" ]; then
      msg="example \`/smart sda\`"
    else
      drive=`echo "$OPTARG" | cut -c 1-3`
      echo "smartctl -a /dev/$drive"
      msg=`smartctl -a /dev/$drive`
    fi
    ;;
  '/df') msg=`df -h | sed -r "s/^/\n/" | sed -r "s/\s+/\n/g"`;;
  '/nl'|'/notifyLevel')
    if [ "$OPTARG" == "" ]; then
      msg="Notify level is: "`cat "$nlFile"`
    elif [[ "$OPTARG" =~ [^0-9]+ ]]; then
      msg="Only numbers"
    else
      if [ $((10#$OPTARG)) -ge 0 ]; then
        notifyLevel=$((10#$OPTARG))
        msg="Now notify level is $notifyLevel"
        echo -n "$notifyLevel">"$nlFile"
      else
        msg="Level must be bigger or equal 0"
      fi
    fi
  ;;
  *)
    if [ -f "$cutomCmdDir/$cmd" ]; then
      . "$cutomCmdDir/$cmd"
    fi
  ;;
esac
