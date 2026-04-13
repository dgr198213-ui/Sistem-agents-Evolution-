# Meta-Router Implementation Guide

## Architecture

The Meta-Router is a hybrid system that combines semantic analysis with tiered LLM routing.

### 1. Complexity Classifier
Located in `src/router/complexity_classifier.py`, it uses heuristics and semantic analysis to categorize queries into:
- **SIMPLE**: Factual Q&A, definitions.
- **BALANCED**: Analysis, medium reasoning.
- **COMPLEX**: Deep analysis, code generation, strategy.

### 2. Tiered Router
Located in `src/router/tiered_router.py`, it uses **LiteLLM** to manage a collection of models:
- **Tier 3 (Simple)**: Llama 3 on Groq or OpenRouter.
- **Tier 2 (Balanced)**: Gemini 2.0 Flash.
- **Tier 1 (Complex)**: Gemini 1.5 Pro or DeepSeek.

### 3. API Service
Exposes the router via FastAPI (`src/router/api_service.py`) at `http://localhost:8000/v1/chat`.

## Integration with Nim

Agents use `src/utils/router_client.nim` to communicate with the Python service. The `Agent` base class provides a `think` method as a standard interface for this interaction.

## Setup

1. Copy `.env.example` to `.env`.
2. Add your API keys.
3. Install Python dependencies: `pip install -r requirements.txt`.
4. Run with `make run-router`.
