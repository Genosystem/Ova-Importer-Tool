# OVA Importer Tool
Param(
    [Parameter(Mandatory = $false)][ValidateSet('e', 's', 'lo', 'li', 'i', 'o', 'c')][string]$direction,
    [Parameter(Mandatory = $false)][string]$OvaSource = "",
    [Parameter(Mandatory = $false)][string]$OvaCheck = ""

)



<#
TODO Check Values
TODO File default

#>

#While ($Hour -gt 23 -or $Hour -lt 0) { 
While (!$OvaCheck) { 
    [string]$OvaSource = Read-Host "File path to OVA"
    $OvaCheck = Test-Path $OvaSource -PathType leaf
    if (!$OvaCheck) {
        Write-Host "File not found or not accesible" -ForegroundColor DarkRed
    }
}
# 
[string]$FileName = Split-Path $OvaSource -leafbase
$ClustersList = get-cluster
$i = 0
foreach ($ClustersItem in $ClustersList ) {
    
    Write-Host "[$i]    - $ClustersItem"
    $i++
}

$ClusterSelected = Get-Cluster ($ClustersList[(Read-Host "Cluster Number")])
Write-host "$ClusterSelected Selected" -ForegroundColor DarkGreen
$RNDHost = ($ClusterSelected | Get-VMHost)

$DSList = get-cluster $ClusterSelected | Get-Datastore
$i = 0
foreach ($DSItem in $DSList ) {
    
    Write-Host "[$i]    - $DSItem"
    $i++
}
$DSSelected = Get-Datastore ($DSList[(Read-Host "DataStore Number")])
Write-host "$DSSelected Selected" -ForegroundColor DarkGreen
$VMName = Read-Host “Vm Name (Press Enter to set to $FileName)”
if (!$VMName) { $VMName = $Filename }
Write-host "Name $VMName" -ForegroundColor DarkGreen

# Don't work with mapped drives
Import-vApp –Source $OvaSource -Location $ClusterSelected[0] -Datastore $DSSelected -Name $VMName -Host $RNDHost[(Get-random ($RNDHost.Count))] -Force