import requests
import time
while (True):
    r = requests.get('http://192.168.69.69')
    print(r.text)
    time.sleep(2)
