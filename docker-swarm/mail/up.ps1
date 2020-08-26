
Write-Host "Deploying from compose file"

docker stack deploy -c ${PSScriptRoot}\docker-compose.yml mail
