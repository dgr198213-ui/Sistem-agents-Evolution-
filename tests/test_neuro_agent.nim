import unittest, sequtils
import ../src/agents/neuro_agent

suite "Neuro Agent Tests":
  test "Neural Network Activation":
    let nn = newNeuralNetwork(2, 1)
    let inputs = @[1.0, -1.0]
    let outputs = nn.activate(inputs)
    check(outputs.len == 1)
    check(outputs[0] >= -1.0 and outputs[0] <= 1.0)

  test "Mutation (Weights)":
    let nn = newNeuralNetwork(2, 1)
    let originalWeights = nn.connections.mapIt(it.weight)
    mutateWeights(nn, 1.0) # Mutate all
    let newWeights = nn.connections.mapIt(it.weight)
    check(originalWeights != newWeights)
