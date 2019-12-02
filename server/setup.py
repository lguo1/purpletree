import sys
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///events.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
db = SQLAlchemy(app)

class Event(db.Model):
    __tablename__ = 'event'
    id = db.Column(db.String(10), primary_key=True, nullable=False)
    speakerHome = db.Column(db.String(50), nullable=False)
    speaker = db.Column(db.String(50), nullable=False)
    speakerTitle = db.Column(db.String(50), nullable=False)
    time = db.Column(db.String(50), default="tbd")
    weekday = db.Column(db.String(50), default="tbd")
    date = db.Column(db.String(50), default="tbd")
    season = db.Column(db.String(50), nullable=False)
    year = db.Column(db.String(50), nullable=False)
    imageHomeName = db.Column(db.String(50), nullable=False)
    imageDetailName = db.Column(db.String(50), nullable=False)
    location = db.Column(db.String(50), nullable=False)
    description = db.Column(db.Text, nullable=False, default="...")
    category = db.Column(db.String(10))
    current = db.Column(db.Boolean, nullable=False)
    red = db.Column(db.Float, nullable=False)
    green = db.Column(db.Float, nullable=False)
    blue = db.Column(db.Float, nullable=False)

    @property
    def serialize(self):
        return {
        "id": self.id,
        "speaker": self.speaker,
        "speakerHome": self.speakerHome,
        "speakerTitle": self.speakerTitle,
        "time": self.time,
        "weekday": self.weekday,
        "date": self.date,
        "season": self.season,
        "year": self.year,
        "imageHomeName": self.imageHomeName,
        "imageDetailName": self.imageDetailName,
        "category": self.category,
        "location": self.location,
        "description": self.description,
        "current": self.current,
        "red": self.red,
        "green": self.green,
        "blue": self.blue
    }

db.create_all()
