#Bashbot
A Telegram bot written in bash.

Uses [json.sh](https://github.com/dominictarr/JSON.sh).

#Why
* Why use shell scripts to implement this bot?
For me this is a really simple implementation which fits perfectly for my OpenWRT
router without the need for any extra dependency like python, lua.
* Why changing curl to wget? because I do not have curl on OpenWRT,
I only have wget.

#Requiments:
* wget (curl)
* sh

#Send notify from server
You can send notify from your servers, using script notify.sh
examples:
- /dir1/dir2/notify.sh -s0 -t "SSH Login $USER@$HOSTNAME"
- /dir1/dir2/notify.sh -s0 -t "User viralex login at service samba"

#Configuration
- Put your bot token in config.sh
