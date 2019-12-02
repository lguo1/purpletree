from flask import Flask, jsonify, request, send_from_directory, abort
from setup import db, Event, Update, app
from sqlalchemy import func

@app.route('/')
def getallevents():
    events = db.session.query(Event)
    return jsonify([i.serialize for i in events])

app.config['CLIENT_IMAGES'] = "./img"
@app.route('/img/<image_name>/')
def getImage(image_name):
    try:
        return send_from_directory(app.config['CLIENT_IMAGES'], filename = image_name, as_attachment=False)
    except FileNotFoundError:
        abort(404)

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=5050)
