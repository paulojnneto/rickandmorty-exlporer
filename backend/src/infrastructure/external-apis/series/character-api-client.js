const { LocationApiClient } = require('./location-api-client');
const { ExternalApiError, asExternalApiError } = require('./external-api-error');

class CharacterApiClient {
  constructor(locationApiClient = new LocationApiClient()) {
    this.locationApiClient = locationApiClient;
  }

  async findCharacters(characterIds) {
    try {
      if (!process.env.API) {
        throw new Error('The API variable is not configured');
      }

      if (characterIds.length === 0) {
        return [];
      }

      const endpoint = `${process.env.API.replace(/\/+$/, '')}/character/${characterIds.join(',')}`;
      const response = await fetch(endpoint);

      if (!response.ok) {
        throw new ExternalApiError('character', response.status, `Character request failed with status ${response.status}`);
      }

      const characters = await response.json();
      const characterList = Array.isArray(characters) ? characters : [characters];
      const locationCache = new Map();
      const getLocation = async (location) => {
        const url = location?.url;
        if (!url) return this.locationApiClient.findLocation(null);
        if (!locationCache.has(url)) locationCache.set(url, this.locationApiClient.findLocation(url));
        return locationCache.get(url);
      };
      return Promise.all(characterList.map(async (character) => ({
        ...character,
        origin: await getLocation(character.origin),
        location: await getLocation(character.location)
      })));
    } catch (error) {
      throw asExternalApiError('character', error);
    }
  }
}

module.exports = { CharacterApiClient };
