# Plugin InventreeToHomeAssistant

Plugin de [InvenTree](https://inventree.org/) que **dispara uma automação do
Home Assistant** sempre que uma localização de stock (sublocalização) é guardada.
É usado para atualizar uma etiqueta de e-paper com o nome da localização e um QR
code.

> Faz parte do [PI-Project](../README.md). Antes de instalar este plugin, o Home
> Assistant e a automação OpenEPaperLink já devem estar a funcionar — ver
> [HA-Webhook](../HA-Webhook/README.md).

## O que faz

Ao ser guardada uma `StockLocation`, o plugin:

1. Verifica se a **descrição** da localização começa por `tag_id:`.
2. Extrai o `device_id` da etiqueta a partir dessa descrição
   (`tag_id:802b7203943c9f35000b7dfa677305b9`).
3. Formata o nome da localização para caber numa etiqueta pequena
   (máx. 11 caracteres por linha, com quebra por palavras).
4. Chama a API do Home Assistant (`/api/services/automation/trigger`),
   passando `device_id`, `drawer_title` (nome formatado) e `qr_text` (id da
   localização).

Localizações cuja descrição **não** comece por `tag_id:` são ignoradas.

## Instalação no InvenTree

### Via Plugin Manager (recomendado)

1. No InvenTree, garante que os plugins estão ativados
   (`INVENTREE_PLUGINS_ENABLED=True` ou *Settings → Plugins*).
2. Em *Settings → Plugins → Install Plugin*, instala a partir do PyPI:

   ```
   inventree-inventreetohomeassistant
   ```

3. Ativa o plugin na lista de plugins.

### Via linha de comandos

```bash
pip install inventree-inventreetohomeassistant
```

Reinicia o servidor InvenTree e ativa o plugin nas definições.

### A partir do código-fonte (desenvolvimento)

```bash
cd Plugin-InventreeToHomeAssistant
pip install -e .
```

## Configuração

Depois de ativar o plugin, abre as suas definições no InvenTree e preenche:

| Definição | Descrição | Exemplo |
|---|---|---|
| `HA_URL` | URL base do Home Assistant | `http://homeassistant.local:8123` |
| `HA_TOKEN` | Long-Lived Access Token do HA | `eyJhbG...` |
| `HA_AUTOMATION_ENTITY` | Entidade da automação a disparar | `automation.inventree_gaveta_update` |

> O token obtém-se no Home Assistant em *Perfil → Tokens de acesso de longa
> duração*. A automação é a criada em [HA-Webhook](../HA-Webhook/README.md).

## Utilização

1. Cria/edita uma localização de stock no InvenTree.
2. No campo **Descrição**, coloca `tag_id:<device_id>`, em que `<device_id>` é o
   id da etiqueta de e-paper no Home Assistant.

   ```
   tag_id:802b7203943c9f35000b7dfa677305b9
   ```

3. Guarda. O plugin dispara a automação do HA e a etiqueta é redesenhada com o
   nome da localização + QR code.

Os logs do servidor InvenTree mostram `[HA Plugin] Triggered automation ...` em
caso de sucesso, ou a mensagem de erro em caso de falha.

## Autores

Afonso Saraiva, Daniel Marques, Inês Francisco, Hugo Silva — PE20 2026.
