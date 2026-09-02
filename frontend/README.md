# Rick and Morty Explorer

Flutter application for searching an episode and displaying its characters.
The project includes a reusable portal loading overlay.

## Requirements

- Flutter SDK (stable channel)
- Dart SDK included with Flutter
- Docker Desktop, only if you want to use the Docker workflow
- A backend reachable through `GET /episode/:id`

Check the local Flutter installation with:

```bash
flutter doctor
flutter devices
```

## Backend configuration

The backend URL is supplied at build/run time with `BACKEND_URL`:

```text
http://localhost:3000
```

This is the default value. For Flutter Web, the backend must allow requests
from the app origin through CORS. The URL is compiled into the Flutter app;
changing it requires a new run or build.

## Run locally

From this directory (`frontend`), install dependencies first:

```bash
flutter pub get
```

Run in Chrome/Web:

```bash
flutter run -d chrome --dart-define=BACKEND_URL=http://localhost:3000
```

Run on a connected Android or iOS device/emulator:

```bash
flutter run --dart-define=BACKEND_URL=http://localhost:3000
```

Use `flutter devices` to find a specific device and pass its identifier with
`-d <device-id>`.

When the backend runs on the host machine, Android Emulator usually needs
`http://10.0.2.2:3000` instead of `localhost`. A physical device must use a
backend address reachable on the same network, such as the host machine's
LAN IP address.

Build or run other platforms individually:

```bash
flutter run -d windows
flutter run -d linux
flutter run -d macos
flutter build apk --dart-define=BACKEND_URL=http://localhost:3000
flutter build ios --dart-define=BACKEND_URL=http://localhost:3000
flutter build web --release --dart-define=BACKEND_URL=http://localhost:3000
```

The target platform must be enabled and available on the current operating
system. For example, iOS and macOS builds require macOS with Xcode.

## Run with Docker

The `Dockerfile` uses a Flutter build stage and serves the generated Web app
with Nginx.

Build the image:

```bash
docker build \
  --build-arg BACKEND_URL=http://localhost:3000 \
  -t rick-morty-explorer-frontend .
```

Start the container:

```bash
docker run --rm --name rick-morty-frontend -p 8080:80 \
  rick-morty-explorer-frontend
```

Open [http://localhost:8080](http://localhost:8080) in a browser.

The `BACKEND_URL` value is compiled into the Web bundle during
`docker build`; it is not read dynamically by Nginx at container startup.
For a deployed environment, use a URL that is reachable from the user's
browser, for example:

```bash
docker build \
  --build-arg BACKEND_URL=https://api.example.com \
  -t rick-morty-explorer-frontend .
```

To stop a container started without `--rm`:

```bash
docker stop rick-morty-frontend
```

After changing Dart code or assets, rebuild the image so the new Flutter Web
bundle is copied into Nginx:

```bash
docker build --no-cache \
  --build-arg BACKEND_URL=http://localhost:3000 \
  -t rick-morty-explorer-frontend .
```

## Tests and static analysis

```bash
flutter analyze
flutter test
```

## Loading animation

The portal loading animation currently runs for a fixed 3.2 seconds. This is
temporary behavior used to reproduce the visual animation. In the production
implementation, the loading overlay must be connected to the request state:
it should remain visible while the request is in progress and be dismissed
only after the data has loaded correctly and has been validated for display.
The animation duration should not be used as a substitute for request
completion state.

## Troubleshooting

If a Web asset returns HTTP 404 after adding or changing an image, stop the
old development server and start it again. For a stale production bundle,
rebuild the Docker image and perform a hard browser refresh.
