from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
# Create the SQLAlchemy “db” object
db = SQLAlchemy()

# Define our Transaction model
class Transaction(db.Model):
    __tablename__ = 'transactions'
    id     = db.Column(db.Integer, primary_key=True)
    amount = db.Column(db.Float,   nullable=False)
    created_at = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.utcnow
    )