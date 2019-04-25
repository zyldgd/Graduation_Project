# coding:utf-8

import json
import time

from flask import request, render_template, jsonify

from modules.apps import app
from modules.apps import get_probe_data
from modules.mysocket.device_server import deviceHelpers, deviceHelper

''' 
            request: "probeData",
            curProbeData: false,
            deviceId: null,
            date: null

'''


@app.route('/probeData/', methods=['POST', 'GET'])
def route_probeData():
    if request.method == 'POST':
        requestData = json.loads(request.data.decode('utf-8'))
        if requestData['request'] == 'probeData':
            deviceId = requestData['deviceId']
            date = requestData['date']
            if requestData['curProbeData']:
                if deviceId in deviceHelpers:
                    curDeviceHelper = deviceHelpers[deviceId]  # type:deviceHelper
                    if curDeviceHelper.online:
                        return jsonify({'ans':0, 'index': curDeviceHelper.latestIndex, 'data': curDeviceHelper.getData(False, requestData['begin'], requestData['end'])})
                return jsonify({'ans': 1})
            else:
                S = time.time()
                rows = get_probe_data(probeDeviceID=deviceId, probeDate=date)
                S1 = time.time()
                ans = []
                for row in rows:
                    ans.append(row[0])
                print(S1 - S)
                return jsonify(ans)
        elif requestData['request'] == 'probeInfo':
            deviceId = requestData['deviceId']
            if deviceId in deviceHelpers:
                curDeviceHelper = deviceHelpers[deviceId]  # type:deviceHelper
                if curDeviceHelper.online:
                    result = {'ans': 0,'task':curDeviceHelper.task ,'probing': curDeviceHelper.probing, 'probed':curDeviceHelper.probed, 'index': curDeviceHelper.latestIndex}
                    return jsonify(result)
            return jsonify({'ans': 1})
        else:
            return jsonify(1)
        # add_probe_data('100001','2019-3-8','10:28:59','','AMP', data)
    else:
        return render_template('probeData.html')


@app.route('/ionoDiagram/<path:types>', methods=['POST', 'GET'])
def route_ionoDiagram(types=''):
    return render_template('ionoDiagram.html', types=types)


@app.route('/route_probeData_online', methods=['POST', 'GET'])
def route_probeData_online():
    if request.method == 'POST':
        pass
    else:
        return render_template('probeDataOnline.html')
