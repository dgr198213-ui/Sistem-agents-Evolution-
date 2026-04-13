# ============================================================================
# Agent Base Module - Core abstractions for evolutionary agents
# ============================================================================
# Defines base types and interfaces for all evolutionary agent systems

import random, sequtils, algorithm, math, json
import types, ../utils/vector_ops, ../utils/router_client

# ============================================================================
# Genome Operations
# ============================================================================

proc newGenome*[T](size: int, generation: int = 0): Genome[T] =
  result.genes = newSeq[T](size)
  result.fitness = 0.0
  result.generation = generation
  result.id = rand(1_000_000)

proc clone*[T](g: Genome[T]): Genome[T] =
  result = g
  result.genes = g.genes
  result.id = rand(1_000_000)

# ============================================================================
# Agent Methods
# ============================================================================

method update*(agent: Agent, env: Environment, dt: float) {.base.} =
  ## Update agent state - to be overridden by specific agent types
  discard

method sense*(agent: Agent, env: Environment): seq[float] {.base.} =
  ## Sense environment - to be overridden
  result = @[]

method act*(agent: Agent, outputs: seq[float], env: Environment) {.base.} =
  ## Perform action based on neural network outputs
  discard

method evaluateFitness*(agent: Agent, env: Environment): float {.base.} =
  ## Calculate fitness score
  result = agent.state.fitness

method think*(agent: Agent, prompt: string, tier: string = ""): string {.base.} =
  ## Use Meta-Router for high-level decision making
  let messages = %*[
    {"role": "system", "content": "You are an evolutionary agent. Analyze the situation and decide on a strategy."},
    {"role": "user", "content": prompt}
  ]
  try:
    let response = callMetaRouter(messages, tier)
    result = response.content
  except:
    result = "Error calling Meta-Router"

# ============================================================================
# Utility Functions
# ============================================================================

proc clamp*(value, minVal, maxVal: float): float =
  max(minVal, min(maxVal, value))

proc randomFloat*(minVal, maxVal: float): float =
  rand(maxVal - minVal) + minVal

proc randomVector2D*(width, height: float): Vector2D =
  Vector2D(x: rand(width), y: rand(height))

proc wrapAround*(pos: var Vector2D, width, height: float) =
  ## Wrap position around boundaries (toroidal topology)
  if pos.x < 0: pos.x += width
  if pos.x > width: pos.x -= width
  if pos.y < 0: pos.y += height
  if pos.y > height: pos.y -= height

# ============================================================================
# Export all symbols
# ============================================================================

export types, vector_ops
export newGenome, clone
export update, sense, act, evaluateFitness, think
export clamp, randomFloat, randomVector2D, wrapAround
