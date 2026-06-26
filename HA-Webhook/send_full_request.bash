curl -X POST http://homeassistant.local:8123/api/services/open_epaper_link/drawcustom \
  -H "Authorization: Bearer YOUR_HA_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "device_id": "802b7203943c9f35000b7dfa677305b9",
    "rotate": 0,
    "dither": "0",
    "ttl": 60,
    "refresh_type": "0",
    "dry-run": false,
    "background": "white",
    "payload": [
      {
        "type": "text",
        "value": "Funcionou script enviado",
        "x": "50%",
        "y": "90%",
        "anchor": "mm",
        "size": 20,
        "color": "red"
      }
    ]
  }'