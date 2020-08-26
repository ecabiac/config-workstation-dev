#!/bin/bash

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD \
-Q "USE [master]
GO
CREATE DATABASE [idsrv] ON 
( FILENAME = N'/srv/mssql/data/idsrv.mdf' ),
( FILENAME = N'/srv/mssql/data/idsrv_log.ldf' )
 FOR ATTACH
GO
"
