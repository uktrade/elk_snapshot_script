#!/bin/bash

if [ $(/usr/bin/curl -Lfs http://169.254.169.254/latest/meta-data/instance-id) == $(/usr/local/bin/aws ec2 describe-instances --instance-ids "`/usr/local/bin/aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names webops-elk-elastic-bak-asg | jq -r '[.AutoScalingGroups[].Instances[].InstanceId]'`" --filters Name=instance-state-name,Values=running | jq -r '[.Reservations[].Instances[].InstanceId]|.[]' |sort |head  -1) ]
then
	exit 0
elses
	exit 100
fi
