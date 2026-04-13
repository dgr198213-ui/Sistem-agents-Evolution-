from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Optional
from .meta_router import MetaRouter
from .complexity_classifier import ComplexityTier
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="Meta-Router API", version="1.0.0")
router = MetaRouter()

class ChatRequest(BaseModel):
    messages: List[Dict[str, str]]
    force_tier: Optional[str] = None
    max_tokens: int = 1000
    temperature: float = 0.7

@app.post("/v1/chat")
async def chat_endpoint(request: ChatRequest):
    """Main chat endpoint that routes through the Meta-Router."""
    try:
        tier = None
        if request.force_tier:
            try:
                tier = ComplexityTier[request.force_tier.upper()]
            except KeyError:
                raise HTTPException(status_code=400, detail=f"Invalid tier: {request.force_tier}")

        result = await router.chat(
            messages=request.messages,
            force_tier=tier,
            max_tokens=request.max_tokens,
            temperature=request.temperature
        )

        if "error" in result:
            raise HTTPException(status_code=500, detail=result["error"])

        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/metrics")
async def get_metrics():
    """Returns Meta-Router metrics."""
    return router.get_metrics()

@app.get("/health")
async def health_check():
    """Service health check."""
    return {"status": "healthy", "service": "meta-router"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
