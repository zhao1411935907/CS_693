from flask import Blueprint, render_template, url_for, request, redirect,jsonify
from flask import Flask, session
from flask import Flask, flash
from datetime import date
import mysql.connector
import connect
import bcrypt
import re 
from werkzeug.utils import secure_filename
import os
from flask import current_app as app
from datetime import datetime

user_blueprint = Blueprint('user', __name__)

def getCursor(dictionary_cursor=False):
    global connection
    connection = mysql.connector.connect(user=connect.dbuser, password=connect.dbpass, host=connect.dbhost, database=connect.dbname, autocommit=True)
    cursor = connection.cursor(dictionary=dictionary_cursor)
    return cursor

#---------------------------------------user dashboard-------------------------------------------
@user_blueprint.route('/user_dashboard')
def user_dashboard():

    return render_template('user_dashboard.html')

#---------------------------------------Login-------------------------------------------
@user_blueprint.route('/login', methods=['GET', 'POST'])
def login():

    connection = getCursor()
    error_message = {}
    if session.get("plant_url"):
        print(session.get("plant_url"))
        if request.method == 'POST':
            email = request.form['email']
            password = request.form['password']

            query = """
            SELECT ID, Email, Password, Role
            FROM user
            WHERE Email = %s
            """

            connection.execute(query, (email,))
            user = connection.fetchone()

            if user:
                if bcrypt.checkpw(password.encode('utf-8'), user[2].encode('utf-8')):
                    session['loggedin'] = True
                    session['ID'] = user[0]
                    session['email'] = user[1]
                    session['role'] = user[3]
                    # confirm user's target url
                    next_url = request.form.get('next') or request.args.get('next')

                    # Determine the dashboard based on the user's role
                    if session['role'] == 'Admin':
                        session['admin_logged_in'] = True
                        return redirect(next_url) if next_url and next_url != 'None' else redirect(url_for('admin.admin_dashboard'))
                    elif session['role'] == 'User':
                        session['user_logged_in'] = True
                        return redirect(next_url) if next_url and next_url != 'None' else redirect(url_for('user.user_dashboard'))
                    else:
                        flash('Unknown role. Please contact support.', 'danger')
                        return redirect(url_for('user.login'))
                else:
                     error_message['password'] = 'Incorrect password.'
            else:
                    error_message['email'] = 'User does not exist.'
        next_url = request.args.get('next')
        return render_template('login.html', error_message=error_message, next=session.get("plant_url"))
    else:
        if request.method == 'POST':
            email = request.form['email']
            password = request.form['password']

            query = """
            SELECT ID, Email, Password, Role
            FROM user
            WHERE Email = %s
            """

            connection.execute(query, (email,))
            user = connection.fetchone()

            if user:
                if bcrypt.checkpw(password.encode('utf-8'), user[2].encode('utf-8')):
                    session['loggedin'] = True
                    session['ID'] = user[0]
                    session['email'] = user[1]
                    session['role'] = user[3]
                    # confirm user's target url
                    next_url = request.form.get('next') or request.args.get('next')

                    # Determine the dashboard based on the user's role
                    if session['role'] == 'Admin':
                        session['admin_logged_in'] = True
                        return redirect(next_url) if next_url and next_url != 'None' else redirect(
                            url_for('admin.admin_dashboard'))
                    elif session['role'] == 'User':
                        session['user_logged_in'] = True
                        return redirect(next_url) if next_url and next_url != 'None' else redirect(
                            url_for('user.user_dashboard'))
                    else:
                        flash('Unknown role. Please contact support.', 'danger')
                        return redirect(url_for('user.login'))
                else:
                    error_message['password'] = 'Incorrect password.'
            else:
                error_message['email'] = 'User does not exist.'
        next_url = request.args.get('next')
        return render_template('login.html', error_message=error_message, next=next_url)
#---------------------------------------Log out-------------------------------------------session.get("plant_url")
@user_blueprint.route('/logout')
def logout():
    # delete session
    session.clear()
    flash('You have been logged out.', 'success')

    return redirect(url_for('main.home'))

