#shbot
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

#Send notify from server
You can send notify from your servers, using script notify.sh
examples:
- /dir1/dir2/notify.sh -s0 -t "SSH Login $USER@$HOSTNAME"
- /dir1/dir2/notify.sh -s0 -t "User viralex login at service samba"

#Configuration
- Put your bot token in config.sh
