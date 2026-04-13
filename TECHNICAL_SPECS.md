# 🎯 Especificaciones Técnicas: Agentes Evolutivos

## Índice
1. [Visión General](#visión-general)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Especificaciones de Módulos](#especificaciones-de-módulos)
4. [Algoritmos Implementados](#algoritmos-implementados)
5. [Parámetros y Configuración](#parámetros-y-configuración)
6. [Casos de Uso Avanzados](#casos-de-uso-avanzados)

---

## Meta-Router Architecture

El sistema integra un enrutador inteligente basado en Python que permite a los agentes realizar razonamiento de alto nivel mediante el método `think`. Este enrutador clasifica la complejidad de las consultas y las deriva a diferentes tiers de modelos (Simple, Balanced, Complex) utilizando LiteLLM.

## Visión General

### Objetivo del Framework

Proporcionar una plataforma modular y eficiente para:
- Evolución de redes neuronales (neuroevolución)
- Comportamientos colectivos emergentes
- Coevolución competitiva y cooperativa
- Investigación en inteligencia artificial evolutiva

### Características Principales

| Característica | Descripción | Estado |
|----------------|-------------|--------|
| Neuroevolución | NEAT-inspired, topología + pesos | ✅ Implementado |
| Enjambre | Flocking, foraging, roles | ✅ Implementado |
| Coevolución | Predator-prey, competición | ✅ Implementado |
| Especiación | Preservación de diversidad | ✅ Implementado |
| Operadores GA | Selección, cruce, mutación | ✅ Implementado |
| Visualización | Rendering en tiempo real | ⏳ Futuro |
| Paralelización | Multi-threaded evolution | ⏳ Futuro |

---

## Arquitectura del Sistema

### Jerarquía de Tipos

```
┌─────────────────────────────────────────┐
│           Environment                    │
│  (width, height, agents, time)          │
└─────────────────────────────────────────┘
                    │
                    │ contiene
                    ▼
        ┌──────────────────────┐
        │      Agent           │
        │  (id, state, genome) │
        └──────────────────────┘
                    │
        ┌───────────┴───────────┬──────────┐
        ▼                       ▼          ▼
  NeuroAgent            SwarmAgent    CoevoAgent
  • network          • role          • coevoType
  • species          • behavior      • health
                     • neighbors     • attacks
```

### Flujo de Datos

```
Inicialización
    │
    ▼
┌─────────────────┐
│ Crear Población │
└─────────────────┘
    │
    ▼
┌─────────────────────┐
│ Loop Generacional   │◄──────┐
├─────────────────────┤       │
│ 1. Evaluar Fitness  │       │
│ 2. Selección        │       │
│ 3. Reproducción     │       │
│ 4. Mutación         │       │
│ 5. Reemplazo        │       │
└─────────────────────┘       │
    │                         │
    │ ¿Converge?              │
    │    No ──────────────────┘
    │    Sí
    ▼
┌─────────────────┐
│ Mejor Solución  │
└─────────────────┘
```

---

## Especificaciones de Módulos

### 1. agent_base.nim

**Propósito**: Tipos y utilidades fundamentales

#### Tipos Principales

```nim
type Vector2D = object
  x, y: float
```
- Operaciones: `+`, `-`, `*`, `magnitude()`, `normalize()`, `distance()`

```nim
type AgentState = object
  position: Vector2D
  velocity: Vector2D
  energy: float
  age: int
  fitness: float
```

```nim
type Agent = ref object of RootObj
  id: int
  state: AgentState
  genome: NeuralGenome
```

#### Métodos Polimórficos

| Método | Firma | Descripción |
|--------|-------|-------------|
| `update` | `(agent, env, dt)` | Actualiza estado del agente |
| `sense` | `(agent, env) -> seq[float]` | Lee sensores |
| `act` | `(agent, outputs, env)` | Ejecuta acciones |
| `evaluateFitness` | `(agent, env) -> float` | Calcula aptitud |

---

### 2. neuro_agent.nim

**Propósito**: Agentes con control por redes neuronales evolutivas

#### Estructura de Red Neural

```nim
type NeuralNetwork = ref object
  nodes: seq[NeuralNode]           # Nodos (input/hidden/output)
  connections: seq[Connection]      # Conexiones con pesos
  nextNodeId: int                  # Contador para nuevos nodos
  innovationNumber: int            # Número de innovación global
```

#### Conexiones

```nim
type Connection = object
  fromNode: int        # ID nodo origen
  toNode: int          # ID nodo destino
  weight: float        # Peso de conexión
  enabled: bool        # ¿Activa?
  innovation: int      # Número de innovación único
```

#### Operadores de Mutación

##### mutateWeights()
- **Frecuencia**: 90% perturbación, 10% aleatorización total
- **Rango**: weights ∈ [-5.0, 5.0]
- **Fuerza de perturbación**: ±0.3 por defecto

##### mutateAddNode()
```
Antes:     A ───w──→ B
           
Después:   A ──1.0→ [N] ──w→ B
```
- Desactiva conexión original
- Crea nodo oculto N
- Primera conexión: peso 1.0
- Segunda conexión: peso original

##### mutateAddConnection()
- Máximo 20 intentos
- Evita auto-conexiones
- Evita conexiones redundantes
- Peso inicial: random ∈ [-2.0, 2.0]

#### Forward Pass

```
Para cada conexión activa:
  valor[destino] += valor[origen] * peso

Para nodos de salida:
  valor[salida] = tanh(valor + bias)
```

---

### 3. swarm_agent.nim

**Propósito**: Comportamientos colectivos emergentes

#### Roles de Enjambre

| Rol | Características | Comportamiento |
|-----|----------------|----------------|
| `srScout` | Explorador | Busca nuevas áreas |
| `srWorker` | Trabajador | Recolecta recursos |
| `srGuard` | Guardia | Defiende territorio |
| `srQueen` | Reina | Permanece en base |

#### Comportamientos

##### Flocking (Reynolds' Boids)

```nim
# Cohesión: moverse hacia centro del grupo
cohesion = (avg_neighbor_pos - my_pos).normalize()

# Separación: evitar colisiones
separation = sum((my_pos - neighbor_pos).normalize() / distance)

# Alineación: igualar velocidad
alignment = (avg_neighbor_vel).normalize()

# Fuerza resultante
force = 1.0*cohesion + 1.5*separation + 1.0*alignment
```

##### Foraging

```
Estado: SIN_CARGA
  ├─ Buscar recurso más cercano
  ├─ Moverse hacia recurso
  └─ Si distancia < 3.0:
      └─ Recoger recurso → estado = CON_CARGA

Estado: CON_CARGA
  ├─ Moverse hacia nido
  └─ Si distancia < 5.0:
      └─ Depositar → estado = SIN_CARGA
```

#### Detección de Vecinos

```nim
proc updateNeighbors(agent, env, radius):
  for other in env.agents:
    if distance(agent.pos, other.pos) < radius:
      agent.neighbors.add(other.id)
```
- Radio por defecto: 30.0 unidades
- Complejidad: O(n²) - mejorable con spatial hashing

---

### 4. coevo_agent.nim

**Propósito**: Evolución competitiva entre especies

#### Tipos Coevolutivos

```nim
type CoevoType = enum
  ctPredator    # Cazador
  ctPrey        # Presa
  ctCompetitor  # Competidor simétrico
```

#### Atributos Específicos

| Tipo | Attack | Defense | Speed | Sensor Range |
|------|--------|---------|-------|--------------|
| Predator | 5-15 | 1-5 | 4.0 | 50-100 |
| Prey | 1-3 | 5-15 | 5.0 | 40-80 |

#### Sistema de Combate

```nim
proc combat(predator, prey):
  attackRoll = rand(predator.attackPower)
  defenseRoll = rand(prey.defenseRating)
  
  if attackRoll > defenseRoll:
    # Éxito del predator
    prey.health -= 30.0
    predator.fitness += 50.0
    predator.kills += 1
  else:
    # Presa escapa
    prey.fitness += 20.0
    prey.escapes += 1
```

#### Funciones de Fitness

**Predator:**
```
fitness = kills × 100 + health × 0.5 - age × 0.01
```

**Prey:**
```
fitness = age × 0.5 + escapes × 50 + health × 0.3
```

---

### 5. evolution_core.nim

**Propósito**: Operadores evolutivos genéricos

#### Métodos de Selección

##### Tournament Selection
```nim
1. Seleccionar k individuos aleatorios
2. Retornar el de mayor fitness
```
- Parámetro: tournament size (k)
- Presión selectiva ajustable
- Complejidad: O(k)

##### Roulette Selection
```nim
1. Calcular suma total de fitness
2. Generar número aleatorio [0, total]
3. Recorrer acumulando fitness hasta superar random
```
- Fitness proporcional
- Requiere fitness positivo
- Complejidad: O(n)

##### Rank Selection
```nim
1. Ordenar población por fitness
2. Asignar probabilidad basada en rango
3. Seleccionar según probabilidad
```
- No requiere fitness positivo
- Reduce presión selectiva
- Complejidad: O(n log n)

#### Crossover NEAT-style

```nim
1. Alinear conexiones por innovation number
2. Para genes coincidentes: elegir de parent1 o parent2
3. Genes disjoint/excess: heredar de parent más apto
4. Heredar nodos del parent más apto
```

#### Especiación

```nim
compatibilityDistance = 
  c1 × (excess / N) + 
  c2 × (disjoint / N) + 
  c3 × avgWeightDiff
```

Parámetros típicos:
- c1 = 1.0 (excess penalty)
- c2 = 1.0 (disjoint penalty)
- c3 = 0.4 (weight difference)
- Threshold = 3.0

---

## Algoritmos Implementados

### NEAT (NeuroEvolution of Augmenting Topologies)

**Características:**
1. ✅ Evolución de topología y pesos simultánea
2. ✅ Innovation numbers para crossover histórico
3. ✅ Mutaciones estructurales (add node/connection)
4. ✅ Especiación para proteger innovación
5. ⏳ Compartir fitness dentro de especies (futuro)
6. ⏳ Interspecies mating (futuro)

### Reynolds' Boids

**Tres reglas fundamentales:**
1. **Cohesión**: Moverse hacia centro del grupo local
2. **Separación**: Evitar colisiones con vecinos
3. **Alineación**: Igualar velocidad con vecinos

**Implementación:**
- Radio de detección: 30.0 unidades
- Pesos: cohesion=1.0, separation=1.5, alignment=1.0

### Algoritmo Genético Estándar

```
1. Inicializar población aleatoria
2. MIENTRAS no converge:
   a. Evaluar fitness de todos
   b. Seleccionar padres (tournament/roulette/rank)
   c. Aplicar crossover (prob. 0.7)
   d. Aplicar mutación (prob. 0.3)
   e. Reemplazo generacional con elitismo
3. Retornar mejor individuo
```

---

## Parámetros y Configuración

### EvolutionParams

```nim
type EvolutionParams = object
  populationSize: int      # 20-100 típico
  mutationRate: float      # 0.1-0.5
  crossoverRate: float     # 0.6-0.9
  eliteSize: int           # 1-10% de población
  maxGenerations: int      # 50-1000
  tournamentSize: int      # 2-7
```

### Recomendaciones por Problema

| Problema | PopSize | MutRate | CrossRate | Elite | Generations |
|----------|---------|---------|-----------|-------|-------------|
| Foraging | 50 | 0.3 | 0.7 | 5 | 50-100 |
| Coevolución | 30 | 0.25 | 0.7 | 3 | 100-200 |
| Flocking | 40 | 0.2 | 0.6 | 4 | 30-50 |
| NEAT | 150 | 0.8* | 0.5 | 2 | 100-300 |

\* NEAT usa múltiples tipos de mutación

---

## Casos de Uso Avanzados

### 1. Evolución de Estrategias de Juego

```nim
type GameAgent = ref object of NeuroAgent
  score: int
  moves: seq[Move]

method evaluateFitness*(agent: GameAgent, env: Environment): float =
  # Jugar partida completa
  for round in 0..99:
    let move = selectMove(agent, gameState)
    applyMove(move)
  return agent.score.float
```

### 2. Optimización Multi-Objetivo

```nim
type MultiObjectiveAgent = ref object of Agent
  objectives: seq[float]  # [velocidad, eficiencia, robustez]

proc dominates(a, b: MultiObjectiveAgent): bool =
  # Dominancia de Pareto
  result = true
  for i in 0..<a.objectives.len:
    if a.objectives[i] < b.objectives[i]:
      return false
```

### 3. Transfer Learning entre Tareas

```nim
# Entrenar en tarea simple
let simpleEnv = newForagingEnv(width=200, foods=5)
let population = evolve(simpleEnv, 50)

# Transferir a tarea compleja
let complexEnv = newForagingEnv(width=400, foods=20)
for agent in population.individuals:
  agent.state.position = complexEnv.nest
  # Red neural mantiene conocimiento previo
```

### 4. Coevolución Cooperativa

```nim
# Dividir problema en subcomponentes
type CooperativeSystem = object
  sensors: Population[SensorAgent]
  motors: Population[MotorAgent]

proc evaluateCombination(sensor, motor):
  # Fitness combinada de ambos componentes
  fitness = performTask(sensor, motor)
  sensor.fitness += fitness
  motor.fitness += fitness
```

---

## Apéndice: Complejidades Computacionales

| Operación | Mejor Caso | Peor Caso | Promedio |
|-----------|-----------|-----------|----------|
| Forward pass | O(E) | O(E) | O(E) |
| Mutate weight | O(E) | O(E) | O(E) |
| Add node | O(1) | O(1) | O(1) |
| Add connection | O(1) | O(E) | O(E) |
| Crossover | O(E) | O(E) | O(E) |
| Tournament sel | O(k) | O(k) | O(k) |
| Roulette sel | O(n) | O(n) | O(n) |
| Speciation | O(n×s×E) | O(n×s×E) | O(n×s×E) |
| Full generation | O(n×E×T) | O(n×E×T) | O(n×E×T) |

Donde:
- E = conexiones en red
- n = tamaño población
- k = tamaño torneo
- s = número de especies
- T = timesteps de simulación

---

**Versión**: 1.0  
**Última actualización**: 2026-04  
**Autor**: Sistema de Agentes Evolutivos Nim
