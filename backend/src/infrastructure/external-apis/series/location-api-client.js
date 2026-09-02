const { ExternalApiError, asExternalApiError } = require('./external-api-error');

class LocationApiClient {
  async findLocation(url) {
    try {
      if (!url) return { name: 'Unknown', type: 'Unknown', dimension: 'Unknown' };
      const response = await fetch(url);
      if (!response.ok) {
        throw new ExternalApiError('location', response.status, `Location request failed with status ${response.status}`);
      }
      const location = await response.json();
      return { name: location.name || 'Unknown', type: location.type || 'Unknown', dimension: location.dimension || 'Unknown' };
    } catch (error) {
      throw asExternalApiError('location', error);
    }
  }
}
module.exports = { LocationApiClient };
