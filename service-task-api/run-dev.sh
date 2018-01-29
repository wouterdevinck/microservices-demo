#!/bin/sh

# 1. Run "npm install"
progress(){
  while true
  do
    echo 'Running "npm install" - this may take some time'
    sleep 2s
  done
}
progress &
PROGRESS=$!
npm install --no-progress
kill $PROGRESS >/dev/null 2>&1

# 2. Run "npm start"
npm start