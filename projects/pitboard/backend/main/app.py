from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify(status='ok')

@app.route('/v1/items')
def items():
    return jsonify(items=[{"id": 1, "name": "sample item"}])

if __name__ == '__main__':
    app.run(port=8000)
