import paho.mqtt.client as mqtt

def on_connect(client, userdata, flags, rc):
    print('connected (%s)' % client._client_id)
    client.subscribe(topic='topic/test', qos=2)
def on_message(client, userdata, message):
    status = str(message.payload.decode("utf-8"))
    print("message received " , status)
    print("message topic=",message.topic)
    print("message qos=",message.qos)
    print("message retain flag=",message.retain)

def main():
    broker_address="b-64160930-1437-447e-a084-0f0e5ed98c68-1.mq.eu-west-1.amazonaws.com"
    print('connecting ',broker_address)
    client = mqtt.Client('Console')
    client.username_pw_set('mqtt', 'LOvehuihui1314')
    client.on_connect=on_connect
    client.on_message=on_message
    client.tls_set('/home/gray/pem/AmazonRootCA1.pem')
    client.connect(broker_address, port=8883)
    client.loop_forever()




if __name__ == "__main__":
    main()
