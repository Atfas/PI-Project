# InkStock App (Android)

Android app (React + TypeScript + Vite + [Capacitor](https://capacitorjs.com/))
that **scans a drawer's QR code**, resolves the matching location in
[InvenTree](https://inventree.org/) and lets you **view and edit the stock** of
that location directly on your phone.

> Part of the [PI-Project](../README.md). The QR code being scanned is the one
> generated on the e-paper tags by the
> [Home Assistant automation](../HA-Webhook/README.md).

## Features

- QR code scanning with the camera (via `html5-qrcode`).
- Resolves the InvenTree location from the QR contents.
- Stock editing, moving items, location breadcrumb and recently viewed.
- Part search with real-time suggestions.

### Supported QR payloads

- A direct tag/location id, for example `TAG-001` or `1`.
- A URL with the tag in the query string, for example
  `https://app.example.com/?tag=TAG-001`.

## Development

Requires Node.js v20 or v22 and npm.

```bash
npm install --include=dev
npm run dev
```

## Configuration (environment variables)

Create a `.env` file (dev) or `.env.production` (APK build) with:

| Variable | Description | Example |
|---|---|---|
| `VITE_INVENTREE_API_BASE_URL` | InvenTree host (no trailing slash) | `http://192.168.1.93` |
| `VITE_INVENTREE_CONTAINER_ENDPOINT_TEMPLATE` | Location endpoint | `/api/stock/location/{id}/` |
| `VITE_INVENTREE_API_TOKEN` | InvenTree API token | `inv-...` |
| `VITE_INVENTREE_AUTH_SCHEME` | Authentication scheme | `Token` |
| `VITE_INVENTREE_UPDATE_METHOD` | Write method | `PATCH` |

> ⚠️ These files are **not** versioned (they are in `.gitignore`) because they
> contain the API token. In the APK, `.env.production` is baked into the build,
> so `VITE_INVENTREE_API_BASE_URL` must be an address reachable from the phone
> (e.g. the Pi's LAN IP).

## Building the Android APK

Requires the Android SDK / Gradle to be set up.

```bash
# Build the web app, sync Capacitor and generate the debug APK
npm run apk

# Or build and install directly on a device connected via adb
npm run apk:install
```

The APK is generated at `android/app/build/outputs/apk/debug/app-debug.apk`.

> InvenTree is usually served over plain HTTP on the LAN, so the
> `AndroidManifest.xml` allows cleartext (`allowMixedContent`). Use `http://`
> only on trusted networks.

## Authors

Afonso Saraiva, Daniel Marques, Inês Francisco, Hugo Silva — PE20 2026.
