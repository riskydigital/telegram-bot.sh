case $cmd in
  '/info')
    msg="$PNAME-$VERSION: https://github.com/viralex/$PNAME"
  ;;

  '/ping')
    msg="pong"
  ;;

  '/chatid')
    msg=$TARGET
  ;;

  '/hostname')
    msg=$DEVICE
  ;;

  '/lock')
    msg="locked"
    echo "locked">$lock_file
  ;;

  '/unlock')
    msg="unlocked"
    echo "unlocked">$lock_file
  ;;

  '/help')
    msg=$'basic commands:\n/info\n/chatid'
  ;;

  '/lsadmin')
    msg=":"
  ;;

  '/insadmin')
    msg=":"
  ;;

  '/deladmin')
    msg=":"
  ;;

  '/free')
    msg=`free -h`
  ;;

  '/ifconfig')
    msg=`ifconfig`
  ;;
  '/df')
    msg=`df -h | sed -r "s/^/\n/" | sed -r "s/\s+/\n/g"`
  ;;

  *)
  ;;
esac

echo "basic_module: $msg"
