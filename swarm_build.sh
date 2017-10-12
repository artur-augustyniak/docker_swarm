#MANAGER
docker run -d -p 8500:8500 --name=consul --restart=always progrium/consul -server -bootstrap
docker run -d -p 4000:4000 --name=swarm-manager --restart=always swarm manage -H :4000 --advertise 1.2.3.4:4000  consul://1.2.3.4:8500

docker network create --driver overlay swarm

#NODES
docker run -d --name l06-swarm-node-0 --restart=always swarm join --advertise=1.2.3.5:2375 consul://1.2.3.4:8500
docker run -d --name l07-swarm-node-1 --restart=always swarm join --advertise=1.2.3.6:2375 consul://1.2.3.4:8500
docker run -d --name l08-swarm-node-2 --restart=always swarm join --advertise=1.2.3.7:2375 consul://1.2.3.4:8500
docker run -d -p 5000:5000 --restart=always --name registry pkobp/docker-registry

#RUN RABBIT
export DOCKER_HOST=l05-swarm-manager:4000
docker run -d -p 7777:7777 -e INSTANCE_ID=logstash-connector-1 -e CONFIG_TEMPLATE=tcp_to_fs.conf.tpl -v /media/gluster:/data logstash-connector