#!/bin/bash

cd /var/www/mst

if [ "$1" = "stop" ] || [ "$1" = "restart" ] ; then
  echo "Stoping processes"
  cat tmp/pids/*.pid | xargs kill
  rm tmp/pids/poller.pid
fi

if [ "$1" = "start" ] || [ "$1" = "restart" ] ; then
  echo "Starting cronos..."
  bundle exec crono start

  echo "Starting Telegram poller..."
  nohup bundle exec rake telegram:bot:poller &>> log/telegram_poller.log&
  pid=$!
  echo "Poller started (pid $pid)"
  echo $pid > tmp/pids/poller.pid

  echo "Starting delayed job worker..."
  bundle exec rake jobs:clear
  bundle exec bin/delayed_job --pool=*:5 start
fi

if [ "$1" = "status" ] ; then
  ps $(cat tmp/pids/*.pid)
fi
