#bashbot
A Telegram bot written in bash.

#Requiment:
* curl
* bash

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
- `/notifyLevel` `/nl` View or Set(-s) notify level
<br />example `/notifyLevel -s 3` set notify level 3 for this chat
 - *0* - Nothing
 - *1* - Critical
 - *2* - Dangerous (password brutforce, etc)
 - *3* - Big success events

#Telegram token
Put your bot token to file "token".
You can clone this bot to the same servers with one token.

#Send notify from server
You can send notify from your servers, using script sendNotify
examples:
- sendNotify -l1 -t "Critical error at service ABC"
- /dir1/dir2/sendNotify -l3 -t "User vasya login at service samba"
Default notify level for new chat is 0. To change notify level use `/nl -s 3|2|1|0`.

#Setup telegram commands
- Say `/setcommands` to botfather
- Choose your bot
- Send following description
```
s - sensors
ss - smbstatus
free - memory status
md - raid status
lvs - lvm status
lvsd - Datailed lvm status
df - disk space
ifconfig - Network configuration
smart - smart status
nl - notify level
```

#Split commands by host names
One host Examples:
- /s -h arch216
- /nl -s 3 -h nas3200

All hosts :
- /s sensors from all servers
- /nl -s 1  Retrive only errors from all servers

#Setup on debian
```
git clone https://github.com/RG72/telegram-bot-bash.git
cd telegram-bot-bash
./installDebian
```
InstallDebian script create init script */etc/init.d/tBot*
Logs placed at /var/log/tBot
Manual start run `/etc/init.d/tBot start`

#Setup on Arch linux
```
git clone https://github.com/RG72/telegram-bot-bash.git
cd telegram-bot-bash
./installArch
```
installArch create */usr/lib/systemd/system/tBot.service*
Manual start `systemctl start tBot`
Enable to system boot `systemctl enable tBot`

Uses [json.sh](https://github.com/dominictarr/JSON.sh).
