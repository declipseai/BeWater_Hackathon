import threading
import time
from utils.web3Manager import * 
from utils.eventThread import * 

def handle_Final_event(event):
    """
    Function to handle Final events.
    """
    print("handle_Final_event received!")
    print(event)
    print(event['args'])
    print(event['args']['requestId'])
    get_request(event['args']['requestId'])

# Start event listener in a background thread
subnode_final_answer_thread = threading.Thread(target=log_loop, args=(event_filter_MasterNodeFinalAnswer, 2, handle_Final_event))

subnode_final_answer_thread.start()

print("Listening for events...")

# Keep the main program running
try:
    while True:
        time.sleep(10)
except KeyboardInterrupt:
    print("Stopped by user")
    subnode_final_answer_thread.join()