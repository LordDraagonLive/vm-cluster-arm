# Validate-ArmTemplate.ps1

param(
    [string]$ResourceGroupName,
    [string]$TemplateFilePath,
    [string]$TemplateParameterFilePath
)

# Ensure the Azure module is loaded
Import-Module Az

# Validate the ARM template
$result = Test-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFilePath -TemplateParameterFile $TemplateParameterFilePath

# Output the result
if ($result.Status -eq "Succeeded") {
    Write-Host "ARM Template validation passed." -ForegroundColor Green
} else {
    Write-Host "ARM Template validation failed." -ForegroundColor Red
    $result.Error | ForEach-Object { Write-Host $_.Message -ForegroundColor Red }
}
