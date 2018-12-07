#!/bin/sh

NAME="[ SAMPLE BOT DAEMON ]"
PID="./sample-bot-daemon.pid"
CMD="bundle exec ruby sample-bot.rb"

start()
{
  if [ -e $PID ]; then
    echo "$NAME already started"
    exit 1
  fi
  echo "$NAME START!"
  $CMD
}

stop()
{
  if [ ! -e $PID ]; then
    echo "$NAME not started"
    exit 1
  fi
  echo "$NAME STOP!"
  kill -INT `cat ${PID}`
  rm $PID
}

restart()
{
  stop
  sleep 2
  start
}

update_system()
{
  git checkout master
  git pull
  bundle install --path vendor/bundle
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  *)
    echo "Usage: ./sample-bot.sh [start|stop|restart|update_system]"
    ;;
esac
