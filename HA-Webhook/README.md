# HA-Webhook — Home Assistant Automation

[Home Assistant](https://www.home-assistant.io/) automation that draws a **logo**,
the **drawer name** and a **QR code** onto an e-paper (ESL) tag via
[OpenEPaperLink](https://openepaperlink.de/). This is the automation triggered by
the [InvenTree plugin](../Plugin-InventreeToHomeAssistant/README.md).

> Part of the [PI-Project](../README.md). Prerequisite: have OpenEPaperLink
> running on an ESP32 and the OpenEPaperLink integration installed in Home
> Assistant (see the [main README](../README.md)).

## Files

| File | Description |
|---|---|
| `webhook_final.yaml` | Final automation: logo + title + QR code on the tag |
| `automation_trigger_content_example.yaml` | Minimal example (text only) for testing |
| `call_trigger.bash` | `curl` examples to trigger the automation manually |
| `send_full_request.bash` | Example of a full API request |

## Home Assistant setup

1. Make sure the **OpenEPaperLink** integration is installed and that the tags
   appear as *devices*. Note down the `device_id` of each tag.
2. Create a new automation in *Settings → Automations & Scenes → Create
   Automation → Edit in YAML* and paste the contents of
   [`webhook_final.yaml`](webhook_final.yaml).
3. Make sure the automation's `alias`/entity matches the one configured in the
   plugin (default `automation.inventree_gaveta_update`).
4. Create a **Long-Lived Access Token** under *Profile → Long-Lived Access
   Tokens* — used by the plugin and by the test scripts.

### Variables received by the automation

The automation expects these variables (sent by the plugin):

| Variable | Description |
|---|---|
| `device_id` | Id of the e-paper tag in Home Assistant |
| `drawer_title` | Text to draw (location name) |
| `qr_text` | QR code contents (location id in InvenTree) |

## Testing manually

You can trigger the automation with `curl`. Replace `YOUR_HA_LONG_LIVED_TOKEN`
with your token and the `device_id` with a real tag:

```bash
curl -s -X POST http://homeassistant.local:8123/api/services/automation/trigger \
  -H "Authorization: Bearer YOUR_HA_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "entity_id": "automation.inventree_gaveta_update",
    "variables": {
      "device_id": "802b7203943c9f35000b7dfa677305b9",
      "drawer_title": "Resistors",
      "qr_text": "1"
    }
  }'
```

> ⚠️ **Never commit your real token.** The examples use the placeholder
> `YOUR_HA_LONG_LIVED_TOKEN` on purpose.

## Authors

Afonso Saraiva, Daniel Marques, Inês Francisco, Hugo Silva — PE20 2026.
