# copy files into data folder if needed
$lib = "$($PSScriptRoot | Split-Path | Split-Path | Split-Path | Split-Path)\lib\DockerUtils.ps1"
. $lib


New-DockerVolume -volName "sqllinux_logs"
New-DockerVolume -volName "sqllinux_data"
New-DockerVolume -volName "sqllinux_backup"



docker create -v sqllinux_data:/tmp/data sqllinux_backup:/tmp/backup --name sqldatainit containous/whoami tail -f /dev/null

# copy backup (bak) files
docker cp F:\AppData\sqlbak\gateway.bak sqldatainit:/tmp/backup/
docker cp F:\AppData\sqlbak\globalconfig.bak sqldatainit:/tmp/backup/
docker cp F:\AppData\sqlbak\idsrv.bak sqldatainit:/tmp/backup/
docker cp F:\AppData\sqlbak\roster.bak sqldatainit:/tmp/backup/

# copy data (mdf/ldf) files
#docker cp C:\dev-db\sqlbak\idsrv.mdf sqldatainit:/tmp/data/
#docker cp C:\dev-db\sqlbak\idsrv_log.ldf sqldatainit:/tmp/data/

docker rm sqldatainit