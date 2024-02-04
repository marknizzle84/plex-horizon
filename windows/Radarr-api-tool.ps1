<#
.SYNOPSIS
    Radarr API Tool

.DESCRIPTION
    This script is used to identify/validate movies coming in off lists set up in Radarr. The tool also has the ability to refresh movies in Radarr and delete unmonitored movies from Radarr, allowing them to be downloaded again (burn and turn strategy).
    This script uses and assumes that settings.xml has all required information filled out and is in the same directory as this script.

.PARAMETER SearchMovie
    Search for a specific movie by title.

.PARAMETER UpdateMovies
    Update movies in Radarr.

.PARAMETER RefreshAllMovies
    Refresh information for all movies in Radarr.

.PARAMETER MarksMovies
    Display movies with the "Marks" tag.

.PARAMETER ChristinasMovies
    Display movies with the "Christinas" tag.

.PARAMETER TimsMovies
    Display movies with the "Tims" tag.

.PARAMETER ShowUnmonitoredMovies
    Show unmonitored movies in Radarr.

.PARAMETER DeleteUnMonitored
    Delete unmonitored movies from Radarr.

.PARAMETER NZBGeekTrendingMovies
    Display movies with the "NZBGeek Trending" tag.

.NOTES
    File Name      : radarr-api-tool.ps1
    Author         : marknizzle84@gmail.com
    Prerequisite   : PowerShell, settings.xml in the same directory

.EXAMPLE
    .\radarr-api-tool.ps1 -SearchMovie "YourMovieTitle"
    .\radarr-api-tool.ps1 -UpdateMovies
    .\radarr-api-tool.ps1 -RefreshAllMovies
    .\radarr-api-tool.ps1 -MarksMovies
    .\radarr-api-tool.ps1 -ChristinasMovies
    .\radarr-api-tool.ps1 -TimsMovies
    .\radarr-api-tool.ps1 -ShowUnmonitoredMovies
    .\radarr-api-tool.ps1 -DeleteUnMonitored
    .\radarr-api-tool.ps1 -NZBGeekTrendingMovies
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)][String]$SearchMovie,
    [Parameter(Mandatory=$false)][Switch]$UpdateMovies,
    [Parameter(Mandatory=$false)][Switch]$RefreshAllMovies,
    [Parameter(Mandatory=$false)][Switch]$MarksMovies,
    [Parameter(Mandatory=$false)][Switch]$ChristinasMovies,
    [Parameter(Mandatory=$false)][Switch]$TimsMovies,
    [Parameter(Mandatory=$false)][Switch]$ShowUnmonitoredMovies,
    [Parameter(Mandatory=$false)][Switch]$DeleteUnMonitored,
    [Parameter(Mandatory=$false)][Switch]$NZBGeekTrendingMovies
)

# Rest of your script...

Stop-Transcript

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)][String]$SearchMovie,
    [Parameter(Mandatory=$false)][Switch]$UpdateMovies,
    [Parameter(Mandatory=$false)][Switch]$RefreshAllMovies,
    [Parameter(Mandatory=$false)][Switch]$MarksMovies,
    [Parameter(Mandatory=$false)][Switch]$ChristinasMovies,
    [Parameter(Mandatory=$false)][Switch]$TimsMovies,
    [Parameter(Mandatory=$false)][Switch]$ShowUnmonitoredMovies,
    [Parameter(Mandatory=$false)][Switch]$DeleteUnMonitored,
    [Parameter(Mandatory=$false)][Switch]$NZBGeekTrendingMovies
)


[xml]$Configfile[xml]$Configfile  = Get-Content .\XML\settings.xml

###VARIABLES 
$RadarrAPIBaseURL = $Configfile.Settings.Radarr.ServerURL
$RadarrToken =  $Configfile.Settings.Radarr.Token
 $RadarrHeaders = @{
    'accept' = '*/*' 
    'X-Api-Key' = $RadarrToken
}

