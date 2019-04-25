# coding:utf-8
import json

from flask import jsonify, request, render_template, redirect, url_for, session

from modules.apps.app import app
from modules.apps.data import add_new_device, has_devicesId, getDeviceData, modify_device, delete_device


@app.route('/devices')
def route_devices():
    if session.get('userName'):
        return render_template("devices.html")
    else:
        return redirect(url_for('route_login'))


@app.route('/devices/operation', methods=['POST', 'GET'])
def route_devices_operation():
    if request.method == 'POST':
        print(request.form['deviceId'])
        # add_new_device(request.form['deviceId'],"123")
        return redirect(url_for('route_devices_operation_probe', deviceID=request.form['deviceId']))
    else:
        return redirect(url_for('route_devices'))


@app.route('/devices/operation/addNewDevice', methods=['POST', 'GET'])
def route_devices_operation_addNewDevice():
    if request.method == 'POST':
        requestData = json.loads(request.data.decode('utf-8'))
        deviceId = requestData['deviceId']
        deviceName = requestData['deviceName']
        deviceType = requestData['deviceType']
        deviceLocation = requestData['deviceLocation']
        remark = requestData['remark']
        if has_devicesId(deviceId):
            return jsonify({'ans': 0})
        else:
            add_new_device(deviceId, deviceName, deviceType, deviceLocation, remark)
            return jsonify({'ans': 1})
    else:
        if session.get('userName'):
            return render_template('addNewDevice.html')
        else:
            return redirect(url_for('route_login'))


@app.route('/devices/operation/probe', methods=['POST', 'GET'])
def route_devices_operation_probe():
    if request.method == 'POST':
        print(request.form['deviceId'])
        session['curDeviceId'] = request.form['deviceId']
        return render_template('set_probe_param.html')
    else:
        return redirect(url_for('route_devices'))


@app.route('/devices/operation/show', methods=['POST', 'GET'])
def route_devices_operation_show():
    if request.method == 'POST':
        print(request.form['deviceId'])
        device_data = getDeviceData(request.form['deviceId'])
        return render_template('modify.html', device_data=device_data)
    else:
        return redirect(url_for('route_devices'))


@app.route('/devices/operation/modify', methods=['POST', 'GET'])
def route_devices_operation_modify():
    if request.method == 'POST':
        requestData = json.loads(request.data.decode('utf-8'))
        type = requestData['type']
        deviceId = requestData['deviceId']
        if type == 'delete':
            if has_devicesId(deviceId):
                delete_device(deviceId)
                return jsonify({'ans': 1})
            else:
                return jsonify({'ans': 0})
        elif type == 'modify':
            if has_devicesId(deviceId):
                deviceName = requestData['deviceName']
                deviceType = requestData['deviceType']
                deviceLocation = requestData['deviceLocation']
                remark = requestData['remark']
                modify_device(deviceId, deviceName, deviceType, deviceLocation, remark)
                return jsonify({'ans': 1})
            else:
                return jsonify({'ans': 0})
    else:
        return redirect(url_for('route_devices'))
