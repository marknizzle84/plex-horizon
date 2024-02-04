# Plex Horizon - Windows Scripts Collection

## Overview

Welcome to Plex Horizon's Windows Scripts Collection! This repository houses a set of PowerShell scripts designed to enhance your Plex media server experience on Windows. These scripts automate various tasks related to media management, post-processing, and interaction with external APIs.

## Scripts

### 1. SABNZBD Postprocess Scripts

#### 1.1 UFC Renamer (`ufc-renamer.ps1`)

- **Synopsis:** Post-processes UFC downloads from SABnzbd, renaming files and moving them to Plex-friendly locations.
- **Usage:**
  ```powershell
  .\ufc-renamer.ps1
  ```
  Customize the `settings.xml` file before executing the script.

#### 1.2 Plex API Tool (`plex-api-tool.ps1`)

- **Synopsis:** Interacts with the Plex API for tasks like identifying unwatched movies, library cleanup, and movie pruning.
- **Usage:**
  ```powershell
  .\plex-api-tool.ps1 -SearchMovie "Movie Title" -UnwatchedLowRatings -UnwatchedOldTimey -CleanupReview -PruneMoviesJob -AllUnwatched
  ```
  Adjust parameters and configure the `settings.xml` file before running the script.

#### 1.3 Radarr API Tool (`radarr-api-tool.ps1`)

- **Synopsis:** Works with the Radarr API to identify, validate, and perform actions on listed movies.
- **Usage:**
  ```powershell
  .\radarr-api-tool.ps1 -SearchMovie "Movie Title" -UpdateMovies -RefreshAllMovies -MarksMovies -ChristinasMovies -TimsMovies -ShowUnmonitoredMovies -DeleteUnMonitored -NZBGeekTrendingMovies
  ```
  Customize parameters and configure the `settings.xml` file before executing the script.

#### 1.4 UFC Downloader (`UFC-Downloader.ps1`)

- **Synopsis:** Queries NZBGeek for UFC PPV download links, checks SABnzbd history, and adds the NZB for processing.
- **Usage:**
  ```powershell
  .\UFC-Downloader.ps1 -Download
  ```
  Ensure the `settings.xml` file is configured with API tokens and server URLs before running the script.

### 2. UFC Stats Scraper (`ufc-stats-scraper.ps1`)

- **Synopsis:** Scrapes UFC stats from the official UFC website and exports them to a CSV file.
- **Usage:**
  ```powershell
  .\ufc-stats-scraper.ps1 -EventID 1000 -OutputFile "UFC_Stats.csv"
  ```
  Adjust parameters and customize the `settings.xml` file before running the script.

## Configuration

All scripts rely on the `settings.xml` file. Customize this file with required information, such as API tokens, server URLs, and file paths.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.