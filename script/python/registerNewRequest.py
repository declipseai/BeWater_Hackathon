from utils.web3Manager import * 
from utils.ipfsManager import upload_file

# Model ID
modelId = 1

# Path to the file to be uploaded
file_path = 'script/python/input_data/car_img.jpg'

# Upload the file to IPFS and get the CID
request_cid = upload_file(file_path)

# Create a request on the blockchain with the CID and model ID
create_request(request_cid, modelId, user_pk)