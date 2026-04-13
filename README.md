# Evolutionary Agents in Nim 🧬

A comprehensive framework for evolutionary computation and multi-agent systems implemented in Nim, now featuring a **Meta-Router Architecture** for high-level decision making.

## 📚 Overview

This framework provides modular, efficient implementations of:

- **Meta-Router Architecture**: Intelligent semantic routing for high-level agent decision making.
- **Neuroevolution**: NEAT-inspired neural network evolution.
- **Swarm Intelligence**: Flocking, foraging, collective behavior.
- **Coevolutionary Systems**: Predator-prey, competitive evolution.
- **Generic Evolutionary Algorithms**: Selection, crossover, mutation.

---

## 🏗️ Architecture

### Core Modules

```
evolutionary_agents/
├── src/
│   ├── core/
│   │   ├── agent_base.nim      # Base types and interfaces (now with 'think')
│   │   ├── types.nim           # Shared types
│   │   └── evolution_core.nim  # EA operations
│   ├── agents/
│   │   ├── neuro_agent.nim     # Neuroevolutionary agents
│   │   ├── swarm_agent.nim     # Swarm agents
│   │   └── coevo_agent.nim     # Coevolutionary agents
│   ├── utils/
│   │   ├── vector_ops.nim      # 2D vector math
│   │   └── router_client.nim   # Meta-Router API client
│   └── router/                 # Meta-Router (Python/FastAPI)
│       ├── api_service.py
│       ├── meta_router.py
│       └── tiered_router.py
└── examples/                   # Demos
```

---

## 🚀 Quick Start

### 1. Start the Meta-Router (Optional but recommended)
Requires Python 3.9+ and API keys in `.env`.
```bash
make run-router
```

### 2. Run Nim Examples
```bash
# Foraging example
nim c -r examples/foraging/example_foraging.nim
```

---

## 🤖 Meta-Router Architecture

Agents can now perform high-level reasoning using the `think` method:

```nim
let strategy = agent.think("The environment has high competition for food. What should I do?")
echo strategy
```

The Meta-Router automatically classifies query complexity and routes to the most efficient model tier (Free models from Groq, Gemini, DeepSeek, etc.).

---

## 🧪 Key Features
... (Rest of original content)
