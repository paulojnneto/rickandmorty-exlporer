class EpisodeApiClient {
  async findEpisode(episodeId) {
    if (!process.env.API) {
      throw new Error('The API variable is not configured');
    }

    const endpoint = `${process.env.API.replace(/\/+$/, '')}/episode/${episodeId}`;
    const response = await fetch(endpoint);

    if (!response.ok) {
      throw new Error(`A API externa respondeu com status ${response.status}`);
    }

    return response.json();
  }
}

module.exports = { EpisodeApiClient };
