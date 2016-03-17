#'/restart')

if [ -d /etc/systemd ]; then
	systemctl --user daemon-reload
	#systemctl --user enable $pdir/services/$PNAME.service
	systemctl --user restart $PNAME
elif [ -d /etc/rc.d ]; then
  /etc/rc.d/$PNAME restart
elif [ -d /etc/init.d ]; then
  /etc/init.d/$PNAME restart
fi
