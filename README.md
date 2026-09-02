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

O frontend será conectado ao backend nas próximas etapas.
