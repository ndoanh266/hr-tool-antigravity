import sys, argparse, requests
API_URL = "https://script.google.com/macros/s/AKfycbzCLefTFNxrI8x_KLO3eaC0prGu4nUv8X2n9no___xc5CPhsjq0er-sWrTGrIM3bXNp/exec"

def filter_words(text):
    try:
        res = requests.get(API_URL, timeout=10)
        res.raise_for_status()
        replacement_map = {entry["A"]: entry["B"] for entry in res.json() if "A" in entry and "B" in entry}
        for old, new in replacement_map.items():
            text = text.replace(old, new)
    except Exception as e:
        print(f"Error fetching bad words: {e}", file=sys.stderr)
    return text

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--text", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(filter_words(args.text))
