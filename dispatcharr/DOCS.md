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

### Opties: `cifs_*` (netwerkschijf met schrijftoegang)

Netwerkopslag die je via **Instellingen → Systeem → Opslag** aan Home Assistant toevoegt, wordt door HA als *root-only* gemount. Dispatcharr draait als UID 1000 en kan daar dus **niet schrijven** (`Permission denied`). Wil je dat Dispatcharr (bijv. de VOD2MLIB-plugin) naar een netwerkschijf kan schrijven, laat de add-on de share dan zelf mounten:

```yaml
cifs_mount: true
cifs_host: uXXXXXX.your-storagebox.de
cifs_share: backup
cifs_username: uXXXXXX
cifs_password: "jouw-wachtwoord"
```

De share wordt dan met de juiste rechten gemount op **`/mnt/remote`** in de container. Gebruik dat pad in Dispatcharr, bijvoorbeeld `/mnt/remote/VOD/Films`.

Voor een Hetzner Storage Box: `cifs_host` is `uXXXXXX.your-storagebox.de`, de share heet `backup` en de gebruikersnaam is je storage box-account (`uXXXXXX`). Zorg dat in Hetzner Robot **Samba-ondersteuning** en **externe bereikbaarheid** aanstaan (dat is al zo als de share in HA zelf werkt).

> De alleen-lezen toegang via `/media/<naam>` (de HA-mount) blijft daarnaast gewoon beschikbaar.

## Netwerk

De webinterface draait standaard op poort **9191**. Je kunt de hostpoort wijzigen via het tabblad **Configuratie → Netwerk** van de add-on.

De streams die Dispatcharr uitserveert (M3U/EPG-URL's voor je mediaspeler) lopen via dezelfde poort, bijvoorbeeld:

```
http://<home-assistant-ip>:9191/output/m3u
```

## Lokale bestanden en netwerkopslag

Twee Home Assistant-mappen zijn beschikbaar in de container:

- **`/share`** — handig voor lokale M3U- of EPG-bestanden, bijv. `/share/dispatcharr/`.
- **`/media`** — hier verschijnt ook netwerkopslag die je via **Instellingen → Systeem → Opslag** hebt toegevoegd. Een netwerkschijf met de naam *Hetzner* is in de container dus bereikbaar als `/media/Hetzner`. **Let op:** deze HA-mounts zijn voor Dispatcharr alleen-lezen (root-only rechten); moet Dispatcharr erop kunnen schrijven, gebruik dan de `cifs_*`-opties hierboven.
- **`/mnt/remote`** — de optionele eigen CIFS-mount van de add-on (zie `cifs_*`-opties), met volledige schrijftoegang.

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
