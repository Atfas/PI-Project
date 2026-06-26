# PI-Project: InkStock (PE20 2026)

**Smart inventory tagging** system that links an [InvenTree](https://inventree.org/)
instance to electronic paper tags (e-paper / ESL) through
[Home Assistant](https://www.home-assistant.io/) and
[OpenEPaperLink](https://openepaperlink.de/).

When a stock location is created or updated in InvenTree, the matching e-paper
tag is automatically redrawn with the **drawer name** and a **QR code**. An
operator can then scan that QR with the **InkStock** Android app to open the
location on their phone and edit the stock right where they are.

---

## How it works

```
┌──────────────┐   saves location        ┌──────────────────────────┐
│   InvenTree  │ ───────────────────────▶│  Plugin                  │
│   (server)   │   (save event)          │  InventreeToHomeAssistant│
└──────────────┘                         └────────────┬─────────────┘
       ▲                                              │ triggers automation
       │ scans QR / edits stock                       │ (REST API + token)
       │                                              ▼
┌──────────────┐                          ┌──────────────────────────────┐
│ InkStock app │                          │      Home Assistant          │
│  (Android)   │                          │  automation + OpenEPaperLink │
└──────────────┘                          └────────────┬─────────────────┘
                                                       │ drawcustom
                                                       ▼
                                          ┌───────────────────────────┐
                                          │  ESP32 (OpenEPaperLink AP)│
                                          │      → e-paper tag        │
                                          └───────────────────────────┘
```

1. **OpenEPaperLink on the ESP32** drives the e-paper tags over BLE.
2. The **OpenEPaperLink integration in Home Assistant** exposes the
   `open_epaper_link.drawcustom` service, used by an automation to draw a logo +
   title + QR code onto a specific tag (`device_id`).
3. The **InvenTree plugin** listens for stock-location save events and, when the
   description starts with `tag_id:<device_id>`, triggers the HA automation.
4. The **InkStock app** scans the drawer's QR code (which contains the location
   id) and lets you view/edit that location's stock via the InvenTree API.

---

## Components

| Folder | What it is | README |
|---|---|---|
| [`App-Inkstock/`](App-Inkstock/) | Android app (React + Capacitor) to scan the QR and edit stock | [README](App-Inkstock/README.md) |
| [`Plugin-InventreeToHomeAssistant/`](Plugin-InventreeToHomeAssistant/) | InvenTree plugin that triggers Home Assistant | [README](Plugin-InventreeToHomeAssistant/README.md) |
| [`HA-Webhook/`](HA-Webhook/) | Home Assistant automation + call examples | [README](HA-Webhook/README.md) |

---

## Setup order

The system should be built **from the bottom up**, first the tag hardware, then
Home Assistant, then InvenTree, and finally the app.

### 1. OpenEPaperLink on the ESP32

First of all, you need the e-paper tags working.

1. Flash the **OpenEPaperLink Access Point** firmware onto an ESP32 — follow the
   [Our tutorial recomendation](https://chrishansen.tech/posts/Electronic_Shelf_Tag/#flashing-openepaperlink-on-esp32).
2. Connect the AP to the network and pair (associate) the e-paper tags.
3. Add to the OpenEpaperLink integration on home assisatnta

### 2. Home Assistant + OpenEPaperLink integration

1. Have a running Home Assistant instance.
2. Install the [OpenEPaperLink](https://github.com/jonasniesner/open_epaper_link_homeassistant) integration (via HACS) and point it at the AP from step 1.
3. Each tag now shows up as a *device* in HA - **note down the `device_id` of each one** (you can read it from the URL when opening the tag in the integration).
4. Create a **Long-Lived Access Token** under *Profile → Long-Lived Access
   Tokens*. Save it; it is used by the InvenTree plugin.
5. Create the automation from [`HA-Webhook/`](HA-Webhook/) ([HA-Webhook README](HA-Webhook/README.md))

### 3. InvenTree + plugin

1. Have a running InvenTree instance with plugins enabled.
2. Install and configure the **InventreeToHomeAssistant** plugin ([Plugin README](Plugin-InventreeToHomeAssistant/README.md))
3. On the stock locations, set the description to `tag_id:<device_id>`, using the
   tag's `device_id` from step 2.3.
4. When you save the location, the e-paper tag should update automatically.

### 4. InkStock app (Android)

1. Build and install the app ([App README](App-Inkstock/README.md))
2. Configure the InvenTree address and API token.
3. Scan a drawer's QR code to open and edit the stock.

---

## Authors

Project developed by:

- Afonso Saraiva
- Daniel Marques
- Inês Francisco
- Hugo Silva

PE20 2026.
