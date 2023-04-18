import os

import pymysql as mdb
from dbutils.pooled_db import PooledDB
from datetime import datetime

path = os.getcwd()
f = open('config', 'r')
lines = f.readlines()

POOL = PooledDB(
    creator=mdb,
    maxconnections=6,
    mincached=2,
    maxcached=5,
    maxshared=1,
    blocking=True,
    maxusage=None,
    setsession=[],
    ping=0,
    host=lines[1][0:-1],
    port=int(lines[3][0:-1]),
    user=lines[5][0:-1],
    password=lines[7][0:-1],
    database=lines[9][0:-1],
    charset='utf8'
)


class DB:
    conn = None
    cursor = None

    # create the database connection
    def create_conn(self):
        self.conn = POOL.connection()
        self.cursor = self.conn.cursor(mdb.cursors.DictCursor)

    # execute the sql
    def execute(self, sql, data):
        self.cursor.execute(sql, data)

    # commit the data
    def commit(self):
        self.conn.commit()

    # get the result from a sql execution
    def result(self, state):
        if state == 0:
            return self.cursor.fetchone()
        elif state == 1:
            return self.cursor.fetchall()
        else:
            return None

    # free the connection pool
    def close(self):
        self.conn.close()
        self.cursor.close()

    # get the encrypted password and salt
    def get_pw_salt(self, data):
        self.create_conn()
        self.execute('SELECT pwvalue,saltvalue FROM user '
                     'INNER JOIN salt ON user.userid = salt.userid '
                     'INNER JOIN pw ON user.userid = pw.userid WHERE username = %s', data)
        self.commit()
        results = self.result(0)
        self.close()
        return results

    # get the user id from username
    def get_userid(self, data):
        if data is None:
            return {'userid': 0}
        self.create_conn()
        self.execute('SELECT userid FROM user WHERE username = %s', data)
        self.commit()
        result = self.result(0)
        return result

    # update the user's avatar
    def update_avatar(self, data):
        self.create_conn()
        self.execute('INSERT INTO user(username, avatar) values(%s, %s)', data)
        self.commit()
        self.close()

    # create a pairs of encrypted password and salt
    def create_pw_salt(self, data):
        self.create_conn()
        self.execute('INSERT INTO pw(pwvalue) values(%s)', data[0])
        self.execute('INSERT INTO salt(saltvalue) values(%s)', data[1])
        self.commit()
        self.close()

    # get avatar of a user
    def get_avatar(self, data):
        self.create_conn()
        self.execute('SELECT avatar FROM user WHERE userid=%s', data)
        result = self.result(0)
        self.close()
        return result

    # update the user's name
    def upload_username(self, data):
        self.create_conn()
        self.execute('UPDATE user SET username=%s WHERE username=%s', data)
        self.commit()
        self.close()

    # update the user's encrypted password and salt
    def update_pw_salt(self, data):
        self.create_conn()
        self.execute('UPDATE pw SET pwvalue=%s WHERE userid=%s', [data[1], data[0]])
        self.execute('UPDATE salt SET saltvalue=%s WHERE userid=%s', [data[2], data[0]])
        self.commit()
        self.close()

    # update user's avatar
    def upload_avatar(self, data):
        self.create_conn()
        self.execute('UPDATE user SET avatar=%s WHERE userid=%s', data)
        self.commit()
        self.close()

    # upload weight record
    def upload_wei_rec(self, data):
        self.create_conn()
        id = int(data[0])
        date = datetime.strptime(data[1], '%y/%m/%d')
        weight = float(data[2])
        self.execute('INSERT INTO weight(id, date, weight) values(%s, %s, %s)', [id, date, weight])
        self.commit()
        self.close()

    # upload weight record
    def upload_meal_rec(self, data):
        self.create_conn()
        id = data[0]
        date = datetime.strptime(data[1], '%y/%m/%d')
        time = data[2]
        meal = data[3]
        self.execute('INSERT INTO meal(id, date, time, meal) values(%s, %s, %s, %s)', [id, date, time, meal])
        self.commit()
        self.close()

    def upload_exe_rec(self, data):
        self.create_conn()
        id = data[0]
        date = datetime.strptime(data[1], '%y/%m/%d')
        time = data[2]
        type = data[3]
        content = data[4]
        self.execute('INSERT INTO exe(id, date, time, type,content) values(%s, %s, %s, %s, %s)', [id, date, time, type, content])
        self.commit()
        self.close()

    def get_wei_rec(self, data):
        self.create_conn()
        id = int(data[0])
        self.execute('SELECT * FROM weight WHERE id = %s',id)

    def get_meal_rec(self, data):
        self.create_conn()
        id = int(data[0])
        self.execute('SELECT * FROM meal WHERE id = %s',id)

    def get_exe_rec(self, data):
        self.create_conn()
        id = int(data[0])
        self.execute('SELECT * FROM exe WHERE id = %s',id)
