import sys, argparse, requests
from bs4 import BeautifulSoup

def search_ddg(query):
    try:
        headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"}
        res = requests.get("https://duckduckgo.com/html/", params={"q": f"{query} Việt Nam", "kl": "vn-vi"}, headers=headers, timeout=10)
        if res.status_code != 200:
            return f"Error: DuckDuckGo returned status {res.status_code} (xác thực bot/captcha)."
        if "anomaly" in res.text or "captcha" in res.text.lower():
            return "Error: DuckDuckGo yêu cầu xác minh CAPTCHA chống bot."
        soup = BeautifulSoup(res.text, "html.parser")
        snippets = [item.get_text(" ", strip=True) for item in soup.select(".result__snippet")[:5] if item.get_text(" ", strip=True)]
        if not snippets:
            return "Error: Không tìm thấy kết quả phù hợp trên DuckDuckGo."
        return "\n\n".join(snippets)
    except Exception as e:
        return f"Error: {e}"

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--query", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(search_ddg(args.query))
