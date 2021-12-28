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
$XLSFile,
[Parameter(Mandatory = $false)]
[string]
$CSVOut = "c:\Temp\YNAB_Test_$(Get-Date -Format yyyyMMdd_HHmmss).csv"
)

.\Convert-YNABEverydayCardXls.ps1 -InPath $XLSFile -OutPath $CSVOut -ErrorAction Stop

.\Import-YNABCSVFile.ps1 -APIToken $APIToken -BudgetName $BudgetName -AccountName $AccountName  -CSVFile $CSVOut