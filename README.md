#telegram-bot.sh
A Telegram bot written in shell language script.

Uses [json.sh](https://github.com/dominictarr/JSON.sh).

#Why
* Why using shell scripts?
This is a really simple implementation which fits my needs.
I want to run this on several machines including an OpenWRT router 
without using any extra dependency like python, lua.

* Why changing curl to wget? because I do not have curl on OpenWRT,
I only use wget and having both is a waste of space.

#Requiments:
* wget
* sh

#Send message mode
You can send notify from your servers
examples:
- /dir1/dir2/telegram-bot.sh -t "SSH Login $USER@$HOSTNAME"
- /dir1/dir2/telegram-bot.sh -t "User viralex login at service samba"

#Daemon mode
You can implement different command modules

#Configuration
- Put your bot token in config.sh
