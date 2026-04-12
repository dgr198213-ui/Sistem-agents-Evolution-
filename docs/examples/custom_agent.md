# Creating a Custom Agent

To create a custom agent, follow these steps:

```nim
type MyAgent = ref object of NeuroAgent

method sense(agent: MyAgent, env: Environment): seq[float] =
  # ... implementation ...
```
