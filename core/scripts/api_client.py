import os, json, requests

def get_api_key():
    # Ưu tiên biến môi trường, sau đó đến file cấu hình
    key = os.getenv("OPENROUTER_API_KEYS", "").split(",")[0].strip()
    if not key:
        path = "C:/mkt/data/data_wl.json"
        if os.path.exists(path):
            try:
                with open(path, "r", encoding="utf-8") as f:
                    key = json.load(f).get("openrouter_api_key", "").strip()
            except Exception: pass
    return key

def increment_usage():
    path = "C:/mkt/data/data_wl.json"
    if os.path.exists(path):
        try:
            with open(path, "r", encoding="utf-8") as f:
                data = json.load(f)
            data["count_get"] = data.get("count_get", 0) + 1
            with open(path, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=4)
        except Exception: pass

def call_llm(prompt, system_instruction=""):
    key = get_api_key()
    if not key:
        raise ValueError("Chưa cấu hình OpenRouter API Key!")
    headers = {"Authorization": f"Bearer {key}", "Content-Type": "application/json"}
    payload = {
        "model": "openrouter/free",
        "messages": [
            {"role": "system", "content": system_instruction},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.0
    }
    res = requests.post("https://openrouter.ai/api/v1/chat/completions", json=payload, headers=headers)
    res.raise_for_status()
    increment_usage()
    return res.json()["choices"][0]["message"]["content"]
