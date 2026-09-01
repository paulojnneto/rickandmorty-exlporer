const http = require('node:http');

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8'
  });
  response.end(JSON.stringify(payload));
}

function createHttpServer() {
  return http.createServer((request, response) => {
    if (request.method === 'GET' && request.url === '/') {
      sendJson(response, 200, { message: 'Backend Node.js funcionando' });
      return;
    }

    if (request.method === 'GET' && request.url === '/health') {
      sendJson(response, 200, { status: 'ok' });
      return;
    }

    sendJson(response, 404, { error: 'Rota não encontrada' });
  });
}

module.exports = { createHttpServer };
