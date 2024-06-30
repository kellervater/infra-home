function restart-gpg-agent {
    Write-Host "gracefully reloading gpg agent..."
    gpg-connect-agent reloadagent /bye
}

function restart-force-gpg-agent {
    Write-Host "forcefully reloading gpg agent..."
    gpg-connect-agent killagent /bye
    gpg-connect-agent /bye
}

# path's subject to fix in future PS1 versions... probably
function start-pageant {
    cscript "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\yubi-wsl-ssh-pageant.vbs"
}
