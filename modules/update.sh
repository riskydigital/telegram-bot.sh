'update')
if [ -d $SCRIPT_DIR/.git ]; then
  echo "updating..."
  RESPONSE=$(git -C $SCRIPT_DIR pull)
else
  wget --no-check-certificate -O /tmp/master.tar.gz https://github.com/viralex/telegram-bot.sh/archive/master.tar.gz
  gunzip -d /tmp/master.tar.gz
  tar -xvf /tmp/master.tar
  mv /tmp/$SCRIPT_NAME-master /root/$SCRIPT_NAME
fi
