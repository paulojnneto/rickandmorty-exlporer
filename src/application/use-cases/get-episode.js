class GetEpisode {
  constructor(episodeRepository, characterRepository) {
    this.episodeRepository = episodeRepository;
    this.characterRepository = characterRepository;
  }

  async execute(episodeId) {
    const episode = await this.episodeRepository.findEpisode(episodeId);
    const characterIds = episode.characters
      .map((characterUrl) => characterUrl.match(/\/character\/(\d+)$/)?.[1])
      .filter(Boolean);

    const characters = await this.characterRepository.findCharacters(characterIds);

    return {
      id: episode.id,
      characters
    };
  }
}

module.exports = { GetEpisode };
