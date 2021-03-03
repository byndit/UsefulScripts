$sourcepath = "D:\Source\"
$targetpath = "D:\Target\"
 
Measure-Command -Expression {
    #slow
    Get-ChildItem $sourcepath  -Filter *.txt | Foreach-Object {
        $filepath = $_.FullName
        $lines = Get-Content -Path $filepath
        foreach ($line in $lines) {
            if ($line -match "OBJECT (Table|Report|Codeunit|Page|Query|XMLport|Form|Dataport|MenuSuite) (\d+) (.*)") {
                $newfilepath = (Join-Path -Path $targetpath -ChildPath ($Matches[1].ToLower() + '_' + ('{0:d10}' -f [int]$Matches[2]) + $_.Extension));
                Add-Content -path $newfilepath -value $line
            }
            else {
                if (Test-Path $newfilepath) {
                    Add-Content -path $newfilepath -value $line
                }
            }
        }
    }
}


Measure-Command -Expression {
    #fast
    $sourcepath = "D:\Source\"
    $targetpath = "D:\Target\"
     
    Get-ChildItem $sourcepath  -Filter *.txt | Foreach-Object {
        $filepath = $_.FullName
        $lines = Get-Content -Path $filepath
        foreach ($line in $lines) {
            if ($line -match "OBJECT (Table|Report|Codeunit|Page|Query|XMLport|Form|Dataport|MenuSuite) (\d+) (.*)") {
                if ($newfilepath) {
                    $arr | Out-File -Append $newfilepath
                    $arr = @()
                }
                $newfilepath = (Join-Path -Path $targetpath -ChildPath ($Matches[1].ToLower() + '_' + ('{0:d10}' -f [int]$Matches[2]) + $_.Extension));
            }
            $arr += $line
        }
    }
}