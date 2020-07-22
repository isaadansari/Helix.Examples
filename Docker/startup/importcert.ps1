$pfxFilePath = 'cert.pfx'
[SecureString]$certificatepassword = ("b" | ConvertTo-SecureString -Force -AsPlainText)

Write-Host "Importing certificate"
Import-PfxCertificate -FilePath $pfxFilePath Cert:\LocalMachine\My -Password $certificatepassword -Exportable
$pfx = Import-PfxCertificate -FilePath $pfxFilePath -CertStoreLocation Cert:\LocalMachine\Root -Password $certificatepassword -Exportable
