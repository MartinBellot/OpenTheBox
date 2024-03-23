from flask import Flask, render_template
from flask_socketio import SocketIO

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('open_gift')
def open_gift():
    socketio.emit('open_gift', 'open_gift')

@socketio.on('receive_gift')
def receive_gift(json):
    socketio.emit('receive_gift', json)

if __name__ == '__main__':
    print("Server running at http://localhost:5000")
    socketio.run(app, debug=True, port=5000)
