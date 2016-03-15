case $cmd in
  '/lock')
    msg="Locked"
    echo "locked">$lock_file
    ;;

  '/unlock')
    msg="Unlocked"
    echo "unlocked">$lock_file
    ;;

  '/info'|'/start'|'/help')
    msg="commands:"
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

  '/chatid') msg=$TARGET ;;

  '/free') msg=`free -h`;;
  '/ifconfig') msg=`ifconfig`;;
  '/df') msg=`df -h | sed -r "s/^/\n/" | sed -r "s/\s+/\n/g"`;;
  
  #'/nl'|'/notifyLevel')
  #  if [ "$OPTARG" == "" ]; then
  #    msg="Notify level is: "`cat "$nlFile"`
  #  elif [[ "$OPTARG" =~ [^0-9]+ ]]; then
  #    msg="Only numbers"
  #  else
  #    if [ $((10#$OPTARG)) -ge 0 ]; then
  #      notifyLevel=$((10#$OPTARG))
  #      msg="Now notify level is $notifyLevel"
  #      echo -n "$notifyLevel">"$nlFile"
  #    else
  #      msg="Level must be bigger or equal 0"
  #    fi
  #  fi
  #;;
  
  *)
  ;;
esac

echo "basic_module: $msg"
