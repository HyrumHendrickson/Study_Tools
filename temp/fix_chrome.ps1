# Temporarily set execution policy for this session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Define path to Chrome's User Data folder
$userDataPath = Join-Path $env:LOCALAPPDATA "Google\Chrome\User Data"
$chromeDir = Split-Path $userDataPath

function Get-NextBackupName {
    param (
        [string]$baseName = "User Data Backup"
    )
    $counter = 1
    $backupName = $baseName
    while (Test-Path (Join-Path $chromeDir $backupName)) {
        $counter++
        $backupName = "$baseName v$counter"
    }
    return $backupName
}

if (Get-Process -Name "chrome" -ErrorAction SilentlyContinue) {
    Write-Host "Google Chrome is running. Please close it before running this script." -ForegroundColor Yellow
    Pause
    exit 1
}

if (-Not (Test-Path $userDataPath)) {
    Write-Host "Chrome 'User Data' folder not found at: $userDataPath" -ForegroundColor Red
    Pause
    exit 1
}

$nextBackupName = Get-NextBackupName
$backupPath = Join-Path $chromeDir $nextBackupName

try {
    Rename-Item -Path $userDataPath -NewName $nextBackupName
    Write-Host "Chrome 'User Data' folder renamed to '$nextBackupName'" -ForegroundColor Green
} catch {
    Write-Host "Error renaming folder: $_" -ForegroundColor Red
    Pause
    exit 1
}

Pause
