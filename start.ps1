$TargetVersion = "25H2"
$RegistryPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"

# 1. Cerveau : Vérification de l'état actuel
if (Test-Path $RegistryPath) {
    $CurrentVersion = (Get-ItemProperty -Path $RegistryPath -Name "TargetReleaseVersionInfo" -ErrorAction SilentlyContinue).TargetReleaseVersionInfo
    $CurrentStatus  = (Get-ItemProperty -Path $RegistryPath -Name "TargetReleaseVersion" -ErrorAction SilentlyContinue).TargetReleaseVersion
    
    # Si le blocage est déjà en place avec la bonne version, on s'arrête immédiatement
    if ($CurrentVersion -eq $TargetVersion -and $CurrentStatus -eq 1) {
        exit 0
    }
}

# 2. Action : On applique le blocage uniquement si nécessaire
try {
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force -ErrorAction Stop | Out-Null
    }
    Set-ItemProperty -Path $RegistryPath -Name "TargetReleaseVersion" -Value 1 -Type DWord -Force -ErrorAction Stop
    Set-ItemProperty -Path $RegistryPath -Name "ProductVersion" -Value "Windows 11" -Type String -Force -ErrorAction Stop
    Set-ItemProperty -Path $RegistryPath -Name "TargetReleaseVersionInfo" -Value $TargetVersion -Type String -Force -ErrorAction Stop
    exit 0 # Succès
}
catch {
    exit 1 # Échec (par exemple si non-administrateur)
}
