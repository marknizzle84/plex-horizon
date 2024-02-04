<#
.SYNOPSIS
    UFC Download Renamer and Copy Tool
.DESCRIPTION
    This script is used to post-process UFC downloads. It renames the downloaded fight to match the movie folder name, 
    appends Season|Episode info to the file name, and moves it to the TV show folder. 
    This ensures Plex imports it correctly into the UFC folder in TV Shows.
.PARAMETER None
    No parameters are required for normal execution. It automatically fetches settings from the 'settings.xml' file.
.NOTES
    File: ufc-renamer.ps1
    Author: marknizzle84@gmail.com
    Date: 11.10.2022
    Version: 1.0
#>

param (
    # No parameters needed for normal execution.
)

<#
.EXAMPLE
    .\ufc-renamer.ps1
    Runs the UFC Renamer script with default settings.
#>

<#
.NOTES
    Customize the script according to your needs. Ensure 'settings.xml' has the correct paths and settings.
#>

$logpaths = $logpaths = ("logs", "logs\UFC-Renamer")
foreach ($logpath in $logpaths) {
    if (!(test-path $logpath)) {    
        New-Item $logpath -ItemType Directory -Force
    }
    
}
#>
### START TRANSCRIPT
$transcriptlogpath =  "logs\UFC-Renamer\UFC-Renamer-Transcript$(Get-date -Format -MM-dd-yyyy-hhmm).txt" 
Start-Transcript -path $transcriptlogpath

[xml]$Configfile = Get-Content .\XML\settings.xml

start-sleep -Seconds 45
Try{
    $UFCFiles = get-childitem $Configfile.Settings.SABnzbd.UFCCompletedDownloadsLocation -Recurse *.m*| Where-Object{$_.Extension -match '.[mp4-mkv]'}
    if ($null -ne $UFCFiles){
        $Destination = $Configfile.Settings.Plex.UFCDestinationFolder
        #Trim File name and just leave last 4 characters (.mkz or .mp4 )
        $Length = $UFCFiles.Name.Length - 4 
        $Trim = $UFCFiles.Name.Remove(0,$length) 

        for ($i=279; $i -le 350){
          #$i++
          write-host $i
         if ($UFCFiles.Directory.Name -match $i ){
            write-host "This is UFC episode $i" -ForegroundColor Green
            $Version = ".S01E$($i)"
         }
         if (!($UFCFiles.Directory.Name -match $i )){
           # write-host "This is not UFC episode $i" -ForegroundColor Yellow
         }
         $i++
        }

        $UFCPPVName = $($UFCFiles.Directory.Name + $Version + $Trim)
        Rename-item $UFCFiles.FullName -newname $UFCPPVName
        start-sleep 30
        if (test-path $($UFCFiles.Directory.FullName + "\" + $UFCPPVName)){
        move-item $($UFCFiles.Directory.FullName + "\" + $UFCPPVName) -Destination $Destination
        }
        start-sleep 30 
        if (!(test-path $($UFCFiles.Directory.FullName + "\" + $UFCPPVName))){
        remove-item -path $UFCFiles.Directory.FullName
        }
        while ((Get-ChildItem $Destination).Count -gt 10) {
        remove-item (Get-ChildItem $Destination |sort CreationTime)[0].FullName
        }
        exit
    }
    if ($null -eq $UFCFiles){
    write-host "There is no UFC Files to process" -ForegroundColor Green
    exit
    }
}
Catch{write-host "There is no UFC Files to process" -ForegroundColor Green 
exit }