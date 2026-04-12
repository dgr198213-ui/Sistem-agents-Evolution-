import ../../src/core/agent_base

proc getSwarmConfig*(): EvolutionParams =
  EvolutionParams(
    populationSize: 40,
    mutationRate: 0.05,
    crossoverRate: 0.0, # Not used for boids
    eliteSize: 0,
    maxGenerations: 1,
    tournamentSize: 0
  )
