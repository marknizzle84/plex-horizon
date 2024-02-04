<#
.SYNOPSIS
    Plex Unwatched Movie Cleanup Tool

.DESCRIPTION
    This script identifies unwatched movies on Plex and cross-references them against timestamps of when the file was uploaded to disk to determine creation date or when added. If criteria are met, it will process deletion. 
    This Script uses and Assumes that settings.xml has all required information filled out and is in the same directory as this script.

.PARAMETER SearchMovie
    Search for a specific movie by title.

.PARAMETER UnwatchedLowRatings
    Display unwatched movies with low audience ratings.

.PARAMETER UnwatchedOldTimey
    Display unwatched movies released before 1969.

.PARAMETER AllUnwatched
    Display all unwatched movies.

.PARAMETER CleanupReview
    Display movies with potential naming issues.

.PARAMETER PruneMoviesJob
    Execute a job to prune movies based on specified conditions.

.NOTES
    File Name      : plex-api-tool.ps1
    Author         : marknizzle84@gmail.com
    Prerequisite   : PowerShell, settings.xml in the same directory

.EXAMPLE
    .\plex-api-tool.ps1 -SearchMovie "YourMovieTitle"
    .\plex-api-tool.ps1 -UnwatchedLowRatings
    .\plex-api-tool.ps1 -UnwatchedOldTimey
    .\plex-api-tool.ps1 -AllUnwatched
    .\plex-api-tool.ps1 -CleanupReview
    .\plex-api-tool.ps1 -PruneMoviesJob
#>
param (
    [Parameter(Mandatory=$false)][String]$SearchMovie,
    [Parameter(Mandatory=$false)][Switch]$UnwatchedLowRatings,
    [Parameter(Mandatory=$false)][Switch]$UnwatchedOldTimey,
    [Parameter(Mandatory=$false)][Switch]$CleanupReview,
    [Parameter(Mandatory=$false)][Switch]$PruneMoviesJob,
    [Parameter(Mandatory=$false)][Switch]$AllUnwatched
)

# Rest of your script...

Stop-Transcript

param (
    [Parameter(Mandatory=$false)][String]$SearchMovie,
    [Parameter(Mandatory=$false)][Switch]$UnwatchedLowRatings,
    [Parameter(Mandatory=$false)][Switch]$UnwatchedOldTimey,
    [Parameter(Mandatory=$false)][Switch]$CleanupReview,
    [Parameter(Mandatory=$false)][Switch]$PruneMoviesJob,
    [Parameter(Mandatory=$false)][Switch]$AllUnwatched
)


[xml]$Configfile[xml]$Configfile  = Get-Content .\XML\settings.xml
#### LOGGING #### 
$logpaths = ("logs", "logs\Plex")
foreach ($logpath in $logpaths) {
    if (!(test-path $logpath)) {    
        New-Item $logpath -ItemType Directory -Force
    }
}
#>
### START TRANSCRIPT
$transcriptlogpath =  "logs\Plex\plex-Transcript$(Get-date -Format -MM-dd-yyyy-hhmm).txt" 
Start-Transcript -path $transcriptlogpath

###VARIABLES 
#PLEX API 
$PlexAPIBaseURL = $Configfile.Settings.Plex.ServerURL
$PlexToken = $Configfile.Settings.Plex.Token
 $PlexHeaders = @{
    'accept' = '*/*' 
    'X-Plex-token' = $PlexToken
}
#PLEX LIBRARY 
$PLEXDestination = $Configfile.Settings.Plex.MovieStoragePath


##### GET Unwatched Movies from Plex API ##### 
$PlexUnwatchedMoviesAPIQuery = Invoke-RestMethod -Method Get -Uri $PlexAPIBaseURL/library/sections/2/unwatched -Headers $PlexHeaders
$PlexUnwatchedMovies = $PlexUnwatchedMoviesAPIQuery.MediaContainer.Video
$PlexAllMoviesAPIQuery = Invoke-RestMethod -Method Get -Uri $PlexAPIBaseURL/library/sections/2/all -Headers $PlexHeaders
$PlexAllMovies = $PlexAllMoviesAPIQuery.MediaContainer.Video
##### $PlexUnwatchedMovies Custom Queries ### 
#Audience Rating 0.0 - 3.9
$ListUnwatchedLowRatings = $PlexUnwatchedMovies |where-object {$_.audiencerating -match '^[0-3]\.[0-9]'}
#Old Movie Prior to 1969
$ListUnwatchedOldTimey = $PlexUnwatchedMovies |where-object {$_.year -match '^1\d[0-6]\d'}
## Movies with multiple periods in the title (likely naming issue to be cleaned up )
#$ListCleanupReview = $PlexAllMovies |where-object {$_.title -match '^*\.*\.'}  
$ListCleanupReview = $PlexAllMovies |where-object {$_.title -match '[a-zA-Z0-9]*\.[a-zA-Z0-9]*\.'}  

