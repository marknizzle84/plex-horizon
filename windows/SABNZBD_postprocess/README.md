# Plex Horizon - SABNZBD Postprocess Scripts

## Overview

This repository contains a collection of PowerShell scripts designed for post-processing tasks related to SABnzbd downloads and Plex media organization. The scripts help automate the renaming, moving, and cleaning of downloaded content to ensure a seamless integration with Plex.

## Scripts

### 1. UFC Renamer (`ufc-renamer.ps1`)

#### Synopsis

This script is used to post-process UFC downloads from SABnzbd. It renames the downloaded fights, appends Season|Episode info to the file name, and moves them to a designated TV show folder. This ensures Plex imports the content correctly into the UFC folder in TV Shows.

#### Usage

```powershell
.\ufc-renamer.ps1
```

Make sure to customize the `settings.xml` file with the appropriate paths before running the script.


Ensure the `settings.xml` file is configured with the appropriate API tokens and server URLs before running the script.

## Configuration

All scripts in this repository rely on the `settings.xml` file. Make sure to customize this file with the required information, such as API tokens, server URLs, and file paths.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
