from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS


db      = SQLAlchemy()
migrate = Migrate()


def create_app():
    app = Flask(__name__)

    # Config yükle
    from config import Config
    app.config.from_object(Config)

    # Extension'ları başlat
    db.init_app(app)
    migrate.init_app(app, db)
    CORS(app)

    # Uploads klasörünü oluştur
    import os
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

    # Modelleri import et (migrate için şart)
    from app.models import user, clothing_item, outfit  # noqa: F401

    # Blueprint'leri kaydet
    from app.api.auth_routes     import auth_bp
    from app.api.clothing_routes import clothing_bp
    from app.api.outfit_routes   import outfit_bp
    from app.api.weather_routes  import weather_bp
    from app.api.chat_routes import chat_bp

    app.register_blueprint(auth_bp,     url_prefix='/auth')
    app.register_blueprint(clothing_bp, url_prefix='/clothes')
    app.register_blueprint(outfit_bp,   url_prefix='/outfit')
    app.register_blueprint(weather_bp,  url_prefix='/weather')
    app.register_blueprint(chat_bp,     url_prefix='/chat')


    return app