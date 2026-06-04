from datetime import datetime
from app import db

class Outfit(db.Model):
    __tablename__ = 'outfits'

    id          = db.Column(db.Integer, primary_key=True)
    user_id     = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    name        = db.Column(db.String(100), nullable=True)
    event_type  = db.Column(db.String(50),  nullable=True)
    ai_note     = db.Column(db.Text,        nullable=True)
    is_favorite = db.Column(db.Boolean, default=False)
    items_json  = db.Column(db.Text,        nullable=True)
    created_at  = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        import json
        return {
            'id':          self.id,
            'user_id':     self.user_id,
            'name':        self.name,
            'event_type':  self.event_type,
            'ai_note':     self.ai_note,
            'is_favorite': self.is_favorite,
            'items':       json.loads(self.items_json) if self.items_json else [],
            'created_at':  self.created_at.isoformat(),
        }

    def __repr__(self):
        return f'<Outfit {self.id}>'