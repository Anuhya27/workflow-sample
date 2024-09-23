# from datetime import datetime
from pandarallel import pandarallel
from simple_salesforce import Salesforce

pandarallel.initialize(nb_workers=30)

def print_time():
    print("Hello, there!")
    # print("time:", datetime.now())

if __name__ == "__main__":
    print_time()