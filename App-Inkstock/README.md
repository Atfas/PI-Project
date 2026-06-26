# App InkStock (Android)

App Android (React + TypeScript + Vite + [Capacitor](https://capacitorjs.com/))
que **lê o QR code de uma gaveta**, resolve a localização correspondente no
[InvenTree](https://inventree.org/) e permite **consultar e editar o stock**
dessa localização diretamente no telemóvel.

> Faz parte do [PI-Project](../README.md). O QR code lido é o gerado nas etiquetas
> de e-paper pela [automação do Home Assistant](../HA-Webhook/README.md).

## Funcionalidades

- Leitura de QR code com a câmara (via `html5-qrcode`).
- Resolução da localização no InvenTree a partir do conteúdo do QR.
- Edição de stock, mover itens, breadcrumb de localização e vistos recentemente.
- Pesquisa de peças com sugestões em tempo real.

### Payloads de QR suportados

- Um id de tag/localização direto, por exemplo `TAG-001` ou `1`.
- Um URL com o tag na query string, por exemplo
  `https://app.example.com/?tag=TAG-001`.

## Desenvolvimento

Requer Node.js v20 ou v22 e npm.

```bash
npm install --include=dev
npm run dev
```

## Configuração (variáveis de ambiente)

Cria um ficheiro `.env` (dev) ou `.env.production` (build do APK) com:

| Variável | Descrição | Exemplo |
|---|---|---|
| `VITE_INVENTREE_API_BASE_URL` | Host do InvenTree (sem barra final) | `http://192.168.1.93` |
| `VITE_INVENTREE_CONTAINER_ENDPOINT_TEMPLATE` | Endpoint da localização | `/api/stock/location/{id}/` |
| `VITE_INVENTREE_API_TOKEN` | Token da API do InvenTree | `inv-...` |
| `VITE_INVENTREE_AUTH_SCHEME` | Esquema de autenticação | `Token` |
| `VITE_INVENTREE_UPDATE_METHOD` | Método de escrita | `PATCH` |

> ⚠️ Estes ficheiros **não** são versionados (estão no `.gitignore`) porque
> contêm o token da API. No APK, o `.env.production` é "cozido" no build, por
> isso o `VITE_INVENTREE_API_BASE_URL` tem de ser um endereço alcançável pelo
> telemóvel (ex: o IP do Pi na LAN).

## Compilar o APK Android

Requer Android SDK / Gradle configurados.

```bash
# Compila a app web, sincroniza o Capacitor e gera o APK debug
npm run apk

# Ou compila e instala diretamente num dispositivo ligado por adb
npm run apk:install
```

O APK fica em `android/app/build/outputs/apk/debug/app-debug.apk`.

> O InvenTree é normalmente servido em HTTP simples na LAN, por isso o
> `AndroidManifest.xml` permite cleartext (`allowMixedContent`). Usa `http://`
> apenas em redes de confiança.

## Autores

Afonso Saraiva, Daniel Marques, Inês Francisco, Hugo Silva — PE20 2026.
