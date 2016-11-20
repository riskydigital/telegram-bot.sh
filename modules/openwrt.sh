wifi_device="radio0"

wifi_status()
{
    return $(wifi status | grep -q '\"disabled\": false')
}

wifi_uci_status()
{
    return test $(uci get wireless.$wifi_device.disabled) -eq 0
}

wifi_set()
{
    if [ $1 -eq '1' ];then
        echo "setting wifi on"
        uci set wireless.$wifi_device.disabled=0;
        wifi
    else
        echo "setting wifi off"
        uci set wireless.$wifi_device.disabled=1;
        wifi down
    fi
    uci commit wireless
}

if [ -f /etc/openwrt_release ]; then
  #source /etc/config/telegram-bot.sh.conf
  case $COMMAND in
    'openwrt_help')
      RESPONSE=$'Openwrt module commands:\n/{wifi,dhcp,dsl,log}'
    ;;
    'wifi')
      case $ARGUMENTS in
      h|help)
        RESPONSE=$'Allowed parameters:\n/wifi {,0,1,on,off,t,toggle,c,clients}'
      ;;
      'reboot')
        reboot
      ;;
      'c'|'clients')
        source $MODULES_DIR/openwrt/show_wifi_clients.sh
      ;;
      t|toggle)
        case wifi_status in
          1)
            wifi_set 0
            RESPONSE="wifi disabled"
          ;;
          0)
            wifi_set 1
            RESPONSE="wifi enabled"
          ;;
        esac
      ;;
      0|off)
        wifi_set 0
        ;;
      1|on)
        wifi_set 1
        ;;
      *)
        if [ wifi_uci_status ]; then
          RESPONSE="wifi radio is on"
        else
          RESPONSE="wifi radio is off"
        fi
        if [ wifi_status ]; then
          RESPONSE="$RESPONSE , wifi enabled"
        else
          RESPONSE="$RESPONSE , wifi disabled"
        fi
      esac
    ;;
    'dsl')
      RESPONSE=`/etc/init.d/dsl_control status`
    ;;
    'dhcp')
      RESPONSE=`cat /tmp/dhcp.leases | awk '{print $3"\t"$4}' | sort`
    ;;
    'log')
        RESPONSE=`logread | tail -n20`
    ;;
    *)
      echo "command not found"
    ;;
  esac
else
  RESPONSE=""
fi
