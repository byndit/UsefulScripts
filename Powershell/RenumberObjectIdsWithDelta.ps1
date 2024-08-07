$Path = "C:\YourRepoPath\"
$delta = 30000

function Calculate-NewId {
    param (
        [string]$oldId
    )

    $newId = ([int]$oldId) + $delta
    return $newId.ToString()
}

function Replace-ObjectIds {
    param (
        [string]$content
    )

    $regexPattern = '\b\d{5}\b'

    $replacer = {
        param ($match)
        return Calculate-NewId -oldId $match.Value
    }

    return [regex]::Replace($content, $regexPattern, $replacer)
}

Get-ChildItem -Path $Path -Recurse -File -Filter *.al | ForEach-Object {
    try {
        $incomingFileContent = [System.IO.File]::ReadAllText($_.FullName)
        $updatedContent = Replace-ObjectIds -content $incomingFileContent
        [System.IO.File]::WriteAllText($_.FullName, $updatedContent, [System.Text.Encoding]::UTF8)
    }
    catch {
        Write-Error "Failed to process file $_.FullName: $_"
    }
}
