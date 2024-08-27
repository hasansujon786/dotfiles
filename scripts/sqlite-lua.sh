#!/bin/bash

dir=~/AppData/Local/nvim-data/sqlite-ddl-win/
link=https://www.sqlite.org/2024/sqlite-dll-win-x64-3460100.zip

if [ -d "$dir" ]; then
  echo "Installed already"
else
  mkdir -p "$dir"
  cd "$dir" || exit
  wget "$link" -O sqlite-dll-win-x64.zip
  unzip sqlite-dll-win-x64.zip && rm sqlite-dll-win-x64.zip
fi
