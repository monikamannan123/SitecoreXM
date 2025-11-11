[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $true)][string]$ResourceGroupName,
    [Parameter(Mandatory = $true)][string]$AccountName,
    [Parameter(Mandatory = $true)][string]$Location,
    [Parameter(Mandatory = $true)][string]$ContainerName
)

Write-Host "[Start] Creating $AccountName storage account $Location location"
try
{
    Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $AccountName -ErrorAction Stop | Out-Null
    Write-Host "$AccountName storage account in $Location location already exists, skipping creation"
}
catch
{
    Write-Host "[Finish] Creating $AccountName storage account in $Location location"
    New-AzStorageAccount -ResourceGroupName     $ResourceGroupName `
                         -AccountName           $AccountName `
                         -Location              $Location `
                         -AllowBlobPublicAccess $false `
                         -Kind                  StorageV2 `
                         -PublicNetworkAccess   Disabled `
                         -SkuName               Standard_LRS `
                         -AccessTier            Cool
}

Write-Host "[Start] Creating $ContainerName storage account $Location location"
try
{
    Get-AzStorageContainer -Name $ContainerName -ErrorAction Stop | Out-Null
    Write-Host "$ContainerName storage container in $Location location already exists, skipping creation"
}
catch
{
    Write-Host "[Finish] Creating $ContainerName storage contrainer in $Location location"

    $azureKey   = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -AccountName $AccountName
    Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -AccountName $AccountName -ListKerbKey
    #$storagekey = [string]$azureKey.Primary
    $storagekey = [string]$azureKey.value[0]

    write-host $azurekey
    write-host $storagekey

    $context    = New-AzStorageContext -StorageAccountName $AccountName -StorageAccountKey $storagekey  

    write-host $context

    New-AzStorageContainer -Name $ContainerName -Context $context -Permission Off
}
