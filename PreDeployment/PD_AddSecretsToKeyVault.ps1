[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $true)][string]$ResourceGroupName,
    [Parameter(Mandatory = $true)][string]$KeyVaultName,
    [Parameter(Mandatory = $true)][string]$sitecoreAdminPassword,    
    [Parameter(Mandatory = $true)][string]$sqlServerPassword,
    [Parameter(Mandatory = $true)][string]$authCertificatePassword
)

$ctx = Get-AzContext
$sp  = Get-AzADServicePrincipal -ApplicationId $ctx.Account.Id
Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -ObjectID $sp.Id -PermissionsToSecrets get,list,set,delete
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

$sitecoreAdminPasswordName   = 'sitecoreAdminPassword'
$sqlServerPasswordName       = 'sqlServerPassword'
$authCertificatePasswordName = 'authCertificatePassword'

if($null -eq (Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $sitecoreAdminPasswordName))
{
    Write-Output "Adding Sitecore Admin Password"
    $secretvalue = ConvertTo-SecureString $sitecoreAdminPassword -AsPlainText -Force
    $secret      = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $sitecoreAdminPasswordName -SecretValue $secretvalue
}
else
{
    Write-Output "$sitecoreAdminPasswordName secret already exists"
}

if($null -eq (Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $sqlServerPasswordName))
{
    Write-Output "Adding SQL Server Password"
    $secretvalue = ConvertTo-SecureString $sqlServerPassword -AsPlainText -Force
    $secret      = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $sqlServerPasswordName -SecretValue $secretvalue
}
else
{
    Write-Output "$sqlServerPasswordName secret already exists"
}

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
