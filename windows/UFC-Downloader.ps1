<#
.SYNOPSIS
    UFC Downloader

.DESCRIPTION
    This script is used to download UFC Pay-Per-View (PPV) events from NZBGeek using SABnzbd. It checks the current month and year to determine the corresponding UFC event and searches NZBGeek for the PPV download link.

.PARAMETER Download
    Initiates the download of the UFC PPV from NZBGeek using SABnzbd.

.NOTES
    File Name      : UFC-Downloader.ps1
    Author         : marknizzle84@gmail.com
    Prerequisite   : PowerShell, settings.xml in the same directory

.EXAMPLE
    .\UFC-Downloader.ps1 -Download
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)][Switch]$Download
)

# Rest of your script...


[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)][Switch]$Download
)
#### LOGGING #### 
##
$logpaths = $logpaths = ("logs", "logs\UFCDownloader")
foreach ($logpath in $logpaths) {
    if (!(test-path $logpath)) {    
        New-Item $logpath -ItemType Directory -Force
    }
    
}
#>
### START TRANSCRIPT
$transcriptlogpath =  "logs\UFCDownloader\UFCDownloader-Transcript$(Get-date -Format -MM-dd-yyyy-hhmm).txt" 
Start-Transcript -path $transcriptlogpath

$Date = Get-Date
if ((($Date).Month -eq 1) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 283 PPV"}
if ((($Date).Month -eq 2) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 284 PPV"}
if ((($Date).Month -eq 3) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 285 PPV"}
if ((($Date).Month -eq 4) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 286 PPV"}
if ((($Date).Month -eq 5) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 287 PPV"}
if ((($Date).Month -eq 6) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 288 PPV"}
if ((($Date).Month -eq 7) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 289 PPV"}
if ((($Date).Month -eq 8) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 290 PPV"}
if ((($Date).Month -eq 9) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 291 PPV"}
if ((($Date).Month -eq 10) -and (($Date).Year -eq 2023)) {$UFCString = "UFC 292 PPV"}
if ((($Date).Month -eq 11) -and (($Date).Year -eq 2022)) {$UFCString = "UFC 281 PPV"}
if ((($Date).Month -eq 12) -and (($Date).Year -eq 2022)) {$UFCString = "UFC 282 PPV"}

[xml]$Configfile = Get-Content .\settings.xml


###VARIABLES

#NZBGEEK API SETUP
$NZBGeekToken = $Configfile.Settings.NZBGeeK.Token
$NZBGeekAPIUFCPPVBaseURL = "https://api.nzbgeek.info/api?apikey=$($NZBGeekToken)&t=search&q=" + $UFCString.Replace(" ","+")

### QUERY NZBGEEK FOR UFC PPV Download Link 
$Results = Invoke-RestMethod -Uri $NZBGeekAPIUFCPPVBaseURL |Where-Object {$_.title -match "1080p"}

##SABNZBD API SETUP 
$SABNZBDToken = $Configfile.Settings.SABnzbd.Token
$SABNZBDURL = $Configfile.Settings.SABnzbd.ServerURL
$SABnzbdBaseAPIURL = "$($SABNZBDURL)/sabnzbd/api?output=json&apikey=$($SABNZBDToken)"
$SABnzbdUFCHistoryQuery =  $SABnzbdBaseAPIURL + "&mode=history&cat=ufc"


if ($Results.Count -eq 1) {
Write-Output "NZB for $UFCString Found!" 
$NZBInfo = $Results 
$NZBInfo
} 
if ($Results.Count -gt 1) {
    Write-Output "NZB for $UFCString Found!"
    $NZBInfo = $Results[0]
    $NZBInfo
    } 
if (!($Results)){Write-Output "Unable to find NZB for $UFCString"} 

if (($Null -ne $NZBInfo.Link) -and ($Download)){
    #CHECK SABnzbd History before downloading  
    $SABNZBQueryResults = Invoke-RestMethod -Uri $SABnzbdUFCHistoryQuery
    $UFCHistory = $SABNZBQueryResults.history.slots |Select-Object name,status   
    if ($UFCHistory.name.Contains($NZBinfo.title)){write-host "Skipping Download of $($NZBinfo.title) as it is found in SABnzbd History"
    }
    ###SUCCESSFUL UFC NZBGEEK QUERY ADD TO SABNZBD 
    if  (!($UFCHistory.name.Contains($NZBinfo.title))){
        try{
        $urlToEncode = $NZBInfo.Link
        #$NZBDownloadURL = $NZBInfo.Link
        $NZBDownloadURL = [System.Web.HttpUtility]::UrlEncode($urlToEncode) 
        $AddNZBbyURL = "&mode=addurl&name=$($NZBDownloadURL)&nzbname=&cat=ufc&script=Default&priority=-100&pp=-1"
        Invoke-RestMethod -Uri ($SABnzbdBaseAPIURL + $AddNZBbyURL) 
        Write-Output "SUCCESS: request to Download $($NZBInfo.title) sent to $SABNZBDURL!"
        }
        catch{Write-Output "ERROR: request for $($NZBInfo.title) failed! check link url and url encoding"}
    }
}







