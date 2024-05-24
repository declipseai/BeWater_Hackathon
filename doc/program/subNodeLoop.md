# subNodeLoop.md

## Introduction
The `subNodeLoop.py` script is designed to handle specific events emitted by the `AIModelPlatform` smart contract for Sub Nodes. This script utilizes threading to listen for `RequestRegistered` and `MasterNodeAcceptSubNode` events in real-time, processes these events, and interacts with the IPFS and blockchain to manage AI jobs and submit intermediate results.

## Setup

### Prerequisites
Ensure you have the necessary dependencies installed and correctly configured:
- `web3`: For interacting with the Ethereum blockchain.
- `torch`: For performing deep learning computations.
- `ipfshttpclient2`: For interacting with the IPFS.
- Custom utility modules: `web3Manager`, `eventThread`, `deeplearning`, and `ipfsManager`.

### Environment Variables
Make sure to set the required environment variables for connecting to the blockchain and managing private keys:
- `sub_pk`: Private key of the Sub Node. If not set, it defaults to `sub1_pk`.

### Initialization

### Importing Modules
The script imports necessary modules and functions from custom utilities.

```python
import threading
import time
import json
import os
from utils.web3Manager import * 
from utils.eventThread import * 
from utils.deeplearning import *
from utils.ipfsManager import check_and_download_and_return_file, upload_json
```

### Set Sub Node Private Key
The script retrieves the Sub Node private key from the environment variables.

```python
sub_pk = os.getenv('SUB_PRIVATE_KEY', sub1_pk)
print('Running Sub Node as ', web3.eth.account.from_key(sub_pk).address)
```

## Event Handlers

### `handle_RequestRegistered_event`
Handles `RequestRegistered` events by having the Sub Node raise its hand to indicate its interest in handling the request.

- **Parameters**:
  - `event`: The event data containing details about the `RequestRegistered` event.

```python
def handle_RequestRegistered_event(event):
    print("handle_RequestRegistered_event received!")
    sub_node_raise_hand(event['args']['requestId'], sub_pk)
```

### `handle_MasterNodeAcceptSubNode_event`
Handles `MasterNodeAcceptSubNode` events by checking if the Sub Node is selected, downloading necessary files from IPFS, performing AI jobs, and submitting the results.

- **Parameters**:
  - `event`: The event data containing details about the `MasterNodeAcceptSubNode` event.

```python
def handle_MasterNodeAcceptSubNode_event(event):
    print("handle_MasterNodeAcceptSubNode_event received!")
    account = web3.eth.account.from_key(sub_pk)
    if account.address in event['args']['subNodeAddresses']:
        print('This node is selected')
        print(event)

        # Get data from web3
        request_info = get_request(event['args']['requestId'])
        my_info = get_subnode(account.address)
        model_info = get_model(request_info[1])

        # Get necessary data
        my_tier = my_info[3]
        model_code_CID = model_info[4]
        model_CID = model_info[5]
        model_q_CID = model_info[6]
        request_CID = request_info[2]

        # Download files
        model_code_file = check_and_download_and_return_file(model_code_CID)
        model_file = check_and_download_and_return_file(model_CID)
        model_q_file = check_and_download_and_return_file(model_q_CID)
        request_file = check_and_download_and_return_file(request_CID)

        print('Doing some AI jobs...')

        # Processing Data
        label, confidence, raw_res, prob_res = classify_image(
            preprocess_image(request_file), 
            model_file if my_tier == 1 else model_q_file
        )
        print(f"\tSubnode) Tier: {my_tier}, Model: {model_file if my_tier == 1 else model_q_file}, Input: {request_file}")
        print(f"\tSubnode) Tier: {my_tier}, label: {label}, Output: {prob_res.tolist()}")

        # Upload result
        result = {
            'subnode_id': account.address,
            'result': label,
            'output': prob_res.tolist()
        }
        result_CID = upload_json(result)

        # Submit result
        sub_node_intermediate_answer(event['args']['requestId'], result_CID, sub_pk)
```

## Event Listener Threads

### `request_registered_thread`
Thread for listening to `RequestRegistered` events.

```python
request_registered_thread = threading.Thread(target=log_loop, args=(event_filter_RequestRegistered, 2, handle_RequestRegistered_event))
```

### `masternode_accept_thread`
Thread for listening to `MasterNodeAcceptSubNode` events.

```python
masternode_accept_thread = threading.Thread(target=log_loop, args=(event_filter_MasterNodeAcceptSubNode, 2, handle_MasterNodeAcceptSubNode_event))
```

### Starting Threads
The event listener threads are started to begin listening for events.

```python
request_registered_thread.start()
masternode_accept_thread.start()

print("Listening for events...")
```

## Main Program Loop
The main program loop keeps the script running and listens for a keyboard interrupt to stop the event listener threads gracefully.

```python
try:
    while True:
        time.sleep(10)
except KeyboardInterrupt:
    print("Stopped by user")
    request_registered_thread.join()
    masternode_accept_thread.join()
```

## Conclusion
The `subNodeLoop.py` script effectively handles event-driven interactions with the `AIModelPlatform` smart contract for Sub Nodes. It listens for events, processes them accordingly, downloads necessary files from IPFS, performs AI jobs, and submits intermediate results. The use of threading ensures that the script can handle multiple events concurrently, making it a robust solution for managing decentralized AI model execution and data labeling services.
