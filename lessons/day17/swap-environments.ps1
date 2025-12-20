#############################################
# Script: swap-environment.ps1
# Purpose: Perform Elastic Beanstalk
#          Blue-Green environment CNAME swap
#############################################

#############################################
# Script Parameters
#############################################

param(
    [Parameter(Mandatory = $false)]
    [string]$Region = "us-east-1",

    [Parameter(Mandatory = $false)]
    [string]$BlueEnv = "",

    [Parameter(Mandatory = $false)]
    [string]$GreenEnv = ""
)

#############################################
# Script Header
#############################################

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Blue-Green Environment Swap" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

#############################################
# Retrieve Environment Names from Terraform
#############################################

if ([string]::IsNullOrEmpty($BlueEnv) -or [string]::IsNullOrEmpty($GreenEnv)) {
    Write-Host "Retrieving environment names from Terraform outputs..." -ForegroundColor Yellow

    try {
        $tfOutput = terraform output -json | ConvertFrom-Json
        $BlueEnv  = $tfOutput.blue_environment_name.value
        $GreenEnv = $tfOutput.green_environment_name.value

        Write-Host "[SUCCESS] Environments detected:" -ForegroundColor Green
        Write-Host "  Blue  (Production): $BlueEnv" -ForegroundColor Blue
        Write-Host "  Green (Staging):    $GreenEnv" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Unable to read Terraform outputs." -ForegroundColor Red
        Write-Host "  Run 'terraform apply' first or provide environment names manually." -ForegroundColor Yellow
        exit 1
    }
}

#############################################
# User Confirmation
#############################################

Write-Host ""
Write-Host "[WARNING] This action will swap environment CNAMEs." -ForegroundColor Yellow
Write-Host "  Production traffic will be redirected to the Green environment." -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to continue or Ctrl+C to cancel..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#############################################
# Execute Blue-Green Swap
#############################################

Write-Host ""
Write-Host "Initiating environment swap..." -ForegroundColor Yellow

try {
    aws elasticbeanstalk swap-environment-cnames `
        --source-environment-name $BlueEnv `
        --destination-environment-name $GreenEnv `
        --region $Region

    #########################################
    # Swap Success
    #########################################

    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "[SUCCESS] Blue-Green swap initiated!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[INFO] The swap typically completes within 1–2 minutes." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Verification steps:" -ForegroundColor Cyan
    Write-Host "1. Check the Elastic Beanstalk console" -ForegroundColor White
    Write-Host "2. Visit the environment URLs after a short wait" -ForegroundColor White
    Write-Host "3. Run: terraform output instructions" -ForegroundColor White
}
catch {

    #########################################
    # Swap Failure
    #########################################

    Write-Host ""
    Write-Host "[ERROR] Swap failed" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting steps:" -ForegroundColor Yellow
    Write-Host "1. Verify AWS CLI credentials and permissions" -ForegroundColor White
    Write-Host "2. Ensure both environments are healthy" -ForegroundColor White
    Write-Host "3. Confirm no other Elastic Beanstalk operation is running" -ForegroundColor White
    exit 1
}
