#!/bin/bash

date +%d-%m-%Y_%H:%M

if [ $(/usr/bin/curl -s https://localhost:9200/_cat/snapshots/s3_repository?v -k --user elastic:changeme |tail -1 |awk '{print $2}') != "SUCCESS"  ]
then
            echo "Snapshot still running exiting..."
            exit 100
else
            echo "Creating an index snapshot"
            /usr/bin/curl -s -XPUT "https://localhost:9200/_snapshot/s3_repository/`date +%d-%m-%Y_%H:%M`" -k --user elastic:changeme
fi
