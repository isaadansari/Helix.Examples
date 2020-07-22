
Import-Module -Name (Join-Path $PSScriptRoot "..\logo")
Show-Start

#---------------------------------------------------
## clean up
#---------------------------------------------------

docker system prune -f

#---------------------------------------------------
## check if user override env file exists and start docker
#---------------------------------------------------

$envFile = ".env" 

if (Test-Path ".env.user") {
    Write-Host "User specific .env file found. Starting Docker with custom user settings." -ForegroundColor Green
    $envFile = ".env.user"
}

#---------------------------------------------------
## start
#---------------------------------------------------
docker-compose --env-file $envFile up -d
whales-names
