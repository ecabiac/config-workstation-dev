<#
.SYNOPSIS
    Creates a docker volume if it doesn't exist
#>
function New-DockerVolume{
    [CmdletBinding()]
    param
    (
        [Parameter(HelpMessage='The name of the volume', Mandatory=$true, ValueFromPipeline)]
        [string] 
        $volName
    )

    process {
        $vols = docker volume ls --format "{{ json . }}" | ConvertFrom-Json
        $vol = $vols | Where-Object { $_.Name -eq $volName }

        if (-not $vol) {
            docker volume create $volName
        } else {
            Write-Information "Volume '$volName' already exists"
        }
    }
}

<#
.SYNOPSIS
    Creates a docker Network if it doesn't exist
#>
function New-DockerNetwork {
    [CmdletBinding()]
    param
    (
        [Parameter(HelpMessage='The name of the network', Mandatory=$true,ValueFromPipeline)]
        [string] 
        $netName
    )

    process {
        $nets = docker network ls --format "{{ json . }}" | ConvertFrom-Json
        $net = $nets | Where-Object { $_.Name -eq $netName }

        if (-not $net) {
            docker network create --attachable --scope swarm -d overlay $netName
        } else {
            Write-Information "Network '$netName' already exists"
        }
    }
}

function Find-DockerServiceInstance {
    
    [CmdletBinding()]
    param
    (
        [Parameter(HelpMessage='The name of the service', Mandatory=$true, ValueFromPipeline)]
        [string] 
        $Name
    )

    process {
        docker ps --format "{{ json . }}" | ConvertFrom-Json | Where-Object {$_.Labels -match "com\.docker\.swarm\.service\.name=$Name"} | Select-Object -First 1 -ExpandProperty ID
    }
    
}