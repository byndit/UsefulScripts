$credential = New-Object pscredential 'test', (ConvertTo-SecureString -String 'test' -AsPlainText -Force)
New-BcContainerBcUser -containerName de-latest -Credential $credential -PermissionSetId "SUPER"

