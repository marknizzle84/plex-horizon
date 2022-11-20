##############################################################################
##                           Radarr API Tool                                ##
##                   Author: marknizzle84@gmail.com                         ## 
##                            Date: 10.06.2022                              ##
##############################################################################
 

#SYNOPSIS
# this script is used to query NZBGeek for UFC PPVs based on the month and year in the get-date queries. The PPV Strings have to be updated manually and do not account for months where 2 ppvs occur. 
# If a new PPV is found matching the query on nzbgeek. It is then compared to the download history of SABnzbd. If SABnzbd has no history of downloading the file then the info is sent to SABnzbd to download. 
# This Script uses and Assumes that settings.xml has all required information filled out and is in the same directory as this script. 
#> 

#CHANGELOG
# 10.06.2022 - Initial Version 
#11.15.2022 - updated lines 37-47, Date updates until OCT. 2023 and UFC 291

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







