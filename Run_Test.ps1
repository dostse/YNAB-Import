$APIToken = (Import-Clixml .\APIKey.xml).GetNetworkCredential().Password
$BudgetName = "Test"
$AccountName = "TestAcc"

$CSVIn = "C:\Temp\Transaktioner_2021-10-29_09-24-16.csv"
#$KomplettCSV = "C:\Temp\transaktioner (1).csv"

$CSVOut = "c:\Temp\YNAB_SwedBank_$(Get-Date -Format yyyyMMdd_HHmmss).csv"
#$KomplettCSVOut = "c:\Temp\YNAB_KOMPLETT_$(Get-Date -Format yyyyMMdd_HHmmss).csv"

.\Convert-YNABSwedbankCSV.ps1 -InPath $CSVIn -OutPath $CSVOut
#.\Convert-YNABKomplettCSV.ps1 -InPath $KomplettCSV -OutPath $KomplettCSVOut

.\Import-YNABCSVFile.ps1 -APIToken $APIToken -BudgetName $BudgetName -AccountName $AccountName  -CSVFile $CSVOut
#.\Import-YNABCSVFile.ps1 -APIToken $APIToken -BudgetName $BudgetName -AccountName "" -CSVFile $KomplettCSVOut