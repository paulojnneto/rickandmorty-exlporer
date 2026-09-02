# Rick and Morty App

Monorepo com frontend Flutter e backend Node.js. As duas aplicações são independentes e não compartilham pacotes.

## Estrutura

```text
backend/   # API Node.js organizada em camadas DDD
frontend/  # Aplicação Flutter
```

## Backend

```bash
cd backend
npm start
```

O backend usa a porta `3000` e expõe `GET /episode/:id`.

## Frontend

```bash
cd frontend
flutter pub get
flutter run
```

O frontend usa `http://localhost:3000` por padrão. Para execução local, é possível alterar a URL com `--dart-define=BACKEND_URL=...`.

## Docker

Suba os dois serviços com:

```bash
docker compose up --build
```

Depois, acesse o frontend em http://localhost:8080 e o backend em http://localhost:3000. O backend consulta a API externa usando `API`; o navegador conversa somente com o backend. Para trocar a URL usada no build do frontend, use `BACKEND_URL`, por exemplo: `BACKEND_URL=http://localhost:3000 docker compose up --build`.

## Testes e análise

```bash
cd frontend
flutter analyze
flutter test
```
