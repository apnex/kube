#!/bin/bash

#docker run -d -P --net host --cap-add=SYS_TIME --cap-add=SYS_NICE apnex/alpine-ntp
#docker run -d -P --net host apnex/alpine-etcd

echo "-- shutting down running containers --"
docker rm -f -v $(docker ps -qa)
echo "-- removing untagged containers --"
#docker rmi -f $(docker images -q --filter dangling=true)
#docker rmi -f $(docker images -q)
echo "-- removing orphaned volumes --"
docker rm -v $(docker ps -a -q -f status=exited)
