import ../utils/vector_ops

type
  # Agent state representation
  AgentState* = object
    position*: Vector2D
    velocity*: Vector2D
    energy*: float
    age*: int
    fitness*: float

  # Genome representation for evolution
  Genome*[T] = object
    genes*: seq[T]
    fitness*: float
    id*: int
    generation*: int

  # Neural network weights genome
  NeuralGenome* = Genome[float]

  # Behavioral tree genome
  BehaviorGenome* = Genome[string]

  # Base agent interface
  Agent* = ref object of RootObj
    id*: int
    state*: AgentState
    genome*: NeuralGenome

  # Environment interface
  Environment* = ref object of RootObj
    width*, height*: float
    agents*: seq[Agent]
    time*: int

  # Evolution parameters
  EvolutionParams* = object
    populationSize*: int
    mutationRate*: float
    crossoverRate*: float
    eliteSize*: int
    maxGenerations*: int
    tournamentSize*: int
