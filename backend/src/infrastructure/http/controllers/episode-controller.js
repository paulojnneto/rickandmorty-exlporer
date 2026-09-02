class EpisodeController {
  constructor(getEpisode) {
    this.getEpisode = getEpisode;
  }

  async handle(response, episodeId) {
    const episode = await this.getEpisode.execute(episodeId);

    response.writeHead(200, {
      'Content-Type': 'application/json; charset=utf-8',
      'Access-Control-Allow-Origin': '*'
    });
    response.end(JSON.stringify(episode));
  }
}

module.exports = { EpisodeController };
