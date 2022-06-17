Install-Module SqlServer -AllowClobber
Import-Module SqlServer

$db = "Demo Database BC (14-0)"
$SQLServer = "localhost"
$olderThanXdays = -365

$companies = Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db -Query 'SELECT Name from [dbo].[Company]'
foreach ($company in $companies) {
    $companyname = $company.Name
    $query = 'SELECT * FROM dbo.['+$companyname+'$Change Log Entry] where [dbo].['+$companyname+'$Change Log Entry].[Date and Time] < DATEADD(day, '+$olderThanXdays+', SYSDATETIME())'
    Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db -Query $query | Export-Csv `
        -NoTypeInformation `
        -Path "C:\$companyname.csv" `
        -Encoding UTF8

    $deleteQuery = 'delete from [dbo].['+$companyname+'$Change Log Entry] where [dbo].['+$companyname+'$Change Log Entry].[Date and Time] < DATEADD(day, '+$olderThanXdays+', SYSDATETIME())'
    Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db -Query $deleteQuery
}
