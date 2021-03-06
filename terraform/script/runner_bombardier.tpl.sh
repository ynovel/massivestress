#!/bin/bash
IFS=$'\n' read -d '' -r -a lines < resources.txt

for i in "$${lines[@]}"
do
  echo "$i"
  export URL=$i
  export RES=$(curl -IsS -m 2 $URL 2>&1 | head -n 1)
  if grep -w "200\|301" <<< "$RES" ; then
    echo "RUNNING"
    docker run -d alpine/bombardier -c ${connections_per_resource} -d ${duration} -l $URL
  else
    echo $RES
    echo "SKIPPED"
  fi
done