#---------------------------------------Register-------------------------------------------
@user_blueprint.route('/register', methods=['GET', 'POST']) 
def register():

    error_message = {}

    if request.method == 'POST':
        email = request.form.get('email')
        plain_text_password = request.form.get('password')
        role = 'User'  # Set a default role for registered users 

        next_url = request.form.get('next')

        if email_exists(email):
            error_message['email'] = 'Email is already registered.'

        if not is_strong_password(plain_text_password):
            error_message['password'] = 'Password must be at least five characters.'

        if not error_message: 
            print("no error")   
            try:
                # hashed the plain text number
                hashed_password = bcrypt.hashpw(plain_text_password.encode('utf-8'), bcrypt.gensalt())
                connection = getCursor()
                # Insert into Users table
                connection.execute('INSERT INTO user (Email, Password, Role) VALUES (%s, %s, %s)',
                               (email, hashed_password, role))
                flash('Registration successful!', 'success')
                return redirect(url_for('user.login',next=next_url))
            
            except Exception as e:
                print("Registration failed. Error:", str(e))
                flash('Registration failed. Please try again.', 'danger')
                return redirect(url_for('user.register', next=next_url))
    
    return render_template('register.html', error_message=error_message, next=request.args.get('next', ''))

# Function to check if email already exists in the database
def email_exists(email):
    connection = getCursor()
    query = "SELECT ID FROM user WHERE Email = %s"
    connection.execute(query, (email,))
    result = connection.fetchone()
    print(result)
    connection.close()
    return result is not None

@user_blueprint.route('/contact_us')
def contact_us():
    return render_template('contact_us.html')

#-------------------------user's profile and update password---------------------------
@user_blueprint.route('/profile', methods=['GET', 'POST'])
def profile():
    if not session.get('loggedin'):
        return redirect(url_for('user.login'))
    
    cursor = getCursor(dictionary_cursor=True)
    email = session['email']

    try:
        if request.method == 'POST':
            old_password = request.form.get('old_password')
            new_password = request.form.get('new_password')
            confirm_password = request.form.get('confirm_password')

            # check old password is correct or not
            if not check_credentials(email, old_password, cursor):
                flash('Old password is incorrect', 'danger')
                return redirect(url_for('user.profile'))
            
            # check if new password is strong enough
            if not is_strong_password(new_password):
                flash('Password must be at least five characters.', 'danger')
                return redirect(url_for('user.profile'))
            
            # new password can't be the same as old password
            if new_password == old_password:
                flash('New password cannot be the same as old password.', 'danger')
                return redirect(url_for('user.profile'))
            
            # passwords filled each time must be same
            if new_password != confirm_password:
                flash('New passwords do not match', 'danger')
                return redirect(url_for('user.profile'))
            
            # hash password and update the database
            hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())
            cursor.execute('UPDATE user SET Password = %s WHERE Email = %s', (hashed_password.decode(), email))
            connection.commit()

            flash('Password changed successfully', 'success')
            return redirect(url_for('user.profile'))
        
        # get user's information
        query = 'SELECT * FROM user WHERE Email = %s;'
        cursor.execute(query, (email,))
        account = cursor.fetchone()
        return render_template('profile.html', account=account)
    
    finally:  
        cursor.close()



@user_blueprint.route('/image', methods=['GET', 'POST'])
def image():
    if not session.get('loggedin'):
        return redirect(url_for('login'))
    
    cursor = getCursor(dictionary_cursor=True)
    email = session['email']
    if request.method == 'POST':
        image = request.files['Image']
        image_filename = None
        if image:
            image_filename = secure_filename(image.filename)
            save_path = os.path.join('static/img', image_filename)
            full_save_path = os.path.join(app.root_path, save_path)
            image.save(full_save_path)
            update_query = """
            UPDATE user
            SET Image=%s
            WHERE Email = %s
            """
            cursor.execute(update_query, (image_filename,email))
            connection.commit()
        # get user's information
    query = 'SELECT * FROM user WHERE Email = %s;'
    cursor.execute(query, (email,))
    account = cursor.fetchone()
    cursor.close()
    return render_template('profile.html', account=account)



