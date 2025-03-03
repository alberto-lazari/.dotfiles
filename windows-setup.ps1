### Windows preliminary setup

# Exit on error
$ErrorActionPreference = "Stop"

# Allow running local scripts
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Set dark theme
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

# Ensure winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue))
{
    Get-AppxPackage Microsoft.DesktopAppInstaller | Remove-AppxPackage
    Start-Sleep -Seconds 5
    $package = "https://aka.ms/getwinget"
    Invoke-WebRequest -Uri $package -OutFile "$env:TEMP\winget.appxbundle"
    Add-AppxPackage -Path "$env:TEMP\winget.appxbundle"
}

# Install sudo
if (-not (Get-Command sudo -ErrorAction SilentlyContinue))
{
    winget install gsudo
    $UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $MachinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $Env:Path = "${UserPath};${MachinePath}"
}

winget install alacritty
winget install mozilla.firefox

# Install MSYS2 for GNU support
winget install msys2.msys2
function Bash($Command)
{
    & "C:/msys64/usr/bin/bash.exe" -c "export PATH=/usr/bin; $Command"
}

$WinHome = "/$($HOME -replace 'C:', 'c' -replace '\\', '/')"

# Make MSYS2 home target Windows home
$Line = "$WinHome /home/$((whoami).Split('\')[-1]) none bind"
Bash "grep -q \`"$Line\`" /etc/fstab || echo $Line >> /etc/fstab"

# Set Windows home as shell home
$Line = "HOME=$WinHome"
Bash "grep -q \`"$Line\`" /msys2.ini || echo $Line >> /msys2.ini"

# Install packages on pacman
Bash "pacman -Syu --noconfirm"
Bash "pacman -S --noconfirm --needed zsh git vim"

# Install dotfiles
Bash "git clone https://github.com/alberto-lazari/.dotfiles ~/.dotfiles && ~/.dotfiles/install"

# Run debloater
curl.exe "https://raw.githubusercontent.com/Sycnex/Windows10Debloater/refs/heads/master/Windows10Debloater.ps1" | sudo powershell
