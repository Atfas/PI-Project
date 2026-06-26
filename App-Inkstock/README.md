# InkStock App (Android)

Android app (React + TypeScript + Vite + [Capacitor](https://capacitorjs.com/))
that **scans a drawer's QR code**, resolves the matching location in
[InvenTree](https://inventree.org/) and lets you **view and edit the stock** of that location directly on your phone.

> The QR code being scanned is the one generated on the e-paper tags by the
> [Home Assistant automation](../HA-Webhook/README.md).

## Features

- QR code scanning with the camera.
- Resolves the InvenTree location from the QR contents.
- Stock editing, moving items, location breadcrumb and recently viewed.
- Part search with real-time suggestions.

### Supported QR payloads

- A direct tag/location id, for example `1`.
- A URL with the tag in the query string, for example
  `https://app.example.com/?tag=1`.

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

### Getting the InvenTree API token

`VITE_INVENTREE_API_TOKEN` is an **InvenTree API token** tied to a user account.
The app sends it as `Authorization: Token <token>` on every request, so that
user's permissions decide what the app can read and edit.

You can generate it in two ways:

- **Web UI:** log in to InvenTree, go to *Settings → Account → API tokens* and
  create a new token.
- **Command line:** request one from the token endpoint with your username and
  password:

  ```bash
  curl -u <username>:<password> http://192.168.1.93/api/user/token/
  ```

  The response contains the token to paste into `.env`:

  ```json
  { "token": "inv-1cea4c47...." }
  ```

## Building the Android APK

### Prerequisites: Android SDK

You need the Android SDK and a Java JDK (17+) installed. The easiest way is
[Android Studio](https://developer.android.com/studio), which bundles the SDK,
the build tools and `adb`:

1. Install **Android Studio** and open it once so it downloads the default SDK.
2. In *Settings → Languages & Frameworks → Android SDK*, make sure an **SDK
   Platform** and the **Android SDK Build-Tools** + **Platform-Tools** are
   installed.
3. Point the build to the SDK by setting `ANDROID_HOME` (and adding the tools to
   your `PATH`). On macOS, add this to `~/.zshrc`:

   ```bash
   export ANDROID_HOME="$HOME/Library/Android/sdk"
   export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
   ```

   Then reload with `source ~/.zshrc` and verify with `adb --version`.

> Alternatively, install just the SDK without Android Studio via the
> [command-line tools](https://developer.android.com/studio#command-line-tools-only),
> or on macOS with `brew install --cask android-commandlinetools`. Gradle itself
> does not need a separate install — the project ships with the Gradle wrapper
> (`./gradlew`).

### Build

```bash
# Build the web app, sync Capacitor and generate the debug APK
npm run apk

# Or build and install directly on a device connected via adb
npm run apk:install
```

The APK is generated at `android/app/build/outputs/apk/debug/app-debug.apk`.

