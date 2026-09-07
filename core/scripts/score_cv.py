import os, sys, argparse

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from api_client import call_llm

def score_cv(cv_text, criteria):
    prompt = f"Hãy chấm điểm CV sau dựa trên tiêu chí: {criteria}. Kết quả trả về dạng: điểm/tổng điểm và nhận xét chi tiết ngắn gọn theo từng tiêu chí.\n\nNội dung CV:\n{cv_text}"
    system_instruction = "Bạn là chuyên gia nhân sự đánh giá CV ứng viên."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--text", required=True)
    parser.add_argument("--criteria", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(score_cv(args.text, args.criteria))
