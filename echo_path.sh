#!/bin/bash

source ./.set_vars_gon

entry_path=$1

entry_path=$(./path-reducer.sh $entry_path)
echo $entry_path

# Verifica se la stringa inserita è un palindromo o meno

#echo $entry_path
FULL_PATH=""
#for (( i=0; i<${#entry_path}; i=$(($i + 1)) )); do
for ((i = 0; i < ${#entry_path}; i++)); do
  CH="${entry_path:$i:2}"
  #echo $CH
  SEG=
  if [ $CH = "is" ]; then
    SEG="wasm.$STARGAZE_PORT/$STARGAZE_TO_IRIS_CHANNEL_1"
  elif [ $CH = "ij" ]; then
    SEG="wasm.$JUNO_PORT/$JUNO_TO_IRIS_CHANNEL_1"
  elif [ $CH = "io" ]; then
    SEG="nft-transfer/$OMNIFLIX_TO_IRIS_CHANNEL_1"
  elif [ $CH = "iu" ]; then
    SEG="nft-transfer/$UPTICK_TO_IRIS_CHANNEL_1"
  fi

  if [ $CH = "os" ]; then
    SEG="wasm.$STARGAZE_PORT/$STARGAZE_TO_OMNIFLIX_CHANNEL_1"
  elif [ $CH = "oj" ]; then
    SEG="wasm.$JUNO_PORT/$JUNO_TO_OMNIFLIX_CHANNEL_1"
  elif [ $CH = "oi" ]; then
    SEG="nft-transfer/$IRIS_TO_OMNIFLIX_CHANNEL_1"
  elif [ $CH = "ou" ]; then
    SEG="nft-transfer/$UPTICK_TO_OMNIFLIX_CHANNEL_1"
  fi

  if [ $CH = "us" ]; then
    SEG="wasm.$STARGAZE_PORT/$STARGAZE_TO_UPTICK_CHANNEL_1"
  elif [ $CH = "uj" ]; then
    SEG="wasm.$JUNO_PORT/$JUNO_TO_UPTICK_CHANNEL_1"
  elif [ $CH = "ui" ]; then
    SEG="nft-transfer/$IRIS_TO_UPTICK_CHANNEL_1"
  elif [ $CH = "uo" ]; then
    SEG="nft-transfer/$OMNIFLIX_TO_UPTICK_CHANNEL_1"
  fi

  if [ $CH = "su" ]; then
    SEG="nft-transfer/$UPTICK_TO_STARGAZE_CHANNEL_1"
  elif [ $CH = "sj" ]; then
    SEG="wasm.$JUNO_PORT/$JUNO_TO_STARGAZE_CHANNEL_1"
  elif [ $CH = "si" ]; then
    SEG="nft-transfer/$IRIS_TO_STARGAZE_CHANNEL_1"
  elif [ $CH = "so" ]; then
    SEG="nft-transfer/$OMNIFLIX_TO_STARGAZE_CHANNEL_1"
  fi

  if [ $CH = "ju" ]; then
    SEG="nft-transfer/$UPTICK_TO_JUNO_CHANNEL_1"
  elif [ $CH = "js" ]; then
    SEG="wasm.$STARGAZE_PORT/$STARGAZE_TO_JUNO_CHANNEL_1"
  elif [ $CH = "ji" ]; then
    SEG="nft-transfer/$IRIS_TO_JUNO_CHANNEL_1"
  elif [ $CH = "jo" ]; then
    SEG="nft-transfer/$OMNIFLIX_TO_JUNO_CHANNEL_1"
  fi

  if [ ! "$SEG" = "" ]; then
    FULL_PATH=$SEG/$FULL_PATH
  fi
done

echo $FULL_PATH
