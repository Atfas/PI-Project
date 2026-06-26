# InventreeToHomeAssistant Plugin

[InvenTree](https://inventree.org/) plugin that **triggers a Home Assistant
automation** whenever a stock location (sublocation) is saved. It is used to
update an e-paper tag with the location name and a QR code.

> Part of the [PI-Project](../README.md). Before installing this plugin, Home
> Assistant and the OpenEPaperLink automation should already be working — see
> [HA-Webhook](../HA-Webhook/README.md).

## What it does

When a `StockLocation` is saved, the plugin:

1. Checks whether the location's **description** starts with `tag_id:`.
2. Extracts the tag's `device_id` from that description
   (`tag_id:802b7203943c9f35000b7dfa677305b9`).
3. Formats the location name to fit a small tag
   (max. 11 characters per line, wrapping on words).
4. Calls the Home Assistant API (`/api/services/automation/trigger`), passing
   `device_id`, `drawer_title` (formatted name) and `qr_text` (location id).

Locations whose description does **not** start with `tag_id:` are ignored.

## Installing in InvenTree

### Via Plugin Manager (recommended)

1. In InvenTree, make sure plugins are enabled
   (`INVENTREE_PLUGINS_ENABLED=True` or *Settings → Plugins*).
2. Under *Settings → Plugins → Install Plugin*, install from PyPI:

   ```
   inventree-inventreetohomeassistant
   ```

3. Enable the plugin in the plugin list.

### Via command line

```bash
pip install inventree-inventreetohomeassistant
```

Restart the InvenTree server and enable the plugin in the settings.

### From source (development)

```bash
cd Plugin-InventreeToHomeAssistant
pip install -e .
```

## Configuration

After enabling the plugin, open its settings in InvenTree and fill in:

| Setting | Description | Example |
|---|---|---|
| `HA_URL` | Base URL of Home Assistant | `http://homeassistant.local:8123` |
| `HA_TOKEN` | Home Assistant Long-Lived Access Token | `eyJhbG...` |
| `HA_AUTOMATION_ENTITY` | Automation entity to trigger | `automation.inventree_gaveta_update` |

> The token is created in Home Assistant under *Profile → Long-Lived Access
> Tokens*. The automation is the one created in
> [HA-Webhook](../HA-Webhook/README.md).

## Usage

1. Create/edit a stock location in InvenTree.
2. In the **Description** field, set `tag_id:<device_id>`, where `<device_id>` is
   the id of the e-paper tag in Home Assistant.

   ```
   tag_id:802b7203943c9f35000b7dfa677305b9
   ```

3. Save. The plugin triggers the HA automation and the tag is redrawn with the
   location name + QR code.

The InvenTree server logs show `[HA Plugin] Triggered automation ...` on success,
or the error message on failure.

## Authors

Afonso Saraiva, Daniel Marques, Inês Francisco, Hugo Silva — PE20 2026.
