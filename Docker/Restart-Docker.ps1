docker-compose down
docker system prune -f
restart-service *docker* -f

Write-Host "$((Get-Date).ToString("HH:mm:ss")) - Docker Service restarted"  -ForegroundColor Green

.\start.ps1
