import os, sys, argparse

def extract_text(path):
    ext = os.path.splitext(path)[1].lower()
    if ext == ".txt":
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            return f.read()
    elif ext == ".pdf":
        import PyPDF2
        with open(path, "rb") as f:
            reader = PyPDF2.PdfReader(f)
            return "\n".join([page.extract_text() or "" for page in reader.pages])
    elif ext == ".docx":
        import docx
        doc = docx.Document(path)
        return "\n".join([p.text for p in doc.paragraphs])
    elif ext == ".doc":
        import doc2docx # Dùng doc2docx để convert sang docx rồi đọc
        docx_path = path + "x"
        doc2docx.convert(path, docx_path)
        text = extract_text(docx_path)
        if os.path.exists(docx_path): os.remove(docx_path)
        return text
    elif ext in (".xlsx", ".xls", ".csv"):
        import pandas as pd
        df = pd.read_excel(path) if ext != ".csv" else pd.read_csv(path)
        return df.to_string()
    return ""

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(extract_text(args.input))
