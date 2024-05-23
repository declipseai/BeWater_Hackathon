import threading
import time
from utils.web3Manager import * 
from utils.eventThread import *

def handle_new_event(event):
    """
    Function to handle new model registered events.
    """
    print("New Model Registered!")
    print(event)
    # Add your event handling logic here.

# Start event listener in a background thread
event_listener_thread = threading.Thread(target=log_loop, args=(event_filter_ModelRegistered, 2, handle_new_event))
event_listener_thread.start()

print("Listening for events...")

# Keep the main program running
try:
    while True:
        time.sleep(10)
except KeyboardInterrupt:
    print("Stopped by user")
    event_listener_thread.join()
