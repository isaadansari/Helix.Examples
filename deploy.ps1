$ErrorActionPreference = "Stop"

$TOOLS_DIR = Join-Path $PSScriptRoot "build\tools"
$NUGET_URL = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$NUGET_EXE = Join-Path $TOOLS_DIR "nuget.exe"
$VSWHERE_EXE = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"

$BUILD_SLN = Join-Path $PSScriptRoot "examples\helix-basic-unicorn\BasicCompany.sln"
$BUILD_PROJ = Join-Path $PSScriptRoot "examples\helix-basic-unicorn\src\Environment\Website\Website.csproj"

$synUrl = "http://localhost:44001/unicorn.aspx"
$syncSecret = "749CABBC85EAD20CE55E2C6066F1BE375D2115696C8A8B24DB6ED1FD60613086"

## https://github.com/microsoft/vswhere/wiki/Find-MSBuild
$MSBUILD = Invoke-Expression "&`"$VSWHERE_EXE`" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe | select-object -first 1"

Import-Module -Name $PSScriptRoot\logo
Show-Start

#---------------------------------------------------
## get latest code
#---------------------------------------------------

Write-Host "Pulling latest code..." -ForegroundColor Green
git pull


#---------------------------------------------------
## Download nuget exe 
#---------------------------------------------------

if (!(Test-Path $NUGET_EXE)) {
	Write-Host "Downloading NuGet.exe..." -ForegroundColor Green
	Invoke-WebRequest $NUGET_URL -OutFile $NUGET_EXE
}


#---------------------------------------------------
## Nuget restore
#---------------------------------------------------

Invoke-Expression "&`"$NUGET_EXE`" restore $BUILD_SLN"


#---------------------------------------------------
## Publish Project
#---------------------------------------------------

Write-Host "Publishing project..." -ForegroundColor Green

Invoke-Expression "&`"$MSBUILD`" $BUILD_PROJ /p:DeployOnBuild=true /p:PublishProfile=Local"


#---------------------------------------------------
## Unicorn sync - SYNC ALL CONFIGURATIONS
#---------------------------------------------------

Write-Host "Syncing Unicorn..." -ForegroundColor Green

Import-Module $PSScriptRoot\build\tools\Unicorn\Unicorn.psm1
Sync-Unicorn -ControlPanelUrl $synUrl -SharedSecret $syncSecret

cd $PSScriptRoot
