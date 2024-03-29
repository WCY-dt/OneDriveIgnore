try {
    # Get local OneDrive path
    $oneDrivePath = [System.Environment]::GetEnvironmentVariable('OneDrive', 'User')
    Write-Output $oneDrivePath

    # If the path does not exist, throw an exception
    if (-not $oneDrivePath) {
        throw "OneDrive path not found."
    }
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}

# Read .onedriveignore file from the path
$ignoreFilePath = "${oneDrivePath}\.onedriveignore"

# If the file does not exist, create a new empty file, prompt and exit
if (-not (Test-Path $ignoreFilePath)) {
    New-Item -Path $ignoreFilePath -ItemType File | Out-Null
    Write-Output "Created new .onedriveignore file."
    exit 0
}

# If the file is empty, exit directly
if ((Get-Content $ignoreFilePath) -eq $null) {
    Write-Output ".onedriveignore file is empty."
    exit 0
}

# Define registry path
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive\EnableODIgnoreListFromGPO"

# Check if the registry path exists, if not, create it
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Delete all items under the registry path
Get-ItemProperty -Path $registryPath | ForEach-Object {
    try {
        Remove-ItemProperty -Path $registryPath -Name $_.PSChildName
    }
    catch {
        Write-Error $_.Exception.Message
        exit 1
    }
}

# Total number of lines in the file
$total = (Get-Content $ignoreFilePath).Count
# Current line number
$count = 0

# Traverse each line of the file
Get-Content $ignoreFilePath | ForEach-Object {
    $count++

    # Convert count to string
    $itemName = $count.ToString()
    # Remove trailing spaces, tabs, and newline characters from the line
    $itemValue = $_.TrimEnd()

    try {
        # Add or modify an item in the specified registry path
        Set-ItemProperty -Path $registryPath -Name $itemName -Value $itemValue
    }
    catch {
        Write-Error $_.Exception.Message
        exit 1
    }

    Write-Output "Add item ${count}/${total}: ${itemValue}"
}