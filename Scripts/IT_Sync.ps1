##############################
# Synchronisation dossier IT #
##############################

Start-Sleep -Seconds 60

# ===== CONFIGURATION =====
$DossierLocal = "C:\IT\Sync"
$User = "Anef15"
$Repo = "IT_Sync"
$Branche = "main"
# ========================

if (-Not (Test-Path $DossierLocal)) {
    Write-Host "Clonage du dépôt..." -ForegroundColor Yellow
    git clone "https://github.com/${User}/${Repo}.git" $DossierLocal
} else {
    Write-Host "Synchronisation..." -ForegroundColor Green
    Set-Location "$DossierLocal"
    git fetch origin -q
    git reset --hard "origin/$Branche" -q
}

Write-Host "Synchronisation terminée!" -ForegroundColor Green
