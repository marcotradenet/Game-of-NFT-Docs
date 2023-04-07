#!/usr/local/bin/bash

source ./.set_vars_gon

denom=$1
entry_path=$2
DEBUG_MODE=$3

if [[ ! -n $denom ]] || [[ ! -n $entry_path ]]; then
  echo "[ERROR]: use ./echo_path2.sh DENOME PATH"
  exit 1
fi

entry_path=$(./path-reducer.sh $entry_path)
if [[ -n $DEBUG_MODE ]]; then
echo $entry_path
fi


FULL_PATH=""
for ((i = 0; i < ${#entry_path}; i++)); do
  CH="${entry_path:$i:2}"
  #echo $CH
  SEG=${PORT_CHANNEL_MATRIX[$CH]}

  if [ -n "$SEG" ]; then
    FULL_PATH=$SEG/$FULL_PATH
  fi
done

echo $FULL_PATH$denom
