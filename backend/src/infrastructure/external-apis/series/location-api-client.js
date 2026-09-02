class LocationApiClient {
  async findLocation(url) {
    if (!url) return { name: 'Unknown', type: 'Unknown', dimension: 'Unknown' };
    const response = await fetch(url);
    if (!response.ok) throw new Error(`The external API responded with status ${response.status}`);
    const location = await response.json();
    return { name: location.name || 'Unknown', type: location.type || 'Unknown', dimension: location.dimension || 'Unknown' };
  }
}
module.exports = { LocationApiClient };
