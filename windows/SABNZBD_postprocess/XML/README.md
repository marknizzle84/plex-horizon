# SABNZBD Postprocess Settings

## Overview

This `settings.xml` file is used for .ps1 scripts in https://github.com/marknizzle84/plex-horizon/tree/main/windows/SABNZBD_postprocess to configure the paths for post-processing UFC downloads from SABnzbd. It contains settings for the UFC Renamer script and ensures that the downloaded UFC fights are correctly organized for Plex.

## Settings

### SABnzbd
- **UFCCompletedDownloadsLocation:** The path where SABnzbd completes UFC downloads. Make sure this path is set to the directory where SABnzbd stores completed UFC downloads.

### Plex
- **UFCDestinationFolder:** The destination folder for the UFC fights after they have been renamed and organized. This is typically the location where Plex imports TV shows.

## Usage

1. Ensure that Scripts in this project is configured to use this `settings.xml` file for post-processing.
2. Customize the paths in `settings.xml` to match your system's directory structure.
3. Run the UFC Renamer script (`ufc-renamer.ps1`) with the appropriate settings.

## Example `settings.xml`

```xml
<?xml version="1.0"?>
<Settings>
    <SABnzbd>
        <UFCCompletedDownloadsLocation>E:\SABnzbd\Downloads\complete\UFC</UFCCompletedDownloadsLocation>
    </SABnzbd>
    <Plex>
        <UFCDestinationFolder>\\home-nas01\Shared\Videos\Plex_TV_Shows\Ultimate Fighting Championship\Season 1</UFCDestinationFolder>
    </Plex>
</Settings>
```

## Notes

- Make sure to keep this `settings.xml` file in the same XML directory as the SABnzbd post-processing scripts reference this location.
- Update the paths and settings according to your system's setup.
- Refer to the respective script's documentation for additional details on usage.
