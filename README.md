# PI-Project — InkStock (PE20 2026)

Sistema de **etiquetagem inteligente de inventário** que liga uma instância
[InvenTree](https://inventree.org/) a etiquetas de papel eletrónico (e-paper / ESL)
através do [Home Assistant](https://www.home-assistant.io/) e do
[OpenEPaperLink](https://openepaperlink.de/).

Quando uma localização de stock é criada ou atualizada no InvenTree, a etiqueta
de e-paper correspondente é automaticamente redesenhada com o **nome da gaveta** e
um **código QR**. Um operador pode depois ler esse QR com a app Android **InkStock**
para abrir a localização no telemóvel e editar o stock diretamente no terreno.

---

## Como funciona

```
┌──────────────┐   guarda localização    ┌──────────────────────────┐
│   InvenTree  │ ───────────────────────▶│  Plugin                  │
│  (servidor)  │   (evento de save)      │  InventreeToHomeAssistant│
└──────────────┘                         └────────────┬─────────────┘
       ▲                                               │ dispara automação
       │ lê QR / edita stock                           │ (REST API + token)
       │                                               ▼
┌──────────────┐                          ┌──────────────────────────┐
│  App InkStock│                          │      Home Assistant       │
│  (Android)   │                          │  automação + OpenEPaperLink│
└──────────────┘                          └────────────┬─────────────┘
                                                        │ drawcustom
                                                        ▼
                                          ┌──────────────────────────┐
                                          │  ESP32 (AP OpenEPaperLink)│
                                          │      → etiqueta e-paper   │
                                          └──────────────────────────┘
```

1. **OpenEPaperLink no ESP32** controla as etiquetas de e-paper por rádio.
2. A integração **OpenEPaperLink no Home Assistant** expõe o serviço
   `open_epaper_link.drawcustom`, usado por uma automação para desenhar logo +
   título + QR code numa etiqueta específica (`device_id`).
3. O **plugin InvenTree** ouve os eventos de gravação de localizações de stock e,
   quando a descrição começa por `tag_id:<device_id>`, dispara a automação do HA.
4. A **app InkStock** lê o QR code da gaveta (que contém o id da localização) e
   permite consultar/editar o stock dessa localização via API do InvenTree.

---

## Componentes

| Pasta | O que é | README |
|---|---|---|
| [`App-Inkstock/`](App-Inkstock/) | App Android (React + Capacitor) para ler o QR e editar stock | [README](App-Inkstock/README.md) |
| [`Plugin-InventreeToHomeAssistant/`](Plugin-InventreeToHomeAssistant/) | Plugin InvenTree que dispara o Home Assistant | [README](Plugin-InventreeToHomeAssistant/README.md) |
| [`HA-Webhook/`](HA-Webhook/) | Automação Home Assistant + exemplos de chamada | [README](HA-Webhook/README.md) |

---

## Ordem de instalação

O sistema deve ser montado **de baixo para cima** — primeiro o hardware das
etiquetas, depois o Home Assistant, depois o InvenTree, e por fim a app.

### 1. OpenEPaperLink no ESP32

Antes de tudo, tens de ter as etiquetas de e-paper a funcionar.

1. Faz flash do firmware **OpenEPaperLink Access Point** num ESP32 — segue o
   [guia oficial de instalação](https://openepaperlink.de/getting_started/).
2. Liga o AP à rede e empareja (associa) as etiquetas de e-paper.
3. Confirma que consegues enviar uma imagem de teste pela web UI do AP.

### 2. Home Assistant + integração OpenEPaperLink

1. Tem uma instância de Home Assistant a correr (no nosso caso, num Raspberry Pi).
2. Instala a integração [OpenEPaperLink](https://github.com/jonasniesner/open_epaper_link_homeassistant)
   (via HACS) e aponta-a para o AP da etapa 1.
3. Cada etiqueta passa a aparecer como um *device* no HA — anota o `device_id`
   de cada uma (vais precisar deles).
4. Cria um **Long-Lived Access Token** em *Perfil → Tokens de acesso de longa
   duração*. Guarda-o; é usado pelo plugin do InvenTree.
5. Cria a automação a partir de [`HA-Webhook/`](HA-Webhook/) — ver
   [README do HA-Webhook](HA-Webhook/README.md).

### 3. InvenTree + plugin

1. Tem uma instância de InvenTree a correr com plugins ativados.
2. Instala e configura o plugin **InventreeToHomeAssistant** — ver
   [README do plugin](Plugin-InventreeToHomeAssistant/README.md).
3. Nas localizações de stock, define a descrição como `tag_id:<device_id>`,
   usando o `device_id` da etiqueta da etapa 2.3.
4. Ao guardar a localização, a etiqueta de e-paper deve atualizar
   automaticamente.

### 4. App InkStock (Android)

1. Compila e instala a app — ver [README da app](App-Inkstock/README.md).
2. Configura o endereço do InvenTree e o token da API.
3. Lê o QR code de uma gaveta para abrir e editar o stock.

---

## Autores

Projeto desenvolvido por:

- Afonso Saraiva
- Daniel Marques
- Inês Francisco
- Hugo Silva

PE20 — 2026.
