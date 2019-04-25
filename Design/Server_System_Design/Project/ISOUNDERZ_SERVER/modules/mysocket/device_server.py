import json
import random
import socketserver
import threading

import time

deviceHelpers = {}  # type:dict

taskTemp = {
    'trigger_mode': 0,
    'trigger_year': 0,
    'trigger_mouth': 0,
    'trigger_day': 0,
    'trigger_hour': 0,
    'trigger_minutes': 0,
    'trigger_second': 0,
    'probe_mode': 0,
    'send_recv_mode': 0,
    'probe_interval': 0,
    'groups_number': 0,
    'repetition_number': 0,
    'freq_mode': 0,
    'freq_start': 0,
    'freq_step': 0,
    'freq_end': 0,
    'code_id': 0,
    'code_type': 0,
    'code_number': 0,
    'code_length': 0,
    'code_duration': 0,
    'pulse_length': 0
}

statusTemp = {
    'sysClockPrecision': 0,
    'probing': False,
    'process': 0,
    'GPS': {
        'locked': False,
        'year': 0,
        'mouth': 0,
        'day': 0,
        'hour': 0,
        'minutes': 0,
        'second': 0,
        'latitude': 0,
        'longitude': 0,
        'height': 0,
        'altitude': 0,
        'visible_satellites': 0,
        'tracking_satellites': 0
    }
}


class deviceHelper(object):
    deviceId = str()
    deviceName = str()
    deviceType = str()
    deviceLocation = str()
    remark = str()

    server = None  # type:deviceServer
    online = False
    deviceInfo = dict()
    probeData = None # type:list
    probing = False
    probed = False
    latestIndex = 0
    task = taskTemp
    status = statusTemp

    def __init__(self, deviceId):
        self.deviceId = deviceId
        # self.status.update({'GPS_locked':False})

    def initData(self, w, h):
        self.probeData = [([0] * h) for i in range(0, w)]

    def getData(self, latest=False, begin=None, end=None):
        if self.probeData is not None:
            if latest and self.latestIndex > 0:
                return self.probeData[self.latestIndex - 1]
            else:
                return self.probeData[begin:end]
        return None

    def setData(self, dataRecv):
        index = dataRecv['index']
        if index == 1:
            self.probing = True
            print('probing')
            w = dataRecv['indexCount']
            h = dataRecv['dataLen']
            self.initData(w, h)

        self.probeData[index - 1] = list(dataRecv['data'])
        self.latestIndex = index

        if index == dataRecv['indexCount']:
            self.probed = True
            self.probing = False
            print('probe over')
            self.saveData()

    def saveData(self):
        from modules.apps.data import add_probe_data
        saveData = {
            'deviceId': self.deviceId,
            'taskId': str(random.randint(0, 9)) + time.strftime("%Y%m%d%H%M%S", time.localtime()) + self.deviceId,
            'type': 'COS',
            # 'date': time.strftime("%Y-%m-%d", time.localtime()),
            # 'time': time.strftime("%H:%M:%S", time.localtime()),
            'date': '{0}-{1}-{2}'.format(self.task['trigger_year'], self.task['trigger_mouth'], self.task['trigger_day']),
            'time': '{0}:{1}:{2}'.format(self.task['trigger_hour'], self.task['trigger_minutes'], self.task['trigger_second']),
            'PSN': self.task['repetition_number'],
            'code_id': self.task['code_id'],
            'freq_start': self.task['freq_start'],
            'freq_step': self.task['freq_step'],
            'freq_end': self.task['freq_end'],
            'transposed': False,
            'data': self.probeData
        }
        add_probe_data(self.deviceId, saveData['date'], saveData['time'], json.dumps(saveData))

    def serverDisconnect(self):
        self.server = None
        self.online = False

    def serverConnect(self, deviceServer):
        self.server = deviceServer
        self.online = True

    def setStatue(self, status):
        self.status.update(status)

    def setTask(self, task):
        self.task.update(task)

    def sendTask(self):
        self.latestIndex = 0
        self.probing = False
        self.probed = False
        if self.server is not None:
            self.server.sendData(json.dumps(self.task))

    def saveTask(self):
        pass


class deviceServer(socketserver.BaseRequestHandler):
    ID = None  # type:str
    lastData = None  # type:str

    def handle(self):
        # self.request.sendall(bytes("123", encoding="utf-8"))
        while True:
            recv_data = bytes(self.request.recv(4096)).decode('utf-8')

            if not recv_data:
                break

            lastLineIndex = recv_data.rfind('\n')
            if lastLineIndex != -1:
                dealStr = recv_data[:lastLineIndex]
                self.dealDataSet((self.lastData + dealStr).splitlines())
                self.lastData = recv_data[lastLineIndex + 1:]

            else:
                self.lastData += recv_data

    def setup(self):
        self.lastData = ''
        print('new connection:', self.client_address)

    def finish(self):
        self.lastData = ''
        if self.ID in deviceHelpers:
            deviceHelpers[self.ID].serverDisconnect()
            print('disable connection:', self.client_address)

    def dealDataSet(self, dataSet):
        global deviceHelpers
        if dataSet is None or len(dataSet) == 0:
            return
        for data in dataSet:
            if len(data) <= 2:
                return
            # print(data)
            recvData = None
            # try:
            recvData = json.loads(data)
            self.ID = recvData['id']
            if self.ID in deviceHelpers:
                deviceHelpers[self.ID].serverConnect(self)
            else:
                deviceHelpers[self.ID] = deviceHelper(self.ID)
                deviceHelpers[self.ID].serverConnect(self)

            if recvData['type'] == 'device_connect':
                print(self.ID, "connected")
            elif recvData['type'] == 'device_status':
                deviceHelpers[self.ID].setStatue(recvData['content'])
            elif recvData['type'] == 'device_data':
                deviceHelpers[self.ID].setData(recvData['content'])
                # except:
                #     print("err ---------------------------")
                #     if recvData is None:
                #         print("None:   ", data)
                #     else:
                #         print(recvData)
                #     print("err ---------------------------")
                #     return

    def sendData(self, sendData):
        self.request.sendall(bytes(sendData, encoding="utf-8"))


class thread_server(threading.Thread):
    def __init__(self, threadID, name):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name

    def run(self):
        print("-------------------serve running-------------------")
        with socketserver.ThreadingTCPServer(("0.0.0.0", 15527), deviceServer) as server:
            server.serve_forever()
