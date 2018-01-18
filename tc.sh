#!/bin/bash

DIR_PREFIX=`pwd`

export JAVA_HOME=$DIR_PREFIX/java

export TEAMCITY_HOME=$DIR_PREFIX/TeamCity
export TEAMCITY_DATA_PATH=$TEAMCITY_HOME/data

export PATH=$JAVA_HOME/bin:$PATH:.

server_service() {
  ( cd "$TEAMCITY_HOME/bin" && exec teamcity-server.sh "$1" )
}

agent_service() {
  ( cd "$TEAMCITY_HOME/buildAgent1/bin" && exec agent.sh "$1" )
  ( cd "$TEAMCITY_HOME/buildAgent2/bin" && exec agent.sh "$1" )
}

start() {
  if server_service start; then
    echo "TeamCity agents on the server being launched in 30 seconds"
    ( sleep 30 && agent_service start ) &
  fi
}

stop() {
  agent_service stop
  server_service stop
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop && sleep 30 && start
    ;;
  start-agent)
    agent_service start
    ;;
  stop-agent)
    agent_service stop
    ;;
  *)
    echo 2>&1 "Usage: $0 {start|stop|restart|start-agent|stop-agent}"
    ;;
esac

exit 0
