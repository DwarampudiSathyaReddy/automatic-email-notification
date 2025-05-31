from flask import Flask, render_template, request, jsonify, session, redirect, url_for, flash
from flask_cors import CORS
import mysql.connector
import boto3
from botocore.exceptions import ClientError
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
CORS(app)
app.secret_key = os.getenv('SECRET_KEY', 'your-secret-key')

# MySQL Configuration
db_config = {
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASSWORD'),
    'host': os.getenv('MYSQL_HOST'),
    'database': os.getenv('MYSQL_DATABASE')
}

# Amazon SES Configuration
ses_client = boto3.client(
    'ses',
    region_name='us-east-1',
    aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('AWS_SECRET_KEY')
)
SENDER_EMAIL = os.getenv('SES_SENDER_EMAIL')

def get_db_connection():
    try:
        return mysql.connector.connect(**db_config)
    except mysql.connector.Error as err:
        print(f"Database connection error: {err}")
        raise

# Signup route (store password as plain text)
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        # Check if email already exists
        cursor.execute('SELECT * FROM users WHERE email = %s', (email,))
        existing_user = cursor.fetchone()
        
        if existing_user:
            cursor.close()
            conn.close()
            flash('Email already registered. Please use a different email or log in.', 'error')
            return redirect(url_for('signup'))
        
        # Insert new user into the database
        try:
            cursor.execute(
                'INSERT INTO users (email, password, role) VALUES (%s, %s, %s)',
                (email, password, 'user')  # Store password as plain text
            )
            conn.commit()
            flash('Signup successful! Please log in.', 'success')
        except mysql.connector.Error as err:
            print(f"Database error during signup: {err}")
            flash('Error during signup. Please try again.', 'error')
        finally:
            cursor.close()
            conn.close()
        
        return redirect(url_for('login'))
    
    return render_template('signup.html')

