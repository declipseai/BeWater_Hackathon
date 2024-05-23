import threading
import time

def handle_event(event):
    """
    Function to handle the received event.
    """
    print("Event received!")
    print(event)
    # Add your event handling logic here.

def log_loop(event_filter, poll_interval, callback=handle_event):
    """
    Function to continuously poll for new events and handle them using the provided callback.
    """
    while True:
        for event in event_filter.get_new_entries():
            callback(event)
        time.sleep(poll_interval)

# Example usage:
# Assuming you have an event filter object `event_filter` and you want to poll every 2 seconds.
# log_loop(event_filter, 2)