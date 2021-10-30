param([Parameter(Mandatory = $true)]
[string]
$InPath,
[Parameter(Mandatory = $true)]
[string]
$OutPath
)

$CSV = Get-Content -Path $InPath | Select-Object -Skip 1 | ConvertFrom-Csv #-Header @("Radnummer","Clearingnummer","Kontonummer","Produkt","Valuta","Bokföringsdag","Transaktionsdag","Valutadag","Referens","Beskrivning","Belopp","Bokfört saldo")
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

$Table | Export-Csv -Path $OutPath -Delimiter "," -Encoding UTF8 -NoClobber -NoTypeInformation