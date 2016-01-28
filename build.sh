#!/bin/bash

if [ ! -d ../master ]; then
  pushd ../ > /dev/null
  git worktree add master master
  popd > /dev/null
fi

# First stage the changes, before overwriting them.
pushd ../ > /dev/null
git add *.pillar
popd
./doclink.py --config=../doclink_config.ini
if [ "$?" -ne "0" ]; then
  echo "doclink.py exited with error, cleaning up.."
  pushd ../ > /dev/null
  rm -r master
  git worktree prune -v
  git checkout -- *.pillar
  popd > /dev/null
  exit 1
fi

pushd ../ > /dev/null
rm -r master
git worktree prune -v

[ ! -d gh-pages ] && mkdir gh-pages

./pillar export

[ -f pillarPostExport.sh ] && type lualatex >/dev/null && bash pillarPostExport.sh

if [ -f gh-pages/html-chap/getting-started.html ]; then
  pushd gh-pages/html-chap
  ln -s getting-started.html index.html
  echo 'Created link for index.html'
  popd
fi
# Discard changes done by doclink.py
git checkout -- *.pillar
popd > /dev/null
