class CharacterApiClient {
  async findCharacters(characterIds) {
    if (!process.env.API) {
      throw new Error('The API variable is not configured');
    }

    if (characterIds.length === 0) {
      return [];
    }

    const endpoint = `${process.env.API.replace(/\/+$/, '')}/character/${characterIds.join(',')}`;
    const response = await fetch(endpoint);

    if (!response.ok) {
      throw new Error(`A API externa respondeu com status ${response.status}`);
    }

    const characters = await response.json();
    return Array.isArray(characters) ? characters : [characters];
  }
}

module.exports = { CharacterApiClient };
