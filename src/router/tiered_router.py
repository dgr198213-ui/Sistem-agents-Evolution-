import os
from typing import List, Dict
from litellm import Router
from .complexity_classifier import ComplexityTier

class TieredLiteLLMRouter:
    """
    LiteLLM Router with tier-aware configuration.
    """

    def __init__(self):
        self.router = self._build_router()

    def _build_router(self) -> Router:
        """Builds router with free-tier models as primary options."""

        model_list = [
            # TIER 3: SIMPLE (Groq, OpenRouter Free)
            {
                "model_name": "tier3-primary",
                "litellm_params": {
                    "model": "groq/llama-3.3-70b-versatile",
                    "api_key": os.getenv("GROQ_API_KEY"),
                },
                "rpm": 30,
            },
            {
                "model_name": "tier3-fallback",
                "litellm_params": {
                    "model": "openrouter/meta-llama/llama-3.3-70b-instruct:free",
                    "api_key": os.getenv("OPENROUTER_API_KEY"),
                },
                "rpm": 20,
            },

            # TIER 2: BALANCED (Gemini Flash, Cerebras)
            {
                "model_name": "tier2-primary",
                "litellm_params": {
                    "model": "gemini/gemini-2.0-flash-exp",
                    "api_key": os.getenv("GOOGLE_API_KEY"),
                },
                "rpm": 15,
            },
            {
                "model_name": "tier2-fallback",
                "litellm_params": {
                    "model": "cerebras/llama3.1-70b",
                    "api_key": os.getenv("CEREBRAS_API_KEY"),
                },
                "rpm": 30,
            },

            # TIER 1: COMPLEX (Gemini, DeepSeek)
            {
                "model_name": "tier1-primary",
                "litellm_params": {
                    "model": "gemini/gemini-1.5-pro",
                    "api_key": os.getenv("GOOGLE_API_KEY"),
                },
                "rpm": 15,
            },
            {
                "model_name": "tier1-fallback",
                "litellm_params": {
                    "model": "deepseek/deepseek-chat",
                    "api_key": os.getenv("DEEPSEEK_API_KEY"),
                },
                "rpm": 60,
            },
        ]

        return Router(
            model_list=model_list,
            routing_strategy="simple-shuffle",
            fallbacks=[
                {"tier3-primary": ["tier3-fallback", "tier2-primary"]},
                {"tier2-primary": ["tier2-fallback", "tier1-primary"]},
                {"tier1-primary": ["tier1-fallback"]},
            ],
            num_retries=3,
        )

    def route_by_tier(self, tier: ComplexityTier, messages: List[Dict], **kwargs) -> Dict:
        """Routes request based on the identified complexity tier."""
        tier_models = {
            ComplexityTier.SIMPLE: "tier3-primary",
            ComplexityTier.BALANCED: "tier2-primary",
            ComplexityTier.COMPLEX: "tier1-primary",
        }

        model = tier_models[tier]
        return self.router.completion(model=model, messages=messages, **kwargs)
