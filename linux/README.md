# UFC Video Organizer Script

This Bash script is designed to organize UFC videos by renaming and moving them to a specified destination folder.

## Usage

```bash
./organize_ufc.sh -p PPV_NUMBER -m MAIN_EVENT_NAME
```

### Options

- `-p PPV_NUMBER`: Specify the Pay-Per-View number.
- `-m MAIN_EVENT_NAME`: Specify the main event name.

## Configuration

Before running the script, make sure to customize the following variables according to your file paths and naming conventions:

```bash
localfolder="data/usenet/tv"
destinationshare="/mnt/shared/Videos/Plex_TV_Shows/Ultimate Fighting Championship/Season 1/"
```

## Example

```bash
./organize_ufc.sh -p 123 -m McGregor_vs_Poirier
```

This will organize UFC videos for Pay-Per-View number 123 and main event McGregor_vs_Poirier.

## File Renaming

The script renames the original video file based on the provided PPV number and main event name. It follows the format: `UFC.PPV_NUMBER.MAIN_EVENT_NAME.S01EPPV_NUMBER.extension`.

Supported video file extensions: `.mkv`, `.mp4`.

## Directory Structure

The organized videos will be moved to the specified destination folder:

```bash
/mnt/shared/Videos/Plex_TV_Shows/Ultimate Fighting Championship/Season 1/
```

## Local Cleanup

After organizing, the script cleans up the local directory by removing the original UFC folder and retaining the last 10 fights in the specified destination folder.

### Note

Make sure to review and modify the script according to your specific requirements before running it.
```

Feel free to further customize or add any additional information based on your preferences!