#this function is used to check if the user input the correct password
def check_credentials(email, password, cursor):

    query = 'SELECT Password FROM user WHERE Email = %s'
    cursor.execute(query, (email,))
    result = cursor.fetchone()

    if result:
        stored_password = result['Password']
        return bcrypt.checkpw(password.encode('utf-8'), stored_password.encode('utf-8'))
    return False

# Function to validate password strength
def is_strong_password(password):
    # Check if it has at least 5 characters
    return len(password) >= 5


#-------------------------------add a plant to "my favorite"---------------------------------------
@user_blueprint.route('/toggle_favorite', methods=['POST'])
def toggle_favorite():
    if 'loggedin' not in session:
        plant_id = request.get_json().get('plant_id', '')
        next_url = url_for('main.plant_detail', plant_id=plant_id)
        login_url = url_for('user.login', next=next_url)
        session['plant_url'] = "/plant/"+str(plant_id)
        return jsonify({'success': False, 'message': 'Not logged in', 'redirect': login_url}), 401
    
    data = request.get_json()
    plant_id = data.get('plant_id')
    user_id = session['ID']

    if not plant_id:
        return jsonify({'success': False, 'message': 'No plant ID provided'}), 400
    
    cursor = getCursor(dictionary_cursor=True)
    
    #check if this plant is exist
    cursor.execute('SELECT * FROM plantdetail WHERE ID = %s', (plant_id,))
    plant = cursor.fetchone()
    if not plant:
        cursor.close()
        return jsonify({'success': False, 'message': 'Invalid plant ID'}), 404
    
    # check if the plant is already in the favorite table
    cursor.execute('SELECT * FROM favorite WHERE User = %s AND Plant = %s', (user_id, plant_id))
    favorite = cursor.fetchone()

    if favorite:
        # if already in favorite table, remove it
        cursor.execute('DELETE FROM favorite WHERE User = %s AND Plant = %s', (user_id, plant_id))
        connection.commit()
        cursor.close()
        return jsonify({'success': True, 'message': 'The plant has been successfully removed from favorites'})
    else:
        # else, add into favorite
        cursor.execute('INSERT INTO favorite (User, Plant) VALUES (%s, %s)', (user_id, plant_id))
        connection.commit()
        cursor.close()
        return jsonify({'success': True, 'message': 'The plant has been successfully added to favorites'})
    
#----------------------------my favorite plant list----------------------------------------------
@user_blueprint.route('/favorites', methods=['GET'])
def favorite_plants_view():
    if 'loggedin' not in session or 'ID' not in session:
        return redirect(url_for('user.login'))
    
    user_id = session['ID']
    cursor = getCursor(dictionary_cursor=True)
    
    # get the favorite plant list
    query = '''
        SELECT plantdetail.ID, plantdetail.BotanicalName, plantdetail.CommonName, plantdetail.Family, plantdetail.Image
        FROM plantdetail
        JOIN favorite ON plantdetail.ID = favorite.Plant
        WHERE favorite.User = %s AND plantdetail.is_delete=0
    '''
    cursor.execute(query, (user_id,))
    favorites = cursor.fetchall()
    cursor.close()

    return render_template('favorites.html', favorites=favorites)


