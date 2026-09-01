const http = require('node:http');

const port = Number(process.env.PORT) || 3000;

const server = http.createServer((request, response) => {
  response.setHeader('Content-Type', 'application/json; charset=utf-8');

  if (request.method === 'GET' && request.url === '/health') {
    response.writeHead(200);
    response.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  if (request.method === 'GET' && request.url === '/') {
    response.writeHead(200);
    response.end(JSON.stringify({ message: 'Backend Node.js funcionando' }));
    return;
  }

  response.writeHead(404);
  response.end(JSON.stringify({ error: 'Rota não encontrada' }));
});

server.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
