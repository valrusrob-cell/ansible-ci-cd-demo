from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    return f"""
    <html>
        <body>
            <h1>Hello from Docker Container!</h1>
            <p>Hostname: {socket.gethostname()}</p>
            <p>Version: 12.0.0</p>
        </body>
    </html>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)