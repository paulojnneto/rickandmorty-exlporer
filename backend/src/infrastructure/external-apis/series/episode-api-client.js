const { ExternalApiError, asExternalApiError } = require('./external-api-error');

class EpisodeApiClient {
  async findEpisode(episodeId) {
    try {
      if (!process.env.API) {
        throw new Error('The API variable is not configured');
      }

      const endpoint = `${process.env.API.replace(/\/+$/, '')}/episode/${episodeId}`;
      const response = await fetch(endpoint);

      if (!response.ok) {
        throw new ExternalApiError('episode', response.status, `Episode request failed with status ${response.status}`);
      }

      return response.json();
    } catch (error) {
      throw asExternalApiError('episode', error);
    }
  }
}

module.exports = { EpisodeApiClient };
