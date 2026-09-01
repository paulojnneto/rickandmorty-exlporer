# Simple Node Backend

Backend Node.js mínimo usando apenas o módulo HTTP nativo.

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
