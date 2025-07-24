from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Dummy lookup for now
barcode_db = {
    "123456789012": {"country": "France", "continent": "Europe"},
    "890123456789": {"country": "India", "continent": "Asia"},
}

@app.route('/lookup', methods=['POST'])
def lookup():
    # Simulate barcode recognition from image (replace with real ML logic)
    barcode = "123456789012"  # Placeholder for demonstration
    data = barcode_db.get(barcode, {"country": "Unknown", "continent": "Unknown"})
    return jsonify(data)

@app.route('/save-scan', methods=['POST'])
def save_scan():
    data = request.json
    # For now, we just print the data
    print("Scan saved:", data)
    return jsonify({"status": "success"})