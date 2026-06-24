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
