
$volumes = "redis-sentinel-1","redis-sentinel-2","redis-sentinel-3"

$mountPath = "/tmp/"

foreach($volumeName in $volumes){
    $container = docker create -v ${volumeName}:${mountPath} containous/whoami
    docker cp $PSScriptRoot\files\sentinel.conf ${container}:${mountPath}
    docker exec $container chmod +w "${mountPath}/sentinel.conf"
    docker rm $container
}
