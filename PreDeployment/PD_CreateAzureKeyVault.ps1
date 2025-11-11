[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $true)][string]$KeyVaultName,
    [Parameter(Mandatory = $true)][string]$ResourceGroupName,
    [Parameter(Mandatory = $true)][string]$Location
)

try 
{
    if (-not(Get-AzKeyVault -VaultName $KeyVaultName))
    {
        Write-Output "Creating key vault"
        New-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $Location
        Write-Output "Done"
    }
    else
    {
        Write-Output "Key vault already exists, skipping creation"
    }
}
catch {

    throw $_.Exception.Message
}
