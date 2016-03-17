#telegram-bot.sh
A Telegram bot written in shell language script.

Uses [json.sh](https://github.com/dominictarr/JSON.sh).

#Why
* Why use shell scripts?
This is a really simple implementation which fits my needs.
I want to run this on several machines including an OpenWRT router 
without including any extra dependency like python, lua.

* Why changing curl to wget? because I do not have curl on OpenWRT,
I only use wget and having both is a waste of space.

#Requiments:
* wget
* *sh (if ash make sure to compile busybox with getopt -l)

#Daemon mode
You can implement different command modules under modules_dir

#Send message mode
You can send messages
examples:
- /dir1/dir2/telegram-bot.sh -t "SSH Login $USER@$HOSTNAME"
- /dir1/dir2/telegram-bot.sh -t "User viralex login at service samba"

#Configuration
- copy default/config.sh.orig, put in your bot token and rename to config.sh
- put chatid under chats/<chatid>
