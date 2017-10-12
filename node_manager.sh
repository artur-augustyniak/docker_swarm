#!/bin/bash

NODE_IP=$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)


node_manager_join()
{
    docker run -d --name $(hostname) --restart=always swarm join --advertise=${NODE_IP}:2375 consul://11.2.3.4.5:8500
}

node_manager_purge()
{
    docker rm -f $(docker ps -aq)
    docker rmi -f $(docker images -aq)
}

case $1 in
"join")
        node_manager_join
        ;;
"purge")
        node_manager_purge
        ;;
*)
        echo "Usage:"
        echo "node_manager join"
        echo "node_manager purge"
        ;;
esac

