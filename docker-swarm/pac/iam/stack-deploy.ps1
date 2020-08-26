function Update-IamStack {
[CmdletBinding()]
Param(
    [string]$StackName = "pac-iam",
    
    [switch]$IncludeIdentityServer,
    [switch]$IncludeApi,
    [switch]$IncludeRoster,
    [switch]$IncludeAdmin,
    [switch]$IncludeRedis,

    [Parameter(Position=0,Mandatory=$false,ValueFromRemainingArguments=$true)]
    [string[]]$ScriptArgs
)


$stackArgs = @("stack", "deploy", "-c", "$PSScriptRoot\docker-compose-base.yml");

if ($IncludeIdentityServer) {
    $stackArgs += "-c"
    $stackArgs += "$PSScriptRoot\docker-compose-idsrv.yml"
}

if ($IncludeApi) {
    $stackArgs += "-c"
    $stackArgs += "$PSScriptRoot\docker-compose-api.yml"
}

if ($IncludeRoster) {
    $stackArgs += "-c"
    $stackArgs += "$PSScriptRoot\docker-compose-roster.yml"
}

if ($IncludeAdmin) {
    $stackArgs += "-c"
    $stackArgs += "$PSScriptRoot\docker-compose-admin.yml"
}


if ($IncludeRedis) {
    $stackArgs += "-c"
    $stackArgs += "$PSScriptRoot\docker-compose-redis.yml"
}

$stackArgs += $ScriptArgs
$stackArgs += $StackName

docker $stackArgs
exit $LASTEXITCODE
#docker stack deploy -c $PSScriptRoot\docker-compose-base.yml -c $PSScriptRoot\docker-compose-roster.yml pac-iam
}