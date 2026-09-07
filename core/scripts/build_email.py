import os, sys, argparse

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from api_client import call_llm

def build_email(name, company, xungho, content, end):
    prompt = f"Hãy viết email thật hay, chuyên nghiệp khoảng 1000 từ để tiếp cận khách hàng {name} ở công ty {company}, cách xưng hô là {xungho}, nội dung chính: {content}, kết email: {end}"
    system_instruction = "Bạn là chuyên viên viết email tiếp cận khách hàng doanh nghiệp."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--name", required=True)
    parser.add_argument("--company", required=True)
    parser.add_argument("--xungho", required=True)
    parser.add_argument("--content", required=True)
    parser.add_argument("--end", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(build_email(args.name, args.company, args.xungho, args.content, args.end))
