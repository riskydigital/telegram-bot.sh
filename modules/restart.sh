'reboot')

if [ -d /etc/systemd ]; then
	systemctl --user daemon-reload
	#systemctl --user enable $pdir/services/$SCRIPT_NAME.service
	systemctl --user restart $SCRIPT_NAME
elif [ -d /etc/rc.d ]; then
  /etc/rc.d/$SCRIPT_NAME restart
elif [ -d /etc/init.d ]; then
  /etc/init.d/$SCRIPT_NAME restart
fi
