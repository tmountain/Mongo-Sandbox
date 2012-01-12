#!/bin/bash
HOSTNAME=`hostname`
./fetch_mongo.sh

if [ "$?" -gt "0" ]
then
  exit
fi

./init_replicas.sh
./init_shards.sh
