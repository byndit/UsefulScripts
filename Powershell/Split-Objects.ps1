#slow
$sourcepath = "D:\Source\"
$targetpath = "D:\Target\"
Remove-Item $targetpath*.txt -Recurse -Force 
Measure-Command -Expression {
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

#fast 
$sourcepath = "D:\Source\"
$targetpath = "D:\Target\"
Remove-Item $targetpath*.txt -Recurse -Force
Measure-Command -Expression {  
    Get-ChildItem $sourcepath  -Filter *.txt | Foreach-Object {
        $filepath = $_.FullName
        $lines = Get-Content -Path $filepath
        foreach ($line in $lines) {
            if ($line -match "OBJECT (Table|Report|Codeunit|Page|Query|XMLport|Form|Dataport|MenuSuite) (\d+) (.*)") {
                if ($newfilepath) {
                    $arr | Out-File -Append $newfilepath -Encoding default
                    $arr = @()
                }
                $newfilepath = (Join-Path -Path $targetpath -ChildPath ($Matches[1].ToLower() + '_' + ('{0:d10}' -f [int]$Matches[2]) + $_.Extension));
            }
            $arr += $line
        }
    }
}

#faster 
$sourcepath = "D:\Source\"
$targetpath = "D:\Target\"
Remove-Item $targetpath*.txt -Recurse -Force
Measure-Command -Expression {
    Get-ChildItem $sourcepath  -Filter *.txt | Foreach-Object {
        $filepath = $_.FullName
        $lines = [IO.File]::OpenText($filepath)
        while ( -not $lines.EndOfStream) {
            $line = $lines.ReadLine()
            if ($line -match "OBJECT (Table|Report|Codeunit|Page|Query|XMLport|Form|Dataport|MenuSuite) (\d+) (.*)") {
                if ($newfilepath) {
                    $Textstream = [System.IO.StreamWriter]::new($newfilepath, $true)
                    $Textstream.Write($arr.ToString())
                    $Textstream.close()
                    $arr.Clear();
                    $arr = [System.Text.StringBuilder]::new()
                }
                $newfilepath = (Join-Path -Path $targetpath -ChildPath ($Matches[1].ToLower() + '_' + ('{0:d10}' -f [int]$Matches[2]) + $_.Extension));
            }
            if ($line) {
                [void]$arr.Append($line + "`r`n") 
            }
        }
        $lines.close()
    }
}