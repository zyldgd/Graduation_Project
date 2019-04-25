# coding:utf-8
import sys

from werkzeug._internal import _log


sys.path.append('/var/www/isounderz_bms/pro/')
import socket
import json
from modules.apps.app import app
from modules.mysocket.device_server import thread_server
from apps import deployDeviceHelpers

__PORT__ = 80
__HOST__ = '0.0.0.0'


def get_ip():
    return socket.gethostbyname_ex(socket.gethostname())[-1][-1]

'''
    CREATE TABLE devices (
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        deviceId VARCHAR(255) UNIQUE NOT NULL,
        deviceName VARCHAR(255) NOT NULL,
        deviceType VARCHAR(255) NULL,
        deviceLocation VARCHAR(255) NULL,
        remark VARCHAR(1024) NULL,
        pic BLOB NULL
        ) DEFAULT CHARSET=utf8;
'''

'''
 CREATE TABLE IF NOT EXISTS user(
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(64) UNIQUE  NOT NULL,
        password TINYBLOB  NOT NULL,
        remark VARCHAR(1024) NULL,
        email VARCHAR(64)  UNIQUE NOT NULL,
        tip VARCHAR(64) NULL,
        authority VARCHAR(64) DEFAULT 'visitor',
        pic BLOB NULL) DEFAULT CHARSET=utf8;
'''

'''
CREATE TABLE IF NOT EXISTS probeData(
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        deviceId VARCHAR(255) NOT NULL,
        date DATE DEFAULT NULL,
        time TIME DEFAULT NULL,
        data MEDIUMTEXT NULL) DEFAULT CHARSET=utf8;
'''

# raise Exception("抛出一个异常")

if __name__ == '__main__':
    #_log('info', 'HostIP : http://{0}:{1}/'.format(get_ip(), __PORT__))
    threadServer = thread_server(1, "Thread-1")
    threadServer.setDaemon(True)
    threadServer.start()
    # add_probe_data2("asd")
    # a = get_probe_data()
    # print(a)
    deployDeviceHelpers()
    app.run(host=get_ip(), port=__PORT__, debug=True, use_reloader=False)

    threadServer.join()