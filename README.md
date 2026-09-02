# Rick and Morty App

Monorepo with a Flutter frontend and Node.js backend. The applications are independent and do not share packages.

## Estrutura

```text
backend/   # Node.js API organized in DDD-inspired layers
frontend/  # Flutter application
```

## Backend

```bash
cd backend
npm start
```

The backend uses port `3000` and exposes `GET /episode/:id`.

## Frontend

```bash
cd frontend
flutter pub get
flutter run
```

The frontend uses `http://localhost:3000` by default. For local execution, the URL can be changed with `--dart-define=BACKEND_URL=...`.

## Docker

Start both services with:

```bash
docker compose up --build
```

Then open the frontend at http://localhost:8080 and the backend at http://localhost:3000. The backend queries the external API using `API`; the browser communicates only with the backend. To change the URL used during the frontend build, set `BACKEND_URL`, for example: `BACKEND_URL=http://localhost:3000 docker compose up --build`.

### Docker development mode with hot reload

For Flutter hot reload while keeping the services in Docker, run:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

Open http://localhost:8080. The frontend source is mounted into the container; saving a Dart file triggers hot reload. The terminal remains interactive, so `r` performs a hot reload, `R` performs a hot restart, and `q` stops Flutter. Use `docker compose -f docker-compose.yml -f docker-compose.dev.yml down` to stop the services.

## Tests and analysis

```bash
cd frontend
flutter analyze
flutter test
```
