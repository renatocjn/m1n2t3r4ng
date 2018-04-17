#!/bin/bash

echo "Starting cronos..."
bundle exec crono start
echo

echo "Starting Telegram poller..."
nohup bundle exec rake telegram:bot:poller &>> log/telegram_poller.log&
pid=$!
echo "Poller started (pid $pid)"
echo $pid > tmp/pids/poller.pid
echo

echo "Starting delayed job worker..."
bundle exec bin/delayed_job --pool=*:5 start
echo
