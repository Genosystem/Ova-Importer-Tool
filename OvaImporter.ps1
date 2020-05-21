# OVA Importer Tool
<#
TODO Check Values
TODO File default

#>


[string]$OvaSource = Read-Host "File path to OVA"
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
$VMName = Read-Host “Vm Name”

# Don't work with mapped drives
Import-vApp –Source $OvaSource -Location $ClusterSelected[0] -Datastore $DSSelected -Name $VMName -Host $RNDHost[(Get-random ($RNDHost.Count))] -Force