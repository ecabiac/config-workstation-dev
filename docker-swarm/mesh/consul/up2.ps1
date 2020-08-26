$HOSTIP="192.168.65.2"
$env:HOSTIP=$HOSTIP
docker stack deploy -c $PSScriptRoot\docker-compose-separates.yml mesh-consul
