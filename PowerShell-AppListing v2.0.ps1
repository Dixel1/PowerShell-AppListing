#PowerShell-AppListing v2.0
Write-Host "🔍 Récupération des applications installées..." -ForegroundColor Cyan

try {
    # Récupère les applications installées depuis les clés de registre
    $apps = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
        , "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" `
        , "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
        Where-Object { $_.DisplayName }

    if ($apps.Count -eq 0) {
        Write-Warning "⚠️ Aucune application installée n'a été trouvée."
    } else {
        Write-Host "✅ Applications récupérées avec succès. Nombre d'applications : $($apps.Count)" -ForegroundColor Green

        $csvPath = "$env:USERPROFILE\Desktop\AppList.csv"
        Write-Host "💾 Exportation vers le fichier : $csvPath" -ForegroundColor Cyan

        $apps | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

        if (Test-Path $csvPath) {
            Write-Host "✅ Export réussi ! Le fichier est disponible sur le Bureau." -ForegroundColor Green
        } else {
            Write-Error "❌ Échec de l'exportation du fichier CSV."
        }
    }
}
catch {
    Write-Error "❌ Une erreur est survenue : $_"
}
