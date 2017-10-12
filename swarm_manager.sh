#!/bin/bash

swarm_manager_up()
{
    docker run -d -p 8500:8500 --name=consul --restart=always progrium/consul -server -bootstrap
    docker run -d -p 4000:4000 --name=swarm-manager --restart=always swarm manage -H :4000 --advertise 1.2.3.4.5:4000  consul://1.2.3.4.5:8500	
}

swarm_manager_purge()
{
    docker rm -f $(docker ps -aq)
    docker rmi -f $(docker images -aq)
}

case $1 in
"up")
	swarm_manager_up
	;;
"purge")
	swarm_manager_purge
	;;
*)	
	echo "Usage:"
	echo "swarm_manager up"
	echo "swarm_manager purge"
	;;
esac
