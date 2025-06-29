from flask import Flask, request, jsonify
from models import db, Transaction

app = Flask(__name__)

# ─── Database Configuration ────────────────────────────────────────────────────
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///budget.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

# Create tables if they don't already exist
with app.app_context():
    db.create_all()


# ─── Create a New Transaction ──────────────────────────────────────────────────
@app.route('/transactions', methods=['POST'])
def add_transaction():
    data = request.get_json() or {}
    amt = data.get('amount')

    # Basic validation: must be a positive number
    if amt is None or not isinstance(amt, (int, float)) or amt <= 0:
        return jsonify({'error': 'Amount must be a positive number'}), 400

    # Save to database
    tx = Transaction(amount=amt)
    db.session.add(tx)
    db.session.commit()

    # Return the created record
    return jsonify({'id': tx.id, 'amount': tx.amount}), 201
    return jsonify({
        'id': tx.id,
        'amount': tx.amount,
        'created_at': tx.created_at.isoformat()
    }), 201

# ─── List All Transactions ─────────────────────────────────────────────────────
@app.route('/transactions', methods=['GET'])
def list_transactions():
    # Fetch all, newest first
    txs = Transaction.query.order_by(Transaction.id.desc()).all()
    # Convert to list of dicts
    result = [{'id': t.id, 'amount': t.amount} for t in txs]
    result = [{
        'id': t.id,
        'amount': t.amount,
        'created_at': t.created_at.isoformat()
    } for t in txs]
    return jsonify(result), 200


# ─── Run the App ────────────────────────────────────────────────────────────────
if __name__ == '__main__':
    app.run(debug=True)
