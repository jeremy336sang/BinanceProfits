## Install Python 3.7 & run on Powershell python -m pip install python-binance #Windows

#Paste Script without '<#' on a file with name output1.py
<#
import binance
from binance.client import Client

apiKey = ""
apiSecurity = ""

client = Client(apiKey, apiSecurity)

#while True:
bal = client.futures_account_balance()
print(bal)
#>



# change variables PythonScriptPath, CSVname , Scriptname :
 $PythonScriptPath = ""
 $scriptname = "output1.py"
 $CsvName = "results.csv"
 $csvpath = "$pythonscriptspath\$csvname"

############################################

$csv = $null
$value1 = $null
$Dolprofit = $null
$Percprofit = $null
$Percprofit1stday = $null
$newvaleur = $null 

Set-Location -Path $pyscriptspath
$value1 = py ./$Scriptname | ConvertFrom-Json 
$value1 = $value1  | Select-Object balance,withdrawAvailable


$csv = import-csv -Path $csvpath  -header date,wallet$,profit$,profit%,Percprofit1stday% -Delimiter ";"
$count = $csv.date.count
$firstcsvvalue = $csv[0]
$lastcsvvalue = $csv[$csv.name.count]

$date = get-date -Format "dd/MM/yyy HH:mm:ss"
$wallet = [math]::Round($value1[0].balance,2)
$Dolprofit = [math]::Round($($value1[0].balance - $csv[$count -1].'wallet$'),2)
$Percprofit =[math]::Round($($Dolprofit / $csv[$count -1].'wallet$')*100,2)
$Percprofit1stday = [math]::Round($($Dolprofit / $firstcsvvalue.'wallet$')*100,2)

$newvaleur = "$date;$wallet;$Dolprofit;$Percprofit;$Percprofit1stday"

if (!$(Test-Path "$PythonScriptPath\$csvname")){
$initvaleur = "$date;$wallet;N/A;N/A;N/A"
$initvaleur | Add-Content -Path $csvpath

}else{

$newvaleur | Add-Content -Path $csvpath
}

$(import-csv -Path $csvpath  -header date,wallet$,profit$,profit%,Percprofit1stday% -Delimiter ";") | ft
