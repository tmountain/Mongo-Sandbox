#!/bin/bash

mkdir -p /tmp/mongo_sandbox/data/config1 2> /dev/null
mkdir -p /tmp/mongo_sandbox/data/config2 2> /dev/null
mkdir -p /tmp/mongo_sandbox/data/config3 2> /dev/null
echo "initializing config1"
bin/mongod -f configs/config1.conf 2>&1 > /dev/null
echo "initializing config2"
bin/mongod -f configs/config2.conf 2>&1 > /dev/null
echo "initializing config3"
bin/mongod -f configs/config3.conf 2>&1 > /dev/null

CONFIGS=`ps aux | grep mongod | grep config | wc -l`
while [ "$CONFIGS" -lt "3" ]
do
    echo "waiting for config servers to come online"
    CONFIGS=`ps aux | grep mongod | grep config | wc -l`
    sleep 1
done
echo "waiting for config servers to come online"
sleep 5

bin/mongos --configdb="$HOSTNAME:50000,$HOSTNAME:50001,$HOSTNAME:50002" -f configs/mongos1.conf 2>&1 > /dev/null

MONGOS=`echo "exit" | mongo 2>&1 > /dev/null`
while [ $? -gt "0" ]
do
    echo "waiting for mongos to come online"
    sleep 1
    echo "exit" | mongo 2>&1 > /dev/null
done

echo "db.runCommand( { addshard : 'sandbox1/$HOSTNAME:30000,$HOSTNAME:30001' } );" | bin/mongo localhost/admin 
