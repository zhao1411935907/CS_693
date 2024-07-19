import logging
from flask import Flask
from .main_routes import main_blueprint
from .user_routes import user_blueprint
from .admin_routes import admin_blueprint

def create_app():
    app = Flask(__name__)
    logging.basicConfig(level=logging.DEBUG)

    app.config.from_pyfile('config.py')

    app.register_blueprint(main_blueprint)
    app.register_blueprint(user_blueprint)
    app.register_blueprint(admin_blueprint)

    return app
