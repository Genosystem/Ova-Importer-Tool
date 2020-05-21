# OVA Importer Tool - Genosystem

Param(
    [Parameter(Mandatory = $false)][string]$OvaSource = "",
    [Parameter(Mandatory = $false)][bool]$OvaCheck = $false,
    [Parameter(Mandatory = $false)][int]$ClusterSelected = 9999,
    [Parameter(Mandatory = $false)][int]$DSSelected = 9999,
    [Parameter(Mandatory = $false)][string]$VMName
)

While (!$OvaCheck) { 
    [string]$OvaSource = Read-Host "File path to OVA"
    $Ovasource  = $OvaSource.Replace('"','')
    $SMBDrives = Get-SMBMapping
    foreach ($SMBDrive in $SMBDrives){
        if ((Split-Path $OvaSource -Qualifier) -eq $SMBDrive.LocalPath) {
            Write-Host "Mapped drive "(Split-Path $OvaSource -Qualifier)" detected, converting to "($SMBDrive.RemotePath) -ForegroundColor DarkYellow
            $OvaSource = $OvaSource.Replace((Split-Path $OvaSource -Qualifier),($SMBDrive.RemotePath))
        }
    }
    $OvaCheck = Test-Path $OvaSource -PathType leaf
    if (!$OvaCheck) {
        Write-Host "File not found or not accessible" -ForegroundColor DarkRed
    }
}
[string]$FileName = Split-Path $OvaSource -leafbase


$ClustersList = get-cluster
$i = 1
foreach ($ClustersItem in $ClustersList ) {
    
    Write-Host "[$i] - $ClustersItem"
    $i++
}
While ($ClusterSelected -gt $ClustersList.Count -or $ClusterSelected -lt 1) { 
    $ClusterSelected = Read-Host "Cluster Number"
}
$ClusterSelected = Get-Cluster ($ClustersList[($ClusterSelected -1)])
Write-host "$ClusterSelected Selected" -ForegroundColor DarkGreen
$RNDHost = ($ClusterSelected | Get-VMHost)

$DSList = get-cluster $ClusterSelected | Get-Datastore
$i = 1
foreach ($DSItem in $DSList ) {
    
    Write-Host "[$i] - $DSItem"
    $i++
}

While ($DSSelected -gt $DSList.Count -or $DSSelected -lt 1) { 
    $DSSelected = Read-Host "DataStore Number"
}

$DSSelected = Get-Datastore ($DSList[($DSSelected -1)])
Write-host "$DSSelected Selected" -ForegroundColor DarkGreen
$VMName = Read-Host “Vm Name (Press Enter to set to $FileName)”
if (!$VMName) { $VMName = $Filename }
Write-host "Name $VMName" -ForegroundColor DarkGreen

Import-vApp –Source $OvaSource -Location $ClusterSelected[0] -Datastore $DSSelected -Name $VMName -Host $RNDHost[(Get-random ($RNDHost.Count))] -Force