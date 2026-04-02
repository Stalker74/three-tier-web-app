from flask import Flask, render_template, request, redirect, make_response
import json
import requests

app = Flask(__name__)
APP_URL = "http://app-service:4000"

@app.route('/')
def index():
    todos = {}
    try:
        response = requests.get(f"{APP_URL}/", timeout=60)
        todos = json.loads(response.content)
    except Exception:
        pass
    return render_template('index.html', todos=todos)

@app.route('/api/create', methods=['POST'])
def create():
    try:
        requests.post(f"{APP_URL}/create", data=request.form, timeout=60)
    except Exception:
        pass
    return redirect('/')

@app.route('/api/update', methods=['POST'])
def update():
    try:
        requests.post(f"{APP_URL}/update", data=request.form, timeout=60)
    except Exception:
        pass
    return redirect('/')

@app.route('/api/complete/<task_id>', methods=['POST'])
def complete(task_id):
    try:
        requests.post(f"{APP_URL}/complete/{task_id}", timeout=60)
    except Exception:
        pass
    return redirect('/')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
