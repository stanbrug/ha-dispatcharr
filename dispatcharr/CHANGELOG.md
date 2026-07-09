# Changelog

## 1.1.0

- Optionele eigen CIFS-mount (`cifs_*`-opties) op `/mnt/remote`, gemount met UID 1000 zodat Dispatcharr er wél kan schrijven (HA-netwerkopslag is root-only)
- `/share/dispatcharr` wordt bij het starten aangemaakt en schrijfbaar gemaakt voor Dispatcharr
- Add-on heeft nu `SYS_ADMIN`-privilege nodig voor de CIFS-mount

## 1.0.1

- `/media` gemount in de container, zodat netwerkopslag (bijv. `/media/Hetzner`) bereikbaar is

## 1.0.0

- Eerste release
- Draait de officiële Dispatcharr all-in-one image (`ghcr.io/dispatcharr/dispatcharr:latest`)
- Persistente opslag in `/data`
- Web-UI op poort 9191
- Configureerbaar logniveau
- `/share` beschikbaar voor lokale M3U/EPG-bestanden
