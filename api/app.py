from flask import Flask, request, jsonify
import json

app = Flask(__name__)

@app.route('/', methods = ['GET', 'POST'])
def index():

	if (request.method == 'POST'):
		data = request.data
		data = json.loads(data.decode('utf-8'))
		return jsonify(data=data['name'])

if __name__ == '__main__':
	app.run()