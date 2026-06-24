# unencrypted-stream-media-downloader
markdown_content = """# Unencrypted Stream Media Downloader

A robust, containerized utility designed to download unencrypted media streams (like HLS `.m3u8` manifests). It automatically extracts the best video quality (up to 1080p), the best audio, and subtitles (English and Portuguese), merging them into standard `.mp4` and `.srt` files. 

By running entirely within a Docker container, it ensures zero dependency conflicts on your host machine and works seamlessly across any operating system.

## Features
- **Single Download**: Download from a remote manifest URL or a local manifest file.
- **Batch Processing**: Process multiple downloads automatically using a `.csv` file.
- **Subtitle Extraction**: Automatically downloads and converts English and Portuguese subtitles to `.srt` format.
- **Auto-Organization**: Creates a dedicated folder for each downloaded media based on the provided base name.
- **Containerized**: Built on a lightweight Debian image with `yt-dlp` and `ffmpeg` pre-configured.

---

## Prerequisites

Before using this tool, ensure you have the following installed on your machine:
- [Docker](https://docs.docker.com/get-docker/)

---

## Installation / Build

1. **Clone the repository** (or navigate to the directory where the `Dockerfile` and `download_media.sh` are located):
  ```bash
   git clone [https://github.com/diegodfs05/unencrypted-stream-media-downloader.git](https://github.com/diegodfs05/unencrypted-stream-media-downloader.git)
   cd unencrypted-stream-media-downloader
  ```
2. **Build te docker image**
   Run the following command in the terminal to build the image locally.
     ```bash
   docker build -t unencrypted-stream-media-downloader .
     ```

     
Usage Instructions
The tool uses Docker volume mapping (-v "$(pwd):/app") to read local files and save the downloaded media directly into your current working directory.

1. Single Download from a Remote URL
To download a video from an online .m3u8 manifest URL:

Bash
docker run --rm -v "$(pwd):/app" unencrypted-stream-media-downloader "https://example.com/path/to/manifest.m3u8" "media_01"

Result: A new directory named media_01/ will be created, containing madia_01.mp4, media_01_en.srt, and media_01_en.srt.

2. Single Download from a Local Manifest File
If you have already saved the .m3u8 file to your computer, place it in your current working directory and run:

Bash
docker run --rm -v "$(pwd):/app" unencrypted-stream-media-downloader "local_manifest.m3u8" "media_01"
3. Batch Processing via CSV File
To download multiple videos automatically, create a .csv file (e.g., playlist.csv) in your current directory.

CSV File Format (No Headers):
local_manifest_3.m3u8,media_03

Run the batch process:
Bash
docker run --rm -v "$(pwd):/app" unencrypted-stream-media-downloader "playlist.csv"

**Troubleshooting**
No Media Downloaded / Empty Folders: Ensure the stream is truly unencrypted. This tool cannot bypass Digital Rights Management (DRM) protections like Widevine or FairPlay. If the manifest points to encrypted segments, the process will fail.

Permission Errors: Ensure Docker has permission to read and write files in the directory where you are executing the command. On Linux, you might need to run the command with sudo if your user is not in the docker group.

HTTP Error 403 (Forbidden): This happens if the authentication tokens appended to the URL (the query string after ?) have expired. Capture a fresh URL from your browser's Network tab and try again. Otherwise you can download the manifest and proccess it locally.
