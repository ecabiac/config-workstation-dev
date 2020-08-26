$volumeName = "prometheus-config"
$containerName = "prometheus-init"
$mountPath = "/tmp/"

# create a container instance with our target volume attached
docker create -v ${volumeName}:${mountPath} --name $containerName containous/whoami

docker cp $PSScriptRoot\files\prometheus.yml ${containerName}:${mountPath}
docker rm $containerName
