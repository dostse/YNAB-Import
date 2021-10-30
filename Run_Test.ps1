param([Parameter(Mandatory = $false)]
[string]
$APIToken = (Import-Clixml .\APIKey.xml).GetNetworkCredential().Password,
[Parameter(Mandatory = $false)]
[string]
$BudgetName = "Test",
[Parameter(Mandatory = $false)]
[string]
$AccountName = "TestAcc",
[Parameter(Mandatory = $true)]
[string]
$CSVFile,
[Parameter(Mandatory = $false)]
[string]
$CSVOut = "c:\Temp\YNAB_Test_$(Get-Date -Format yyyyMMdd_HHmmss).csv"
)

.\Convert-YNABSwedbankCSV.ps1 -InPath $CSVFile -OutPath $CSVOut

.\Import-YNABCSVFile.ps1 -APIToken $APIToken -BudgetName $BudgetName -AccountName $AccountName  -CSVFile $CSVOut