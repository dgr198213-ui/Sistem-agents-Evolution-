import httpclient, json, strutils

type
  RouterResponse* = object
    content*: string
    tier*: string
    model*: string
    latency_ms*: int

proc callMetaRouter*(messages: JsonNode, tier: string = ""): RouterResponse =
  let client = newHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/json"})

  var body = %*{
    "messages": messages,
    "max_tokens": 1000,
    "temperature": 0.7
  }

  if tier != "":
    body["force_tier"] = %tier

  try:
    let response = client.post("http://localhost:8000/v1/chat", $body)
    if response.status == "200 OK":
      let data = parseJson(response.body)
      result.content = data["response"]["choices"][0]["message"]["content"].getStr()
      result.tier = data["metadata"]["tier"].getStr()
      result.model = data["metadata"]["model_used"].getStr()
      result.latency_ms = data["metadata"]["latency_ms"].getInt()
    else:
      raise newException(IOError, "Router API returned status: " & response.status)
  finally:
    client.close()
