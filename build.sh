#!/bin/bash

if [ ! -d ../master ]; then
  pushd ../ > /dev/null
  git worktree add master master
  popd > /dev/null
fi

# First stage the changes, before overwriting them.
git add .
./doclink.py --source-directory="../master/" --prefix="https://github.com/Balletie/GitHub/tree/master"

pushd ../ > /dev/null
rm -r master
git worktree prune -v

[ ! -d gh-pages ] && mkdir gh-pages

./pillar export
# Discard changes done by doclink.py
git checkout -- *.pillar
popd > /dev/null