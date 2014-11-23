#!/bin/sh
# Start and stop servers

function start_server() {
  home_dir=$1
  pid_file=$2
  sock_file=$3

  cd ${home_dir}
  echo "Enter $(pwd)"
  HOME_DIR=$home_dir UNICORN_SOCK_FILE=$sock_file UNICORN_PID_FILE=$pid_file bundle exec unicorn -E production -c config/system/unicorn.conf.rb &


  pid=$(ps -o pid= -p $(cat $pid_file))
  if [$pid != ""]; then
    echo "Server started successfully !"
  else
    echo "Server start failed."
  fi
}

function stop_server() {
  pid_file=$1
  kill -QUIT $(cat $pid_file)
}

function start_1s() {
  start_server "/home/app/tao_1s" "/tmp/unicorn_1s.pid" "/tmp/unicorn_1s.sock"
}

function stop_1s() {
  stop_server "/tmp/unicorn_1s.pid"
}

function start_gold() {
  start_server "/home/app/tao" "/tmp/unicorn.pid" "/tmp/unicorn.sock"
}

function stop_gold() {
  stop_server "/tmp/unicorn.pid"
}

$@
