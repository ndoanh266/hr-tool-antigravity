# Hướng Dẫn Dành Cho AI Agent (Antigravity) - Phiên Bản v1.6 (Tối Ưu Chi Phí)

Chào Antigravity. Người dùng tin tưởng vào trí tuệ nhân tạo trực tiếp của bạn (AI Agent) và muốn tiết kiệm chi phí gọi API bên ngoài. 
Vì vậy, **bạn sẽ tự mình xử lý toàn bộ các tác vụ tư duy, phân tích, dịch thuật và tổng hợp bằng chính năng lực của mình**, thay vì chạy các file script Python gọi API OpenRouter. Bạn chỉ chạy các script Python thuần cho các tác vụ hệ thống (đọc/ghi file, tìm kiếm web, lọc từ cấm).

## Quy Trình 3 Bước Điều Hướng & Thực Thi:

### Bước 1: Đọc File Luật Tổng Quát
Đọc file `rules/master_rules.html` để xác định yêu cầu của người dùng tương ứng với file luật nào.

### Bước 2: Đọc File Luật Chi Tiết
Mở file luật HTML chi tiết tương ứng (ví dụ: `rules/rule_extract_cv.html`) để xem trình tự các bước thực hiện và các ràng buộc dữ liệu.

### Bước 3: Tự Xử Lý Suy Luận (AI Reasoning) và Chạy Script Hệ Thống Tương Ứng

#### 1. Trích xuất thông tin CV (rule_extract_cv.html)
- **Hệ thống:** Chạy `python scripts/get_excel_fields.py --excel "<excel_path>"` để lấy danh sách tiêu đề cột.
- **Hệ thống:** Chạy `python scripts/extract_text.py --input "<cv_path>"` để lấy nội dung CV.
- **Hệ thống:** Nếu Excel có cột chứa liên kết/link (như `Link CV`), chạy `python scripts/get_drive_links.py --filename "<tên_file_cv_không_kèm_đường_dẫn>"` để lấy link Google Drive.
- **Tư duy của bạn (AI):** Tự dịch CV (nếu có ngoại ngữ), tự phân tích và điền thông tin (bao gồm cả link Drive vừa lấy nếu có cột tương ứng) khớp chính xác với tiêu đề cột thu được ở bước trên, tuân thủ đúng quy tắc định dạng của `rule_extract_cv.html`. Trả kết quả dưới dạng bảng Markdown (gồm tiêu đề cột và 1 dòng dữ liệu).
- **Hệ thống:** Chạy `python scripts/write_to_excel.py --excel "<excel_path>" --headers "<các_cột>" --data "<bảng_markdown_của_bạn>"` để ghi vào Excel.


#### 2. Trích xuất thông tin JD (rule_extract_jd.html)
- **Hệ thống:** Chạy `python scripts/get_excel_fields.py --excel "<excel_path>"` để lấy tiêu đề cột.
- **Hệ thống:** Chạy `python scripts/extract_text.py --input "<jd_path>"` để lấy nội dung JD.
- **Tư duy của bạn (AI):** Tự phân tích, trích xuất thông tin JD khớp chính xác với tiêu đề cột. Trả kết quả dạng bảng Markdown (gồm tiêu đề cột và 1 dòng dữ liệu).
- **Hệ thống:** Chạy `python scripts/write_to_excel.py --excel "<excel_path>" --headers "<các_cột>" --data "<bảng_markdown_của_bạn>"` để ghi vào Excel.

#### 3. Tìm kiếm file theo nội dung (rule_search_files.html)
- **Hệ thống:** Chạy `python scripts/search_files.py --dir "<thư_mục>" --keyword "<từ_khóa>"` để quét file.

#### 4. Tổng hợp thông tin khách hàng (rule_summarize_client.html)
- **Hệ thống:** Chạy `python scripts/search_web.py --query "<tên_công_ty>"` để lấy thông tin web thô.
- **Tư duy của bạn (AI):** Tự tổng hợp thông tin web thu được thành hồ sơ doanh nghiệp theo mẫu chuẩn quy định trong `rule_summarize_client.html`.

#### 5. Tra cứu từ chuyên ngành (rule_lookup_term.html)
- **Tư duy của bạn (AI):** Tự định nghĩa và giải nghĩa thuật ngữ chuyên ngành ngắn gọn khoảng 200 từ. Không cần chạy script.

#### 6. Chấm điểm JD (rule_score_jd.html)
- **Hệ thống:** Chạy `python scripts/extract_text.py --input "<jd_path>"` để lấy nội dung JD.
- **Tư duy của bạn (AI):** Tự chấm điểm và nhận xét chi tiết JD theo tiêu chí yêu cầu.

#### 7. Chấm điểm CV (rule_score_cv.html)
- **Hệ thống:** Chạy `python scripts/extract_text.py --input "<cv_path>"` để lấy nội dung CV.
- **Tư duy của bạn (AI):** Tự chấm điểm và nhận xét chi tiết CV theo tiêu chí yêu cầu.

#### 8. Xây dựng email tiếp cận khách hàng (rule_build_email.html)
- **Tư duy của bạn (AI):** Tự soạn email tiếp cận khách hàng theo các tham số đầu vào (tên, công ty, xưng hô, nội dung chính, kết bài).

#### 9. Gợi ý kịch bản liên hệ (rule_suggest_script.html)
- **Tư duy của bạn (AI):** Tự đề xuất kịch bản phản hồi tiếp theo dựa vào lịch sử trò chuyện và kịch bản mẫu.

#### 10. Tạo bài viết tuyển dụng & Gợi ý Canva (rule_create_ad.html)
- **Tư duy của bạn (AI):** Tự viết nội dung bài tuyển dụng thô dựa theo mô tả.
- **Hệ thống:** Chạy `python scripts/filter_forbidden_words.py --text "<bài_viết_thô_của_bạn>"` để tự động lọc và thay thế từ cấm.
- **Tư duy của bạn (AI):** Nhận nội dung đã lọc từ cấm, sau đó tự đề xuất cách thiết kế/trang trí tin tuyển dụng trên Canva.
