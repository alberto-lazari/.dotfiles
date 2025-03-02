# Exit on error
$ErrorActionPreference = "Stop"

$IsAdmin = (
    [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")
if (-not $IsAdmin)
{
    Write-Output "You need to run this from an elevated shell: search `"Windows PowerShell`" and select `"Run as Administrator`"."
    Write-Error "Not running as administrator."
    exit 1
}

# Allow running local scripts
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Set dark theme
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

# Run debloater
# iex (iwr -UseBasicParsing -Uri "https://raw.githubusercontent.com/Sycnex/Windows10Debloater/refs/heads/master/Windows10Debloater.ps1")

if (-not (Get-Command winget -ErrorAction SilentlyContinue))
{
    Get-AppxPackage Microsoft.DesktopAppInstaller | Remove-AppxPackage
    Start-Sleep -Seconds 5
    $package = "https://aka.ms/getwinget"
    Invoke-WebRequest -Uri $package -OutFile "$env:TEMP\winget.appxbundle"
    Add-AppxPackage -Path "$env:TEMP\winget.appxbundle"
}

winget install alacritty

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
Bash "pacman -S --noconfirm zsh git vim"

# Install dotfiles
Bash "git clone https://github.com/alberto-lazari/.dotfiles ~/.dotfiles && ~/.dotfiles/install"
