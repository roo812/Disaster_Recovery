# from flask import Flask, jsonify, request
# import mysql.connector
# import os

# app = Flask(__name__)

# # Database connection configuration
# db_config = {
#     'host': os.environ.get('DB_HOST'),  # Set by userdata in launch template
#     'user': 'admin',
#     'password': 'admin123',  # db password
#     'database': 'appdb'
# }

# def get_db_connection():
#     return mysql.connector.connect(**db_config)

# @app.route('/', methods=['GET'])
# def get_users():
#     try:
#         conn = get_db_connection()
#         cursor = conn.cursor()
#         cursor.execute("SELECT id, name FROM users")
#         rows = cursor.fetchall()
#         users = [{'id': row[0], 'name': row[1]} for row in rows]
#         cursor.close()
#         conn.close()
#         return jsonify(users)
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# @app.route('/add_user', methods=['POST'])
# def add_user():
#     try:
#         data = request.get_json()
#         name = data.get('name')
#         if not name:
#             return jsonify({'error': 'Name is required'}), 400
        
#         conn = get_db_connection()
#         cursor = conn.cursor()
#         cursor.execute("INSERT INTO users (name) VALUES (%s)", (name,))
#         conn.commit()
#         cursor.close()
#         conn.close()
#         return jsonify({'message': f'User {name} added successfully'}), 201
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=80)

# from flask import Flask, jsonify, request, render_template_string
# import mysql.connector
# import os

# app = Flask(__name__)

# db_config = {
#     'host': os.environ.get('DB_HOST'),
#     'user': 'admin',
#     'password': 'admin123',
#     'database': 'appdb'
# }

# def get_db_connection():
#     return mysql.connector.connect(**db_config)

# # View users as JSON
# @app.route('/', methods=['GET'])
# def get_users():
#     try:
#         conn = get_db_connection()
#         cursor = conn.cursor()
#         cursor.execute("SELECT id, name FROM users")
#         rows = cursor.fetchall()
#         users = [{'id': row[0], 'name': row[1]} for row in rows]
#         cursor.close()
#         conn.close()
#         return jsonify(users)
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# # Add user via API
# @app.route('/add_user', methods=['POST'])
# def add_user():
#     try:
#         data = request.get_json()
#         name = data.get('name')
#         if not name:
#             return jsonify({'error': 'Name is required'}), 400

#         conn = get_db_connection()
#         cursor = conn.cursor()
#         cursor.execute("INSERT INTO users (name) VALUES (%s)", (name,))
#         conn.commit()
#         cursor.close()
#         conn.close()
#         return jsonify({'message': f'User {name} added successfully'}), 201
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# # Simple HTML form to add user
# @app.route('/form', methods=['GET', 'POST'])
# def form():
#     message = ''
#     if request.method == 'POST':
#         name = request.form.get('name')
#         if name:
#             try:
#                 conn = get_db_connection()
#                 cursor = conn.cursor()
#                 cursor.execute("INSERT INTO users (name) VALUES (%s)", (name,))
#                 conn.commit()
#                 cursor.close()
#                 conn.close()
#                 message = f'User {name} added successfully!'
#             except Exception as e:
#                 message = f'Error: {e}'
#         else:
#             message = 'Name is required'

#     html = """
#     <!doctype html>
#     <title>Add User</title>
#     <h2>Add a User</h2>
#     <form method="post">
#       Name: <input type="text" name="name">
#       <input type="submit" value="Add User">
#     </form>
#     <p>{{message}}</p>
#     """
#     return render_template_string(html, message=message)

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=80)

from flask import Flask, jsonify, request, render_template_string
import mysql.connector
import os

app = Flask(__name__)

# DB configuration from environment variables
db_host = os.environ.get('DB_HOST')
db_user = os.environ.get('DB_USER')
db_pass = os.environ.get('DB_PASS')
db_name = 'appdb'

def get_db_connection():
    return mysql.connector.connect(host=db_host, user=db_user, password=db_pass, database=db_name)

# Route to show users and cluster info
@app.route('/', methods=['GET'])
def get_users():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id, name FROM users")
        rows = cursor.fetchall()
        users = [{'id': row[0], 'name': row[1]} for row in rows]
        cursor.close()
        conn.close()
        return jsonify({
            'cluster_host': db_host,
            'users': users
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# API route to add user (POST only)
@app.route('/add_user', methods=['POST'])
def add_user():
    try:
        data = request.get_json()
        name = data.get('name')
        if not name:
            return jsonify({'error': 'Name is required'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (name) VALUES (%s)", (name,))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': f'User {name} added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Simple HTML form to add user via browser
@app.route('/form', methods=['GET', 'POST'])
def form():
    message = ''
    if request.method == 'POST':
        name = request.form.get('name')
        if name:
            try:
                conn = get_db_connection()
                cursor = conn.cursor()
                cursor.execute("INSERT INTO users (name) VALUES (%s)", (name,))
                conn.commit()
                cursor.close()
                conn.close()
                message = f'User {name} added successfully!'
            except Exception as e:
                message = f'Error: {e}'
        else:
            message = 'Name is required'

    html = """
    <!doctype html>
    <title>Add User</title>
    <h2>Add a User</h2>
    <p>Connected to DB cluster: {{ db_host }}</p>
    <form method="post">
      Name: <input type="text" name="name">
      <input type="submit" value="Add User">
    </form>
    <p>{{message}}</p>
    """
    return render_template_string(html, message=message, db_host=db_host)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
