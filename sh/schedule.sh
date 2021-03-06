#!/bin/bash

timeframe=$(printf '5M\n10M\n15M\n30M\n1H\n' | shuf -n1)
queued=$(tsp | grep queued | wc -l)
ncpu=$(nproc)

if (($queued >= 1))
then
    exit 0
fi

list=$(shuf -n 1 list.txt)

for i in $list
do
  if [ $(tsp | grep $timeframe | grep $i | wc -l) == 0 ];
  then
    echo "Queueing $i $timeframe"

    tsp sh/compute.sh $i 100 $timeframe
  fi
done

tsp -S $ncpu
