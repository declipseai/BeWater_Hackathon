import threading
import time
import json
import os
from utils.web3Manager import * 
from utils.eventThread import * 
from utils.deeplearning import *
from utils.ipfsManager import check_and_download_and_return_file, upload_json

# Get the sub-node private key
sub_pk = os.getenv('SUB_PRIVATE_KEY', sub1_pk)

print('Running Sub Node as ', web3.eth.account.from_key(sub_pk).address)

def handle_RequestRegistered_event(event):
    """
    Function to handle RequestRegistered events.
    """
    print("handle_RequestRegistered_event received!")
    sub_node_raise_hand(event['args']['requestId'], sub_pk)

def handle_MasterNodeAcceptSubNode_event(event):
    """
    Function to handle MasterNodeAcceptSubNode events.
    """
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

# Start event listeners in background threads
request_registered_thread = threading.Thread(target=log_loop, args=(event_filter_RequestRegistered, 2, handle_RequestRegistered_event))
masternode_accept_thread = threading.Thread(target=log_loop, args=(event_filter_MasterNodeAcceptSubNode, 2, handle_MasterNodeAcceptSubNode_event))

request_registered_thread.start()
masternode_accept_thread.start()

print("Listening for events...")

# Keep the main program running
try:
    while True:
        time.sleep(10)
except KeyboardInterrupt:
    print("Stopped by user")
    request_registered_thread.join()
    masternode_accept_thread.join()
