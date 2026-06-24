FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

WORKDIR /app

COPY download_media.sh /usr/local/bin/download_media.sh
RUN chmod +x /usr/local/bin/download_media.sh

ENTRYPOINT ["/usr/local/bin/download_media.sh"]
