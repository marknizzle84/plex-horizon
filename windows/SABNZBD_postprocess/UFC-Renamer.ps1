##############################################################################
##                    UFC Download Renamer and Copy Tool                    ##
##                   Author: marknizzle84@gmail.com                         ## 
##                            Date: 11.10.2022                              ##
##############################################################################
 

#SYNOPSIS
# this script is used to post process ufc downloads. It will rename the downloaded fight to match the movie folder name, append Season|Episode info to the file name and movie it over to tv show folder so Plex imports it correctly into UFC folder in TV Shows. 
# This Script uses and Assumes that settings.xml has all required information filled out and is in the same directory as this script. 
#> 

#CHANGELOG
# 11.10.2022 - Initial Version 

#### LOGGING #### 
##
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

[xml]$Configfile = Get-Content .\settings.xml

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