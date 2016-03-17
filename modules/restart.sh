#'/restart')

if [ -d /etc/systemd ]; then
	systemctl --user daemon-reload
	systemctl --user enable $pdir/services/$PNAME.service
	systemctl --user restart $PNAME
else if [ -d /etc/rc.d ]; then
  /etc/rc.d/$PNAME restart
else if [ -d /etc/init.d ]; then
  /etc/init.d/$PNAME restart
fi
