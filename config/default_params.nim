import ../src/core/agent_base

proc getDefaultParams*(): EvolutionParams =
  EvolutionParams(
    populationSize: 50,
    mutationRate: 0.1,
    crossoverRate: 0.7,
    eliteSize: 5,
    maxGenerations: 100,
    tournamentSize: 3
  )
