#!/bin/bash

# Mongo 2.0 32-bit
#URL="http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.0.2.tgz"

# Mongo 2.0 64-bit
#URL="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.0.2.tgz"

# Mongo 1.8 32-bit
#URL="http://fastdl.mongodb.org/linux/mongodb-linux-i686-1.8.4.tgz"

# Mongo 1.8 64-bit
#URL="http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-1.8.4.tgz"

if [ "x$URL" = "x" ]
then
    echo "Please select a download source in fetch_mongo.sh and try again."
    exit 1
fi

if [ ! -f /tmp/mongo.tar.gz ]
then
    wget -O /tmp/mongo.tar.gz "$URL"
fi

tar --strip-components=1 -zxvf /tmp/mongo.tar.gz
