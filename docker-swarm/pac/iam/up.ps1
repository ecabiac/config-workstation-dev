. $PSScriptRoot\stack-deploy.ps1

Update-IamStack -IncludeIdentityServer -IncludeApi -IncludeRoster -IncludeAdmin -IncludeRedis
