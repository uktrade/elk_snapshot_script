#!/bin/bash

date +%d-%m-%Y_%H:%M

request_body=$(< <(cat <<EOF
{
  "type": "s3",
  "settings": {
    "bucket": "$SNAPSHOT_BUCKET",
    "region": "$AWS_DEFAULT_REGION"
  }
}
EOF
))

if [ $(curl -s https://localhost:9200/_snapshot/s3_repository/ -k --user elastic:changeme | jq '.[]'|tail -1) == "404" ]
then
	echo "Enabling snapshots to S3"
	/usr/bin/curl -s -XPUT 'https://localhost:9200/_snapshot/s3_repository?verify=false&pretty' -H 'Content-Type: application/json' -d "$request_body" -k --user elastic:changeme
	echo "Creating an index snapshot"
	/usr/bin/curl -s -XPUT "https://localhost:9200/_snapshot/s3_repository/`date +%d-%m-%Y_%H:%M`" -k --user elastic:changeme
	exit 0

fi

if [ $(/usr/bin/curl -s https://localhost:9200/_cat/snapshots/s3_repository?v -k --user elastic:changeme |tail -1 |awk '{print $2}') != "SUCCESS"  ]
then
            echo "Snapshot still running exiting..."
            exit 100
else
            echo "Creating an index snapshot"
            /usr/bin/curl -s -XPUT "https://localhost:9200/_snapshot/s3_repository/`date +%d-%m-%Y_%H:%M`" -k --user elastic:changeme
fi
