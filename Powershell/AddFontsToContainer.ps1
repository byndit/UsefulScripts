Import-Module bccontainerhelper
$containerName  = "de-latest"

Add-FontsToBcContainer -containername $containerName -path C:\Windows\Fonts
Restart-BcContainer -containerName $containername