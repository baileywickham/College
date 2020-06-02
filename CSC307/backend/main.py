from flask import Flask, request, jsonify, Response
import flask_cors
import uuid
import random

app = Flask(__name__)
flask_cors.CORS(app)

users = {
        'users_list' :
        [
            {
                'id' : 'xyz789',
                'name' : 'Charlie',
                'job': 'Janitor',
                },
            {
                'id' : 'abc123',
                'name': 'Mac',
                'job': 'Bouncer',
                },
            {
                'id' : 'ppp222',
                'name': 'Mac',
                'job': 'Professor',
                },
            {
                'id' : 'yat999',
                'name': 'Dee',
                'job': 'Aspring actress',
                },
            {
                'id' : 'zap555',
                'name': 'Dennis',
                'job': 'Bartender',
                }
            ]
        }

@app.route('/users/<id>', methods=['GET', 'DELETE'])
def get_user(id):
    if request.method == 'GET':
        if id :
            for user in users['users_list']:
                if user['id'] == id:
                    return user
            return {}

    elif request.method == 'DELETE':
        if id :
            # Note, this will always return sucessful, even if no elm is found.
            # Also, it's not that efficent because it traverses the entire list
            users['users_list'] = list(filter(lambda x: x['id'] != id, users['users_list']))
            return Response(status=204)



@app.route('/')
@app.route('/users', methods=['POST', 'GET'])
def get_users():
    if request.method == 'GET':
        search_username = request.args.get('name')
        if search_username :
            return list(filter(lambda x: x['name'] == search_username, users['users_list']))
        return users

    elif request.method == 'POST':
        userToAdd = request.get_json()
        userToAdd['id'] = get_random_id()[0:6]
        users['users_list'].append(userToAdd)
        resp = jsonify(userToAdd) # Return user to front end to get UUID
        resp.status_code = 201
        return userToAdd


def get_random_id():
    # should be a hash of the name
    return str(uuid.uuid4())

if __name__ == "__main__":
    app.run(port=8080)
