# Rick and Morty App

Monorepo containing an independent Flutter frontend and Node.js backend.

## Project structure

```text
backend/              Node.js API
frontend/             Flutter application
docker-compose.yml    Production-style local stack
docker-compose.dev.yml Flutter development override
```

## Requirements

- Flutter SDK (stable channel)
- Dart SDK included with Flutter
- Node.js and npm, for running the backend individually
- Docker Desktop, for the Docker workflows

## Prerequisites and external dependencies

### Required tools

- Flutter stable SDK with Dart `^3.10.3` support.
- Node.js with npm. The Docker backend uses Node.js 22; using Node.js 22
  locally is recommended.
- Docker Desktop with the Compose V2 command (`docker compose`), if running
  the containerized stack.
- A browser for the Flutter Web app. Chrome is used by the local run command.
- Xcode for iOS/macOS targets, or Android Studio/Android SDK for Android
  targets.

### Frontend libraries

Declared in `frontend/pubspec.yaml`:

- Flutter SDK (`flutter`), including Material and Cupertino support.
- `http ^1.3.0` for HTTP requests from Flutter to the backend.
- `flutter_dotenv ^5.2.1` for loading the frontend `.env` configuration.
- `flutter_svg ^2.0.17` for SVG asset support retained in the project.
- `cupertino_icons ^1.0.8` for Cupertino icons.
- Development-only: `flutter_test` and `flutter_lints ^6.0.0`.

The frontend also bundles the portal image at
`frontend/assets/portal.png`. The loading overlay uses this local asset and
does not require an external image service.

### Backend libraries

The backend currently has no third-party runtime npm dependencies. It uses:

- Node.js built-in `node:http` module for the HTTP server.
- Node.js global `fetch` for outbound API calls.
- npm scripts from `backend/package.json` (`npm start` and `npm run dev`).

### External services and network access

- The backend calls the public [Rick and Morty API](https://rickandmortyapi.com/)
  using the `API` environment variable.
- `GET /episode/:id` first queries the episode resource and then queries the
  character resource for the character IDs returned by that episode.
- Internet access is required by the backend unless `API` is replaced with a
  compatible internal service.
- The Flutter app calls the local backend at `http://localhost:3000` by
  default. For Web, the backend must be reachable from the browser and allow
  CORS requests.
- The frontend reads `frontend/.env` through `flutter_dotenv`. Its
  `BACKEND_URL` value is used unless a `--dart-define=BACKEND_URL=...` value is
  provided; the build-time define takes precedence.
- No database, cache, authentication provider, message broker, or cloud
  storage is required by the current implementation.

### Container images

The Docker workflows use these external base images:

- `ghcr.io/cirruslabs/flutter:stable` to build the Flutter Web bundle.
- `nginx:alpine` to serve the frontend bundle.
- `node:22-alpine` to run the backend.

Docker needs registry access the first time these images are built.

## Run the complete stack with Docker

Run these commands from the repository root:

```bash
docker compose up --build
```

This starts both services:

- Frontend: [http://localhost:8080](http://localhost:8080)
- Backend: [http://localhost:3000](http://localhost:3000)

The frontend image is built with `BACKEND_URL=http://localhost:3000` by
default. To use a different backend URL during the Flutter Web build:

```bash
BACKEND_URL=https://api.example.com docker compose up --build
```

On PowerShell:

```powershell
$env:BACKEND_URL = "https://api.example.com"
docker compose up --build
```

Stop the stack:

```bash
docker compose down
```

View service logs:

```bash
docker compose logs -f
docker compose logs -f frontend
docker compose logs -f backend
```

Force a clean rebuild after changing dependencies or assets:

```bash
docker compose build --no-cache
docker compose up
```

## Docker development mode

The development override mounts the Flutter source and runs Flutter's Web
server with hot reload:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

Open [http://localhost:8080](http://localhost:8080). In the interactive
terminal, use `r` for hot reload, `R` for hot restart, and `q` to stop Flutter.

Stop development mode:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml down
```

## Run the backend individually

```bash
cd backend
cp .env.example .env
npm ci
npm start
```

On PowerShell, use `Copy-Item .env.example .env` instead of `cp`.

The `.env` file is required when running the backend locally because it
provides the upstream API URL. The Docker Compose configuration provides
these values automatically.

The backend listens on port `3000` and exposes:

```text
GET http://localhost:3000/episode/:id
```

The upstream Rick and Morty API is configured through the backend's `API`
environment variable. The default Docker value is
`https://rickandmortyapi.com/api`.

## Run the frontend individually

Start the backend first. Before running the frontend, create its environment
file by copying the example:

```bash
cd frontend
cp .env.example .env
```

On PowerShell:

```powershell
cd frontend
Copy-Item .env.example .env
```

Then install dependencies and run the app:

```bash
flutter pub get
flutter run -d chrome \
  --dart-define=BACKEND_URL=http://localhost:3000
```

The frontend `.env` is versioned because it currently contains only the local
backend URL; do not put secrets in it.

Run on a connected device or emulator:

```bash
flutter run --dart-define=BACKEND_URL=http://localhost:3000
```

Find available targets with:

```bash
flutter devices
```

When using Android Emulator, the host machine is usually available at
`http://10.0.2.2:3000` instead of `localhost`. A physical device must use a
backend address reachable over the local network.

Build the frontend individually:

```bash
cd frontend
flutter build web --release \
  --dart-define=BACKEND_URL=http://localhost:3000
flutter build apk --dart-define=BACKEND_URL=http://localhost:3000
```

The frontend also has its own `Dockerfile`, so it can be built independently:

```bash
cd frontend
docker build \
  --build-arg BACKEND_URL=http://localhost:3000 \
  -t rick-morty-explorer-frontend .
docker run --rm -p 8080:80 rick-morty-explorer-frontend
```

## Tests and analysis

```bash
cd frontend
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

If a Web asset returns HTTP 404 after changing an image, stop the old server
and rebuild the frontend bundle. For Docker, run `docker compose build
--no-cache` and then `docker compose up`. If the browser still serves stale
files, perform a hard refresh.
