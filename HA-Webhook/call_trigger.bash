curl -X POST http://homeassistant.local:8123/api/services/automation/trigger \
  -H "Authorization: Bearer YOUR_HA_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "automation.inventree_gaveta_update"}'



curl -s -X POST http://homeassistant.local:8123/api/services/automation/trigger \
  -H "Authorization: Bearer YOUR_HA_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
  "entity_id": "automation.inventree_gaveta_update",
  "variables": {
    "overlay_text": "Texto workings again",
    "device_id": "802b7203943c9f35000b7dfa677305b9"
  }
}'
  

  curl -s -X POST http://homeassistant.local:8123/api/services/automation/trigger \
    -H "Authorization: Bearer YOUR_HA_LONG_LIVED_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "entity_id": "automation.inventree_gaveta_update",
      "variables": {
        "device_id": "802b7203943c9f35000b7dfa677305b9",
        "message": "Funcionou"
      }
    }'


curl -s -X POST http://homeassistant.local:8123/api/services/automation/trigger \
  -H "Authorization: Bearer YOUR_HA_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "entity_id": "automation.inventree_gaveta_update",
    "variables": {
      "device_id": "802b7203943c9f35000b7dfa677305b9",
      "drawer_title": "Funcionou",
      "qr_text": "1"
    }
  }'