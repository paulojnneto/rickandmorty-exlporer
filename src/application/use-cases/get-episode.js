class GetEpisode {
  constructor(episodeRepository) {
    this.episodeRepository = episodeRepository;
  }

  async execute() {
    const response = await this.episodeRepository.findEpisode();

    const episodes = Array.isArray(response)
      ? response
      : Array.isArray(response.results)
        ? response.results
        : [response];

    return episodes.map(({ id, characters }) => ({ id, characters }));
  }
}

module.exports = { GetEpisode };
