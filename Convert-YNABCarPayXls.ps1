param([Parameter(Mandatory = $true)]
    [string]
    $InPath,
    [Parameter(Mandatory = $true)]
    [string]
    $OutPath
)

#ConvertTo-ExcelXlsx -Path $InPath 
$SkipSheets = "Sammanställning"
$Sheets = Get-ExcelSheetInfo -Path "$($InPath)"
$XLSX = @()
foreach ($Sheet in ($Sheets | Where-Object { $SkipSheets -notcontains $_.Name })) {
    $XLSXSheetData = Import-Excel -Path "$($InPath)" -StartRow 7 -WorksheetName $Sheet.Name 
    if ($XLSXSheetData[0].Kontonummer) {
        $XLSX += $XLSXSheetData
    }
}


$Headers = ($XLSX | Get-Member -MemberType NoteProperty).Name
$Table = @()

if ($Headers -contains "Datum" -and $Headers -contains 'Försäljningsställe' -and $Headers -contains "Belopp") {

    foreach ($Item in $XLSX) {
        if ([int]$Item."Belopp" -ge 0) {

            $Amount = - ($Item."Belopp")

        }
        elseif ([int]$Item."Belopp" -lt 0) {
            $Amount = [Math]::Abs($Item."Belopp")
        }
        $Date = [datetime]::FromOADate($Item.Datum)
        $Properties = [ordered]@{       'Date' = $Date.ToShortDateString() 
            'Payee'                            = $Item.'Försäljningsställe'.Trim()
            'Memo'                             = $Item.Korttext
            'Amount'                           = $Amount
        }
    
        $obj = New-Object -TypeName psobject -Property $Properties
        $Table += $obj
    }
    
    $Table | Export-Csv -Path $OutPath -Delimiter "," -Encoding UTF8 -NoClobber -NoTypeInformation

}
else {

    Write-Error "Wrong headers in xls file"

}

