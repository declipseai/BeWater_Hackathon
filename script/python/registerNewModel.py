from utils.web3Manager import * 
from utils.ipfsManager import upload_file

# Model details
model_name = 'Resnet50'
model_type = 'ImgClassification'
quant_type = 'QuantType1'

# Paths to model files
ExecutionCode1_path = 'script/python/.model_cache/resnet50_jit.pth'
ModelData1_path = 'script/python/.model_cache/resnet50_jit.pth'
CalibrationData1_path = 'script/python/.model_cache/quant_resnet50_jit.pth'

# Upload model files to IPFS and get CIDs
ExecutionCode1_cid = upload_file(ExecutionCode1_path)
ModelData1_cid = upload_file(ModelData1_path)
CalibrationData1_cid = upload_file(CalibrationData1_path)

# Register the model on the blockchain
register_model(
    model_name,
    model_type,
    quant_type,
    ExecutionCode1_cid,
    ModelData1_cid,
    CalibrationData1_cid,
    private_key
)
