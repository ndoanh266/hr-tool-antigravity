import os, sys, argparse

# Đảm bảo import được các file script cùng thư mục
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from extract_text import extract_text

def search_files(root_dir, keyword, extensions=(".txt", ".pdf", ".docx", ".xlsx", ".xls", ".csv")):
    matched_files = []
    keyword_lower = keyword.lower()
    for root, _, files in os.walk(root_dir):
        for file in files:
            ext = os.path.splitext(file)[1].lower()
            if ext in extensions:
                path = os.path.join(root, file)
                try:
                    text = extract_text(path)
                    if keyword_lower in text.lower():
                        matched_files.append(path)
                except Exception:
                    pass
    return matched_files

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", required=True)
    parser.add_argument("--keyword", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    results = search_files(args.dir, args.keyword)
    for r in results:
        print(r)
