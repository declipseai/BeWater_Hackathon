# web3Manager.md

## Introduction
The `web3Manager.py` script provides a set of functions to interact with the `AIModelPlatform` smart contract deployed on an Ethereum blockchain. This script leverages the Web3.py library to perform various actions such as registering models, creating requests, and managing Sub Nodes and Master Nodes. Additionally, it includes event filters to track specific contract events.

## Setup

### Environment Variables
The script relies on several environment variables for configuration:
- `RPC_URL`: URL of the Ethereum node.
- `PLATFORM_CONTRACT_ADDRESS`: Address of the deployed `AIModelPlatform` contract (default: `'0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9'`).
- `DEPLOYER_PRIVATE_KEY`: Private key of the deployer.
- `USER_PRIVATE_KEY`: Private key of the user.
- `MASTER_PRIVATE_KEY`: Private key of the Master Node.
- `SUB1_PRIVATE_KEY`: Private key of the first Sub Node.
- `SUB2_PRIVATE_KEY`: Private key of the second Sub Node.

### ABI Path
- `abi_path`: Path to the ABI file of the `AIModelPlatform` contract (default: `'out/AIModelPlatform.sol/AIModelPlatform.abi.json'`).

## Connecting to Ethereum Node
The script connects to the Ethereum node using the provided RPC URL.

```python
web3 = Web3(Web3.HTTPProvider(rpc_url))
```

## Contract Initialization
The ABI of the contract is loaded from the specified path, and the contract instance is created.

```python
with open(abi_path, 'r') as abi_file:
    contract_abi = json.load(abi_file)

contract = web3.eth.contract(address=contract_address, abi=contract_abi)
```

## Functions

### `execute_transaction`
Executes a transaction on the Ethereum blockchain.

- **Parameters**:
  - `_tx`: The transaction object.
  - `private_key`: The private key of the account initiating the transaction.
  - `gas`: (Optional) The gas limit for the transaction (default: `2000000`).
  - `gas_price`: (Optional) The gas price for the transaction (default: `web3.to_wei('50', 'gwei')`).
  - `is_wait`: (Optional) Boolean indicating whether to wait for the transaction receipt (default: `True`).

```python
def execute_transaction(_tx, private_key, gas=2000000, gas_price=web3.to_wei('50', 'gwei'), is_wait=True):
    ...
```

### `register_model`
Registers a new AI model.

- **Parameters**:
  - `name`: The name of the model.
  - `model_type`: The type of the model.
  - `quantization_type`: The quantization type of the model.
  - `execution_code`: The execution code for the model.
  - `model_data`: The model data.
  - `calibration_data`: The calibration data.
  - `private_key`: The private key of the account registering the model.

```python
def register_model(name, model_type, quantization_type, execution_code, model_data, calibration_data, private_key):
    ...
```

### `create_request`
Creates a new request for a model.

- **Parameters**:
  - `request_data`: The data for the request.
  - `model_id`: The ID of the model for which the request is made.
  - `private_key`: The private key of the account creating the request.

```python
def create_request(request_data, model_id, private_key):
    ...
```

### `sub_node_raise_hand`
Allows a Sub Node to express interest in handling a request.

- **Parameters**:
  - `requestId`: The ID of the request.
  - `private_key`: The private key of the Sub Node.

```python
def sub_node_raise_hand(requestId, private_key):
    ...
```

### `master_node_accept_subnode`
Allows a Master Node to accept Sub Nodes for a request.

- **Parameters**:
  - `subnode_addresses`: The addresses of the Sub Nodes.
  - `requestId`: The ID of the request.
  - `private_key`: The private key of the Master Node.

```python
def master_node_accept_subnode(subnode_addresses, requestId, private_key):
    ...
```

### `sub_node_intermediate_answer`
Allows a Sub Node to submit an intermediate answer.

- **Parameters**:
  - `requestId`: The ID of the request.
  - `answerLink`: The link to the intermediate answer.
  - `private_key`: The private key of the Sub Node.

```python
def sub_node_intermediate_answer(requestId, answerLink, private_key):
    ...
```

### `master_node_final_answer`
Allows a Master Node to submit the final answer.

- **Parameters**:
  - `requestId`: The ID of the request.
  - `answerLink`: The link to the final answer.
  - `private_key`: The private key of the Master Node.

```python
def master_node_final_answer(requestId, answerLink, private_key):
    ...
```

### `assign_sub_node`
Assigns a Sub Node.

- **Parameters**:
  - `subNodeAddress`: The address of the Sub Node.
  - `performanceTier`: The performance tier of the Sub Node.
  - `private_key`: The private key of the account assigning the Sub Node.

```python
def assign_sub_node(subNodeAddress, performanceTier, private_key):
    ...
```

### `assign_master_node`
Assigns a Master Node.

- **Parameters**:
  - `masterNodeAddress`: The address of the Master Node.
  - `private_key`: The private key of the account assigning the Master Node.

```python
def assign_master_node(masterNodeAddress, private_key):
    ...
```

### `get_model`
Retrieves details of a model.

- **Parameters**:
  - `model_id`: The ID of the model.
- **Returns**: The details of the model.

```python
def get_model(model_id):
    ...
```

### `get_request`
Retrieves details of a request.

- **Parameters**:
  - `request_id`: The ID of the request.
- **Returns**: The details of the request.

```python
def get_request(request_id):
    ...
```

### `get_subnode`
Retrieves details of a Sub Node.

- **Parameters**:
  - `node_address`: The address of the Sub Node.
- **Returns**: The details of the Sub Node.

```python
def get_subnode(node_address):
    ...
```

### `get_intermediate_answer`
Retrieves details of an intermediate answer.

- **Parameters**:
  - `requestId`: The ID of the request.
  - `node_address`: The address of the Sub Node.
- **Returns**: The details of the intermediate answer.

```python
def get_intermediate_answer(requestId, node_address):
    ...
```

## Event Filters
The script includes event filters to track specific events emitted by the `AIModelPlatform` contract. These events can be used to monitor the contract's activity in real-time.

```python
event_filter_ModelRegistered = contract.events.ModelRegistered.create_filter(fromBlock='latest')
event_filter_RequestRegistered = contract.events.RequestRegistered.create_filter(fromBlock='latest')
event_filter_SubNodeRaiseHand = contract.events.SubNodeRaiseHand.create_filter(fromBlock='latest')
event_filter_MasterNodeAcceptSubNode = contract.events.MasterNodeAcceptSubNode.create_filter(fromBlock='latest')
event_filter_SubNodeIntermediateAnswer = contract.events.SubNodeIntermediateAnswer.create_filter(fromBlock='latest')
event_filter_MasterNodeFinalAnswer = contract.events.MasterNodeFinalAnswer.create_filter(fromBlock='latest')
```

## Conclusion
The `web3Manager.py` script provides a comprehensive set of functions to interact with the `AIModelPlatform` smart contract. It facilitates the registration of models, creation of requests, management of Sub Nodes and Master Nodes, and real-time event monitoring. By leveraging the Web3.py library, it ensures secure and efficient interactions with the Ethereum blockchain.
