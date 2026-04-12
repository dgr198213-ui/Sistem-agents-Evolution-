import ../../src/core/agent_base

proc getCoevoConfig*(): EvolutionParams =
  EvolutionParams(
    populationSize: 30,
    mutationRate: 0.25,
    crossoverRate: 0.7,
    eliteSize: 3,
    maxGenerations: 100,
    tournamentSize: 3
  )
