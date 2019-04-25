# coding:utf-8
import json

import pymysql
from flask import jsonify, request, session

from modules.apps.app import app
from modules.mysocket.device_server import deviceHelpers, deviceHelper

ionolabDB = None
cursor = None
__DB_HOST__ = 'zylcy.cn'  # '127.0.0.1'

devicesBaseStatus = {}


def getDeviceData(deviceId=None):
    if deviceId is None:
        return get_devices('deviceId, deviceName, deviceType, deviceLocation, remark')
    else:
        return get_devices('deviceId, deviceName, deviceType, deviceLocation, remark', 'WHERE deviceId="{0}"'.format(deviceId))[0]


def deployDeviceHelpers():
    for r in getDeviceData():
        deviceId = r[0]
        deviceHelpers[deviceId] = deviceHelper(deviceId)  # type:deviceHelper
        deviceHelpers[deviceId].deviceName = r[1]
        deviceHelpers[deviceId].deviceType = r[2]
        deviceHelpers[deviceId].deviceLocation = r[3]
        deviceHelpers[deviceId].remark = r[4]
        print("Deploy DeviceHelper [%s]" % deviceId)


@app.route('/data/devicesStatus')
def devicesStatus():
    devices_data = getDeviceData()
    rows = []
    for r in devices_data:
        deviceId = r[0]
        deviceState = "未连接"
        if deviceId in deviceHelpers:
            curDeviceHelper = deviceHelpers[deviceId]  # type:deviceHelper
            deviceState = "在线" if curDeviceHelper.online else "未连接"
        row = {"deviceId": deviceId, "deviceName": r[1], "deviceType": r[2], "deviceLocation": r[3], "deviceState": deviceState}
        rows.append(row)
    return jsonify({"code": 0, "msg": "", "count": 4096, "data": rows})


@app.route('/data/deviceStatus', methods=['POST', 'GET'])
def deviceStatus():
    if request.method == 'POST':
        requestData = json.loads(request.data.decode('utf-8'))
        if session.get('curDeviceId'):
            deviceId = session['curDeviceId']
            if deviceId in deviceHelpers:
                data = {}
                curDeviceHelper = deviceHelpers[deviceId]  # type:deviceHelper

                data.update(curDeviceHelper.status)
                return jsonify(data)
    return jsonify('err')


# =================================================================

def connect_database():
    global ionolabDB, cursor
    try:
        ionolabDB = pymysql.connect(host=__DB_HOST__, user="ionolabDB_admin", password="ionolab2019", database='ionolabDB', charset='utf8')
        cursor = ionolabDB.cursor()
    except Exception:
        print("database connect failed!")
        return False
    else:
        print("database connect succeeded!")
        return True


def disconnect_database():
    try:
        ionolabDB.close()
    except:
        print("database disconnect failed!")
        return False
    return True


def commit(sql: str, args=None):
    try:
        connect_database()
        if args is None:
            cursor.execute(sql)
        else:
            cursor.execute(sql, args)
        ionolabDB.commit()
    except:
        ionolabDB.rollback()
        print("{0} --- sql commit failed！".format(sql))
        return False
    finally:
        disconnect_database()

    return True


# =================================================================

def add_new_device(deviceId, deviceName, deviceType='', deviceLocation='', remark=''):
    return commit(
        "INSERT INTO devices(deviceId,deviceName,deviceType,deviceLocation,remark) VALUES ('{0}', '{1}', '{2}', '{3}', '{4}');".format(deviceId, deviceName, deviceType, deviceLocation, remark))


def modify_device(deviceId, deviceName, deviceType='', deviceLocation='', remark=''):
    result = commit(
        "UPDATE devices SET deviceName = '{1}', deviceType = '{2}', deviceLocation = '{3}', remark = '{4}' WHERE deviceId = '{0}';".format(deviceId, deviceName, deviceType, deviceLocation, remark))
    if result:
        if deviceId in deviceHelpers:
            deviceHelpers[deviceId].deviceName = deviceName
            deviceHelpers[deviceId].deviceType = deviceType
            deviceHelpers[deviceId].deviceLocation = deviceLocation
            deviceHelpers[deviceId].remark = remark
    return result


def delete_device(deviceId):
    return commit(
        "DELETE FROM devices WHERE deviceId = '{0}';".format(deviceId))


def get_devices(columns: str, condition: str = ''):
    # deviceId, deviceName, deviceType, deviceLocation
    if commit("SELECT {0} FROM devices {1};".format(columns, condition)):
        devices = cursor.fetchall()
        return devices
    else:
        return False


def has_devicesId(deviceId):
    if commit("SELECT 1 FROM devices WHERE deviceId='{0}';".format(deviceId)):
        try:
            return ((tuple(cursor.fetchall())[0][0]) >= 1)
        except:
            return False
    else:
        return "err"


def show_devices():
    devices = get_devices("deviceId, deviceName, deviceType, deviceLocation")
    for row in devices:
        print(row)


# ==================================================================


def identify(user, password):
    if commit("SELECT 1 FROM user WHERE name='{0}' and password=MD5('{1}') LIMIT 1;".format(user, password)):
        try:
            return (tuple(cursor.fetchall())[0][0] == 1)
        except:
            return False
    else:
        return "err"


# ==================================================================

def add_probe_data(deviceId, date, time, data=None):
    return commit('INSERT INTO probeData(deviceId, date, time,  data) VALUES(%s, %s, %s, %s);', (deviceId, date, time, data))


def get_probe_data(probeDeviceID=None, probeDate=None):
    sql = ""
    if probeDeviceID is None and probeDate is None:
        sql = "SELECT data FROM probeData;"
    elif probeDeviceID is not None and probeDate is not None:
        sql = "SELECT data FROM probeData WHERE deviceId = {0} AND date = {1};".format(probeDeviceID, probeDate)
    elif probeDeviceID is None and probeDate is not None:
        sql = "SELECT data FROM probeData WHERE date = {1};".format(probeDate)
    elif probeDeviceID is not None and probeDate is None:
        sql = "SELECT data FROM probeData WHERE deviceId = {0};".format(probeDeviceID)
    if commit(sql):
        return cursor.fetchall()
    return False


def delete_probe_data(id=None, probeDeviceID=None, probeDate=None):
    condition = 'WHERE '
    if id is not None:
        condition += 'id = "{0}"'.format(id)
    if probeDeviceID is not None:
        condition += 'probeDeviceID = "{0}"'.format(probeDeviceID)
    if probeDate is not None:
        condition += 'probeDate = "{0}"'.format(probeDate)

    return commit('DELETE FROM probeData {0};'.format(condition))