### Display Switches 
if ($SearchMovie){
    $PlexUnwatchedMovies |Where-Object {$_.title -match $SearchMovie}
}
if ($UnwatchedLowRatings){
    $ListUnwatchedLowRatings |Select-Object title,audiencerating |Sort-Object audiencerating -Descending
}
if ($UnwatchedOldTimey){
    $ListUnwatchedOldTimey
}
if ($AllUnwatched){
$PlexUnwatchedMovies    
}
if ($CleanupReview){
    $ListCleanupReview  |Select-Object title
    }

  if ($PruneMoviesJob){
    $MaxLimit = ([int]$Configfile.Settings.Plex.MovieMaxLimit)
    $PruningPercentage = ([decimal]$Configfile.Settings.Plex.PruningStartLimitPercentage)
    $PruningStartLimit = $MaxLimit * $PruningPercentage
    $PruningAge = $Configfile.Settings.Plex.PruningMovieAge
    $PlexTotalCount = (get-ChildItem $PLEXDestination).Count
    $PruneList = get-ChildItem $PLEXDestination


    write-host "Current Plex movie count is: $PlexTotalCount" -ForegroundColor Yellow
    if ((get-ChildItem $PLEXDestination).Count -gt $MaxLimit){ write-host "Current Movie Count is above The Max Allowed Limit of: $MaxLimit" -ForegroundColor Yellow}
    While ((get-ChildItem $PLEXDestination).Count -gt $MaxLimit ){
        try{    
        $MaxLimitPruneFile = (get-ChildItem $PLEXDestination -Directory |Where-Object {$_.Name -ne ".grab"}|Sort-Object CreationTime)[0]
        remove-item $MaxLimitPruneFile -Recurse -Force
        write-host "SUCCESS: deletion of $($MaxLimitPruneFile.Name) completed" -ForegroundColor Green
        }
        catch{write-host "FALIURE: deletion of $($MaxLimitPruneFile.Name) unsuccessful" -ForegroundColor Yellow
        }
    }
    if ($PlexTotalCount -lt $MaxLimit ){
    write-host "Movie Count is under Current Max Limit of $MaxLimit" -ForegroundColor Green
    }




    ############### Start Pruning when $PruningStartLimit count is reached and removing unwatched movies older than $PruningAge
    if (!($PlexTotalCount -gt $PruningStartLimit )){write-host "pruning skipped: Current Movie Count is below the pruning start limit of: $PruningStartLimit" -ForegroundColor Green}
    if ((get-ChildItem $PLEXDestination).Count -gt $PruningStartLimit ){write-host "Current Movie Count is above the pruning start limit of: $PruningStartLimit" -ForegroundColor Yellow}
    while ((get-ChildItem $PLEXDestination).Count -gt $PruningStartLimit ){
            try{
                $RandomPlexUnwatchedMovie = Get-Random $PlexUnwatchedMovies
                if ($PruneList -match $RandomPlexUnwatchedMovie.Title){
                $Movietoprune = ($PruneList |Where-Object {($_.Name -match $RandomPlexUnwatchedMovie.title) -and ($_.CreationTime -lt (Get-Date).AddDays($PruningAge))})[0] 
                Remove-Item $Movietoprune -Recurse -Force 
                write-host "SUCCESS: deletion of $($RandomPlexUnwatchedMovie.title) completed" -ForegroundColor Green
                }
            }
            catch {#write-host "conditions not met exluding $($RandomPlexUnwatchedMovie.title)" -ForegroundColor Yellow 
        } 
    }
  }
Stop-Transcript
