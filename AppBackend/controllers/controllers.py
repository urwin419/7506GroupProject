import base64
import hashlib
import html
import json
import os
import random
import time
from datetime import timedelta, datetime

import pagan
import jwt


# get the md5 from the string input
def get_md5(s):
    md = hashlib.md5()
    md.update(s.encode('utf-8'))
    return md.hexdigest()


# get a rand string
def rand_str(num):
    str_r = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    salt = ''
    for i in range(num):
        salt += random.choice(str_r)
    return salt


# get the processed password
def pw_process(username, password):
    time_stamp = str(int(time.time()))
    salt = get_md5(username + time_stamp + rand_str(16))
    pw_processed = get_md5(get_md5(password) + salt)
    return [pw_processed, salt]


# update the editor's file
def uploaded_editor_files_con(request):
    image = request.files['image']
    if image:
        image.filename = html.escape(image.filename, True)
        content_type = image.content_type
        image.seek(0)

        data = image.read()
        return "data:{};base64,{}".format(content_type, base64.b64encode(data).decode("utf-8"))
    return request.form.image.data


# define the controller layer
class Controller(object):
    def __init__(self, app, conn):
        self.app = app
        self.conn = conn

    def generate_jwt_token(self, user_id):
        payload = {
            'user_id': user_id,
            'exp': datetime.utcnow() + timedelta(days=1)
        }
        jwt_token = jwt.encode(payload, self.app.secret_key, algorithm='HS256')
        return jwt_token

    # get the login form
    def post_login_get_fun(self, request):
        username = request.form['username']
        password = request.form['password']
        db = self.conn
        results = db.get_pw_salt(username)
        if results is not None:
            pw_processed = get_md5(get_md5(password) + results['saltvalue'])
            if pw_processed == results['pwvalue']:
                token = self.generate_jwt_token(db.get_userid(username))
                return {'status': 1, 'token': token}
            else:
                return {'status': 2}
        else:
            return {'status': 2}

    # get the form of register
    def post_register_fun(self, request):
        username = request.form['username']
        password = request.form['password']
        if username == '' or password == '':
            return {'status': 3}
        pw_processed_salt = pw_process(username, password)
        db = self.conn
        result = db.get_userid(username)
        if result is None:
            input_str = str(os.urandom(12))
            img = pagan.Avatar(input_str, pagan.SHA512)
            img.save('static/res/avatar', 'buffer')
            pic = open('static/res/avatar/buffer.png', 'rb')
            pic_base64 = 'data:image/png;base64,' + str(base64.b64encode(pic.read()))[2:-1]
            db.update_avatar([username, pic_base64])
            db.create_pw_salt(pw_processed_salt)
            # db.create_user_table(username)
            token = self.generate_jwt_token(db.get_userid(username))
            return {'status': 1, 'token': token}
        else:
            db.close()
            return {'status': 2}

    def get_username(self, user_data):
        db = self.conn
        username = db.get_username(user_data['userid'])
        db.close()
        return {'status': 1, 'username': username}

    # get the user's avatar
    def get_avatar_fun(self, user_data):
        db = self.conn
        result = db.get_avatar(user_data['userid'])
        db.close()
        return {'url': result['avatar']}

    # get the upload of the new username
    def upload_username_fun(self, user_data, request):
        username = request.form['username']
        if username == '':
            return {'status': 2}
        else:
            db = self.conn
            result = db.get_userid(username)
            if result is None:
                db.upload_username([username, user_data['userid']])
                return {'name': db.get_username(user_data['userid']), 'status': 1}
            else:
                return {'status': 3}

    # get the new password
    def upload_password_fun(self, user_data, request):
        db = self.conn
        username = db.get_username(user_data['userid'])
        old_password = request.form['old_password']
        password = request.form['password']

        if old_password == '' or password == '':
            return {'status': 2}

        db = self.conn
        results = db.get_pw_salt(username)

        pw_processed = get_md5(get_md5(old_password) + results['saltvalue'])
        if pw_processed == results['pwvalue']:
            time_stamp = str(int(time.time()))
            salt = get_md5(username + time_stamp + rand_str(16))
            pw_processed = get_md5(get_md5(password) + salt)
            result = db.get_userid(username)
            if results is not None:
                db.update_pw_salt([result['userid'], pw_processed, salt])
                return {'status': 1}
            else:
                db.close()
                return {'status': 2}
        else:
            db.close()
            return {'status': 2}

    # get the upload avatar
    def upload_avatar_fun(self, user_data, request):
        avatar = request.form['avatar']
        db = self.conn
        db.upload_avatar([avatar, user_data['userid']])
        return {'status': 1}
