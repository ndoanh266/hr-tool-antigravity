import sys, argparse
from api_client import call_llm

def translate_text(text):
    prompt = f"Hãy dịch đoạn văn bản sau sang tiếng Việt. Nếu đã là tiếng Việt thì giữ nguyên:\n\n{text}"
    system_instruction = "Bạn là biên dịch viên chuyên nghiệp."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--text", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(translate_text(args.text))
