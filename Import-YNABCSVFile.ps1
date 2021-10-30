param([Parameter(Mandatory = $true)]
[string]
$APIToken,
[Parameter(Mandatory = $true)]
[string]
$BudgetName,
[Parameter(Mandatory = $true)]
[string]
$AccountName,
[Parameter(Mandatory = $true)]
[string]
$CSVFile
)

$Headers = @{}
$Headers.Add("content-type","application/json; charset=utf-8")
$Headers.Add("Authorization", "Bearer $APIToken")
$APIURI = "https://api.youneedabudget.com/v1/budgets"

# Get Budget
$Budgets = Invoke-RestMethod -Method Get -Uri $APIURI -Headers $Headers

$BudgetID = ($Budgets.data.budgets | Where-Object {$_.name -eq $BudgetName}).id

# Get Account
$URI = "$($APIURI)/$($BudgetID)/accounts"

$Accounts = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers

$AccountID = ($Accounts.data.accounts | Where-Object {$_.name -eq $AccountName}).id


# Get current transaction within same date range
$CSV = Import-Csv -Path $CSVFile -Delimiter "," -Encoding UTF8

$StartDate = ($CSV | Sort-Object -Property Date)[0].Date

$URI = "$($APIURI)/$($BudgetID)/accounts/$($AccountID)/transactions?since_date=$($StartDate)"

$CurrentTransactions = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers

# Create transactions
foreach($DateGroup in $CSV | Group-Object -Property Date){

    foreach($AmountGroup in $DateGroup.Group | Group-Object -Property Amount){
        $Occurrence = 0
        foreach($Item in $AmountGroup.Group){
            $Occurrence++
            #Write-Host $Item $Occurrence

            [decimal]$Amount = $Item.Amount -replace ",","." -replace "kr", "" -replace " ",""
            $MilliunitsAmount = [int]($Amount * 1000)
            $ImportID = "YNAB:$($MilliunitsAmount):$($Item.Date):$($Occurrence)"
            if($CurrentTransactions.data.transactions.import_id -notcontains $ImportID){
                $Transaction = @{}
                $Transaction.Add("account_id", $AccountID)
                $Transaction.Add("date", $Item.Date)
                $Transaction.Add("payee_name", $Item.Payee)
                $Transaction.Add("amount", $MilliunitsAmount)
                $Transaction.Add("cleared", "cleared")
                $Transaction.Add("import_id", $ImportID)
            
                $TransactionObj = @{"transaction" = $Transaction}
            
                $Body = $TransactionObj | ConvertTo-Json -Depth 100
                
                $URI = "$($APIURI)/$($BudgetID)/transactions"
                try{
                    $Post = Invoke-RestMethod -Method Post -Uri $URI -Headers $Headers -Body ([System.Text.Encoding]::UTF8.GetBytes($Body))

                    Write-Host "ImportID: $($ImportID) with Payee $($Item.Payee) successfully imported with TransactionID: $($Post.data.transaction.id)"
                }
                catch{

                    Write-Host "ImportID: $($ImportID) with Payee $($Item.Payee) FAILED! StatusCode: $($_.Exception.Response.StatusCode.value__) $($_.Exception.Response.StatusDescription)"

                }
            }
            else {
                Write-Host "ImportID: $($ImportID) Already Exists"
            }
       }
    }
}

