from flask import Flask, jsonify, request, send_from_directory, abort
from setup import db, Event, app
from sqlalchemy import func

@app.route('/')
def getAllEvents():
    events = db.session.query(Event)
    return jsonify([i.serialize for i in events])

app.config['CLIENT_IMAGES'] = "./img"
@app.route('/img/<image_name>/')
def getImage(image_name):
    try:
        return send_from_directory(app.config['CLIENT_IMAGES'], filename = image_name, as_attachment=False)
    except FileNotFoundError:
        abort(404)

@app.route('/support/')
def getSupport():
    return """
    <h2 style="text-align: center;"><span style="color: #800080;">Purple Tree Support</span></h2>
    <p>Purpletree is an app designed to show campus events at Swarthmore College. To use the app, simply download it from the App Store and open it with an internet connection.</p>
    <p>Internet connection is necessary for keeping events up to date with event organizers. However, you may view events anytime after you retrieved them from the internet once.</p>
    <p>Purpletree supports user interactions with events. For each speaker event, you have the option to like the event. Once you click "like", you give a tiny purple leave to the speaker.</p>
    <p>Sometimes you may receive no event. This usually happens because your phone does not have an internet connection. Occasionally, this is because event organizers haven't put out any event. In either case, you will receive a no event notification. Click on the notification and an instruction page will show you how to retrieve more events, if there is any.</p>
"""

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=5050)
