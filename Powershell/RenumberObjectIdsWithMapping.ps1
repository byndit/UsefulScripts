$Path = "C:\YourRepoPath\"

$mapping = @{
    '50000' = '80000'
    '50001' = '80001'
    '50002' = '80002'
    '50003' = '80003'
    '50004' = '80004'
}

$regexescape = $mapping.Keys | ForEach-Object {[System.Text.RegularExpressions.Regex]::Escape($_)}
$regex = [regex]($regexescape -join '|')

Get-ChildItem -Path $Path -Recurse -File -Filter *.al | ForEach-Object {
    try {
        $values = { $mapping[$args[0].Value] }
        $incomingfile = [System.IO.File]::ReadAllText($_.FullName)
        $incomingfile = $regex.Replace($incomingfile, $values)
        [System.IO.File]::WriteAllText($_.FullName, $incomingfile)
    }
    catch {
        Write-Error "Failed to process file $_.FullName: $_"
    }
}
