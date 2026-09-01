class GetEpisode {
  constructor(episodeRepository) {
    this.episodeRepository = episodeRepository;
  }

  async execute(episodeId) {
    const episode = await this.episodeRepository.findEpisode(episodeId);

    return {
      id: episode.id,
      characters: episode.characters
    };
  }
}

module.exports = { GetEpisode };
