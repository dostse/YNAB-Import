param([Parameter(Mandatory = $true)]
[string]
$InPath,
[Parameter(Mandatory = $true)]
[string]
$OutPath
)

$CSV = Import-Csv -Path $InPath  -Encoding UTF7

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

$Table | Export-Csv -Path $OutPath -Delimiter "," -Encoding UTF8 -NoClobber -NoTypeInformation