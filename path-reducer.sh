#!/usr/local/bin/bash

input=$1
new_path=""
for ((i = 0; i < ${#input}; i+=2)); do
  piece=${input:i:2}
  #i=$((i + 1))
  letter=${piece:0:1}
  channel=${piece:1:2}
  if [[ $channel = 2 ]]; then
    letter=$(echo $letter | tr '[:lower:]' '[:upper:]')
  fi
  new_path=$new_path$letter
done

function reverse {
  echo $1 | rev
}

function find_palindrome {
  path=$1
  length=${#path}
  for ((i = 0; i < $length; i++)); do
    for ((j = 2; j <= $length - $i; j++)); do
      substring=${path:$i:$j}
      reverse_substring=$(reverse $substring)
      if [[ "$substring" == "$reverse_substring" ]]; then
        min_palindrome=$substring
      fi
    done
  done
  echo $min_palindrome
}

pal=$(find_palindrome $new_path)
while [[ -n $pal ]]; do
  f_letter=${pal:0:1}
  new_path=$(echo $new_path | sed "s|$pal|$f_letter|g")
  pal=$(find_palindrome $new_path)
done

echo $new_path
