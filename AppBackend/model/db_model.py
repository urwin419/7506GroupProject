import os

import pymysql as mdb
from dbutils.pooled_db import PooledDB

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
