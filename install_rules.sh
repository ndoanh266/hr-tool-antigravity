#!/bin/bash
# install_rules.sh - Setup HR Tool Antigravity on macOS

echo "========================================================"
echo " [HE THONG] KIEM TRA & CAP NHAT HR TOOL ANTIGRAVITY (MAC)"
echo "========================================================"

TARGET_DIR="$HOME/mkt/hr-tool-antigravity"
mkdir -p "$HOME/mkt"

# 1. Download source from GitHub
echo "[*] Dang tai ma nguon tu GitHub..."
curl -L https://github.com/ndoanh266/hr-tool-antigravity/archive/refs/heads/main.zip -o "$HOME/mkt/hr-tool.zip"
echo "[*] Giai nen ma nguon..."
unzip -o "$HOME/mkt/hr-tool.zip" -d "$HOME/mkt/"
rm -rf "$TARGET_DIR"
mv -f "$HOME/mkt/hr-tool-antigravity-main" "$TARGET_DIR"
rm -f "$HOME/mkt/hr-tool.zip"

# 2. Setup rules in Antigravity global config
echo "[*] Dang lien ket Rules vao Antigravity IDE..."
mkdir -p "$HOME/.gemini"
touch "$HOME/.gemini/GEMINI.md"
if ! grep -q "INSTRUCTIONS_FOR_AI.md" "$HOME/.gemini/GEMINI.md" 2>/dev/null; then
    echo -e "\n# HR Tool Rules\n@$HOME/mkt/hr-tool-antigravity/INSTRUCTIONS_FOR_AI.md" >> "$HOME/.gemini/GEMINI.md"
fi

# 3. Check and Install Python 3
if ! command -v python3 &>/dev/null; then
    echo "[!] Khong tim thay Python 3 tren may Mac cua ban."
    echo "[*] Dang tai ve bo cai dat Python 3.11 chinh thuc..."
    curl -L "https://www.python.org/ftp/python/3.11.9/python-3.11.9-macos11.pkg" -o "$HOME/mkt/python.pkg"
    echo "[*] Dang mo cua so cai dat Python..."
    echo "========================================================"
    echo " VUI LONG THUC HIEN CAI DAT PYTHON TRONG CUA SO MO KINH!"
    echo " (Sau khi cai dat xong, hay mo lai Terminal de tu dong"
    echo " chay lai hoac tiep tuc cai dat cac thu vien)."
    echo "========================================================"
    open "$HOME/mkt/python.pkg"
    exit 0
fi

# 4. Install python dependencies
echo "[*] Dang cai dat cac thu vien Python can thiet..."
pip3 install -r "$TARGET_DIR/requirements.txt"

echo "========================================================"
echo " [THANH CONG] CAI DAT HOAN TAT!"
echo " Hay khoi dong lai Antigravity IDE de ap dung rules."
echo "========================================================"
