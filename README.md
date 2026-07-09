# Home Assistant Add-on repository: Dispatcharr

Deze repository bevat een Home Assistant add-on die [Dispatcharr](https://github.com/dispatcharr/dispatcharr) draait — een open-source beheerplatform voor IPTV-streams, EPG-data en VOD-content.

## Installatie

1. Ga in Home Assistant naar **Instellingen → Add-ons → Add-on shop**.
2. Klik rechtsboven op **⋮ → Repositories**.
3. Voeg de URL van deze repository toe (bijv. `https://github.com/<jouw-gebruikersnaam>/ha-dispatcharr`) en klik op **Toevoegen**.
4. Zoek **Dispatcharr** in de add-on shop en klik op **Installeren**.

> **Let op:** de eerste installatie bouwt de image lokaal op basis van `ghcr.io/dispatcharr/dispatcharr:latest` en kan enkele minuten duren.

### Lokaal testen (zonder GitHub)

Kopieer de map `dispatcharr/` naar de `addons/`-map van je Home Assistant-installatie (bereikbaar via de Samba- of SSH-add-on) en ververs daarna de add-on shop. De add-on verschijnt dan onder **Lokale add-ons**.

## Gebruik

- Na het starten is de webinterface bereikbaar op poort **9191** (knop **Open web-UI** in de add-on-pagina).
- Alle data (database, M3U's, EPG, instellingen) wordt bewaard in de persistente `/data`-opslag van de add-on en overleeft herstarts en updates.
- De Home Assistant `/share`-map is beschikbaar in de container, handig voor lokale M3U- of EPG-bestanden.

## Add-ons

| Add-on | Beschrijving |
|---|---|
| [Dispatcharr](./dispatcharr) | IPTV-stream-, EPG- en VOD-beheer (all-in-one: web-app, PostgreSQL, Redis en Celery in één container) |
