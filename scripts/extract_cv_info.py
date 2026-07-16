import sys, argparse
from api_client import call_llm

def extract_info(text, fields, mode="cv"):
    question = f"""Hãy phân tích văn bản {mode.upper()} sau và điền thông tin vào các cột tương ứng: {fields}
    Lưu ý: Không được tự ý thêm cột. Định dạng trả về phải là bảng markdown có tiêu đề và 1 dòng dữ liệu.
    Quy tắc điền thông tin (áp dụng nếu có cột tương ứng):
    - Họ Tên: Ghi rõ họ tên đầy đủ. Tên: Chỉ lấy tên riêng.
    - Giới tính: Nam hoặc Nữ.
    - Năm sinh: Chỉ ghi 4 chữ số năm (ví dụ: 1995).
    - SĐT: Thêm dấu nháy đơn đằng trước (ví dụ: '0912345678).
    - Bằng cấp: THPT, Trung cấp, Cao đẳng, Đại học, Senmon.
    - Chứng chỉ tiếng: N1-N5, IELTS 5.0-9.0, Toeic 350-990, Topik 1-6, HSK 1-6. Nếu tự đánh giá thêm TD ở cuối (ví dụ: N3TD).
    - Kinh nghiệm: Ghi dạng: ="-(thời gian) chức danh tại công ty"&CHAR(10)... dùng CHAR(10) để xuống dòng.
    - Note: Điền dạng "mức_lương;khu_vực" (ví dụ: 15 triệu;Hà Nội).
    - Đã tìm được việc: "chưa" hoặc "đã có việc làm".
    - Loại ứng viên: Tiếng Nhật, Anh Nhật, mua hàng, xuất nhập khẩu, logistic, Sales, CSKH, KHSX, QLSX, QA QC, HCNS, Kỹ thuật...
    """
    prompt = f"{question}\n\nNội dung văn bản:\n{text}"
    system_instruction = f"Bạn là chuyên viên trích xuất dữ liệu cực kỳ chính xác từ {mode.upper()}."
    return call_llm(prompt, system_instruction)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--text", required=True)
    parser.add_argument("--fields", required=True)
    parser.add_argument("--mode", default="cv")
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(extract_info(args.text, args.fields, args.mode))
