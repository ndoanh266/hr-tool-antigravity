import os
import sys
import argparse

def load_config():
    config = {}
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for dirpath in [repo_root, "."]:
        path = os.path.join(dirpath, "config.env")
        if os.path.exists(path):
            try:
                with open(path, "r", encoding="utf-8") as f:
                    for line in f:
                        if "=" in line:
                            k, v = line.strip().split("=", 1)
                            config[k] = v
            except Exception:
                pass
            break
    return config

def get_link_via_local_stream(filename):
    config = load_config()
    cv_dir = config.get("CV_DIR")
    if not cv_dir:
        return None
    
    file_path = os.path.join(cv_dir, filename)
    # Check if file exists in the CV folder
    if not os.path.exists(file_path):
        # Try searching directly inside cv_dir and subdirectories
        found_path = None
        try:
            for root, dirs, files in os.walk(cv_dir):
                if filename in files:
                    found_path = os.path.join(root, filename)
                    break
        except Exception:
            pass
        if found_path:
            file_path = found_path
        else:
            return None

    # Check Windows Alternate Data Stream for Google Drive Desktop
    stream_path = f"{file_path}:user.drive.id"
    try:
        with open(stream_path, "r", encoding="utf-8") as f:
            file_id = f.read().strip()
            if file_id and not file_id.startswith("local"):
                return f"https://drive.google.com/file/d/{file_id}/view?usp=drivesdk"
    except Exception:
        pass
    return None

def find_credentials(creds_path="service_account.json"):
    possible_paths = [creds_path, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), creds_path)]
    for p in possible_paths:
        if os.path.exists(p):
            return p
            
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    try:
        if os.path.exists(repo_root):
            for name in os.listdir(repo_root):
                if name.endswith('.json'):
                    path = os.path.join(repo_root, name)
                    import json
                    try:
                        with open(path, 'r', encoding='utf-8') as f:
                            data = json.load(f)
                            if data.get('type') == 'service_account':
                                return path
                    except Exception:
                        pass
    except Exception:
        pass
    return None

def get_file_drive_link(filename, creds_path="service_account.json"):
    # 1. Try to get the link locally via Google Drive Stream (No API key or credentials needed)
    local_link = get_link_via_local_stream(filename)
    if local_link:
        return local_link
        
    # 2. Fallback to Google Drive API (requires google-auth, google-api-python-client, and service account json)
    try:
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
    except ImportError:
        return "ERROR: Google Drive desktop stream metadata not found, and API libraries (google-api-python-client, google-auth) are not installed for online fallback."

    actual_path = find_credentials(creds_path)
    if not actual_path:
        return "ERROR: Google Drive desktop stream metadata not found, and no Service Account JSON key file was found for online fallback."
    
    try:
        credentials = service_account.Credentials.from_service_account_file(actual_path)
        scoped_credentials = credentials.with_scopes(['https://www.googleapis.com/auth/drive.readonly'])
        service = build('drive', 'v3', credentials=scoped_credentials)
        
        query = f"name = '{filename}' and trashed = false"
        results = service.files().list(q=query, fields="files(id, name, webViewLink)").execute()
        files = results.get('files', [])
        if files:
            return files[0].get('webViewLink')
        else:
            return "ERROR: File not found in Google Drive shared folder (neither locally nor on Cloud)."
    except Exception as e:
        return f"ERROR: Local stream check failed, and API check failed with error: {str(e)}"

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--filename", required=True)
    parser.add_argument("--creds", default="service_account.json")
    args = parser.parse_args()
    sys.stdout.reconfigure(encoding='utf-8')
    print(get_file_drive_link(args.filename, args.creds))
