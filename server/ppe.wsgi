import os, sys

# Turn on virtual environment
activate_this = os.path.join('/srv/org/ppe/server/venv/bin/activate_this.py')
with open(activate_this) as file_:
    exec(file_.read(), dict(__file__=activate_this))

# Insert program filepath
sys.path.insert(0, '/srv/org/ppe/server')

from setup import app as application
