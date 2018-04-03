#!/bin/bash

echo "Starting cronos..."
bundle exec crono start

echo "Starting Telegram poller"
nohup bundle exec rake telegram:bot:poller &> log/telegram_poller.log&
echo "Iniciado com pid $!"

echo "Starting delayed job worker"
bundle exec bin/delayed_job start
