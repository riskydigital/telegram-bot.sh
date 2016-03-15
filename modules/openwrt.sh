case $cmd in
  '/wifion')
    msg="wifi switched on"
    #uci
    ;;
  '/wifioff')
    msg="wifi switched off"
    #uci
    ;;
  *)
    echo "command not found!"
  ;;
esac
