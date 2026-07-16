# HR Tool Antigravity (v1.6) - Headhunter AI Agent

Dự án tối ưu hóa quy trình Headhunter sử dụng AI Agent (Antigravity) với kiến trúc phi tập trung, hướng tri thức (Knowledge-driven), giúp tối đa hóa khả năng suy luận trực tiếp của AI và giảm thiểu tối đa chi phí sử dụng API ngoài.

---

## 🌟 Kiến Trúc Hoạt Động (3 Bước)

Khi được cấu hình thành công, AI Agent (Antigravity) sẽ tuân thủ nghiêm ngặt quy trình 3 bước sau:

1. **Bước 1 (Đọc Luật Tổng Quát):** Đọc file `rules/master_rules.html` để xác định yêu cầu công việc hiện tại của bạn thuộc nhóm quy tắc nào.
2. **Bước 2 (Đọc Luật Chi Tiết):** Truy cập vào file HTML tương ứng trong thư mục `rules/` (ví dụ: `rule_extract_cv.html`) để xem hướng dẫn chi tiết, định dạng và các ràng buộc dữ liệu.
3. **Bước 3 (Tự Xử Lý Suy Luận & Gọi Script Hệ Thống):** AI sử dụng năng lực của chính mình để dịch thuật, suy luận, định dạng dữ liệu, và chỉ gọi các Python scripts thuần để thực hiện các thao tác hệ thống (đọc file, ghi file Excel, tìm kiếm web).

---

## 🚀 Hướng Dẫn Tích Hợp Vào Antigravity (Global Rules)

Để Antigravity tự động nhận diện và luôn luôn áp dụng quy trình xử lý của HR Tool trong mọi phiên làm việc, bạn cần nạp file hướng dẫn `INSTRUCTIONS_FOR_AI.md` vào cấu hình chung của Agent.

### Cách 1: Sử dụng File Tự Động (Khuyên Dùng)
1. Trong thư mục dự án, nhấp đúp (Double-click) để chạy file **`install_rules.bat`**.
2. Script sẽ tự động phát hiện file cấu hình toàn cục `GEMINI.md` của Antigravity tại thư mục `%USERPROFILE%\.gemini\GEMINI.md` và thêm dòng nạp luật tự động.
3. Nhấn phím bất kỳ để hoàn thành.

### Cách 2: Cấu Hình Thủ Công
Nếu không muốn dùng file `.bat`, bạn có thể mở file:
`C:\Users\dell\.gemini\GEMINI.md`

Và thêm dòng sau vào cuối file:
```markdown
# HR Tool Antigravity Rules
@E:/Workshop/2025/hr-tool-antigravity/INSTRUCTIONS_FOR_AI.md
```

---

## 📂 Danh Sách File Luật & Scripts Hệ Thống

### 1. Thư mục `rules/` (Quy định & Định dạng)
*   **`master_rules.html`**: Định tuyến nghiệp vụ chính của AI Agent.
*   **`rule_extract_cv.html`**: Quy định chuẩn trích xuất thông tin từ CV ứng viên vào Excel.
*   **`rule_extract_jd.html`**: Quy định chuẩn trích xuất thông tin Mô tả công việc (JD) vào Excel.
*   **`rule_score_cv.html`** & **`rule_score_jd.html`**: Tiêu chí đánh giá, chấm điểm CV và JD.
*   **`rule_summarize_client.html`**: Định dạng tóm tắt thông tin công ty/khách hàng.
*   **`rule_build_email.html`**: Mẫu email tiếp cận ứng viên/khách hàng.
*   **`rule_create_ad.html`**: Quy định viết bài tuyển dụng & gợi ý thiết kế Canva.
*   **`rule_search_files.html`**: Quy trình quét tìm kiếm tài liệu cục bộ.
*   **`rule_suggest_script.html`**: Mẫu kịch bản tương tác tiếp theo.
*   **`rule_lookup_term.html`**: Quy chuẩn giải nghĩa thuật ngữ chuyên ngành.
*   **`style.css`**: Định dạng giao diện hiển thị cho các file luật.

### 2. Thư mục `scripts/` (Công cụ hệ thống hỗ trợ)
Các công cụ viết bằng Python thuần để Agent gọi trong các bước xử lý dữ liệu hệ thống:
*   `extract_text.py`: Đọc nội dung thô từ file Word (`.docx`) hoặc PDF.
*   `get_excel_fields.py`: Trích xuất tiêu đề các cột của file Excel hiện có.
*   `write_to_excel.py`: Ghi dữ liệu dạng bảng Markdown do AI phân tích vào file Excel.
*   `search_files.py`: Tìm kiếm file cục bộ theo từ khóa.
*   `search_web.py`: Tra cứu công cụ tìm kiếm để thu thập dữ liệu thô về doanh nghiệp.
*   `filter_forbidden_words.py`: Lọc và thay thế các từ cấm/từ nhạy cảm trong bài đăng tuyển dụng.

---

## 🛡️ Lưu ý An Toàn Bảo Mật
Dự án đã được cấu hình sẵn `.gitignore` để tránh đẩy các file rác, file chạy Python (`__pycache__`, `.venv`, `.idea`) hoặc các file cấu hình chứa API Key cá nhân lên GitHub.
