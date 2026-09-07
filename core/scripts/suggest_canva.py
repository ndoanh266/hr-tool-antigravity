import os, sys, argparse

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from api_client import call_llm

def suggest_canva(ad_content):
    prompt = f"Hãy gợi ý cách trang trí trên Canva thật đẹp, trực quan, chuyên nghiệp với nội dung bài viết tuyển dụng sau:\n\n{ad_content}"
    system_instruction = "Bạn là chuyên gia thiết kế đồ họa truyền thông."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--content", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(suggest_canva(args.content))
