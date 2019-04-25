# coding:utf-8

from modules.apps.app import render_template
from modules.apps.app import app
from flask import request, session,redirect,url_for
# from datetime import timedelta
# from modules.apps.data import identify
app.config['SECRET_KEY'] = "1234560"
#app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=1)  # 设置session的保存时间。


@app.route('/index', methods=['POST', 'GET'])
def route_index():
    if request.method == 'GET':
        if session.get('userName'):
            return render_template("general.html")
    return redirect(url_for('route_login'))



@app.route('/construction', methods=['POST', 'GET'])
def route_construction():
    if request.method == 'GET':
        if session.get('userName'):
            return render_template("underConstruction.html")
    return redirect(url_for('route_login'))