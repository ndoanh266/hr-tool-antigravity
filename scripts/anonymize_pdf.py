import fitz
import os

def anonymize_and_brand_pdf(pdf_in, pdf_out, logo_path):
    doc = fitz.open(pdf_in)
    page = doc[0]
    
    # 1. Search for phone and email and draw cream rectangles to cover them
    # Cream color in RGB (0-1 range): #e8ded1 -> (232/255, 222/255, 209/255)
    cream_color = (232/255, 222/255, 209/255)
    
    # We will search for all words and check if they match phone number or email regex
    import re
    phone_pattern = re.compile(r'\b(0[35789]\d{8}|02\d{8,9}|\+84\d{9,10})\b')
    email_pattern = re.compile(r'\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b')
    
    words = page.get_text("words")
    for w in words:
        x0, y0, x1, y1, text = w[0], w[1], w[2], w[3], w[4]
        if phone_pattern.search(text) or email_pattern.search(text) or "0379436225" in text or "huyenthu04022k3" in text:
            # Create rect with slight padding to ensure complete coverage
            rect = fitz.Rect(x0 - 2, y0 - 2, x1 + 2, y1 + 2)
            page.draw_rect(rect, color=cream_color, fill=cream_color, width=0)
            print(f"[DA AN] Đã che text: {text} tại tọa độ: {rect}")
            
    # 2. Insert logo at top-left of main section
    # Let's check the size of the page
    page_rect = page.rect
    print(f"Kích thước trang PDF: {page_rect.width}x{page_rect.height}")
    
    # Place logo at x = 232, y = 5, width = 60, height = 31 (aspect ratio 1.90)
    logo_rect = fitz.Rect(232, 5, 232 + 60, 5 + 31)
    
    if os.path.exists(logo_path):
        page.insert_image(logo_rect, filename=logo_path)
        print(f"[OK] Đã chèn logo vào vị trí: {logo_rect}")
    else:
        print(f"[LỖI] Không tìm thấy file logo tại: {logo_path}")
        
    doc.save(pdf_out)
    doc.close()
    print(f"[OK] Đã xuất file PDF bảo mật tại: {pdf_out}")

if __name__ == "__main__":
    import sys
    import argparse
    
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(encoding='utf-8')
        
    parser = argparse.ArgumentParser(description="Ẩn thông tin bảo mật và chèn logo Worklink trực tiếp vào file PDF.")
    parser.add_argument("--input", required=True, help="Đường dẫn file PDF gốc")
    parser.add_argument("--output", required=True, help="Đường dẫn xuất file PDF bảo mật")
    parser.add_argument("--logo", required=True, help="Đường dẫn file logo PNG/JPG")
    
    args = parser.parse_args()
    anonymize_and_brand_pdf(args.input, args.output, args.logo)
