import ../../src/core/agent_base

proc getForagingConfig*(): EvolutionParams =
  EvolutionParams(
    populationSize: 50,
    mutationRate: 0.3,
    crossoverRate: 0.7,
    eliteSize: 5,
    maxGenerations: 50,
    tournamentSize: 3
  )
