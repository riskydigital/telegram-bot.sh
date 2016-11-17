#'/update')

if [ -d $pdir/.git ]; then
  echo "updating..."
  msg=$(git -C $pdir pull)
else
  wget --no-check-certificate -O /tmp/master.tar.gz https://github.com/viralex/telegram-bot.sh/archive/master.tar.gz
  gunzip -d /tmp/master.tar.gz
  tar -xvf /tmp/master.tar
  mv /tmp/$PNAME-master /root/$PNAME
fi
