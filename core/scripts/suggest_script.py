import os, sys, argparse

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from api_client import call_llm

def suggest_script(template, history):
    prompt = f"Hãy xây dựng kịch bản tiếp theo để nhắn tin thật ngắn gọn, ít chữ, chuyên nghiệp, lịch sự dựa theo mẫu: {template}\n\nĐoạn hội thoại trước đó:\n{history}"
    system_instruction = "Bạn là trợ lý tư vấn kịch bản giao tiếp."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--template", required=True)
    parser.add_argument("--history", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(suggest_script(args.template, args.history))
