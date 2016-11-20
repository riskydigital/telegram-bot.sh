case $COMMAND in
  'info')
    RESPONSE="$PNAME-$VERSION: https://github.com/viralex/$PNAME"
  ;;

  'ping')
    RESPONSE="pong"
  ;;

  'chatid')
    RESPONSE=$TARGET
  ;;

  'hostname')
    RESPONSE=$DEVICE
  ;;

  'lock')
    RESPONSE="locked"
    echo "locked">$LOCK_FILE
  ;;

  'unlock')
    RESPONSE="unlocked"
    echo "unlocked">$LOCK_FILE
  ;;

  'help')
    RESPONSE=$'basic commands:\n/info\n/chatid'
  ;;

  'lsadmin')
    RESPONSE=":"
  ;;

  'insadmin')
    RESPONSE=":"
  ;;

  'deladmin')
    RESPONSE=":"
  ;;

  'free')
    RESPONSE=`free -h`
  ;;

  'ifconfig')
    RESPONSE=`ifconfig`
  ;;
  'df')
    RESPONSE=`df -h | sed -r "s/^/\n/" | sed -r "s/\s+/\n/g"`
  ;;

  *)
  ;;
esac

echo "basic_module: $RESPONSE"
