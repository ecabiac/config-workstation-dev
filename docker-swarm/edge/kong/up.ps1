Push-Location

Set-Location $PSScriptRoot
docker stack deploy -c .\docker-compose.yml kong

Pop-Location
