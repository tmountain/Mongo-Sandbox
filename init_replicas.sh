#!/bin/bash

mkdir /tmp/mongo_sandbox 2> /dev/null
mkdir -p /tmp/mongo_sandbox/data/arb1 2> /dev/null
mkdir -p /tmp/mongo_sandbox/data/replset1 2> /dev/null
mkdir -p /tmp/mongo_sandbox/data/replset2 2> /dev/null
echo "initializing replica1"
bin/mongod -f configs/replset1.conf 2>&1 > /dev/null
echo "initializing replica2"
bin/mongod -f configs/replset2.conf 2>&1 > /dev/null
echo "initializing arbiter1"
bin/mongod -f configs/arb1.conf 2>&1 > /dev/null
echo "initializing replica primary"
echo "rs.initiate()" | bin/mongo --port 30000 2>&1 > /dev/null

# wait for primary to come online
PRIMARIES=`echo "rs.status()" | mongo --port 30000 | grep PRIM | wc -l`
while [ "$PRIMARIES" -lt "1" ]
do
    echo "waiting for primary to come online"
    echo "rs.initiate()" | bin/mongo --port 30000 2>&1 > /dev/null
    PRIMARIES=`echo "rs.status()" | mongo --port 30000 | grep PRIM | wc -l`
    sleep 1
done

echo "rs.add('$HOSTNAME:30001');" | bin/mongo --port 30000 2>&1 > /dev/null
echo "rs.addArb('$HOSTNAME:40000');" | bin/mongo --port 30000 2>&1 > /dev/null
echo "done! run mongo --port 30000 to connect"
