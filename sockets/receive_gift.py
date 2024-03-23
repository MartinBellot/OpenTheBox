import socketio

sio = socketio.Client()

@sio.event
def connect():
    print("I'm connected!")
    gift = {
        "titre": "Caca",
        "description": "yoyoyoyo.",
        "images": ["image1.jpg", "image2.jpg"],
        "musique": "music.mp3"
    }
    sio.emit('receive_gift', gift)

@sio.event
def disconnect():
    print("I'm disconnected!")

sio.connect('http://localhost:5000')
sio.wait()