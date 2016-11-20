#telegram-bot.sh
A Telegram bot written in shell language script.

#Why
* Why use shell scripts?
This is a really simple implementation which fits my needs.
I want to run this on several machines including an OpenWRT router 
without including any extra dependency like python, lua.

* Why changing curl to wget? because I do not have curl on OpenWRT,
I only use wget and having both is a waste of space.

#Requiments:
* [json.sh](https://github.com/dominictarr/JSON.sh).
* wget
* getopt
* a unix shell. 

#Daemon mode
Implements bot executing different command modules.

#Send direct messages
You can send messages
example:
- ./telegram-bot.sh -t "SSH Login $USER@$HOSTNAME"

#Configuration
- "~/.config/tbot/config" put TOKEN,OWNER,CHAT_ID in the config file.
