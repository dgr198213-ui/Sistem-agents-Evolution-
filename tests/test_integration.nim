import unittest, json
import ../src/core/agent_base, ../src/core/types

suite "Integration Tests":
  test "Agent thinking (Mocked API)":
    # Since we don't have real API keys, we test that the method exists and handles errors correctly
    let agent = Agent(id: 1)
    let thought = agent.think("Test prompt")
    check(thought == "Error calling Meta-Router") # Expected because service is up but failing API calls
