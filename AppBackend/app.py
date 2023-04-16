from flask import Flask
import os
from flask import Flask, request, session, url_for, redirect
from flask_cors import CORS
from model.db_model import DB
from controllers.controllers import Controller, get_name

app = Flask(__name__)

app.config['SECRET_KEY'] = os.urandom(24)


@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World!'


@app.route('/post_login', methods=['POST'])
def post_login():
    controller = Controller(app, DB(), session)
    return controller.post_login_get_fun(request)


@app.route('/post_register', methods=['POST'])
def post_register():
    controller = Controller(app, DB(), session)
    return controller.post_register_fun(request)


# get the avatar from the user
@app.route('/get_avatar', methods=['GET'])
def get_avatar():
    controller = Controller(app, DB(), session)
    return controller.get_avatar_fun()


# get the username
@app.route('/get_username', methods=['GET'])
def get_username():
    return get_name()


# get the upload of the username
@app.route('/upload_username', methods=['POST'])
def upload_username():
    controller = Controller(app, DB(), session)
    return controller.upload_username_fun(request)


# get the upload form of the password update
@app.route('/upload_password', methods=['POST'])
def upload_password():
    controller = Controller(app, DB(), session)
    return controller.upload_password_fun(request)


# get the upload avatar form
@app.route('/upload_avatar', methods=['POST'])
def upload_avatar():
    controller = Controller(app, DB(), session)
    return controller.upload_avatar_fun(request)


# get the logout action
@app.route('/log_out', methods=['GET'])
def log_out():
    session.pop('username')
    return {'status': 1}

# upload weight record
@app.route('/rec_wei', methods=['POST'])
def rec_wei():
    controller = Controller(app, DB(), session)
    return controller.rec_wei_func(request)

# upload meal record
@app.route('/rec_meal', methods=['POST'])
def rec_meal():
    controller = Controller(app, DB(), session)
    return controller.rec_meal_func(request)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
    CORS(app, supports_credentials=True)
