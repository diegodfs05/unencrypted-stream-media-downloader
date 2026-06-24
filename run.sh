#!/bin/bash

docker build -t unencrypted-stream-media-downloader .

#Single media download from URL
# docker run --rm -v "$(pwd):/app" unencrypted-stream-media-downloader "https://manifest-url" "output-media-name"

#Single media download from local manifest file
# docker run --rm -v "$(pwd):/app" unencrypted-stream-media-downloader "manifest-path.m3u8" "output-media-name"

#Batch download from CSV file
#The app expects CSV tuples in following schema: ['manifest-url-or-path', 'output-media-name']
docker run --rm -v "$(pwd):/app" unencrypted-stream-media-downloader batch-info.csv
