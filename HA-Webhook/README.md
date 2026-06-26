# HA-Webhook — Automação Home Assistant

Automação do [Home Assistant](https://www.home-assistant.io/) que desenha numa
etiqueta de e-paper (via [OpenEPaperLink](https://openepaperlink.de/)) o **logo**,
o **nome da gaveta** e um **QR code**. É esta a automação disparada pelo
[plugin do InvenTree](../Plugin-InventreeToHomeAssistant/README.md).

> Faz parte do [PI-Project](../README.md). Pré-requisito: ter o OpenEPaperLink a
> correr num ESP32 e a integração OpenEPaperLink instalada no Home Assistant
> (ver [README global](../README.md#1-openepaperlink-no-esp32)).

## Ficheiros

| Ficheiro | Descrição |
|---|---|
| `webhook_final.yaml` | Automação final: logo + título + QR code na etiqueta |
| `automation_trigger_content_example.yaml` | Exemplo mínimo (só texto) para testes |
| `call_trigger.bash` | Exemplos de `curl` para disparar a automação manualmente |
| `send_full_request.bash` | Exemplo de pedido completo à API |

## Configuração no Home Assistant

1. Confirma que a integração **OpenEPaperLink** está instalada e que as etiquetas
   aparecem como *devices*. Anota o `device_id` de cada etiqueta.
2. Cria uma nova automação em *Settings → Automations & Scenes → Create
   Automation → Edit in YAML* e cola o conteúdo de
   [`webhook_final.yaml`](webhook_final.yaml).
3. Garante que o `alias`/entity da automação corresponde ao configurado no
   plugin (por omissão `automation.inventree_gaveta_update`).
4. Cria um **Long-Lived Access Token** em *Perfil → Tokens de acesso de longa
   duração* — usado pelo plugin e pelos scripts de teste.

### Variáveis recebidas pela automação

A automação espera estas variáveis (enviadas pelo plugin):

| Variável | Descrição |
|---|---|
| `device_id` | Id da etiqueta de e-paper no Home Assistant |
| `drawer_title` | Texto a desenhar (nome da localização) |
| `qr_text` | Conteúdo do QR code (id da localização no InvenTree) |

## Testar manualmente

Os scripts em [`call_trigger.bash`](call_trigger.bash) mostram como disparar a
automação com `curl`. Substitui `YOUR_HA_LONG_LIVED_TOKEN` pelo teu token e o
`device_id` por uma etiqueta real:

```bash
curl -s -X POST http://homeassistant.local:8123/api/services/automation/trigger \
  -H "Authorization: Bearer YOUR_HA_LONG_LIVED_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "entity_id": "automation.inventree_gaveta_update",
    "variables": {
      "device_id": "802b7203943c9f35000b7dfa677305b9",
      "drawer_title": "Resistências",
      "qr_text": "1"
    }
  }'
```

> ⚠️ **Nunca faças commit do teu token real.** Os exemplos usam o placeholder
> `YOUR_HA_LONG_LIVED_TOKEN` propositadamente.

## Autores

Afonso Saraiva, Daniel Marques, Inês Francisco, Hugo Silva — PE20 2026.
