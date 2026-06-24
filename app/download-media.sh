#!/bin/bash
#created with Debian 13
#require yt-dlp package to work
#used to download media from unencrypted stream channels
#accepts 2 params: [manifest_url, basename]
#or
#accept 1 param: [csv_file.csv]
#if using a csv, must contain touples with two initial params
#Update v1.1 - Now accepts

process_download() {
    local manifest_source="$1"
    local base_name="$2"

    mkdir -p "$base_name"

    if [ -f "$manifest_source" ]; then
        manifest_source="file://$(realpath "$manifest_source")"
    fi

    yt-dlp -f "bv[height=1080]+ba/bestvideo+bestaudio" \
      --merge-output-format mp4 \
      --write-subs \
      --sub-langs "en,pt" \
      --convert-subs srt \
      -o "${base_name}/${base_name}.%(ext)s" \
      "$manifest_source"
}

if [ "$#" -eq 2 ]; then
    process_download "$1" "$2"

elif [ "$#" -eq 1 ]; then
    csv_file="$1"

    if [ ! -f "$csv_file" ]; then
        echo "Error: File not found: $csv_file"
        exit 1
    fi

    while IFS=',' read -r source name || [ -n "$source" ]; do
        source=$(echo "$source" | tr -d '\r' | xargs)
        name=$(echo "$name" | tr -d '\r' | xargs)

        if [ -z "$source" ] || [ -z "$name" ]; then
            echo "Warning: Ignored invalid csv tuple."
            continue
        fi

        echo "Batch processing: $name"
        process_download "$source" "$name"
    done < "$csv_file"

else
    echo "Single processing: $0 <URL_OU_CAMINHO_DO_MANIFESTO> <NOME_BASE>"
    echo "Batch processing: $0 <CAMINHO_DO_ARQUIVO_CSV>"
    exit 1
fi
