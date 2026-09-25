# É necessário instalar  o yt-dlp e o ffmpeg para utilizar o script
## winget install yt-dlp.yt-dlp
## winget install Gyan.FFmpeg
# Para verificar se estão instalados corretamente
## yt-dlp --version
## ffmpeg -version

# Para chamar o script, execute no diretório onde ele está localizado
## Manifesto remoto
## .\download-media.ps1 "https://exemplo.com/manifest.mpd" "meu_video"
#
## Manifesto local
## .\download-media.ps1 "C:\caminho\para\manifesto.ism" "meu_video"
#
# Processamento em Lote com CSV
## .\download-media.ps1 "videos.csv"

# Liberação do powershell para executar arquivos de script, se necessário
## Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process


function Process-Download {
    param (
        [string]$Source,
        [string]$BaseName
    )

    New-Item -ItemType Directory -Force -Path $BaseName | Out-Null

    if (Test-Path -Path $Source -PathType Leaf) {
        $absPath = (Resolve-Path $Source).Path -replace '\\', '/'
        $Source = "file:///$absPath"
    }

    yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 --write-subs --sub-langs "en,pt" --convert-subs srt -o "$BaseName\$BaseName.%(ext)s" "$Source"
}

if ($args.Count -eq 2) {
    Process-Download -Source $args[0] -BaseName $args[1]
}
elseif ($args.Count -eq 1) {
    $csvFile = $args[0]

    if (-not (Test-Path -Path $csvFile -PathType Leaf)) {
        Write-Host "Error: File not found: $csvFile"
        exit 1
    }

    Get-Content $csvFile | ForEach-Object {
        $line = $_.Trim()
        if ([string]::IsNullOrEmpty($line)) { return }

        $parts = $line -split ',', 2
        if ($parts.Count -lt 2) {
            Write-Host "Warning: Ignored invalid csv tuple."
            return
        }

        $source = $parts[0].Trim()
        $name = $parts[1].Trim()

        if ([string]::IsNullOrEmpty($source) -or [string]::IsNullOrEmpty($name)) {
            Write-Host "Warning: Ignored invalid csv tuple."
            return
        }

        Write-Host "Batch processing: $name"
        Process-Download -Source $source -BaseName $name
    }
}
else {
    $scriptName = if ($MyInvocation.MyCommand.Name) { $MyInvocation.MyCommand.Name } else { "download-media.ps1" }
    Write-Host "Single processing: .\$scriptName <URL_OU_CAMINHO_DO_MANIFESTO> <NOME_BASE>"
    Write-Host "Batch processing: .\$scriptName <CAMINHO_DO_ARQUIVO_CSV>"
    exit 1
}
