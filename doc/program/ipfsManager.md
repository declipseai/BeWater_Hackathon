# ipfsManager.md

## Introduction
The `ipfsManager.py` script provides a set of functions to interact with the InterPlanetary File System (IPFS). This script leverages the `ipfshttpclient2` library to perform actions such as uploading JSON objects and files, and downloading files using their IPFS Content Identifier (CID). It also includes utility functions to check the existence of files locally and to manage file downloads.

## Setup

### Prerequisites
Ensure that you have an IPFS node running locally and that the `ipfshttpclient2` library is installed.

### Environment Configuration
The script connects to the IPFS client at the default local address (`/ip4/127.0.0.1/tcp/5001/http`). Ensure your IPFS node is running and accessible at this address.

## Connecting to IPFS
The script initializes a connection to the local IPFS node using the `ipfshttpclient2` library.

```python
client = ipfshttpclient2.connect('/ip4/127.0.0.1/tcp/5001/http')
download_path = 'ipfs-download'
```

## Functions

### `upload_json`
Uploads a JSON object to IPFS and returns the resulting CID.

- **Parameters**:
  - `data`: The JSON object to be uploaded.
- **Returns**: The CID of the uploaded JSON object.

```python
def upload_json(data):
    res = client.add_json(data)
    print(res)
    return res
```

### `upload_file`
Uploads a file to IPFS and returns the resulting CID.

- **Parameters**:
  - `file_path`: The path to the file to be uploaded.
- **Returns**: The CID of the uploaded file.

```python
def upload_file(file_path):
    res = client.add(file_path)
    print(f"File uploaded: {res['Hash']}")
    return res['Hash']
```

### `download_file`
Downloads a file from IPFS using its CID and saves it to the specified output path.

- **Parameters**:
  - `cid`: The CID of the file to be downloaded.
  - `output_path`: The path where the downloaded file should be saved.

```python
def download_file(cid, output_path):
    client.get(cid, target=output_path)
    print(f"File downloaded to: {output_path}")
```

### `check_and_load_file`
Checks if a file exists locally and loads its content.

- **Parameters**:
  - `cid`: The CID of the file to be checked and loaded.
- **Returns**: The content of the file if it exists locally; otherwise, `None`.

```python
def check_and_load_file(cid):
    file_path = os.path.join(download_path, cid)
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            content = json.load(file)
            return content
    else:
        print("File download failed.")
```

### `check_and_download_and_return_file`
Checks if a file exists locally, and if not, downloads it from IPFS.

- **Parameters**:
  - `cid`: The CID of the file to be checked and downloaded.
  - `output_path`: (Optional) The path where the downloaded file should be saved (default: `download_path`).
  - `count`: (Optional) The retry count for downloading the file (default: `0`).
- **Returns**: The path to the file if it exists or is successfully downloaded; otherwise, `None`.

```python
def check_and_download_and_return_file(cid, output_path=download_path, count=0):
    if count > 3:
        return
    file_path = os.path.join(output_path, cid)
    if os.path.exists(file_path):
        return file_path
    else:
        download_file(cid, output_path)
        return check_and_download_and_return_file(cid, output_path, count + 1)
```

## Example Usage

### Uploading a JSON Object
```python
data = {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": 30
}

cid = upload_json(data)
```

### Downloading a File
```python
# Set download path
download_path = 'ipfs-download'

# Download file using its CID
download_file(cid, download_path)
```

### Checking and Loading a File
```python
if os.path.exists(os.path.join(download_path, cid)):
    with open(os.path.join(download_path, cid), 'r') as file:
        content = json.load(file)
        print(f"Downloaded file content: {json.dumps(content, indent=4)}")
else:
    print("File download failed.")
```

### Uploading a File
```python
res = upload_file('/path/to/your/file')
print(res)
```

## Conclusion
The `ipfsManager.py` script provides a comprehensive set of functions to interact with IPFS, enabling the upload and download of JSON objects and files. It also includes utility functions to manage file existence checks and retries for downloads, making it a versatile tool for IPFS operations.
