# Dispatcharr add-on documentatie

## Hoe het werkt

Deze add-on draait de officiële all-in-one image van Dispatcharr (`ghcr.io/dispatcharr/dispatcharr:latest`). Eén container bevat de webapplicatie, PostgreSQL, Redis en de Celery-taakverwerker.

Alle applicatiedata (database, M3U-playlists, EPG-cache, instellingen) staat in `/data`, de persistente opslag van de add-on. Data blijft dus bewaard bij herstarts en updates van de add-on.

## Configuratie

Voorbeeld:

```yaml
log_level: info
```

### Optie: `log_level`

Het logniveau van Dispatcharr. Mogelijke waarden:

- `debug` — zeer uitgebreid, alleen voor probleemoplossing
- `info` — standaard
- `warning`
- `error`

## Netwerk

De webinterface draait standaard op poort **9191**. Je kunt de hostpoort wijzigen via het tabblad **Configuratie → Netwerk** van de add-on.

De streams die Dispatcharr uitserveert (M3U/EPG-URL's voor je mediaspeler) lopen via dezelfde poort, bijvoorbeeld:

```
http://<home-assistant-ip>:9191/output/m3u
```

## Lokale bestanden en netwerkopslag

Twee Home Assistant-mappen zijn beschikbaar in de container:

- **`/share`** — handig voor lokale M3U- of EPG-bestanden, bijv. `/share/dispatcharr/`.
- **`/media`** — hier verschijnt ook netwerkopslag die je via **Instellingen → Systeem → Opslag** hebt toegevoegd. Een netwerkschijf met de naam *Hetzner* is in de container dus bereikbaar als `/media/Hetzner`.

Verwijs in de Dispatcharr-webinterface naar deze paden om de bestanden te gebruiken.

## Eerste start

Bij de eerste start initialiseert Dispatcharr de PostgreSQL-database en voert het migraties uit; dit kan één tot enkele minuten duren. Volg de voortgang via het tabblad **Log**. Zodra de webinterface bereikbaar is, maak je daar je beheerdersaccount aan.

## Backups

De add-on-data in `/data` wordt meegenomen in Home Assistant-backups van deze add-on. Maak een backup vóór grote updates.

## Problemen oplossen

- **Web-UI niet bereikbaar direct na start** — wacht tot de initialisatie klaar is (zie Log).
- **Poortconflict** — wijzig de hostpoort onder Configuratie → Netwerk als 9191 al in gebruik is.
- **Hoge CPU tijdens EPG-import** — normaal; Celery verwerkt imports op de achtergrond.

## Ondersteunde architecturen

- `amd64` (x86-64)
- `aarch64` (Raspberry Pi 4/5, enz.)
