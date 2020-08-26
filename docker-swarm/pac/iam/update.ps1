$dbServer = "sql_sqllinux"

docker run --rm `
    --net mesh-overlay `
    --env "MIGRATE_ONLY=true" `
    --env "DB_SERVER=$dbServer" `
    --env "DB_NAME=idsrv" `
    --env "DB_USER=sa" `
    --env "DB_PASSWORD=P@ssword1" `
    realms:latest-local

docker run --rm `
    --net mesh-overlay `
    --env "MIGRATE_ONLY=true" `
    --env "DB_SERVER=$dbServer" `
    --env "DB_NAME=roster2" `
    --env "DB_USER=sa" `
    --env "DB_PASSWORD=P@ssword1" `
    roster:latest-local
