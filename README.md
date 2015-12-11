#bashbot
A Telegram bot written in bash.

#sendNotify
bash script for sending notify
examples:
- sendNotify -l0 -t "Critical error at service ABC"
- sendNotify -l3 -t "User vasya login at service samba"

#Bot commands:
- /ss *smbstatus*
- /s *sensors*
- /free *memory status*
- /md *raid status*
- /lvs *lvm status*
- /lvsd *Datailed lvm status*
- /df *disk space*
- /ifconfig *ifconfig output*
- /smart -d sda *smart status for sda drive*
- /notifyLevel /nl *View or Set(-s) notify level*
  example */notifyLevel -s 3* set notify level 3 for this chat
  *0* - Nothing
  *1* - Critical
  *2* - Dangerous (password brutforce, etc)
  *3* - Big success events

Uses [json.sh](https://github.com/dominictarr/JSON.sh).
