# coding:utf-8
import json

from flask import jsonify, request, redirect, url_for

from modules.apps.app import app
from modules.mysocket.device_server import deviceHelpers, deviceHelper


@app.route('/probe', methods=['POST', 'GET'])
def route_probe():
    if request.method == 'POST':
        requestData = json.loads(request.data.decode('utf-8'))
        deviceId = requestData['deviceId']
        if deviceId in deviceHelpers:
            curDeviceHelper = deviceHelpers[deviceId]  # type:deviceHelper
            if curDeviceHelper.online and curDeviceHelper.server is not None:
                curDeviceHelper.setTask(formatProbeParams(requestData))
                curDeviceHelper.sendTask()
                return jsonify({'ans': 1})
        return jsonify({'ans': 0})
    else:
        return redirect(url_for('route_devices_operation_probe'))


def formatProbeParams(dicts):
    probeParams = dict()
    triggerDate = str(dicts['triggerDate']).split('-')
    triggerTime = str(dicts['triggerTime']).split(':')

    probeParams['type'] = 'request_probe'

    probeParams['trigger_mode'] = int(dicts['triggerMode'])
    probeParams['trigger_year'] = int(triggerDate[0])
    probeParams['trigger_mouth'] = int(triggerDate[1])
    probeParams['trigger_day'] = int(triggerDate[2])
    probeParams['trigger_hour'] = int(triggerTime[0])
    probeParams['trigger_minutes'] = int(triggerTime[1])
    probeParams['trigger_second'] = int(triggerTime[2])
    probeParams['probe_mode'] = int(dicts['probeMode'])
    probeParams['send_recv_mode'] = int(dicts['sendRecvMode'])
    probeParams['probe_interval'] = 0
    probeParams['groups_number'] = 1
    probeParams['repetition_number'] = int(dicts['repetitionNumber'])
    probeParams['freq_mode'] = int(dicts['freqMode'])
    probeParams['freq_start'] = round(dicts['startFreq'], 2)  # 8947848.5
    probeParams['freq_step'] = round(dicts['stepFreq'], 2)
    probeParams['freq_end'] = round(dicts['endFreq'], 2)
    probeParams['code_id'] = int(dicts['codeID'])
    probeParams['code_type'] = 0
    probeParams['code_number'] = 2
    probeParams['code_length'] = 16
    probeParams['code_duration'] = round(dicts['baseSpeed'], 1)
    probeParams['pulse_length'] = int(dicts['pulseWide'])

    return probeParams


def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        pass

    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass
    return False
