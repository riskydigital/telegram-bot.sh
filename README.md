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
You can send notify from your servers, using script sendNotify
examples:
- /dir1/dir2/sendNotify -l1 -t "SSH Login $USER@$HOSTNAME"
- /dir1/dir2/sendNotify -l3 -t "User viralex login at service samba"

#Bot commands:
- `/s` sensors
- `/ss` smbstatus
- `/free` memory status
- `/md` raid status
- `/lvs` lvm status
- `/lvsd` Datailed lvm status
- `/df` disk space
- `/ifconfig` ifconfig output
- `/smart -d sda` smart status for sda drive
- `/lock` allow only chats from notifyLevels dir
- `/unlock` - allow any users to chat with bot
- `/notifyLevel` `/nl` View or Set notify level
<br />example `/notifyLevel 3` set notify level 3 for this chat
 - *0* - Nothing
 - *1* - Critical
 - *2* - Dangerous (password brutforce, etc)
 - *3* - Big success events
 - *4* - Success events
 - *...* - ...

#Telegram token
- Put your bot token to file "token". You can use install script.
- One bot(process) - One token
