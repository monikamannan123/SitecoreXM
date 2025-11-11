[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $true)][string]$ResourceGroupName,
    [Parameter(Mandatory = $true)][string]$KeyVaultName,
    [Parameter(Mandatory = $true)][string]$authCertificatePassword
)

$ctx = Get-AzContext
$sp  = Get-AzADServicePrincipal -ApplicationId $ctx.Account.Id
Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -ObjectID $sp.Id -PermissionsToSecrets get,list,set,delete
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

$authCertificatePasswordName = 'conedAuthCertificatePassword'

if($null -eq (Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $authCertificatePasswordName))
{
    Write-Output "Adding Certificate Password"
    $secretvalue = ConvertTo-SecureString $authCertificatePassword -AsPlainText -Force
    $secret      = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $authCertificatePasswordName -SecretValue $secretvalue
}
else
{
    Write-Output "$authCertificatePasswordName secret already exists"
}

Write-Output "Done"
