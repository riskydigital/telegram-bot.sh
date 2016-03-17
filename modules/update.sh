#'/update')

if [ -d $pdir/.git ]; then
  echo "updating..."
  msg=$(git -C $pdir pull)
fi

echo ">> \"$msg\" $pdir/services/$PNAME.service"

if [ -d /etc/systemd ]; then
	systemctl --user daemon-reload
	systemctl --user enable $pdir/services/$PNAME.service
	systemctl --user restart $PNAME
fi
