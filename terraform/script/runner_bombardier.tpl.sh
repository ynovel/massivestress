#!/bin/bash
IFS=$'\n' read -d '' -r -a lines < resources.txt

for i in "$${lines[@]}"
do
  echo "$i"
  export URL=$i
  docker run -d alpine/bombardier -c ${connections_per_resource} -d ${duration} -l $URL
done
