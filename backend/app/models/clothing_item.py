from datetime import datetime
from app import db

class ClothingItem(db.Model):
    __tablename__ = 'clothing_items'

    id         = db.Column(db.Integer, primary_key=True)
    user_id    = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    name       = db.Column(db.String(100), nullable=False)
    category   = db.Column(db.String(50),  nullable=False)
    color      = db.Column(db.String(50),  nullable=False)
    season     = db.Column(db.String(50),  nullable=False)
    sub_category = db.Column(db.String(50),  nullable=True)
    image_url  = db.Column(db.String(255), nullable=True)
    wear_count  = db.Column(db.Integer, default=0)
    is_favorite = db.Column(db.Boolean, default=False, nullable=False)
    last_worn   = db.Column(db.DateTime, nullable=True)
    created_at  = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id':          self.id,
            'user_id':     self.user_id,
            'name':        self.name,
            'category':    self.category,
            'sub_category':self.sub_category,
            'color':       self.color,
            'season':      self.season,
            'image_url':   self.image_url,
            'wear_count':  self.wear_count,
            'is_favorite': self.is_favorite,
            'last_worn':   self.last_worn.isoformat() if self.last_worn else None,
            'created_at':  self.created_at.isoformat(),
        }

    def __repr__(self):
        return f'<ClothingItem {self.name}>'