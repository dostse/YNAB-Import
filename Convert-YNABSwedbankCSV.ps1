param([Parameter(Mandatory = $true)]
[string]
$Path = "C:\users\slayer\downloads\Transaktioner_2021-10-26_14-17-04.csv"
)

$Outfile = "c:\Temp\YNAB_SwedBank_$(Get-Date -Format yyyyMMdd_HHmmss).csv"

$CSV = Get-Content -Path $Path | Select-Object -Skip 1 | ConvertFrom-Csv #-Header @("Radnummer","Clearingnummer","Kontonummer","Produkt","Valuta","Bokföringsdag","Transaktionsdag","Valutadag","Referens","Beskrivning","Belopp","Bokfört saldo")
$Table = @()

foreach($Item in $CSV){

    $Properties = [ordered]@{       'Date' = $Item.Transaktionsdag 
                                    'Payee' = $Item.Beskrivning
                                    'Memo' = $Item.Referens 
                                    'Amount' = $Item.Belopp
            }

    $obj = New-Object -TypeName psobject -Property $Properties
    $Table += $obj
}

$Table | Export-Csv -Path $Outfile -Delimiter "," -Encoding UTF8 -NoClobber -NoTypeInformation