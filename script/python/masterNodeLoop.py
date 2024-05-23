import threading
import time
import json
import torch
from utils.web3Manager import * 
from utils.eventThread import * 
from utils.deeplearning import *
from utils.ipfsManager import check_and_download_and_return_file, upload_json, download_path

# Request and result sets to track events
requestSet = {}
resultSet = {}

# Thresholds for handling events
threshHold1 = 2
threshHold2 = 2

def handle_RaiseHand_event(event):
    """
    Function to handle RaiseHand events.
    """
    print("handle_RaiseHand_event received!")
    get_request(event['args']['requestId'])
    requestSet.setdefault(event['args']['requestId'], [])
    requestSet[event['args']['requestId']].append(event['args']['subNodeAddress'])

    subnodes = requestSet[event['args']['requestId']]

    if len(subnodes) >= threshHold1:
        master_node_accept_subnode(subnodes, event['args']['requestId'], master_pk)
    else:
        print('threshHold not reached')

def handle_InterMidateAnswer_event(event):
    """
    Function to handle IntermediateAnswer events.
    """
    print("handle_InterMidateAnswer_event received!")
    answerInfo = get_intermediate_answer(event['args']['requestId'], event['args']['subNodeAddress'])
    subnode_info = get_subnode(event['args']['subNodeAddress'])

    resultSet.setdefault(event['args']['requestId'], [])
    resultSet[event['args']['requestId']].append([event['args']['subNodeAddress'], answerInfo[0], subnode_info[3]])

    subnodes = resultSet[event['args']['requestId']]
    if len(subnodes) >= threshHold2:
        intermediate_results_files = []
        for nodeAnswer in subnodes:
            result_file = check_and_download_and_return_file(nodeAnswer[1])
            with open(result_file, 'r') as file:
                content = json.load(file)
                print(content)
                intermediate_results_files.append(content)

        # Ensemble output from sub-nodes
        nodes_list = [torch.tensor([ele['output']]) for ele in intermediate_results_files]
        final_res, _, _ = ensemble_output(nodes_list)

        result = {
            'ensemble_res': final_res,
            'nodes_res': [ele['result'] for ele in intermediate_results_files] 
        }
        print("Final Res: ", result)

        # Upload final result to IPFS
        final_result_CID = upload_json(json.dumps(result))
        master_node_final_answer(event['args']['requestId'], final_result_CID, master_pk)
    else:
        print('threshHold not reached')

# Start event listeners in background threads
subnode_raise_hand_thread = threading.Thread(target=log_loop, args=(event_filter_SubNodeRaiseHand, 2, handle_RaiseHand_event))
subnode_intermediate_answer_thread = threading.Thread(target=log_loop, args=(event_filter_SubNodeIntermediateAnswer, 2, handle_InterMidateAnswer_event))

subnode_raise_hand_thread.start()
subnode_intermediate_answer_thread.start()

print("Listening for events...")

# Keep the main program running
try:
    while True:
        time.sleep(10)
except KeyboardInterrupt:
    print("Stopped by user")
    subnode_raise_hand_thread.join()
    subnode_intermediate_answer_thread.join()
