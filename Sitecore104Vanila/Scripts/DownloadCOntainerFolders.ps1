[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,

    [Parameter(Mandatory = $true)]
    [string]$ContainerName,

    [Parameter(Mandatory = $true)]
    [string]$Prefix,

    [Parameter(Mandatory = $false)]
    [string]$Destination = ""
)

try {
    Write-Output "Getting the storage account context"
    $storageAccount = Get-AzureRMStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName

    Write-Output "Getting the blob path"
    $blobPath = Get-AzureStorageBlob -Container $ContainerName -Context $storageAccount.Context -Prefix $Prefix


    if ([string]::IsNullOrWhiteSpace($Destination)) {
        $Destination = Get-Location
    }
    if (!(Test-Path $Destination)) {
        New-Item -ItemType Directory -Force -Path $Destination
    }
    $Destination = Resolve-Path $Destination


    Write-Output ("Downloading files to '{0}'" -f $Destination)
    foreach ( $item in $blobPath.Name ) {
        Write-Output ("Downloading {0}" -f $item)
        $result = Get-AzureStorageBlobContent -Blob $item -Container $ContainerName -Context $storageAccount.Context -Destination $Destination -Force
    } #>
    Write-Output "Done"
}
catch {

    throw $_.Exception.Message
}