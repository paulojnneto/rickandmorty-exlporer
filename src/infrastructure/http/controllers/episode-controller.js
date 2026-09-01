class EpisodeController {
  constructor(getEpisode) {
    this.getEpisode = getEpisode;
  }

  async handle(response) {
    const episode = await this.getEpisode.execute();

    response.writeHead(200, {
      'Content-Type': 'application/json; charset=utf-8'
    });
    response.end(JSON.stringify(episode));
  }
}

module.exports = { EpisodeController };
