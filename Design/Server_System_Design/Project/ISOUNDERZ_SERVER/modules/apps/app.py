from flask import Flask, request, escape, session, g, redirect, url_for, abort, render_template, flash, request, \
    render_template_string, make_response, jsonify, send_from_directory
import datetime, os, time, base64, json, shutil

#import modules.apps.index

app = Flask(__name__, static_folder='../../static', template_folder='../../templates')

# print(os.path.dirname(app.instance_path))
app.config['ROOT_DIR'] = os.path.dirname(app.instance_path)
app.config['JSON_AS_ASCII'] = False
#app.config['databasePath'] = os.path.join(app.config['ROOT_DIR'],"database","isounderz.db")