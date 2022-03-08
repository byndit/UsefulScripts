Set-ExecutionPolicy Unrestricted
Install-Module bccontainerhelper

$RootPath = (Split-Path $PSScriptRoot)
$containerName = 'de-latest'
$credential = Get-Credential -Message 'Using UserPassword authentication. Please enter credentials for the container.'
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type sandbox -country 'de' -select Latest
$licenseFile = "C:\Temp\license.flf"

New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -licenseFile $licenseFile `
    -isolation "hyperv" `
    -memoryLimit 8G `
    -includeAL `
    -doNotExportObjectsToText `
    -updateHosts
