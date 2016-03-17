#'/update')

if [ -d $pdir/.git ]; then
  echo "updating..."
  msg=$(git -C $pdir pull)
fi
