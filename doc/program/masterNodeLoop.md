# MasterNode.md

## Introduction
The `MasterNode.py` script is designed to handle specific events emitted by the `AIModelPlatform` smart contract. This script utilizes threading to listen for `RaiseHand` and `IntermediateAnswer` events in real-time, processes these events, and interacts with the IPFS and blockchain to manage requests and compute final results.

## Setup

### Prerequisites
Ensure you have the necessary dependencies installed and correctly configured:
- `web3`: For interacting with the Ethereum blockchain.
- `torch`: For performing deep learning computations.
- `ipfshttpclient2`: For interacting with the IPFS.
- Custom utility modules: `web3Manager`, `eventThread`, `deeplearning`, and `ipfsManager`.

### Environment Variables
Make sure to set the required environment variables for connecting to the blockchain and managing private keys:
- `master_pk`: Private key of the Master Node.

## Initialization

### Importing Modules
The script imports necessary modules and functions from custom utilities.

```python
import threading
import time
import json
import torch
from utils.web3Manager import * 
from utils.eventThread import * 
from utils.deeplearning import *
from utils.ipfsManager import check_and_download_and_return_file, upload_json, download_path
```

### Event Tracking
The script maintains dictionaries to track requests and results.

```python
requestSet = {}
resultSet = {}
```

### Thresholds
Threshold values to determine when to process events.

```python
threshHold1 = 2
threshHold2 = 2
```

## Event Handlers

### `handle_RaiseHand_event`
Handles `RaiseHand` events by tracking Sub Nodes expressing interest in handling a request.

- **Parameters**:
  - `event`: The event data containing details about the `RaiseHand` event.

```python
def handle_RaiseHand_event(event):
    ...
```

### `handle_InterMidateAnswer_event`
Handles `IntermediateAnswer` events by processing intermediate results from Sub Nodes and performing ensemble computations to determine the final result.

- **Parameters**:
  - `event`: The event data containing details about the `IntermediateAnswer` event.

```python
def handle_InterMidateAnswer_event(event):
    ...
```

## Event Listener Threads

### `subnode_raise_hand_thread`
Thread for listening to `RaiseHand` events.

```python
subnode_raise_hand_thread = threading.Thread(target=log_loop, args=(event_filter_SubNodeRaiseHand, 2, handle_RaiseHand_event))
```

### `subnode_intermediate_answer_thread`
Thread for listening to `IntermediateAnswer` events.

```python
subnode_intermediate_answer_thread = threading.Thread(target=log_loop, args=(event_filter_SubNodeIntermediateAnswer, 2, handle_InterMidateAnswer_event))
```

### Starting Threads
The event listener threads are started to begin listening for events.

```python
subnode_raise_hand_thread.start()
subnode_intermediate_answer_thread.start()

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
    subnode_raise_hand_thread.join()
    subnode_intermediate_answer_thread.join()
```

## Conclusion
The `MasterNode.py` script effectively handles event-driven interactions with the `AIModelPlatform` smart contract. It listens for events, processes them accordingly, and leverages IPFS and deep learning techniques to manage requests and compute results. The use of threading ensures that the script can handle multiple events concurrently, making it a robust solution for managing the decentralized AI model execution and data labeling service.
