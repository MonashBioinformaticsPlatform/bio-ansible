#!/bin/sh
echo "$7" | sbatch \
       --parsable \
       --no-requeue \
       --time=$1 / 60 \
       --cpus-per-task=$2 \
       --mem=$3 / 1048576 \
       --partition=$4 \
       --output=$5 \
       --error=$6
