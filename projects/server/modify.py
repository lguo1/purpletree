from setup import db, Event, Proposal, Organizer, Subscription, Presentation
import argparse
import json

session = db.session

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('filename')
    parser.add_argument('-de')
    parser.add_argument('-e', action='store_true', help='event')
    parser.add_argument('--pro', action='store_true', help='proposal')
    parser.add_argument('--org', action='store_true', help='organizer')
    parser.add_argument('--sub', action='store_true', help='subscription')
    parser.add_argument('--pre',action='store_true', help='presentation')
    args = parser.parse_args()
    with open(args.filename) as json_file:
        data = json.load(json_file)
        if args.e:
            for i in data:
                event = Event(
                    id=i['id'],
                    speakerHome=i['speakerHome'],
                    speaker=i['speaker'],
                    speakerTitle=i['speakerTitle'],
                    time=i['time'],
                    season=i['season'],
                    year=i['year'],
                    imageNameHome=i['imageNameHome'],
                    imageNameDetail=i['imageNameDetail'],
                    start=i['start'],
                    end=i['end'],
                    category=i['category'],
                    location=i['location'],
                    current=i['current'],
                    red=i['red'],
                    green=i['green'],
                    blue=i['blue'],
                    organizer=i['organizers'],
                    description=i['description'])
                session.add(event)
                session.commit()
        if args.pre:
            for i in data
            presentation = Presentation(
                ordering = i['ordering']
            )
            session.add(event)
            session.commit()
