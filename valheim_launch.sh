#!/usr/bin/env bash

set -eu

export LD_LIBRARY_PATH=/home/steam/valheim/linux64
export SteamAppId=892970


function backup() {
  echo "Backing up data in directory ${SAVE_DIR}"
  if [[ ! -d ${SAVE_DIR} ]]; then
    echo "Save directory does not exist, nothing to backup"
    return
  fi

  mkdir -p ${SAVE_DIR}/backups

  tar -czv --exclude ${SAVE_DIR}/backups -f "${SAVE_DIR}/backups/valheim_data_$(date +%Y%m%d-%H%M%S).tar.gz" ${SAVE_DIR}
}

function launch() {
    echo "Launching Valheim Server with the following parameters"
    echo "Server Name: ${SERVER_NAME}"
    echo "Public Name: ${SERVER_PUBLIC}"
    echo "World Name: ${WORLD_NAME}"
    echo "Save Dir:${SAVE_DIR}"

    /home/steam/valheim/valheim_server.x86_64 -name ${SERVER_NAME} -nographics -password ${SERVER_PASSWORD} -public ${SERVER_PUBLIC} -savedir ${SAVE_DIR} -world ${WORLD_NAME} & SERVER_PID=$!
    wait $SERVER_PID
}

function shutdown() {
    echo "Shutting down Valheim Server"
    kill -INT $SERVER_PID

    i=0
    while [[ -d "/proc/${SERVER_PID}" ]]; do
      sleep 10

      case $i in
          [3])
              kill -TERM $SERVER_PID
              ;;
          [5])
              kill -KILL $SERVER_PID
              ;;
          [8])
            echo "Server unresponsive to shutdown signals"
      esac

      (( i++ ))

      echo "Waiting for Server shutdown."
    done

    echo "Server shutdown complete."
}

trap shutdown SIGTERM
backup
launch