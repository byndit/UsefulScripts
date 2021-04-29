param(
    $basePath = '.',
    $search = '',
    $replace = ''
)

$gitFolders = Get-ChildItem -Path $basePath -Recurse -Force | Where-Object { $_.Mode -match "h" -and $_.FullName -like "*\.git" }

 ForEach ($gitFolder in $gitFolders) {

        # Remove the ".git" folder from the path 
        $folder = $gitFolder.FullName -replace ".git", ""
        if(!(Test-Path $gitFolder.FullName)) {
                Write-Warning "No valid repo"
                continue
        }
        Write-Host "Performing origin renaming in folder: '$folder'..."

        # Go into the folder
 

        # Perform the command within the folder 
        try {
            Push-Location $folder 
            $url = git remote get-url origin 
            $newUrl = $url.Replace($search,$replace)

            if($url -ne $newUrl) {
                git remote set-url origin $newUrl
                $verifyUrl = git remote get-url origin
                if($verifyUrl -eq $newUrl) {
                    Write-Host "Changed remote from $url to $newUrl" -ForegroundColor Green
                } else {
                    Write-Host "Remote could not be switched" -ForegroundColor Red
                }
            } else {
                Write-Host "Nothing to do" -ForegroundColor Yellow
            }


        } finally {
            Pop-Location
        }
    }