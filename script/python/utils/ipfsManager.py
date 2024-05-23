import ipfshttpclient2
import json
import os

# Connect to the IPFS client
client = ipfshttpclient2.connect('/ip4/127.0.0.1/tcp/5001/http')
download_path = 'ipfs-download'

def upload_json(data):
    """
    Function to upload a JSON object to IPFS and return the resulting CID.
    """
    res = client.add_json(data)
    print(res)
    return res

def upload_file(file_path):
    """
    Function to upload a file to IPFS and return the resulting CID.
    """
    res = client.add(file_path)
    print(f"File uploaded: {res['Hash']}")
    return res['Hash']

def download_file(cid, output_path):
    """
    Function to download a file from IPFS using its CID.
    """
    client.get(cid, target=output_path)
    print(f"File downloaded to: {output_path}")

def check_and_load_file(cid):
    """
    Function to check if a file exists locally and load its content.
    """
    file_path = os.path.join(download_path, cid)
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            content = json.load(file)
            return content
    else:
        print("File download failed.")

def check_and_download_and_return_file(cid, output_path=download_path, count=0):
    """
    Function to check if a file exists locally, and if not, download it from IPFS.
    """
    if count > 3:
        return
    file_path = os.path.join(output_path, cid)
    if os.path.exists(file_path):
        return file_path
    else:
        download_file(cid, output_path)
        return check_and_download_and_return_file(cid, output_path, count + 1)

# Example usage:
# data = {
#     "name": "John Doe",
#     "email": "john.doe@example.com",
#     "age": 30
# }

# cid = upload_json(data)

# # Download path
# download_path = 'ipfs-download'

# # Download file
# download_file(cid, download_path)

# # Compare uploaded file and downloaded file content
# if os.path.exists(os.path.join(download_path, cid)):
#     with open(os.path.join(download_path, cid), 'r') as file:
#         content = json.load(file)
#         print(f"Downloaded file content: {json.dumps(content, indent=4)}")
# else:
#     print("File download failed.")

# res = upload_file('/path/to/your/file')
# print(res)
