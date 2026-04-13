import time
from typing import List, Dict, Optional
from .complexity_classifier import ComplexityClassifier, ComplexityTier, QueryClassification
from .tiered_router import TieredLiteLLMRouter

class MetaRouter:
    """
    Main orchestrator that combines complexity classification with tiered routing.
    """

    def __init__(self):
        self.classifier = ComplexityClassifier()
        self.router = TieredLiteLLMRouter()
        self.metrics = {
            "total_requests": 0,
            "tier_distribution": {tier.name: 0 for tier in ComplexityTier},
        }

    async def chat(self, messages: List[Dict], force_tier: Optional[ComplexityTier] = None, **kwargs) -> Dict:
        """
        Processes a chat request through the meta-router.
        """
        query = messages[-1]["content"] if messages else ""

        if force_tier:
            classification = QueryClassification(
                tier=force_tier,
                confidence=1.0,
                reasoning="Forced by user",
                estimated_tokens=0
            )
        else:
            classification = self.classifier.classify(query)

        start_time = time.time()
        try:
            response = self.router.route_by_tier(
                tier=classification.tier,
                messages=messages,
                **kwargs
            )

            latency = time.time() - start_time
            self.metrics["total_requests"] += 1
            self.metrics["tier_distribution"][classification.tier.name] += 1

            return {
                "response": response,
                "metadata": {
                    "tier": classification.tier.name,
                    "confidence": classification.confidence,
                    "reasoning": classification.reasoning,
                    "latency_ms": int(latency * 1000),
                    "model_used": response.get("model", "unknown"),
                }
            }
        except Exception as e:
            return {
                "error": str(e),
                "metadata": {
                    "tier": classification.tier.name,
                    "failed": True
                }
            }

    def get_metrics(self) -> Dict:
        """Returns collected routing metrics."""
        return self.metrics
