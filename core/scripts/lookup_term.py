import os, sys, argparse

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from api_client import call_llm

def lookup_term(term):
    prompt = f"Hãy tìm kiếm nghĩa của từ '{term}' thật cơ bản và ngắn gọn khoảng 200 từ về tất cả các lĩnh vực chứ không đơn thuần là nhân sự."
    system_instruction = "Bạn là trợ lý từ điển chuyên nghiệp giải nghĩa thuật ngữ."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--term", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(lookup_term(args.term))
