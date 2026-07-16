import os, sys, argparse

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from api_client import call_llm

def summarize_client(query, web_info):
    prompt = (
        f"Hãy nghiên cứu và tổng hợp thông tin về doanh nghiệp/khách hàng '{query}' "
        f"dựa trên các kết quả tìm kiếm web sau:\n\n{web_info}\n\n"
        f"Hãy trả về kết quả theo cấu trúc mẫu sau (nếu không có thông tin thì để trống):\n"
        f"Tên công ty: \n"
        f"Ngày thành lập: \n"
        f"Lĩnh vực hoạt động: \n"
        f"Cơ cấu tổ chức: \n"
        f"Địa chỉ: \n"
        f"Số điện thoại liên hệ: \n"
        f"Website: \n"
        f"Thông tin bổ sung khác: \n"
    )
    system_instruction = "Bạn là chuyên viên nghiên cứu doanh nghiệp tuyển dụng."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--query", required=True)
    parser.add_argument("--web_info", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(summarize_client(args.query, args.web_info))
