# PowerShell Core
# Windows system

# Alias
## Github Folder
Function FUNCGH {Set-Location -Path C:\Github\}
Set-Alias -Name gh -Value FUNCGH

## Gitlab Folder
Function FUNCGL {Set-Location -Path C:\Gitlab\}
Set-Alias -Name gl -Value FUNCGL

## Docker
Set-Alias -Name d -Value docker

# Check output
Write-Output "andxpto configs loaded"
