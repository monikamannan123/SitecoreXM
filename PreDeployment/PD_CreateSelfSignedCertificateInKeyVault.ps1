[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $true)][string]$KeyVaultName,
    [Parameter(Mandatory = $true)][string]$CertificateName,
    #[Parameter(Mandatory = $true)][string]$SubjectName,
    #[Parameter(Mandatory = $true)][string]$DnsName,
    #[Parameter(Mandatory = $true)][string]$FilePath,
    [Parameter(Mandatory = $true)][string]$BuildArtifactRootDirectory    
)

try 
{
    #$subject = "CN=" + $SubjectName
    #$dns     = ConvertTo-SecureString -String $DnsName -Force -AsPlainText

    # Creates an in-memory certificate policy object
    #$Policy  = New-AzKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName $subject `
    #                                    -DnsName $DnsName -IssuerName "Self" -ReuseKeyOnRenewal

    #Enroll certificate in key vault
    #Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertificateName -CertificatePolicy $Policy

    $path = "$(System.DefaultWorkingDirectory)\$BuildArtifactRootDirectory\drop\Scripts\$CertificateName"
    Write-Host $path
    $Password = ConvertTo-SecureString -String "Certificate01" -AsPlainText -Force
    Import-AzKeyVaultCertificate -VaultName $KeyVaultName -Name "ImportCert02" -FilePath $path -Password $Password
}
catch {

    throw $_.Exception.Message
}

