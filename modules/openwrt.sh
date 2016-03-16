device="1"

case $cmd in
  '/wifistatus')
    if [ $(uci get wireless.@wifi-iface[$device].disabled) -eq 0 ]; then
      msg="wifi is on"
    else
      msg="wifi is off"
    fi
  ;;
  '/wifi')
    case $(uci get wireless.@wifi-iface[$device].disabled) in
      0)
        wifi down
        uci set wireless.@wifi-iface[$device].disabled=1
        msg="wifi disabled"
      ;;
      1)
        uci set wireless.@wifi-iface[$device].disabled=0
        wifi up
        msg="wifi enabled"
      ;;
      esac
    ;;
  '/wifion')
    wifi down
    uci set wireless.@wifi-iface[$device].disabled=1
    msg="wifi enabled"
    ;;
  '/wifioff')
    wifi up
    uci set wireless.@wifi-iface[$device].disabled=1
    msg="wifi disabled"
    ;;
  *)
    echo "command not found!"
  ;;
esac
