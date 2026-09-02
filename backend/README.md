# Simple Node Backend

Minimal Node.js HTTP API for the Rick and Morty Explorer. The backend uses
Node's built-in HTTP server and is organized in DDD-inspired layers.

## Prerequisites

- Node.js 22 or newer is recommended. The Docker image uses Node.js 22.
- npm, included with Node.js.
- Internet access to the upstream Rick and Morty API.

## Project structure

```text
src/
├── domain/                 # Regras e conceitos centrais do domínio
│   ├── entities/           # Entidades do seriado
│   ├── repositories/       # Contratos para persistência/consulta
│   └── services/           # Serviços de domínio
├── application/            # Casos de uso e DTOs
│   ├── use-cases/
│   └── dtos/
├── infrastructure/         # Detalhes externos e adaptadores
│   ├── config/
│   ├── external-apis/series/ # Cliente da API pública do seriado
│   └── http/
│       ├── controllers/
│       └── routes/
└── shared/                 # Recursos compartilhados
    └── errors/
```

The public API integration is isolated in
`infrastructure/external-apis/series`, keeping the domain layer independent
from the external provider.

## External API configuration

Create a `.env` file from the provided example:

```env
PORT=3000
API=https://rickandmortyapi.com/api
```

From the `backend` directory:

```bash
cp .env.example .env
```

On PowerShell:

```powershell
Copy-Item .env.example .env
```

The `GET /episode/:id` endpoint queries `${API}/episode/:id`, extracts the
character IDs, and then queries `${API}/character/:ids`. The response contains
the episode ID and the complete character data.

## Run locally

```bash
npm ci
npm start
```

For development, with automatic restart:

```bash
npm run dev
```

The server uses port `3000` by default. Set `PORT` to use another port.

## Routes

- `GET /` — mensagem de boas-vindas
- `GET /health` — status da aplicação
- `GET /episode/:id` — episode data and its characters

## Docker

Build and run the backend independently from this directory:

```bash
docker build -t rick-morty-explorer-backend .
docker run --rm --name rick-morty-backend \
  -e PORT=3000 \
  -e API=https://rickandmortyapi.com/api \
  -p 3000:3000 \
  rick-morty-explorer-backend
```

The root `docker-compose.yml` is the recommended way to run the backend
together with the frontend.
