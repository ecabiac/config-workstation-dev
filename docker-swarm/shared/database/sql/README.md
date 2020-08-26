# Swarm Service for MSSQL On Linux

## Configuration Notes

The base IMAGE from the vendor (`mcr.microsoft.com/mssql/server:2017-CU14-ubuntu`)
is configured with several subdirectories under `/var/opt/mssql/`. In order to
preserve the state of our server in the event the container gets recreated, we
need to mount a volume to this directory.

It is possible that the database system itself (i.e. the master and model
databases) may become corrupt. In this case we want to ensure that we have
backups of the user databases mounted in a separate volume. Technically, it
would be possible to use the same volume, and simply bind mount to a different
container path during a recovery event...but this seems like more effort than
is needed.

## Configuration Decisions

Three Volumes will be created in docker *external* to the swarm stack. This will make it easier to
drop the whole stack without losing our data files.

- mssql_db - mounts to `/var/opt/mssql/` to preserve the instance configuration
- mssql_data - mounts to `/var/dbfiles/data` and is where the data and log files for user databases are stored
- mssql_backups - mounts to `/var/dbfiles/backups` and is where user database backups are stored

## Initialization Procedures

When starting with no service and no existing volumes, we can run a container using the same docker image for preparation purposes.

### Create the volumes

```bash
docker volume create mssql_db
docker volume create mssql_data
docker volume create mssql_backups
```

### Run the docker container

```powershell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourStrong!Passw0rd>" `
   --name "sqlinit"`
   -v mssql_db:/var/opt/mssql `
   -v mssql_data:/var/dbfiles/data `
   -v mssql_backups:/var/dbfiles/backups `
   -d mcr.microsoft.com/mssql/server:2017-latest
```

### Copy our backup database files into the container

```powershell
docker cp .\dbfile.bak sqlinit:/var/dbfiles/backups/dbfile.bak
```

## Standard Operating Procedures

### Creating Backups

## Recovery Procedures
