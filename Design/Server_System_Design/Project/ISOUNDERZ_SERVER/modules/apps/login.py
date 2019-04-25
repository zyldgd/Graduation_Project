# coding:utf-8
from flask import request, json, session, jsonify, redirect, url_for
from modules.apps.data import identify
from modules.apps.app import render_template
from modules.apps.app import app


@app.route('/', methods=['POST', 'GET'])
def route_login():
    if request.method == 'POST':
        requestData = json.loads(request.data.decode('utf-8'))
        userName = requestData['userName']
        userPassword = requestData['userPassword']
        if identify(userName, userPassword):
            session['userName'] = userName
            session['loggedIn'] = True
            return jsonify({'ans': 1})
        else:
            return jsonify({'ans': 0})
    else:
        return render_template("login.html")


@app.route('/logout', methods=['POST', 'GET'])
def route_logout():
    if request.method == 'GET':
        session.pop('userName',None)
        session.pop('loggedIn', None)
        return redirect(url_for('route_login'))
    else:
        return render_template("login.html")
