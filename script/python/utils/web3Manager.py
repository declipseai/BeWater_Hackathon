import os
import json
from web3 import Web3
from web3.middleware import geth_poa_middleware

# Get environment variables
rpc_url = os.getenv('RPC_URL')
contract_address = os.getenv('PLATFORM_CONTRACT_ADDRESS', '0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9')
private_key = os.getenv('DEPLOYER_PRIVATE_KEY')
user_pk = os.getenv('USER_PRIVATE_KEY')
master_pk = os.getenv('MASTER_PRIVATE_KEY')
sub1_pk = os.getenv('SUB1_PRIVATE_KEY')
sub2_pk = os.getenv('SUB2_PRIVATE_KEY')

# ABI path
abi_path = 'out/AIModelPlatform.sol/AIModelPlatform.abi.json'

# Connect to Ethereum Node
web3 = Web3(Web3.HTTPProvider(rpc_url))

# Use Geth POA middleware if connecting to a POA network
# web3.middleware_onion.inject(geth_poa_middleware, layer=0)

# Load contract ABI
with open(abi_path, 'r') as abi_file:
    contract_abi = json.load(abi_file)

# Generate contract
contract = web3.eth.contract(address=contract_address, abi=contract_abi)

def execute_transaction(_tx, private_key, gas=2000000, gas_price=web3.to_wei('50', 'gwei'), is_wait=True):
    """
    Function to execute a transaction.
    """
    account = web3.eth.account.from_key(private_key)
    tx = _tx.build_transaction({
        'from': account.address,
        'nonce': web3.eth.get_transaction_count(account.address),
        'gas': gas,
        'gasPrice': gas_price
    })
    signed_tx = web3.eth.account.sign_transaction(tx, private_key)
    tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)
    print(f'Transaction sent: {tx_hash.hex()}')
    if is_wait:
        tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
        print(f'Transaction receipt: {tx_receipt}')

def register_model(name, model_type, quantization_type, execution_code, model_data, calibration_data, private_key):
    """
    Function to register a model.
    """
    execute_transaction(contract.functions.registerModel(name, model_type, quantization_type, execution_code, model_data, calibration_data), private_key=private_key)

def create_request(request_data, model_id, private_key):
    """
    Function to create a request.
    """
    execute_transaction(contract.functions.createRequest(request_data, model_id), private_key=private_key)

def sub_node_raise_hand(requestId, private_key):
    """
    Function for sub-node to raise hand.
    """
    execute_transaction(contract.functions.subNodeRaiseHand(requestId), private_key=private_key)

def master_node_accept_subnode(subnode_addresses, requestId, private_key):
    """
    Function for master node to accept sub-node.
    """
    execute_transaction(contract.functions.masterNodeAcceptSubNode(subnode_addresses, requestId), private_key=private_key)
    
def sub_node_intermediate_answer(requestId, answerLink, private_key):
    """
    Function for sub-node to submit intermediate answer.
    """
    execute_transaction(contract.functions.subNodeIntermediateAnswer(requestId, answerLink), private_key=private_key)
    
def master_node_final_answer(requestId, answerLink, private_key):
    """
    Function for master node to submit final answer.
    """
    execute_transaction(contract.functions.masterNodeFinalAnswer(requestId, answerLink), private_key=private_key)
    
def assign_sub_node(subNodeAddress, performanceTier, private_key):
    """
    Function to assign sub-node.
    """
    execute_transaction(contract.functions.assignSubNode(subNodeAddress, performanceTier), private_key=private_key)
    
def assign_master_node(masterNodeAddress, private_key):
    """
    Function to assign master node.
    """
    execute_transaction(contract.functions.assignMasterNode(masterNodeAddress), private_key=private_key)

def get_model(model_id):
    """
    Function to get model details.
    """
    model = contract.functions.models(model_id).call()
    print(f"Model ID: {model[0]}")
    print(f"Name: {model[1]}")
    print(f"Model Type: {model[2]}")
    print(f"Quantization Type: {model[3]}")
    print(f"Execution Code: {model[4]}")
    print(f"Model Data: {model[5]}")
    print(f"Calibration Data: {model[6]}")
    return model
    
def get_request(request_id):
    """
    Function to get request details.
    """
    request = contract.functions.requests(request_id).call()
    print(f"Request ID: {request[0]}")
    print(f"Model ID: {request[1]}")
    print(f"Request Data: {request[2]}")
    print(f"User Address: {request[3]}")
    print(f"Status: {request[4]}")
    print(f"Final Answer - Master Node Address: {request[5][0]}")
    print(f"Final Answer - Answer Link: {request[5][1]}")
    return request

def get_subnode(node_address):
    """
    Function to get sub-node details.
    """
    subnode = contract.functions.subNodes(node_address).call()
    print(f"subNodeAddress: {subnode[0]}")
    print(f"failCount: {subnode[1]}")
    print(f"successCount: {subnode[2]}")
    print(f"performanceTier: {subnode[3]}")
    return subnode

def get_intermediate_answer(requestId, node_address):
    """
    Function to get intermediate answer details.
    """
    intermediate_answer = contract.functions.intermediateAnswers(requestId, node_address).call()
    print(f"answerLink: {intermediate_answer[0]}")
    print(f"status: {intermediate_answer[1]}")
    return intermediate_answer

# Event filters
event_filter_ModelRegistered = contract.events.ModelRegistered.create_filter(fromBlock='latest')
event_filter_RequestRegistered = contract.events.RequestRegistered.create_filter(fromBlock='latest')
event_filter_SubNodeRaiseHand = contract.events.SubNodeRaiseHand.create_filter(fromBlock='latest')
event_filter_MasterNodeAcceptSubNode = contract.events.MasterNodeAcceptSubNode.create_filter(fromBlock='latest')
event_filter_SubNodeIntermediateAnswer = contract.events.SubNodeIntermediateAnswer.create_filter(fromBlock='latest')
event_filter_MasterNodeFinalAnswer = contract.events.MasterNodeFinalAnswer.create_filter(fromBlock='latest')
