wifi_device="1"

if [ -f /etc/openwrt_release ]; then
  #source /etc/config/telegram-bot.sh.conf
  case $cmd in
    '/openwrt_help')
      msg=$'Openwrt module commands:\n/{wifi,dhcp}'
    ;;
    '/wifi')
      case $args in
      h|help)
        msg=$'Allowed parameters:\n/wifi {,0,1,on,off,t,toggle,c,clients}'
      ;;
      'c'|'clients')
        source $pdir/$modules_dir/openwrt/show_wifi_clients.sh
      ;;
      t|toggle)
        case $(uci get wireless.@wifi-iface[$wifi_device].disabled) in
          0)
            wifi down
            uci set wireless.@wifi-iface[$wifi_device].disabled=1
            msg="wifi disabled"
          ;;
          1)
            uci set wireless.@wifi-iface[$wifi_device].disabled=0
            wifi up
            msg="wifi enabled"
          ;;
        esac
        uci commit wireless
      ;;
      0|off)
        wifi down
        uci set wireless.@wifi-iface[$wifi_device].disabled=1
        uci commit wireless
        msg="wifi disabled"
      ;;
      1|on)
        wifi up
        uci set wireless.@wifi-iface[$wifi_device].disabled=0
        uci commit wireless
        msg="wifi enabled"
      ;;
      *)
        if [ $(uci get wireless.@wifi-iface[$wifi_device].disabled) -eq 0 ]; then
          msg="wifi is on"
        else
          msg="wifi is off"
        fi
      esac
    ;;
    '/dhcp')
      msg=`cat /tmp/dhcp.leases | awk '{print $3"\t"$4}' | sort`
    ;;
    '/log')
        msg=`logread | tail -n20`
    ;;
    *)
      echo "command not found"
    ;;
  esac
else
  msg=""
  #msg="this is not openwrt!"
fi
