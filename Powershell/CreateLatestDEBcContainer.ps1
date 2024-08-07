Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
Import-Module bccontainerhelper

$RootPath = (Split-Path $PSScriptRoot)
$containerName = 'bc24'
$credential = Get-Credential -Message 'Using UserPassword authentication. Please enter credentials for the container.'
$auth = 'UserPassword'
$sasToken = "?sv=XXXX"
$artifactUrl = Get-BcArtifactUrl -type sandbox -country 'de' -select NextMajor -sasToken  $sasToken
$licenseFile = "D:\Temp\license.flf"

New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -licenseFile $licenseFile `
    -isolation "hyperv" `
    -includeTestToolkit `
    -memoryLimit 8G `
    -includeAL `
    -doNotExportObjectsToText `
    -updateHosts `
    -assignPremiumPlan `
    -includeTestToolkit

Import-TestToolkitToBcContainer $containerName -includeTestLibrariesOnly
