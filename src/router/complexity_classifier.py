import hashlib
from enum import Enum
from dataclasses import dataclass

class ComplexityTier(Enum):
    """Complexity levels for queries"""
    SIMPLE = 1      # Facts, definitions, simple Q&A
    BALANCED = 2    # Analysis, comparisons, medium reasoning
    COMPLEX = 3     # Multi-step reasoning, creativity, deep analysis

@dataclass
class QueryClassification:
    """Result of query complexity classification"""
    tier: ComplexityTier
    confidence: float
    reasoning: str
    estimated_tokens: int

class ComplexityClassifier:
    """
    Classifies queries into complexity tiers using heuristics.
    Inspired by semantic analysis approaches.
    """

    SIMPLE_KEYWORDS = {
        "what is", "who is", "define", "meaning of", "when did",
        "where is", "how many", "list", "name", "how is", "find"
    }

    COMPLEX_KEYWORDS = {
        "analyze", "compare", "evaluate", "synthesize", "design",
        "create", "build", "optimize", "why", "explain deeply",
        "architecture", "strategy", "implement", "how to"
    }

    def __init__(self):
        self.cache = {}

    def classify(self, query: str) -> QueryClassification:
        """
        Classifies query into a complexity tier.
        """
        # Cache check
        cache_key = hashlib.md5(query.encode()).hexdigest()
        if cache_key in self.cache:
            return self.cache[cache_key]

        query_lower = query.lower()
        token_estimate = len(query.split())

        simple_score = sum(1 for kw in self.SIMPLE_KEYWORDS if kw in query_lower)
        complex_score = sum(1 for kw in self.COMPLEX_KEYWORDS if kw in query_lower)

        has_code = "```" in query or "def " in query or "class " in query
        has_multiple_questions = query.count("?") > 1

        if simple_score > 0 and complex_score == 0 and token_estimate < 50:
            tier = ComplexityTier.SIMPLE
            confidence = 0.9
            reasoning = "Simple factual query detected"
        elif complex_score > 0 or has_code or has_multiple_questions or token_estimate > 200:
            tier = ComplexityTier.COMPLEX
            confidence = 0.85
            reasoning = "Complex reasoning/creation task detected"
        else:
            tier = ComplexityTier.BALANCED
            confidence = 0.7
            reasoning = "Balanced analysis task (default)"

        result = QueryClassification(
            tier=tier,
            confidence=confidence,
            reasoning=reasoning,
            estimated_tokens=token_estimate
        )

        self.cache[cache_key] = result
        return result
