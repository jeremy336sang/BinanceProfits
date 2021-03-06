## Install Python 3.7 & run on Powershell py -m pip install python-binance #Windows

#Paste Script without '<#' on a file with name output1.py
<#
import binance
from binance.client import Client

apiKey = ""
apiSecurity = ""

client = Client(apiKey, apiSecurity)

bal = client.futures_account_balance()
print(bal)
#>
Function Send-DiscordMsg {
param($Content)
  $WebhookUrl = ''

  $Payload = [PSCustomObject]@{ content = $Content }
  $Payload = $Payload | ConvertTo-Json

  Invoke-RestMethod -Method Post -Uri $WebhookUrl -Body $Payload -ContentType 'application/json'

}


# change variables PythonScriptPath, CSVname , Scriptname :
 $PythonScriptPath = "C:\Temp\"
 $scriptname = "output1.py"
 $CsvName = "results.csv"
 $csvpath = "$pythonscriptpath\$csvname"

############################################

$csv = $null
$value1 = $null
$Dolprofit = $null
$Percprofit = $null
$Percprofit1stday = $null
$newvaleur = $null 
$value=$null

Set-Location -Path $PythonScriptPath
$value1 = py "./$Scriptname" | ConvertFrom-Json 
$value1 = $value1  | Select-Object balance,withdrawAvailable


$csv = import-csv -Path $csvpath  -header date,wallet$,profit$,profit%,Percprofit1stday% -Delimiter ";"
$count = $csv.date.count
$firstcsvvalue = $csv[0]
$lastcsvvalue = $csv[$csv.name.count]

$date = get-date -Format "dd/MM/yyy HH:mm:ss"
$discorddate= get-date -Format "dd/MM/yyy"
$wallet = [math]::Round($value1[0].balance,2)
$Dolprofit = [math]::Round($($value1[0].balance - $csv[$count -1].'wallet$'),2)
$allprofit = [math]::Round($($($csv.'profit$') | Where-Object {$_ -ne "N/A"} | ? {$value+=[decimal]$_};$value+=$Dolprofit;Write-Output $value))
$Percprofit =[math]::Round($($($Dolprofit) / $($csv[$count -1].'wallet$'))*100,2)
$Percprofit1stday = [math]::Round($($allprofit / $($firstcsvvalue.'wallet$'))*100,2)

$newvaleur = "$date;$wallet;$Dolprofit;$Percprofit;$Percprofit1stday"

if ($Dolprofit -gt 0){
$Dolprofit = "+$Dolprofit"
}
if ($Percprofit -gt 0){
$Percprofit= "+$Percprofit"
}
if ($Percprofit1stday -gt 0){
$Percprofit1stday = "+$Percprofit1stday"
}

if ($(Test-Path "$PythonScriptPath\$csvname") -eq $false){
$initvaleur = "$date;$wallet;N/A;N/A;N/A"
$initvaleur | Add-Content -Path $csvpath

Send-DiscordMsg -Content "
$discorddate

Start Wallet : $wallet$
"
}else{
Send-DiscordMsg -Content "
$discorddate
$Dolprofit$ / $Percprofit%

wallet total : $wallet$
AllProfits/ Start Wallet : $Percprofit1stday%
"

$newvaleur | Add-Content -Path $csvpath
}

$(import-csv -Path $csvpath  -header date,wallet$,profit$,profit%,Percprofit1stday% -Delimiter ";") | ft
