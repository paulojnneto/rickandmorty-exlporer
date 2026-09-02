const http = require('node:http');
const { EpisodeApiClient } = require('../external-apis/series/episode-api-client');
const { CharacterApiClient } = require('../external-apis/series/character-api-client');
const { GetEpisode } = require('../../application/use-cases/get-episode');
const { EpisodeController } = require('./controllers/episode-controller');

const getEpisode = new GetEpisode(new EpisodeApiClient(), new CharacterApiClient());
const episodeController = new EpisodeController(getEpisode);

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  });
  response.end(JSON.stringify(payload));
}

function createHttpServer() {
  return http.createServer((request, response) => {
    if (request.method === 'OPTIONS') {
      response.writeHead(204, {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type'
      });
      response.end();
      return;
    }
    const requestUrl = new URL(request.url, 'http://localhost');

    if (request.method === 'GET' && request.url === '/') {
      sendJson(response, 200, { message: 'Backend Node.js funcionando' });
      return;
    }

    if (request.method === 'GET' && request.url === '/health') {
      sendJson(response, 200, { status: 'ok' });
      return;
    }

    const episodeMatch = requestUrl.pathname.match(/^\/episode\/(\d+)$/);

    if (request.method === 'GET' && episodeMatch) {
      episodeController.handle(response, Number(episodeMatch[1])).catch((error) => {
        console.error(error);
        sendJson(response, 502, { error: 'Could not query the external API' });
      });
      return;
    }

    sendJson(response, 404, { error: 'Route not found' });
  });
}

module.exports = { createHttpServer };