@user_blueprint.route('/save_filter', methods=['POST'])
def save_filter():
    data = request.get_json()
    filter_name = data.get('filterName')
    weight_dict = data.get('weightDict')
    user_id = session.get('ID')  
    if not filter_name or not user_id:
        return jsonify({'success': False, 'message': 'Filter name or user ID is missing.'})

    try:
        cursor = getCursor()
        check_query = """
            SELECT COUNT(*) FROM filter_result WHERE filter_name = %s AND UserID = %s
        """
        cursor.execute(check_query, (filter_name, user_id))
        result = cursor.fetchone()

        if result[0] > 0:
            return jsonify({'success': False, 'message': 'Filter name already exists. Please choose a different name.'})


        query = """
            INSERT INTO filter_result (UserID, filter_name, BirdNestingSitesScore, ConservationThreatScore, PalatabilityScore, 
                                        DefoliationScore, GrowthRateScore, ToxicPartsScore, HeightScore, ShadeScore, 
                                        ShelterScore, CanopyScore, FoodSourcesScore, DroughtToleranceScore, FrostToleranceScore, 
                                        WindToleranceScore, SaltToleranceScore, SunPreferencesScore, SoilDrainageScore, SoilDepthScore, 
                                        SoilMoistureScore, SoilTypeScore, WetlandScore, FlammabilityScore, created_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
        """

        values = (
            user_id,
            filter_name,
            weight_dict.get('Bird'),
            weight_dict.get('Conservation Threat'),
            weight_dict.get('Palatability'),
            weight_dict.get('Defoliation'),
            weight_dict.get('Growth Rate'),
            weight_dict.get('Toxic Elements'),
            weight_dict.get('Height'),
            weight_dict.get('Shade'),
            weight_dict.get('Shelter'),
            weight_dict.get('Canopy'),
            weight_dict.get('Food Sources'),
            weight_dict.get('Drought Tolerance'),
            weight_dict.get('Frost Tolerance'),
            weight_dict.get('Wind Tolerance'),
            weight_dict.get('Salt Tolerance'),
            weight_dict.get('Sun/Shade'),
            weight_dict.get('Soil Drainage'),
            weight_dict.get('Soil Depth'),
            weight_dict.get('Soil Moisture'),
            weight_dict.get('Soil Type'),
            weight_dict.get('Wetland'),
            weight_dict.get('Flammability')
        )

        cursor.execute(query, values)
        connection.commit()

        return jsonify({'success': True})

    except Exception as e:
        return jsonify({'success': False, 'message': str(e)})

    finally:
        cursor.close()




# Route to display filter results
@user_blueprint.route('/filter_results')
def filter_results():
    cursor = getCursor(dictionary_cursor=True)
    cursor.execute("SELECT id, filter_name, created_at FROM filter_result WHERE UserID = %s", (session['ID'],))
    saved_filters = cursor.fetchall()
    return render_template('filter_results.html', saved_filters=saved_filters)

# Route to rename a filter
@user_blueprint.route('/rename_filter/<int:filter_id>', methods=['POST'])
def rename_filter(filter_id):
    new_name = request.form['new_filter_name']
    
    # Check if the name already exists
    cursor = getCursor()
    cursor.execute("SELECT COUNT(*) FROM filter_result WHERE filter_name = %s AND UserID = %s", (new_name, session['ID']))
    existing_name_count = cursor.fetchone()[0]

    if existing_name_count > 0:
        flash('Filter name already exists. Please choose another name.', 'danger')
    else:
        cursor.execute("UPDATE filter_result SET filter_name = %s WHERE ID = %s AND UserID = %s", (new_name, filter_id, session['ID']))
        flash('Filter name updated successfully!', 'success')

    return redirect(url_for('user.filter_results'))

# Route to delete a filter (AJAX call)
@user_blueprint.route('/delete_filter/<int:filter_id>', methods=['DELETE'])
def delete_filter(filter_id):
    cursor = getCursor()
    cursor.execute("DELETE FROM filter_result WHERE ID = %s AND UserID = %s", (filter_id, session['ID']))
    return jsonify({'status': 'success'})


@user_blueprint.route('/start_filter/<int:filter_id>', methods=['GET'])
def start_filter(filter_id):
    cursor = getCursor(dictionary_cursor=True)
    cursor.execute("SELECT * FROM filter_result WHERE ID = %s", (filter_id,))
    filter_data = cursor.fetchone()
    cursor.close()

    if filter_data:
        return render_template('index.html', filter=filter_data)
    else:
        flash('Filter not found', 'danger')
        return redirect(url_for('user.filter_results'))