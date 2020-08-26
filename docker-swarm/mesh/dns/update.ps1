#$volumeName = "dnsmasq-config"
##$containerName = "dnsmasq-init"
#$mountPath = "/tmp/"
#
#$container = docker create -v ${volumeName}:${mountPath} containous/whoami
#
#docker cp $PSScriptRoot\files\dnsmasq.conf ${container}:${mountPath}
#docker rm $container

docker config create dnsmasq-conf $PSScriptRoot\files\dnsmasq.conf