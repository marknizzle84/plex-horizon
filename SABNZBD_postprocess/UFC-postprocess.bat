@echo off
goto start:
########################################
### NZBGET POST-PROCESSING SCRIPT    ###

# Kicks off job for UFC-Renamer.ps1. 
#
# This also works for SABnzbd, which im currently using (no edits required.) 
# and so on and so forth....

########################################
### OPTIONS																   ###

# An option goes here, do you want that? (yes, no).
#
# The explanation of the option goes here...
#DoYouWantThisOption=no

### NZBGET POST-PROCESSING SCRIPT     ###
#########################################

:start
powershell.exe -noprofile -NoExit -ExecutionPolicy Bypass -command "&{start-process powershell -ArgumentList '-NoExit -noprofile -file \"E:\SABnzbd\Scripts\UFC-Renamer.ps1"' -verb RunAs}"
exit /b 93