#### LOGGING #### 
    $logpaths = ("logs", "logs\radarr")
    foreach ($logpath in $logpaths) {
        if (!(test-path $logpath)) {    
            New-Item $logpath -ItemType Directory -Force
        }
    }
#>
### START TRANSCRIPT
$transcriptlogpath =  "logs\radarr\radarr-Transcript$(Get-date -Format -MM-dd-yyyy-hhmm).txt" 
Start-Transcript -path $transcriptlogpath


##### GET Movies from RADARR API ##### 
$GetMovies = Invoke-RestMethod -Method Get -Uri "$RadarrAPIBaseURL/api/v3/movie" -Headers $RadarrHeaders


##### $GetMovies Custom Queries ### 
$ListUnmonitoredMovies = $GetMovies |Where-Object {$_.Monitored -match "False"}
$ListMarksMovies = $GetMovies |Where-Object {$_.Tags -match 3} |Select-Object title,Tags,@{n="GB";e={[decimal]($_.sizeondisk/1GB)}} |Sort-Object GB -Descending
$ListChristinasMovies = $GetMovies |Where-Object {$_.Tags -match 5} |Select-Object title,Tags,@{n="GB";e={[decimal]($_.sizeondisk/1GB)}} |Sort-Object GB -Descending
$ListTimsMovies = $GetMovies |Where-Object {$_.Tags -match 2} |Select-Object title,Tags,@{n="GB";e={[decimal]($_.sizeondisk/1GB)}} |Sort-Object GB -Descending
$ListNZBGeekTrendingMovies = $GetMovies |Where-Object {$_.Tags -match 6} |Select-Object title,Tags,@{n="GB";e={[decimal]($_.sizeondisk/1GB)}} |Sort-Object GB -Descending



###### OUTPUTS ###########
if ($SearchMovie){
    $GetMovies |Where-Object {$_.title -match $SearchMovie}
}
if ($MarksMovies){
$ListMarksMovies
}
if ($ChristinasMovies){
    $ListChristinasMovies
}
if ($TimsMovies){
    $ListTimsMovies
}
if ($NZBGeekTrendingMovies){
 $ListNZBGeekTrendingMovies   
}
if ($ShowUnmonitoredMovies){
    $ListUnmonitoredMovies
}


##### ACTIONS ###########

######### DELETE UNMONITORED MOVIES #############
if ($DeleteUnMonitored){
    foreach ($UnmonitoredMovie in $ListUnmonitoredMovies){
        try {
        #$DeleteURI = $RadarrAPIBaseURL + "/api/v3/movie/" + $UnmonitoredMovie.id
        Invoke-RestMethod -Method Delete -Uri "$RadarrAPIBaseURL/api/v3/movie/$($UnmonitoredMovie.id)" -Headers $RadarrHeaders 
        write-host "SUCCESS: deletion of $($UnmonitoredMovie.sortTitle) completed" -ForegroundColor Green    
        }
    
    catch {
        write-host "INFO: no action taken on $($UnmonitoredMovie.sortTitle)" -ForegroundColor Yellow
    }
}
}
#>

######### REFRESH MOVIE INFO #############
if ($RefreshAllMovies){
    try {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36"
    Invoke-WebRequest -UseBasicParsing -Uri "$($RadarrAPIBaseURL)/api/v3/command" `
    -Method "POST" `
    -WebSession $session `
    -Headers @{
    "Accept"="application/json, text/javascript, */*; q=0.01"
      "Accept-Encoding"="gzip, deflate"
      "Accept-Language"="en-US,en;q=0.9"
      "DNT"="1"
      "Origin"= $RadarrAPIBaseURL
      "Referer"= $RadarrAPIBaseURL
      "X-Api-Key"= $RadarrToken
      "X-Requested-With"="XMLHttpRequest"
    } `
    -ContentType "application/json" `
    -Body "{`"name`":`"RefreshMovie`",`"movieIds`":[]}"
}
catch{}
}
Stop-Transcript

