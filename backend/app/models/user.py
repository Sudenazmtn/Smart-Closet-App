from datetime import datetime
from app import db

class User(db.Model):
    __tablename__ = 'users'

    id           = db.Column(db.Integer, primary_key=True)
    firebase_uid = db.Column(db.String(128), unique=True, nullable=False)
    name         = db.Column(db.String(100), nullable=False)
    email        = db.Column(db.String(120), unique=True, nullable=False)
    created_at   = db.Column(db.DateTime, default=datetime.utcnow)

    clothing_items = db.relationship(
        'ClothingItem', backref='owner', lazy=True,
        cascade='all, delete-orphan'
    )
    outfits = db.relationship(
        'Outfit', backref='owner', lazy=True,
        cascade='all, delete-orphan'
    )

    def to_dict(self):
        return {
            'id':           self.id,
            'firebase_uid': self.firebase_uid,
            'name':         self.name,
            'email':        self.email,
            'created_at':   self.created_at.isoformat(),
        }

    def __repr__(self):
        return f'<User {self.email}>'