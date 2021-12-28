param([Parameter(Mandatory = $true)]
[string]
$InPath,
[Parameter(Mandatory = $true)]
[string]
$OutPath
)


ConvertTo-ExcelXlsx -Path $InPath 
$XLSX = Import-Excel -Path "$($InPath)x" -StartRow 6
$Headers = ($XLSX | Get-Member -MemberType NoteProperty).Name

$Table = @()

if($Headers -contains "Datum" -and $Headers -contains "Specifikation" -and $Headers -contains "Belopp SEK" ){

    foreach($Item in $XLSX){

        $Properties = [ordered]@{       'Date' = $Item.Datum 
                                        'Payee' = $Item.Specifikation
                                        'Memo' = ""
                                        'Amount' = "-$($Item."Belopp SEK")"
                }
    
        $obj = New-Object -TypeName psobject -Property $Properties
        $Table += $obj
    }
    
    $Table | Export-Csv -Path $OutPath -Delimiter "," -Encoding UTF8 -NoClobber -NoTypeInformation

}
else{

    Write-Error "Wrong headers in xls file"

}

