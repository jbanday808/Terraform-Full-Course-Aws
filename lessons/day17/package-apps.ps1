#############################################
# Script: package-apps.ps1
# Purpose: Package application versions for
#          Elastic Beanstalk Blue-Green deployment
#############################################

#############################################
# Script Header
#############################################

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Packaging Applications for Deployment" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

#############################################
# Package Application Version 1.0 (Blue)
#############################################

Write-Host "Packaging Application v1.0 (Blue)..." -ForegroundColor Yellow

Push-Location app-v1

# Remove existing package if present
if (Test-Path "app-v1.zip") {
    Remove-Item "app-v1.zip" -Force
}

# Create deployment package
Compress-Archive `
    -Path "app.js", "package.json" `
    -DestinationPath "app-v1.zip" `
    -CompressionLevel Optimal

Write-Host "[SUCCESS] Created app-v1/app-v1.zip" -ForegroundColor Green

# Return to project root
Pop-Location

Write-Host ""

#############################################
# Package Application Version 2.0 (Green)
#############################################

Write-Host "Packaging Application v2.0 (Green)..." -ForegroundColor Yellow

Push-Location app-v2

# Remove existing package if present
if (Test-Path "app-v2.zip") {
    Remove-Item "app-v2.zip" -Force
}

# Create deployment package
Compress-Archive `
    -Path "app.js", "package.json" `
    -DestinationPath "app-v2.zip" `
    -CompressionLevel Optimal

Write-Host "[SUCCESS] Created app-v2/app-v2.zip" -ForegroundColor Green

# Return to project root
Pop-Location

Write-Host ""

#############################################
# Script Completion
#############################################

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] All applications packaged successfully!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

#############################################
# Next Steps
#############################################

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run: terraform init" -ForegroundColor White
Write-Host "2. Run: terraform plan" -ForegroundColor White
Write-Host "3. Run: terraform apply" -ForegroundColor White
