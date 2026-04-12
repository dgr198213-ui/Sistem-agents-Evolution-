import unittest
import ../src/core/evolution_core, ../src/agents/neuro_agent, ../src/core/agent_base

suite "Evolution Core Tests":
  test "Population Creation":
    let pop = newPopulation[NeuroAgent]()
    check(pop.individuals.len == 0)
    check(pop.generation == 0)

  test "Tournament Selection":
    var pop = newPopulation[NeuroAgent]()
    for i in 0..<10:
      let agent = newNeuroAgent(i, 2, 1)
      agent.state.fitness = i.float
      pop.individuals.add(agent)

    let winner = tournamentSelection(pop, 3)
    check(winner != nil)
    check(winner.state.fitness >= 0.0)
