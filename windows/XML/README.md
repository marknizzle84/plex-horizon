# PowerShell Scripts Settings

## settings.xml

This XML file contains configuration settings used by various PowerShell scripts in the directory.

### Configuration Sections

#### NZBGeeK

- **Token:** Replace `NZBgeekAPIToken` with your NZBGeek API token.

#### SABnzbd

- **Token:** Replace `SABnzbdAPIToken` with your SABnzbd API token.
- **ServerURL:** Update `http://192.168.1.75:8080` with your SABnzbd server URL.

#### Radarr

- **Token:** Replace `RadarrAPIToken` with your Radarr API token.
- **ServerURL:** Update `http://home-hv1:7878` with your Radarr server URL.

#### Plex

- **Token:** Replace `PlexAPIToken` with your Plex API token.
- **ServerURL:** Update `http://192.168.1.50:32400` with your Plex server URL.
- **MovieStoragePath:** Update `\\home-nas01\Shared\Videos\Plex_Movies` with your Plex movie storage path.
- **MovieMaxLimit:** Set the maximum allowed number of movies in Plex (e.g., `1750`).
- **PruningStartLimitPercentage:** Set the pruning start limit percentage (e.g., `.858`).
- **PruningMovieAge:** Set the age limit (in days) for pruning movies (e.g., `-360`).

### Important Note

Make sure to secure this file and avoid sharing sensitive information, such as API tokens, publicly.

---

Feel free to customize this README as needed, and ensure to update any placeholders with actual values before sharing it with others.
