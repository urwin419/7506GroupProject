import os
from datetime import datetime
from functools import wraps

import jwt
from flask import Flask, request
from flask_cors import CORS

from controllers.controllers import Controller
from model.db_model import DB

app = Flask(__name__)

app.config['SECRET_KEY'] = os.urandom(24)


def validate_jwt_token(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        try:
            jwt_token = request.args['token']
            payload = jwt.decode(jwt_token, app.secret_key, algorithms=['HS256'])

            user_id = payload['user_id']
            expire_time = payload['exp']
            if int(datetime.utcnow().timestamp()) > expire_time:
                return {'status': 2}

            return f(user_id, *args, **kwargs)

        except Exception as e:
            print(e)
            # 处理错误情况
            return {'status': 1}

    return decorated_function


@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World!'


@app.route('/post_login', methods=['POST'])
def post_login():
    controller = Controller(app, DB())
    return controller.post_login_get_fun(request)


@app.route('/post_register', methods=['POST'])
def post_register():
    controller = Controller(app, DB())
    return controller.post_register_fun(request)


# get the avatar from the user

@app.route('/get_avatar', methods=['GET'])
@validate_jwt_token
def get_avatar(user_id):
    controller = Controller(app, DB())
    return controller.get_avatar_fun(user_id)


# get the username
@app.route('/get_username', methods=['GET'])
@validate_jwt_token
def get_username(user_id):
    controller = Controller(app, DB())
    return controller.get_username(user_id)


# get the upload of the username
@app.route('/upload_username', methods=['POST'])
@validate_jwt_token
def upload_username(user_id):
    controller = Controller(app, DB())
    return controller.upload_username_fun(user_id, request)


# get the upload form of the password update
@app.route('/upload_password', methods=['POST'])
@validate_jwt_token
def upload_password(user_id):
    controller = Controller(app, DB())
    return controller.upload_password_fun(user_id, request)


# get the upload avatar form
@app.route('/upload_avatar', methods=['POST'])
@validate_jwt_token
def upload_avatar(user_id):
    controller = Controller(app, DB())
    return controller.upload_avatar_fun(user_id, request)


# get the logout action
@app.route('/log_out', methods=['GET'])
def log_out():
    return {'status': 1}


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
    CORS(app, supports_credentials=True)