# Login route (compare plain text passwords)
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('SELECT * FROM users WHERE email = %s', (email,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if user and user['password'] == password:
            session['user_id'] = user['id']
            session['email'] = user['email']
            session['role'] = user['role']
            print(f"User {email} logged in, role: {user['role']}")
            if user['role'] == 'admin':
                return redirect(url_for('admin'))
            return redirect(url_for('index'))
        else:
            flash('Invalid email or password', 'error')
            return redirect(url_for('login'))
    
    return render_template('login.html')

# Logout route
@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out', 'success')
    print("Session cleared on logout")
    return redirect(url_for('login'))

# Index route
@app.route('/')
def index():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    if session.get('role') == 'admin':
        return redirect(url_for('admin'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM products')
    products = cursor.fetchall()
    for product in products:
        product['sizes'] = eval(product['sizes'])
        product['colors'] = eval(product['colors'])
        if product['price'] is not None:
            product['price'] = float(product['price'])
    cursor.close()
    conn.close()
    
    return render_template('index.html', cart=session.get('cart', []), products=products)

# Contact route
@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        subject = request.form['subject']
        message = request.form['message']
        try:
            response = ses_client.send_email(
                Source=SENDER_EMAIL,
                Destination={'ToAddresses': [SENDER_EMAIL]},
                Message={
                    'Subject': {'Data': f'Contact Form: {subject}'},
                    'Body': {
                        'Text': {
                            'Data': f'Name: {name}\nEmail: {email}\nMessage: {message}'
                        }
                    }
                }
            )
            print(f"Email sent successfully! Message ID: {response['MessageId']}")
            flash('Your message has been sent successfully!', 'success')
        except ClientError as e:
            print(f"Email error: {e.response['Error']['Message']}")
            flash('Error sending message. Please try again.', 'error')
        return redirect(url_for('contact'))
    return render_template('contact.html')

# About route
@app.route('/about')
def about():
    return render_template('about.html')

# Cart page route
@app.route('/cart')
def cart_page():
    if 'user_id' not in session:
        flash('Please log in to access cart', 'error')
        return redirect(url_for('login'))
    
    cart = session.get('cart', [])
    if cart:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        product_ids = [item['id'] for item in cart]
        placeholders = ','.join(['%s'] * len(product_ids))
        cursor.execute(f'SELECT * FROM products WHERE id IN ({placeholders})', product_ids)
        products = cursor.fetchall()
        for product in products:
            product['sizes'] = eval(product['sizes'])
            product['colors'] = eval(product['colors'])
            if product['price'] is not None:
                product['price'] = float(product['price'])
        cursor.close()
        conn.close()
        # Update cart with full product details
        updated_cart = []
        for item in cart:
            product = next((p for p in products if p['id'] == item['id']), None)
            if product:
                updated_cart.append({
                    'id': product['id'],
                    'name': product['name'],
                    'price': product['price'],
                    'image_url': product['image_url'],
                    'sizes': product['sizes'],
                    'colors': product['colors']
                })
        session['cart'] = updated_cart
        session.modified = True
    else:
        products = []
    
    return render_template('cart.html', cart=session.get('cart', []), products=products)

# Admin route
@app.route('/admin')
def admin():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    if session.get('role') != 'admin':
        return redirect(url_for('index'))
    return render_template('admin.html')

@app.route('/api/products', methods=['GET'])
def get_products():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM products')
    products = cursor.fetchall()
    for product in products:
        product['sizes'] = eval(product['sizes'])
        product['colors'] = eval(product['colors'])
        if product['price'] is not None:
            product['price'] = float(product['price'])
    cursor.close()
    conn.close()
    return jsonify(products)

@app.route('/api/search', methods=['GET'])
def search_products():
    query = request.args.get('q', '').strip()
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if query:
        cursor.execute('SELECT * FROM products WHERE name LIKE %s', (f'%{query}%',))
    else:
        cursor.execute('SELECT * FROM products')
    products = cursor.fetchall()
    for product in products:
        product['sizes'] = eval(product['sizes'])
        product['colors'] = eval(product['colors'])
        if product['price'] is not None:
            product['price'] = float(product['price'])
    cursor.close()
    conn.close()
    return jsonify(products)

@app.route('/api/subscribe', methods=['POST'])
def subscribe():
    if 'user_id' not in session:
        return jsonify({'message': 'Please log in to subscribe'}), 401
    
    data = request.json
    product_id = data['productId']
    size = data['size']
    color = data['color']
    email = data['email']
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'INSERT INTO subscriptions (product_id, size, color, email) VALUES (%s, %s, %s, %s)',
        (product_id, size, color, email)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Subscribed successfully'})

@app.route('/api/update-stock', methods=['POST'])
def update_stock():
    if 'user_id' not in session or session.get('role') != 'admin':
        return jsonify({'message': 'Unauthorized'}), 403

    data = request.form
    product_id = data['product_id']
    size = data['size']
    color = data['color']
    in_stock = data['in_stock'] == 'true'

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'UPDATE products SET in_stock = %s WHERE id = %s',
        (in_stock, product_id)
    )
    conn.commit()

    if in_stock:
        cursor.execute(
            'SELECT * FROM subscriptions WHERE product_id = %s AND size = %s AND color = %s',
            (product_id, size, color)
        )
        subscriptions = cursor.fetchall()
        for sub in subscriptions:
            try:
                ses_client.send_email(
                    Source=SENDER_EMAIL,
                    Destination={'ToAddresses': [sub[4]]},
                    Message={
                        'Subject': {'Data': 'Product Back In Stock'},
                        'Body': {
                            'Text': {
                                'Data': f'The product (Size: {sub[2]}, Color: {sub[3]}) is back in stock!'
                            }
                        }
                    }
                )
            except ClientError as e:
                print(f"Email error for {sub[4]}: {e}")

        cursor.execute(
            'DELETE FROM subscriptions WHERE product_id = %s AND sizeshe = %s AND color = %s',
            (product_id, size, color)
        )
        conn.commit()

    cursor.close()
    conn.close()
    return jsonify({'message': 'Stock updated'})

@app.route('/api/cart', methods=['GET', 'POST'])
def cart():
    if 'user_id' not in session:
        return jsonify({'message': 'Please log in to access cart'}), 401
    
    if request.method == 'POST':
        data = request.json
        product_id = data['productId']
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('SELECT * FROM products WHERE id = %s', (product_id,))
        product = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if not product:
            return jsonify({'message': 'Product not found'}), 404
        
        product['sizes'] = eval(product['sizes'])
        product['colors'] = eval(product['colors'])
        product['price'] = float(product['price'])
        
        if 'cart' not in session:
            session['cart'] = []
        
        # Prevent duplicates
        existing_item = next((item for item in session['cart'] if item['id'] == product['id']), None)
        if not existing_item:
            session['cart'].append({
                'id': product['id'],
                'name': product['name'],
                'price': product['price'],
                'image_url': product['image_url'],
                'sizes': product['sizes'],
                'colors': product['colors']
            })
            session.modified = True
            return jsonify({'message': 'Product added to cart'})
        else:
            return jsonify({'message': 'Product already in cart'})
    
    return jsonify(session.get('cart', []))

@app.route('/api/cart/remove/<int:product_id>', methods=['POST'])
def remove_from_cart(product_id):
    if 'user_id' not in session:
        return jsonify({'message': 'Please log in to access cart'}), 401
    
    if 'cart' in session:
        session['cart'] = [item for item in session['cart'] if item['id'] != product_id]
        session.modified = True
        return jsonify({'message': 'Product removed from cart'})
    return jsonify({'message': 'Cart is empty'})

@app.route('/api/purchase', methods=['POST'])
def purchase():
    if 'user_id' not in session:
        return jsonify({'message': 'Please log in to purchase'}), 401
    
    if 'cart' not in session or not session['cart']:
        return jsonify({'message': 'Your cart is empty'}), 400
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        for item in session['cart']:
            cursor.execute(
                'INSERT INTO orders (user_id, product_id, name, price, image_url) VALUES (%s, %s, %s, %s, %s)',
                (session['user_id'], item['id'], item['name'], item['price'], item['image_url'])
            )
        conn.commit()
        
        # Clear cart
        session['cart'] = []
        session.modified = True
        return jsonify({'message': 'Purchase successful! Your order has been placed.'})
    
    except mysql.connector.Error as err:
        print(f"Database error during purchase: {err}")
        conn.rollback()
        return jsonify({'message': 'Error processing purchase'}), 500
    
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=False, port=port)
