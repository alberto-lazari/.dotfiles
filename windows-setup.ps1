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

$BashCommands = @'
set -e
export PATH=/usr/bin

WIN_HOME="/$(echo $(echo 'echo %HOME%' | cmd | grep '^[A-Z]:\\[^>]*$') | sed 's|^\([A-Z]\):|\l\1|' | sed 's|\\|/|g')"

# Make MSYS2 home target Windows home
line="$WIN_HOME /home/$(whoami) none bind"
grep -q "^$line$" /etc/fstab || echo $'\n'$line >> /etc/fstab

# Set Windows home as shell home
line="HOME=\"$WIN_HOME\""
grep -q "^$line$" /msys2.ini || echo $line >> /msys2.ini

# Inherit Windows PATH
sed -i 's/^#\(MSYS2_PATH_TYPE=inherit\)/\1/' /msys2.ini

# Install packages on pacman
pacman -Syu --noconfirm
pacman -S --noconfirm --needed zsh git vim

# Install dotfiles
git clone https://github.com/alberto-lazari/.dotfiles ~/.dotfiles && ~/.dotfiles/install
'@

echo "$BashCommands" | & "C:/msys64/usr/bin/bash.exe"

# Run debloater
curl.exe "https://raw.githubusercontent.com/Sycnex/Windows10Debloater/refs/heads/master/Windows10Debloater.ps1" | sudo powershell
