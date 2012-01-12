#!/bin/bash

killall mongod 2> /dev/null
killall mongos 2> /dev/null
rm -rf /tmp/mongo_sandbox 2> /dev/null
rm -f THIRD-PARTY-NOTICES README GNU-AGPL-3.0
echo "remove bin/ if you want, I'm not doing that ;-)"
