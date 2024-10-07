#!/bin/bash

EMULATORS=$1
PROJECT_ID=$2
MAX_RETRIES=$3
MAX_CHECKATTEMPTS=$4
CHECKATTEMPTS_WAIT=$5
CHECK_PORT=$6

if ! [ -x "$(command -v firebase)" ]; then
  echo "❌ Firebase tools CLI is missing."
  exit 1
fi

if ! [ -x "$(command -v node)" ]; then
  echo "❌ Node.js is missing."
  exit 1
fi

if ! [ -x "$(command -v npm)" ]; then
  echo "❌ NPM is missing."
  exit 1
fi

# Run NPM install if node modules does not exist.
if [[ -d "functions" && ! -d "functions/node_modules" ]]; then
  cd functions
  if npm i; then
    echo "✅ NPM install successful."
  else
    if [[ -z "${CI}" ]]; then
      echo "❌ NPM install failed."
      exit 1
    else
      # TODO temporary workaround for GitHub Actions CI issue:
      # npm ERR! Your cache folder contains root-owned files, due to a bug in
      # npm ERR! previous versions of npm which has since been addressed.
      sudo chown -R 501:20 "/Users/runner/.npm" || exit 1
      npm i || exit 1
    fi
  fi
  cd ..
fi

export STORAGE_EMULATOR_DEBUG=true
EMU_START_COMMAND="firebase emulators:start --only $EMULATORS --project $PROJECT_ID"

RETRIES=1
while [ $RETRIES -le $MAX_RETRIES ]; do

  if [[ -z "${CI}" ]]; then
    echo "Starting Firebase Emulator Suite in foreground."
    $EMU_START_COMMAND
    exit 0
  else
    echo "Starting Firebase Emulator Suite in background."
    $EMU_START_COMMAND &
    CHECKATTEMPTS=1
    while [ $CHECKATTEMPTS -le $MAX_CHECKATTEMPTS ]; do
      sleep $CHECKATTEMPTS_WAIT
      if curl --output /dev/null --silent --fail http://localhost:$CHECK_PORT; then
        # Check again since it can exit before the emulator is ready.
        sleep 15
        if curl --output /dev/null --silent --fail http://localhost:$CHECK_PORT; then
          echo "Firebase Emulator Suite is online!"
          exit 0
        else
          echo "❌ Firebase Emulator exited after startup."
          exit 1
        fi
      fi
      echo "Waiting for Firebase Emulator Suite to come online, check $CHECKATTEMPTS of $MAX_CHECKATTEMPTS..."
      ((CHECKATTEMPTS = CHECKATTEMPTS + 1))
    done
  fi

  echo "Firebase Emulator Suite did not come online in $MAX_CHECKATTEMPTS checks. Try $RETRIES of $MAX_RETRIES."
  ((RETRIES = RETRIES + 1))

done
echo "Firebase Emulator Suite did not come online after $MAX_RETRIES attempts."
exit 1