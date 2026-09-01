# Simple Node Backend

# Hello world
Backend Node.js mínimo usando apenas o módulo HTTP nativo e organizado em camadas inspiradas em DDD.

## Estrutura

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

O consumo da API pública fica isolado em `infrastructure/external-apis/series`, mantendo a camada de domínio independente do fornecedor externo.

## Configuração da API externa

Crie um arquivo `.env` com a URL base da API:

```env
PORT=3000
API=https://rickandmortyapi.com/api
```

O endpoint `GET /episode/:id` consulta `${API}/episode/:id` e retorna somente `id` e `characters` do episódio solicitado.

## Como executar

```bash
npm start
```

Para desenvolvimento, com reinício automático:

```bash
npm run dev
```

O servidor usa a porta `3000` por padrão. Para alterar, defina a variável `PORT`.

## Rotas

- `GET /` — mensagem de boas-vindas
- `GET /health` — status da aplicação
