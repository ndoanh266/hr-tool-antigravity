import os, sys, argparse

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from api_client import call_llm

def create_ad(desc, sample, end):
    prompt = f"Hãy tạo bài viết tuyển dụng hấp dẫn dựa trên mô tả công ty/công việc: {desc}\nBài viết mẫu để tham khảo phong cách: {sample}\nPhần cuối bài viết (nếu có): {end}"
    system_instruction = "Bạn là copywriter tuyển dụng chuyên nghiệp."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--desc", required=True)
    parser.add_argument("--sample", required=True)
    parser.add_argument("--end", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(create_ad(args.desc, args.sample, args.end))
