#!/bin/bash

# bashbot, the Telegram bot written in bash.
# Written by @topkecleon and Juan Potato (@awkward_potato)
# http://github.com/topkecleon/bashbot

# Depends on JSON.sh (http://github.com/dominictarr/JSON.sh),
# which is MIT/Apache-licensed.

# This file is public domain in the USA and all free countries.
# If you're in Europe, and public domain does not exist, then haha.



echo "Telegram bot starting dir:"$(pwd)
. global
./sendNotify -l2 -t "Bot started at $hostname"
#MESSAGE="$@"
OFFSET=0

#buttons="{\"keyboard\":[[\"sensors\",\"raid_status\"]],\"one_time_keyboard\":true}"
prevActiveTime=0
#prevActiveTime=$((10#`date +%s`))
while true; do {
	curTime=$((10#`date +%s`))
	{
		res=$(curl $URL\/getUpdates\?offset=$OFFSET\&limit=1)
    TARGET=$(echo $res | ./JSON.sh | egrep '\["result",0,"message","chat","id"\]' | cut -f 2)
		from=$(echo $res | ./JSON.sh | egrep '\["result",0,"message","from","username"\]' | cut -f 2)
	  OFFSET=$(echo $res | ./JSON.sh | egrep '\["result",0,"update_id"\]' | cut -f 2)
	  MESSAGE=$(echo $res | ./JSON.sh -s | egrep '\["result",0,"message","text"\]' | cut -f 2 | cut -d '"' -f 2)
	  message_id=$(echo $res | ./JSON.sh -s | egrep '\["result",0,"message","message_id"\]' | cut -f 2 | cut -d '"' -f 2)
  } &>/dev/null

	OFFSET=$((OFFSET+1))
  #echo "$MESSAGE"

	if [ $OFFSET != 1 ]; then
		msgWords=($MESSAGE)
		cmd=${msgWords[0]}
		args=("${msgWords[@]:1}") #removed the 1st element
		#echo "cmd: $cmd"
		toHost="$hostname"
		drive=""
		notifyLevel=-1
		msg=""
		#echo "args:${args[@]}"
		unset OPTIND
		while getopts ":h: :d: :s:" opt "${args[@]}"; do
			case $opt in
				s)
				  #
					#echo "notifyLevel:$notifyLevel"
					if [[ "$OPTARG" =~ [^0-9]+ ]]; then
						msg="Only numbers"
						cmd=""
					else
						if [ $((10#$OPTARG)) -le 3 ] && [ $((10#$OPTARG)) -ge 0 ]; then
							notifyLevel=$((10#$OPTARG))
							echo "Good notify level $notifyLevel"
						else
							msg="Level must be from 0 to 3"
							cmd=""
						fi
					fi
					;;
				d)
				  drive=`echo "$OPTARG" | cut -c 1-3`;;
		    h)
				  toHost="$OPTARG";;
		    :)
				  toHost=""
				  msg="Option -$OPTARG requires an argument.";;
		  esac
		done

		if [ ! "$toHost" == "$hostname" ]; then
			cmd=""
			echo "To other host"
		fi
		echo "from:$from Message:$MESSAGE"
	  case $cmd in
			'/info'|'/start'|'help')
			msg="Monitoring bot commands:"`cat commandsInfo`
			send_message "$TARGET" "$msg" "{\"hide_keyboard\":false}"
			prevActiveTime=$curTime
			msg="";;
			'/md'|'raid_status')msg=`cat /proc/mdstat`;;
			'/chatid') msg="ChatId="$TARGET
			;;
			'/ss'|'smbstatus')
			  msg=""
			  smbstatus>/tmp/smbstatus
			  send_doc "$TARGET" "/tmp/smbstatus"
				prevActiveTime=$curTime
			;;
			'/s'|'sensors') msg=`sensors`;;
			'/free') msg=`free -h`;;
			'/lvs') msg=`lvs`;;
			'/pvs') msg=`pvs`;;
			'/ifconfig') msg=`ifconfig`;;
			'/vgs') msg=`vgs`;;
			'/lvsd') msg=`lvs -a -o +devices`;;
			'/smart')
			  echo "smartctl -a /dev/$drive"
			  msg=`smartctl -a /dev/$drive`;;
			'/df') msg=`df -h`;;
			'/nl'|'/notifyLevel')
		    nlFile="$nlDir/$TARGET"
			  if [ $notifyLevel -eq -1 ]; then
					msg="Notify level is: *"`cat "$nlFile"`"*"
				else
					msg="Now notify level is *$notifyLevel*"
					echo -n "$notifyLevel">"$nlFile"
				fi
			;;
			#*) msg="$MESSAGE toHost=$toHost cmd=$cmd";;
		esac
		if [ ! -z "$msg" ]; then
			prevActiveTime=$curTime
		  send_message "$TARGET" "$msg"
		fi
	fi

	elapsed=$((curTime-prevActiveTime))

	if [ $elapsed -le $standByAfter ]; then
		if [ $cycleSleep -gt 0 ]; then
		  sleep $cycleSleep
		fi
	else
		sleep $cycleSleepStandBy
	fi

} done
#} &>/dev/null; done
