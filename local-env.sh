#!/usr/bin/env bash

# Treafik
function start_edge_router(){

   read -r -d '' TREAFIK_CONFIG << EOM
[api]
[docker]
domain = "docker"
watch = true
[accessLog]
filePath = "/proc/self/fd/1"
format = "json"
EOM

    echo "Sourcing edge router (traefik)."
    echo ${TREAFIK_CONFIG} > /tmp/traefik.toml
    echo "Config file written to /tmp/traefik.toml."
    docker stop traefik > /dev/null
    docker rm traefik > /dev/null
	docker run --name traefik -d -p 8080:8080 -p 80:80 -v /tmp/traefik.toml:/etc/traefik/traefik.toml -v /var/run/docker.sock:/var/run/docker.sock -l traefik.enable=false traefik:1.7
	echo "Edge router in running, see: http://localhost:8080"
}

function ctop(){
   echo "Sourcing ctop."
   docker run --rm -ti \
     --name=ctop \
     -v /var/run/docker.sock:/var/run/docker.sock \
     quay.io/vektorlab/ctop:latest
}

function clog() {
    docker-compose logs -f
}

echo "Commands:"
echo " * start_edge_router \t - Initiate Treafik edge router"
echo " * ctop \t\t - A htop-like interface for container metrics"
echo " * clog \t\t - Alias for \`docker-compose logs -f\`"
echo "Hf gl!"