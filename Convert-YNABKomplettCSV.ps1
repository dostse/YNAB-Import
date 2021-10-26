param([Parameter(Mandatory = $true)]
[string]
$Path
)

$Outfile = "c:\Temp\YNAB_KOMPLETT_$(Get-Date -Format yyyyMMdd_HHmmss).csv"

$CSV = Import-Csv -Path $Path  -Encoding UTF7

$Table = @()

foreach($Item in $CSV){

    $Properties = [ordered]@{       'Date' = $Item.Transaktionsdatum 
                                    'Payee' = $Item.Beskrivning
                                    'Memo' = ""
                                    'Amount' = $Item.Belopp
            }

    $obj = New-Object -TypeName psobject -Property $Properties
    $Table += $obj
}

$Table | Export-Csv -Path $Outfile -Delimiter "," -Encoding UTF8 -NoClobber -NoTypeInformation