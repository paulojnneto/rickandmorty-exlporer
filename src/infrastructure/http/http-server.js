const http = require('node:http');
const { EpisodeApiClient } = require('../external-apis/series/episode-api-client');
const { GetEpisode } = require('../../application/use-cases/get-episode');
const { EpisodeController } = require('./controllers/episode-controller');

const getEpisode = new GetEpisode(new EpisodeApiClient());
const episodeController = new EpisodeController(getEpisode);

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8'
  });
  response.end(JSON.stringify(payload));
}

function createHttpServer() {
  return http.createServer((request, response) => {
    const requestUrl = new URL(request.url, 'http://localhost');

    if (request.method === 'GET' && request.url === '/') {
      sendJson(response, 200, { message: 'Backend Node.js funcionando' });
      return;
    }

    if (request.method === 'GET' && request.url === '/health') {
      sendJson(response, 200, { status: 'ok' });
      return;
    }

    if (request.method === 'GET' && requestUrl.pathname === '/episode') {
      episodeController.handle(response).catch((error) => {
        console.error(error);
        sendJson(response, 502, { error: 'Não foi possível consultar a API externa' });
      });
      return;
    }

    sendJson(response, 404, { error: 'Rota não encontrada' });
  });
}

module.exports = { createHttpServer };
