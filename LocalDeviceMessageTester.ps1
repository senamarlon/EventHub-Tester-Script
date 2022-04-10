$eventHubsRessourceFQDN = "<eventhub resource FQDN>"
$eventHubName = "<evemt hub name>"
$Access_Policy_Name="<SAS Policy Name. Default : RootManageSharedAccessKey>" #default value
$Access_Policy_Key="<SAS Key>"


######## END OF TO MODIFY #########

######## Some fixed variables ##########
$URIs=$eventHubsRessourceFQDN+"/"+$eventHubName
$method = "POST"
$URI = "https://"+$URIs+"/messages"

$cimobj=Get-CimInstance -ClassName Win32_ComputerSystem
$cimobj2=Get-CimInstance -ClassName Win32_OperatingSystem
$computerName = ($env:computername).Replace(" ","_")
$computerMake = ($cimobj.Manufacturer).Replace(",","_").Replace(" ","_")
$computerModel = ($cimobj.Model).Replace(" ","_")
$computerWindowsOS = ($cimobj2.Caption).Replace(" ","_")
$computerLoggedOnUser = ($cimobj.UserName).Replace(" ","_")


######## End of Some fixed variables ########

# Creating SASToken object from default access token"
[Reflection.Assembly]::LoadWithPartialName("System.Web")| out-null

#Token expires now+3000
$Expires=([DateTimeOffset]::Now.ToUnixTimeSeconds())+3000
$SignatureString=[System.Web.HttpUtility]::UrlEncode($URIs)+ "`n" + [string]$Expires
$HMAC = New-Object System.Security.Cryptography.HMACSHA256
$HMAC.key = [Text.Encoding]::ASCII.GetBytes($Access_Policy_Key)
$Signature = $HMAC.ComputeHash([Text.Encoding]::ASCII.GetBytes($SignatureString))
$Signature = [Convert]::ToBase64String($Signature)
$SASToken = "SharedAccessSignature sr=" + [System.Web.HttpUtility]::UrlEncode($URIs) + "&sig=" + [System.Web.HttpUtility]::UrlEncode($Signature) + "&se=" + $Expires + "&skn=" + $Access_Policy_Name
$signature=$SASToken

# API headers
$headers = @{
            "Authorization"=$signature;
            "Content-Type"="application/atom+xml;type=entry;charset=utf-8";
            }

# create Request Body
$timestamp = get-date -format s

$body = "{'DeviceId':'$computerName', 'Make':'$computerMake', 'Model':'$computerModel', 'OS':'$computerWindowsOS', 'User':'$computerLoggedOnUser', 'Timestamp':'$timestamp'}"
Write-Host $body
# execute the Azure REST API
Invoke-RestMethod -Uri $URI -Method $method -Headers $headers -Body $body