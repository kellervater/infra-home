# if you are using network drives (e.g. for this repo), make sure that they are linkable between elevated and non-elevated sessions 
# If so, please set registry entry: "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" (simply Win+R -> regedit -> Enter)
# Value "EnableLinkedConnections" as DWORD32 -> Value: 1

# 
# ELEVATE SHELL
#
#some things here need admin permission. so we directly go to admin mode
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{

    $answer = Read-Host "Setup needs an elevated powershell to write the host file. Do you want to elevate the powershell now? [Y/n]"
    if ($answer.ToLowerInvariant() -eq "n") {
        Write-Host -ForegroundColor Red "Closing due to user abortion... (phrasing sounds off)"
        exit
    }
    else {
        # Get the script path
        $scriptPath = $MyInvocation.MyCommand.Definition

        # Create a new PowerShell process with administrator privileges
        $newProcess = New-Object System.Diagnostics.ProcessStartInfo "powershell"
        $newProcess.Arguments = "-NoProfile -NoExit -Command `"cd '$(Split-Path -Path $scriptPath -Parent)' ; & '$scriptPath'`""
        $newProcess.Verb = "runas"
        [System.Diagnostics.Process]::Start($newProcess)
        exit
    }
}

# TODO:
# install choco itself

# Install Dependencies using choco
choco install -y gpg4win


# Basic GPG Setup
Copy-Item -Path "gpg-agent.conf" -Destination "$HOME\AppData\Local\gnupg\gpg-agent.conf" -Force -Confirm:$false


# Use wsl-ssh-pageant as daemon in the background
## Download (we assume amd64 architecture here)
$url = "https://github.com/benpye/wsl-ssh-pageant/releases/latest/download/wsl-ssh-pageant-amd64.exe"
$outputFolder = Join-Path -Path $env:SystemDrive -ChildPath "wsl-ssh-pageant" # currently being located under system drive instead of program files (would otherwise require admin permissions)
if (!(Test-Path -Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}
$outputFile = Join-Path -Path $outputFolder -ChildPath (Split-Path $url -Leaf)
if (!(Test-Path -Path $outputFile)) {
    # Download the file only if it doesn't exist
    Invoke-WebRequest -Uri $url -OutFile $outputFile
} else {
    Write-Host "File '$outputFile' already exists. Skipping download."
}

## copy autostart script
$fileName = "yubi-wsl-ssh-pageant.vbs"
$startupFolderPath = [System.Environment]::ExpandEnvironmentVariables("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\$fileName")

Copy-Item -Path $fileName -Destination $startupFolderPath -Force -Confirm:$false


# if you call the script from here (elevated), normal users won't have access.

gpg-connect-agent killagent /bye
gpg-connect-agent /bye


## Add special functions to Powershell Profile
$fileName = "gpg_functions.ps1"
$psPath = "$HOME\Documents\WindowsPowershell\"
$profilePath = "$psPath\profile.ps1"


### Ensure the profile file exists
if (-not (Test-Path $profilePath)) {
    Write-Output "No powershell profile found! creating..."
    New-Item -ItemType File -Path $profilePath -Force
}

### copy functions script
Copy-Item -Path $fileName -Destination $psPath -Force -Confirm:$false
$functionsScript = "$psPath\$fileName"

### source functions script if not done so far
$gpgSourcingLine = ". $functionsScript; restart-gpg-agent"
$profileContent = Get-Content -Path $profilePath -ErrorAction SilentlyContinue
if ($profileContent -notcontains $gpgSourcingLine) {
    Write-Output "adding sourcing line for gpg-functions to powershell profile..."
    Add-Content -Path $profilePath -Value $gpgSourcingLine
}
