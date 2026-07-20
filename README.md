# HR Tool Antigravity – Công cụ hỗ trợ tuyển dụng

## 🎯 Mục tiêu
Giúp bộ phận nhân sự nhanh chóng truy cập, quản lý và sử dụng các hồ sơ CV, tài liệu tuyển dụng trên Google Drive mà không cần thao tác phức tạp.

## 📦 Các chức năng chính
- **Trích xuất CV** – Đọc file PDF/Word/Excel của ứng viên, tự động lấy thông tin cá nhân, kỹ năng, kinh nghiệm và ghi vào Excel/CSV.
- **Trích xuất JD** – Phân tích mô tả công việc, trích xuất yêu cầu và lưu thành dữ liệu có cấu trúc.
- **Tìm kiếm file** – Quét đệ quy thư mục (Google Drive hoặc ổ cục bộ) để tìm nhanh file chứa từ khóa.
- **Tìm kiếm & tổng hợp khách hàng** – Dùng DuckDuckGo thu thập thông tin doanh nghiệp, tổng hợp báo cáo ngắn gọn.
- **Tra cứu thuật ngữ** – Giải nghĩa nhanh các từ ngữ, khái niệm HR, công nghệ, kinh tế.
- **Chấm điểm CV** – Đánh giá mức độ phù hợp của hồ sơ với tiêu chí tuyển dụng, đưa ra điểm số chuẩn hoá.
- **Chấm điểm JD** – Đánh giá cấu trúc và nội dung JD dựa trên tiêu chuẩn công ty.
- **Xây dựng email tiếp cận** – Tự động tạo mẫu email mời phỏng vấn, bán hàng hoặc theo dõi, cá nhân hoá nội dung.
- **Gợi ý kịch bản hội thoại** – Đề xuất các đoạn hội thoại, phản hồi tiếp theo cho nhân viên tuyển dụng.
- **Tạo bài đăng tuyển dụng & thiết kế Canva** – Viết nội dung bài đăng, lọc từ cấm và gợi ý mẫu Canva.
- **Kết hợp Google Drive App (Windows)** – Tạo ổ ảo (`subst`) trỏ tới thư mục CV trên Google Drive, gán nhãn và biểu tượng để người HR nhận diện ngay trong Explorer.
- **Tự động hoá qua Antigravity** – Khi Antigravity được cấu hình, các quy tắc trong `INSTRUCTIONS_FOR_AI.md` sẽ gọi các script PowerShell/Python để thực hiện các chức năng trên mà không cần thao tác thủ công.

## 💻 Hướng dẫn cài đặt
1. **Kiểm tra môi trường**
   - **PowerShell 3.0+** – Cần để chạy các script PowerShell (`install_rules.bat`, `setup_subst.ps1`). Các lệnh như `subst`, `New-Item`, `SHChangeNotify` chỉ hoạt động trên PowerShell hiện đại.
   - **Git** – Dùng để sao chép, cập nhật source code từ GitHub và để quản lý phiên bản. Nếu máy chưa có, script sẽ tự động tải và cài đặt.
   - **Python 3.x** – Các script xử lý dữ liệu (extract, write_to_excel, search_web…) được viết bằng Python. Cài Python cho phép chạy các công cụ này và cài các thư viện phụ thuộc (`openpyxl`, `pandas`, …).

2. **Cài đặt nhanh**
   - Mở thư mục dự án và chạy file **`install_rules.bat`** bằng cách double‑click.
   - Nếu thiếu **Git** hoặc **Python**, script sẽ:
     - Yêu cầu quyền **Administrator**, tải bộ cài từ Microsoft / Python.org, cài đặt ở chế độ **silent**.
     - Thêm đường dẫn cài đặt vào biến môi trường `PATH` để các lệnh có thể được gọi ngay.
   - Khi cài đặt hoàn tất, script sẽ tạo một **ổ ảo** (ví dụ `S:`) trỏ tới thư mục CV trên Google Drive và gán nhãn, biểu tượng theo cấu hình.

3. **Kiểm tra**
   - Mở `File Explorer` → kiểm tra ổ mới (ví dụ `S:`) có nhãn “CV Tool” và biểu tượng tùy chọn.
   - Chạy PowerShell và thực hiện lệnh `Get-PSDrive` để xác nhận ổ ảo đã được tạo.

## ☕ Buy Me a Coffee
Nếu bạn thấy công cụ hữu ích, hãy ủng hộ để tôi tiếp tục phát triển:

**VIB**
**002606**
**Nguyễn Thế Doanh**

![QR Code for donation](https://img.vietqr.io/image/VIB-002606-1.png?amount=0&addInfo=Support%20HR%20Tool&accountName=Nguyen%20The%20Doanh)

Bạn có thể truy cập https://vietqr.io/ để quét mã QR và thực hiện chuyển khoản.
