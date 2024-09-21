from flask import Blueprint, render_template, url_for, request, redirect, send_file
from flask import Flask, session
from flask import Flask, flash
from datetime import date
import mysql.connector
import connect
from werkzeug.utils import secure_filename
import os
from flask import current_app as app
from io import BytesIO
import pandas as pd

admin_blueprint = Blueprint('admin', __name__)

def getCursor(dictionary_cursor=False):
    global connection
    connection = mysql.connector.connect(user=connect.dbuser, password=connect.dbpass, host=connect.dbhost, database=connect.dbname, autocommit=True)
    cursor = connection.cursor(dictionary=dictionary_cursor)
    return cursor

#---------------------------------------admin dashboard-------------------------------------------
@admin_blueprint.route('/admin_dashboard')
def admin_dashboard():

    return render_template('admin_dashboard.html')

#-------------------------------------plant details view--------------------------------------
@admin_blueprint.route('/plant_detail', methods=['GET'])
def plant_detail():

    page = request.args.get('page', 1, type=int)  # get current page，default as page 1
    search_query = request.args.get('searchQuery', '')
    per_page = 20 #10 plants per page
    offset = (page - 1) * per_page  

    #connect to database
    cursor = getCursor(dictionary_cursor=True)

    # Prepare the base query and parameters list
    if search_query:
        search_query = f"%{search_query}%"  # Prepare the search query for a LIKE statement
        base_query = """
        FROM plantdetail
        WHERE BotanicalName LIKE %s OR CommonName LIKE %s
        """
        params = [search_query, search_query]
    else:
        base_query = " FROM plantdetail"
        params = []

    # Count total entries for pagination
    cursor.execute("SELECT COUNT(*) AS total " + base_query, params)
    total_count = cursor.fetchone()['total']
    total_pages = (total_count + per_page - 1) // per_page 

    query = """
    SELECT *
    """ + base_query + """
    ORDER BY ID ASC 
    LIMIT %s OFFSET %s
    """
    params.extend([per_page, offset])
    
    cursor.execute(query, params)
    plantdetails = cursor.fetchall()

    return render_template('plant_detail.html',plantdetails=plantdetails, page=page, total_pages=total_pages,search_query=search_query)

#-------------------------------------Delete a plant------------------------------------------
@admin_blueprint.route('/delete_plant/<int:plant_id>', methods=['POST', 'GET'])
def delete_plant(plant_id):
    cursor = getCursor(dictionary_cursor=True)

    # First, check if the plant is in any user's favorite list
    cursor.execute("SELECT * FROM favorite WHERE Plant = %s", (plant_id,))
    if cursor.fetchone():
        flash("This plant can't be deleted because it has been added to My Favorite Plant by users.", 'danger')
        return redirect(url_for('admin.plant_detail'))
    
    else:
        # If the plant is not in the favorite list, proceed with deletion
        # delete from plantattribute table
        cursor.execute("DELETE FROM plantattribute WHERE PlantID = %s", (plant_id,))
        # delete from plantdetail table
        cursor.execute("DELETE FROM plantdetail WHERE ID = %s", (plant_id,))
        connection.commit()  
        flash('Plant deleted successfully.', 'success')
    return redirect(url_for('admin.plant_detail'))



#-----------------------------------------------edit plant details--------------------------------
@admin_blueprint.route('/edit_plant/<int:plant_id>', methods=['GET', 'POST'])
def edit_plant(plant_id):
    cursor = getCursor(dictionary_cursor=True)

    # Check if the plant is in any user's favorite list
    cursor.execute("SELECT * FROM favorite WHERE Plant = %s", (plant_id,))
    if cursor.fetchone():
        flash("This plant can't be edited because it has been added to My Favorite Plant by users.", 'danger')
        return redirect(url_for('admin.plant_detail', plant_id=plant_id))

    if request.method == 'POST':
        # Retrieve form data
        botanical_name = request.form['BotanicalName']
        common_name = request.form['CommonName']
        family = request.form['Family']
        distribution = request.form['Distribution']
        habitat = request.form['Habitat']
        note = request.form['Note']
        image = request.files['Image']
        image_reference = request.form.get('image_reference', "")
        is_delete = int(request.form['Visibility'])
        image_filename = None
        if image and allowed_file(image.filename):
            image_filename = secure_filename(image.filename)
            save_path = os.path.join('static/img', image_filename)
            full_save_path = os.path.join(app.root_path, save_path)
            image.save(full_save_path)
            if image_reference =="":
                image_reference = 'Source unknown'

            # Update image file path in database
            update_query = """
            UPDATE plantdetail
            SET BotanicalName=%s, CommonName=%s, Family=%s, Distribution=%s, Habitat=%s, Note=%s, Image=%s, is_delete=%s, reference=%s
            WHERE ID=%s
            """
            cursor.execute(update_query, (botanical_name, common_name, family, distribution, habitat, note, image_filename, is_delete, image_reference, plant_id))
        
        else:
            if image_reference =="":
                image_reference = 'Source unknown'            
            # Update database without changing the image
            update_query = """
            UPDATE plantdetail
            SET BotanicalName=%s, CommonName=%s, Family=%s, Distribution=%s, Habitat=%s, Note=%s, is_delete=%s, reference=%s
            WHERE ID=%s
            """
            cursor.execute(update_query, (botanical_name, common_name, family, distribution, habitat, note, is_delete, image_reference, plant_id))

        connection.commit()
        # Redirect back to the plant details page
        flash('Plant details updated successfully!', 'success')
        return redirect(url_for('admin.plant_detail', plant_id=plant_id))
    
    # Fetch the existing plant details for GET request
    cursor.execute("SELECT * FROM plantdetail WHERE ID = %s", (plant_id,))
    plant = cursor.fetchone()
    return render_template('edit_plant.html', plant=plant)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'png', 'jpg', 'jpeg'}

#----------------------------------------plant attribute view-------------------------------------
@admin_blueprint.route('/plant_attributes/<int:plant_id>')
def plant_attributes(plant_id):
    cursor = getCursor(dictionary_cursor=True)

    query = """
    SELECT pa.PlantID, 
            ct.ID AS ConservationID, ct.ConservationThreatStatus, ct.Score AS ConservationScore,
            p.ID AS PalatabilityID, p.Level AS PalatabilityLevel, p.Score AS PalatabilityScore,
            d.ID AS DefoliationID, d.ToleranceToDefoliation, d.Score AS DefoliationScore,
            gr.ID AS GrowthRateID, gr.GrowthRate AS GrowthRate, gr.Score AS GrowthRateScore,
            tp.ID AS ToxicPartsID, tp.ToxicParts AS ToxicParts, tp.Score AS ToxicPartsScore,
            h.ID AS HeightID, h.`PlantHeight (m)` AS Height, h.Score AS HeightScore,
            s.ID AS ShadeID, s.ShadeClass, s.Score AS ShadeScore,
            sl.ID AS ShelterID, sl.ShelterClass, sl.Score AS ShelterScore,
            c.ID AS CanopyID, c.CanopySize, c.Score AS CanopyScore,
            fs.ID AS FoodSourceID, fs.SourceQuantity, fs.Score AS FoodScore,
            bn.ID AS BirdID, bn.Level AS BirdNestingSites, bn.Score AS BirdScore,
            dt.ID AS DroughtToleranceID, dt.DroughtTolerance, dt.Score AS DroughtToleranceScore,
            ft.ID AS FrostToleranceID, ft.FrostTolerance, ft.Score AS FrostToleranceScore,
            wt.ID AS WindToleranceID, wt.WindTolerance, wt.Score AS WindToleranceScore,
            st.ID AS SaltToleranceID, st.SaltTolerance, st.Score AS SaltToleranceScore,
            sp.ID AS SunPreferencesID, sp.SunPreferences, sp.Score AS SunPreferencesScore,
            sd.ID AS SoilDrainageID, sd.SoilDrainage, sd.Score AS SoilDrainageScore,
            sdp.ID AS SoilDepthID, sdp.SoilDepth, sdp.Score AS SoilDepthScore,
            sm.ID AS SoilMoistureID, sm.SoilMoisture, sm.Score AS SoilMoistureScore,
            stp.ID AS SoilTypeID, stp.SoilType, stp.Score AS SoilTypeScore,
            wl.ID AS WetlandID, wl.WetlandType, wl.Score AS WetlandTypeScore,
            f.ID AS FlammabilityID, f.Flammability, f.Score AS FlammabilityScore,
            pd.BotanicalName AS BotanicalName

    FROM plantattribute pa
    LEFT JOIN conservationthreat ct ON pa.ConservationThreatStatus = ct.ID
    LEFT JOIN palatability p ON pa.Palatability = p.ID
    LEFT JOIN defoliation d ON pa.Defoliation = d.ID
    LEFT JOIN growthrate gr ON pa.GrowthRate = gr.ID
    LEFT JOIN toxicparts tp ON pa.ToxicParts = tp.ID
    LEFT JOIN height h ON pa.Height = h.ID
    LEFT JOIN shade s ON pa.Shade = s.ID
    LEFT JOIN shelter sl ON pa.Shelter = sl.ID
    LEFT JOIN canopy c ON pa.Canopy = c.ID
    LEFT JOIN foodsources fs ON pa.FoodSources = fs.ID
    LEFT JOIN birdnestingsites bn ON pa.BirdNestingSites = bn.ID
    LEFT JOIN droughttolerance dt ON pa.DroughtTolerance = dt.ID
    LEFT JOIN frosttolerance ft ON pa.FrostTolerance = ft.ID
    LEFT JOIN windtolerance wt ON pa.WindTolerance = wt.ID
    LEFT JOIN salttolerance st ON pa.SaltTolerance = st.ID
    LEFT JOIN sunpreference sp ON pa.SunPreferences = sp.ID
    LEFT JOIN soildrainage sd ON pa.SoilDrainage = sd.ID
    LEFT JOIN soildepth sdp ON pa.SoilDepth = sdp.ID
    LEFT JOIN soilmoisture sm ON pa.SoilMoisture = sm.ID
    LEFT JOIN soiltype stp ON pa.SoilType = stp.ID
    LEFT JOIN wetland wl ON pa.Wetland = wl.ID
    LEFT JOIN flammability f ON pa.Flammability = f.ID
    LEFT JOIN plantdetail pd ON pa.PlantID = pd.ID
    WHERE pa.PlantID = %s
    """
    cursor.execute(query, (plant_id,))
    attributes = cursor.fetchone()

    if attributes:
        conservation_query = "SELECT ID, ConservationThreatStatus, Score FROM conservationthreat"
        cursor.execute(conservation_query)
        conservation_options = cursor.fetchall()

        palatability_query = "SELECT ID, Level, Score FROM palatability"
        cursor.execute(palatability_query)
        palatability_options = cursor.fetchall()

        defoliation_query = "SELECT ID, ToleranceToDefoliation, Score FROM defoliation"
        cursor.execute(defoliation_query)
        defoliation_options = cursor.fetchall()

        growthrate_query = "SELECT ID, GrowthRate, Score FROM growthrate"
        cursor.execute(growthrate_query)
        growthrate_options = cursor.fetchall()

        toxic_query = "SELECT ID, ToxicParts, Score FROM toxicparts"
        cursor.execute(toxic_query)
        toxic_options = cursor.fetchall()

        height_query = "SELECT ID, `PlantHeight (m)`, Score FROM height"
        cursor.execute(height_query)
        height_options = cursor.fetchall()

        shade_query = "SELECT ID, ShadeClass, Score FROM shade"
        cursor.execute(shade_query)
        shade_options = cursor.fetchall()

        shelter_query = "SELECT ID, ShelterClass, Score FROM shelter"
        cursor.execute(shelter_query)
        shelter_options = cursor.fetchall()

        canopy_query = "SELECT ID, CanopySize, Score FROM canopy"
        cursor.execute(canopy_query)
        canopy_options = cursor.fetchall()

        foodsource_query = "SELECT ID, SourceQuantity, Score FROM foodsources"
        cursor.execute(foodsource_query)
        foodsource_options = cursor.fetchall()

        birdnestingsite_query = "SELECT ID, Level, Score FROM birdnestingsites"
        cursor.execute(birdnestingsite_query)
        birdnestingsite_options = cursor.fetchall()

        droughttolerance_query = "SELECT ID, DroughtTolerance, Score FROM droughttolerance"
        cursor.execute(droughttolerance_query)
        droughttolerance_options = cursor.fetchall()

        frosttolerance_query = "SELECT ID, FrostTolerance, Score FROM frosttolerance"
        cursor.execute(frosttolerance_query)
        frosttolerance_options = cursor.fetchall()

        windtolerance_query = "SELECT ID, WindTolerance, Score FROM windtolerance"
        cursor.execute(windtolerance_query)
        windtolerance_options = cursor.fetchall()

        salttolerance_query = "SELECT ID, SaltTolerance, Score FROM salttolerance"
        cursor.execute(salttolerance_query)
        salttolerance_options = cursor.fetchall()

        sunpreference_query = "SELECT ID, SunPreferences, Score FROM sunpreference"
        cursor.execute(sunpreference_query)
        sunpreference_options = cursor.fetchall()

        soildrainage_query = "SELECT ID, SoilDrainage, Score FROM soildrainage"
        cursor.execute(soildrainage_query)
        soildrainage_options = cursor.fetchall()

        soildepth_query = "SELECT ID, SoilDepth, Score FROM soildepth"
        cursor.execute(soildepth_query)
        soildepth_options = cursor.fetchall()

        soilmoisture_query = "SELECT ID, SoilMoisture, Score FROM soilmoisture"
        cursor.execute(soilmoisture_query)
        soilmoisture_options = cursor.fetchall()

        soiltype_query = "SELECT ID, SoilType, Score FROM soiltype"
        cursor.execute(soiltype_query)
        soiltype_options = cursor.fetchall()

        wetland_query = "SELECT ID, WetlandType, Score FROM wetland"
        cursor.execute(wetland_query)
        wetland_options = cursor.fetchall()

        flammability_query = "SELECT ID, Flammability, Score FROM flammability"
        cursor.execute(flammability_query)
        flammability_options = cursor.fetchall()

    if attributes:
        return render_template('plant_attributes.html', attributes=attributes, conservation_options=conservation_options,palatability_options=palatability_options,
                               defoliation_options=defoliation_options,growthrate_options=growthrate_options,toxic_options=toxic_options,height_options=height_options,
                                shade_options=shade_options, shelter_options=shelter_options,canopy_options=canopy_options, foodsource_options=foodsource_options,
                                birdnestingsite_options=birdnestingsite_options,droughttolerance_options=droughttolerance_options, frosttolerance_options=frosttolerance_options,
                                windtolerance_options=windtolerance_options,salttolerance_options=salttolerance_options, sunpreference_options=sunpreference_options,
                                soildrainage_options=soildrainage_options,soildepth_options=soildepth_options, soilmoisture_options=soilmoisture_options,
                                soiltype_options=soiltype_options, wetland_options=wetland_options, flammability_options=flammability_options
                                )
    else:
        flash('No attributes found for this plant.', 'info')
        return redirect(url_for('admin.plant_detail'))
    
#-------------------------------------------plant attribute edit-----------------------------------    
@admin_blueprint.route('/update_attributes/<int:plant_id>', methods=['POST'])
def update_attributes(plant_id):
    cursor = getCursor(dictionary_cursor=True)

    attribute_ids = {
        'ConservationThreatStatus': request.form.get('conservation_id'),
        'Palatability': request.form.get('palatability_id'),
        'Defoliation': request.form.get('defoliation_id'),
        'GrowthRate': request.form.get('growthrate_id'),
        'ToxicParts': request.form.get('toxic_id'),
        'Height': request.form.get('height_id'),
        'Shade': request.form.get('shade_id'),
        'Shelter': request.form.get('shelter_id'),
        'Canopy': request.form.get('canopy_id'),
        'FoodSources': request.form.get('foodsource_id'),
        'BirdNestingSites': request.form.get('birdnestingsite_id'),
        'DroughtTolerance': request.form.get('droughttolerance_id'),
        'FrostTolerance': request.form.get('frosttolerance_id'),
        'WindTolerance': request.form.get('windtolerance_id'),
        'SaltTolerance': request.form.get('salttolerance_id'),
        'SunPreferences': request.form.get('sunpreference_id'),
        'SoilDrainage': request.form.get('soildrainage_id'),
        'SoilDepth': request.form.get('soildepth_id'),
        'SoilMoisture': request.form.get('soilmoisture_id'),
        'SoilType': request.form.get('soiltype_id'),
        'Wetland': request.form.get('wetland_id'),
        'Flammability': request.form.get('flammability_id')
    }
    
    # Update each attribute in the database
    for attribute, new_id in attribute_ids.items():
        if new_id:  # Check if a new ID has been provided
            update_query = f"UPDATE plantattribute SET {attribute} = %s WHERE PlantID = %s"
            cursor.execute(update_query, (new_id, plant_id))
            connection.commit() 
    
    flash('Attributes updated successfully.', 'success')
    return redirect(url_for('admin.plant_attributes', plant_id=plant_id))

#----------------------------------------add a plant-----------------------------------------------
@admin_blueprint.route('/add_plant', methods=['GET','POST'])
def add_plant():
    #connect to database
    cursor = getCursor(dictionary_cursor=True)

    #get attribute options from database
    conservation_query = "SELECT ID, ConservationThreatStatus, Score FROM conservationthreat"
    cursor.execute(conservation_query)
    conservation_options = cursor.fetchall()

    palatability_query = "SELECT ID, Level, Score FROM palatability"
    cursor.execute(palatability_query)
    palatability_options = cursor.fetchall()

    defoliation_query = "SELECT ID, ToleranceToDefoliation, Score FROM defoliation"
    cursor.execute(defoliation_query)
    defoliation_options = cursor.fetchall()

    growthrate_query = "SELECT ID, GrowthRate, Score FROM growthrate"
    cursor.execute(growthrate_query)
    growthrate_options = cursor.fetchall()

    toxicparts_query = "SELECT ID, ToxicParts, Score FROM toxicparts"
    cursor.execute(toxicparts_query)
    toxicparts_options = cursor.fetchall()

    height_query = "SELECT ID, `PlantHeight (m)`, Score FROM height"
    cursor.execute(height_query)
    height_options = cursor.fetchall()

    shade_query = "SELECT ID, ShadeClass, Score FROM shade"
    cursor.execute(shade_query)
    shade_options = cursor.fetchall()

    shelter_query = "SELECT ID, ShelterClass, Score FROM shelter"
    cursor.execute(shelter_query)
    shelter_options = cursor.fetchall()

    canopy_query = "SELECT ID, CanopySize, Score FROM canopy"
    cursor.execute(canopy_query)
    canopy_options = cursor.fetchall()

    foodsource_query = "SELECT ID, SourceQuantity, Score FROM foodsources"
    cursor.execute(foodsource_query)
    foodsource_options = cursor.fetchall()

    birdnestingsite_query = "SELECT ID, Level, Score FROM birdnestingsites"
    cursor.execute(birdnestingsite_query)
    birdnestingsite_options = cursor.fetchall()

    droughttolerance_query = "SELECT ID, DroughtTolerance, Score FROM droughttolerance"
    cursor.execute(droughttolerance_query)
    droughttolerance_options = cursor.fetchall()

    frosttolerance_query = "SELECT ID, FrostTolerance, Score FROM frosttolerance"
    cursor.execute(frosttolerance_query)
    frosttolerance_options = cursor.fetchall()

    windtolerance_query = "SELECT ID, WindTolerance, Score FROM windtolerance"
    cursor.execute(windtolerance_query)
    windtolerance_options = cursor.fetchall()

    salttolerance_query = "SELECT ID, SaltTolerance, Score FROM salttolerance"
    cursor.execute(salttolerance_query)
    salttolerance_options = cursor.fetchall()

    sunpreference_query = "SELECT ID, SunPreferences, Score FROM sunpreference"
    cursor.execute(sunpreference_query)
    sunpreference_options = cursor.fetchall()

    soildrainage_query = "SELECT ID, SoilDrainage, Score FROM soildrainage"
    cursor.execute(soildrainage_query)
    soildrainage_options = cursor.fetchall()

    soildepth_query = "SELECT ID, SoilDepth, Score FROM soildepth"
    cursor.execute(soildepth_query)
    soildepth_options = cursor.fetchall()

    soilmoisture_query = "SELECT ID, SoilMoisture, Score FROM soilmoisture"
    cursor.execute(soilmoisture_query)
    soilmoisture_options = cursor.fetchall()

    soiltype_query = "SELECT ID, SoilType, Score FROM soiltype"
    cursor.execute(soiltype_query)
    soiltype_options = cursor.fetchall()

    wetland_query = "SELECT ID, WetlandType, Score FROM wetland"
    cursor.execute(wetland_query)
    wetland_options = cursor.fetchall()

    flammability_query = "SELECT ID, Flammability, Score FROM flammability"
    cursor.execute(flammability_query)
    flammability_options = cursor.fetchall()

    if request.method == 'POST':
        #get the data from the form
        botanical_name = request.form['botanicalName']
        common_name = request.form['commonName']
        family = request.form['family']
        distribution = request.form.get('distribution', '')
        habitat = request.form.get('habitat', '')
        note = request.form.get('note', '')
        image = request.files['image']
        image_filename = None
        image_reference = request.form.get('image_reference', '')

        conservation_id = request.form['conservationThreatStatus']
        palatability_id = request.form['palatability']
        defoliation_id = request.form['defoliation']
        growthrate_id = request.form['growthrate']
        toxic_id = request.form['toxic']
        height_id = request.form['height']
        shade_id = request.form['shade']
        shelter_id = request.form['shelter']
        canopy_id = request.form['canopy']
        foodsource_id = request.form['foodsource']
        bird_id = request.form['bird']
        drought_id = request.form['drought']
        frost_id = request.form['frost']
        wind_id = request.form['wind']
        salt_id = request.form['salt']
        sun_id = request.form['sun']
        drainage_id = request.form['drainage']
        depth_id = request.form['depth']
        moisture_id = request.form['moisture']
        soiltype_id = request.form['soiltype']
        wetland_id = request.form['wetland']
        flammability_id = request.form['flammability']

        if image:
            image_filename = secure_filename(image.filename)
            save_path = os.path.join('static/img', image_filename)
            full_save_path = os.path.join(app.root_path, save_path)
            image.save(full_save_path)

        if image_reference is None:
            reference = 'Source unknown'


        try:
            #insert into plantdetail table
            query = """
            INSERT INTO plantdetail (BotanicalName, CommonName, Family, Distribution, Habitat, Note, Image, reference)
            VALUES (%s, %s, %s, %s, %s, %s, %s,%s)
            """
            cursor.execute(query, (botanical_name, common_name, family, distribution, habitat, note, image_filename, reference))
            plant_id = cursor.lastrowid

            # Insert into plantattribute table
            attribute_query = """
            INSERT INTO plantattribute (PlantID, ConservationThreatStatus,Palatability,Defoliation,GrowthRate,
            ToxicParts,Height,Shade,Shelter,Canopy,FoodSources,BirdNestingSites,DroughtTolerance,
            FrostTolerance,WindTolerance,SaltTolerance,SunPreferences,SoilDrainage,SoilDepth,SoilMoisture,
            SoilType,Wetland,Flammability)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(attribute_query, (plant_id, conservation_id,palatability_id,defoliation_id,growthrate_id,
                                             toxic_id,height_id,shade_id,shelter_id,canopy_id,foodsource_id,bird_id,
                                             drought_id,frost_id,wind_id,salt_id,sun_id,drainage_id,depth_id,moisture_id,
                                             soiltype_id,wetland_id,flammability_id))
            
            connection.commit()
            flash('New plant added successfully!', 'success')
        except Exception as e:
            connection.rollback()
            flash('Error adding plant: ' + str(e), 'danger')
        finally:
            cursor.close()

        return redirect(url_for('admin.plant_detail'))
    else:
        return render_template('add_plant.html', conservation_options = conservation_options,palatability_options=palatability_options,
                               defoliation_options=defoliation_options,growthrate_options=growthrate_options,toxicparts_options=toxicparts_options,height_options=height_options,
                                shade_options=shade_options, shelter_options=shelter_options,canopy_options=canopy_options, foodsource_options=foodsource_options,
                                birdnestingsite_options=birdnestingsite_options,droughttolerance_options=droughttolerance_options, frosttolerance_options=frosttolerance_options,
                                windtolerance_options=windtolerance_options,salttolerance_options=salttolerance_options, sunpreference_options=sunpreference_options,
                                soildrainage_options=soildrainage_options,soildepth_options=soildepth_options, soilmoisture_options=soilmoisture_options,
                                soiltype_options=soiltype_options, wetland_options=wetland_options, flammability_options=flammability_options
                                )


# upload the file
@admin_blueprint.route('/upload_plant_attributes', methods=['POST'])
def upload_plant_attributes():
    file = request.files['excelFile']
    if not file:
        flash('No file selected', 'danger')
        return redirect(url_for('admin.plant_detail'))

    try:

        df = pd.read_excel(file)

        cursor = getCursor()

        for _, row in df.iterrows():
            plant_id = row.get('PlantID')
            botanical_name = row.get('BotanicalName', None)
            common_name = row.get('CommonName', None)
            family = row.get('Family', None)
            distribution = row.get('Distribution', None)
            habitat = row.get('Habitat', None)
            note = row.get('Note', None)

            conservation_score = row.get('ConservationThreatStatus')
            palatability_score = row.get('Palatability')
            defoliation_score = row.get('ToleranceToDefoliation')
            growthrate_score = row.get('GrowthRate')
            toxicparts_score = row.get('ToxicParts')
            height_score = row.get('PlantHeight (m)')
            shade_score = str(row.get('ShadeClass'))
            if shade_score == "nan":
                shade_score = "None"  
            else:
                shade_score = shade_score or None           
            shelter_score = str(row.get('ShelterClass'))
            if shelter_score == "nan":
                shelter_score = "None"  
            else:
                shelter_score = shelter_score or None              
            canopy_score = str(row.get('CanopySize'))
            if canopy_score == "nan":
                canopy_score = "None"  
            else:
                canopy_score = canopy_score or None             
            foodscore = row.get('SourceQuantity')
            birdscore = row.get('BirdNestingSites')
            droughttolerance_score = row.get('DroughtTolerance')
            frosttolerance_score = row.get('FrostTolerance')
            windtolerance_score = row.get('WindTolerance')
            salttolerance_score = row.get('SaltTolerance')
            sunpreference_score = row.get('SunPreferences')
            soildrainage_score = row.get('SoilDrainage')
            soildepth_score = row.get('SoilDepth')
            soilmoisture_score = row.get('SoilMoisture')
            soiltype_score = row.get('SoilType')
            wetland_score = row.get('WetlandType')
            flammability_score = row.get('Flammability')
            print(f"Shade Score: {shade_score}")
            query_to_print = f"(SELECT ID FROM shade WHERE ShadeClass = '{shade_score}' LIMIT 1)"
            print(f"Shade Query: {query_to_print}")
            if plant_id: 

                update_plantdetail = """
                UPDATE plantdetail SET 
                    BotanicalName = %s,
                    CommonName = %s,
                    Family = %s,
                    Distribution = %s,
                    Habitat = %s,
                    Note = %s
                WHERE ID = %s
                """
                cursor.execute(update_plantdetail, (
                    botanical_name, common_name, family, distribution, habitat, note, plant_id
                ))


                update_plantattribute = """
                UPDATE plantattribute SET 
                    ConservationThreatStatus = (SELECT ID FROM conservationthreat WHERE ConservationThreatStatus = %s LIMIT 1),
                    Palatability = (SELECT ID FROM palatability WHERE Level = %s LIMIT 1),
                    Defoliation = (SELECT ID FROM defoliation WHERE ToleranceToDefoliation = %s LIMIT 1),
                    GrowthRate = (SELECT ID FROM growthrate WHERE GrowthRate = %s LIMIT 1),
                    ToxicParts = (SELECT ID FROM toxicparts WHERE ToxicParts = %s LIMIT 1),
                    Height = (SELECT ID FROM height WHERE `PlantHeight (m)` = %s LIMIT 1),
                    Shade = (SELECT ID FROM shade WHERE ShadeClass = %s LIMIT 1),
                    Shelter = (SELECT ID FROM shelter WHERE ShelterClass = %s LIMIT 1),
                    Canopy = (SELECT ID FROM canopy WHERE CanopySize = %s LIMIT 1),
                    FoodSources = (SELECT ID FROM foodsources WHERE SourceQuantity = %s LIMIT 1),
                    BirdNestingSites = (SELECT ID FROM birdnestingsites WHERE Level = %s LIMIT 1),
                    DroughtTolerance = (SELECT ID FROM droughttolerance WHERE DroughtTolerance = %s LIMIT 1),
                    FrostTolerance = (SELECT ID FROM frosttolerance WHERE FrostTolerance = %s LIMIT 1),
                    WindTolerance = (SELECT ID FROM windtolerance WHERE WindTolerance = %s LIMIT 1),
                    SaltTolerance = (SELECT ID FROM salttolerance WHERE SaltTolerance = %s LIMIT 1),
                    SunPreferences = (SELECT ID FROM sunpreference WHERE SunPreferences = %s LIMIT 1),
                    SoilDrainage = (SELECT ID FROM soildrainage WHERE SoilDrainage = %s LIMIT 1),
                    SoilDepth = (SELECT ID FROM soildepth WHERE SoilDepth = %s LIMIT 1),
                    SoilMoisture = (SELECT ID FROM soilmoisture WHERE SoilMoisture = %s LIMIT 1),
                    SoilType = (SELECT ID FROM soiltype WHERE SoilType = %s LIMIT 1),
                    Wetland = (SELECT ID FROM wetland WHERE WetlandType = %s LIMIT 1),
                    Flammability = (SELECT ID FROM flammability WHERE Flammability = %s LIMIT 1)
                WHERE PlantID = %s
                """
                cursor.execute(update_plantattribute, (
                    conservation_score, palatability_score, defoliation_score, growthrate_score,
                    toxicparts_score, height_score, shade_score, shelter_score, canopy_score,
                    foodscore, birdscore, droughttolerance_score, frosttolerance_score,
                    windtolerance_score, salttolerance_score, sunpreference_score,
                    soildrainage_score, soildepth_score, soilmoisture_score, soiltype_score,
                    wetland_score, flammability_score, plant_id
                ))

            else: 
                insert_plantdetail = """
                INSERT INTO plantdetail (BotanicalName, CommonName, Family, Distribution, Habitat, Note)
                VALUES (%s, %s, %s, %s, %s, %s)
                """
                cursor.execute(insert_plantdetail, (botanical_name, common_name, family, distribution, habitat, note))
                new_plant_id = cursor.lastrowid

                insert_plantattribute = """
                INSERT INTO plantattribute (PlantID, ConservationThreatStatus, Palatability, Defoliation, GrowthRate, ToxicParts, Height, Shade, Shelter, Canopy, FoodSources, BirdNestingSites, DroughtTolerance, FrostTolerance, WindTolerance, SaltTolerance, SunPreferences, SoilDrainage, SoilDepth, SoilMoisture, SoilType, Wetland, Flammability)
                VALUES (%s, 
                    (SELECT ID FROM conservationthreat WHERE ConservationThreatStatus = %s LIMIT 1),
                    (SELECT ID FROM palatability WHERE Level = %s LIMIT 1),
                    (SELECT ID FROM defoliation WHERE ToleranceToDefoliation = %s LIMIT 1),
                    (SELECT ID FROM growthrate WHERE GrowthRate = %s LIMIT 1),
                    (SELECT ID FROM toxicparts WHERE ToxicParts = %s LIMIT 1),
                    (SELECT ID FROM height WHERE `PlantHeight (m)` = %s LIMIT 1),
                    (SELECT ID FROM shade WHERE ShadeClass = %s LIMIT 1),
                    (SELECT ID FROM shelter WHERE ShelterClass = %s LIMIT 1),
                    (SELECT ID FROM canopy WHERE CanopySize = %s LIMIT 1),
                    (SELECT ID FROM foodsources WHERE SourceQuantity = %s LIMIT 1),
                    (SELECT ID FROM birdnestingsites WHERE Level = %s LIMIT 1),
                    (SELECT ID FROM droughttolerance WHERE DroughtTolerance = %s LIMIT 1),
                    (SELECT ID FROM frosttolerance WHERE FrostTolerance = %s LIMIT 1),
                    (SELECT ID FROM windtolerance WHERE WindTolerance = %s LIMIT 1),
                    (SELECT ID FROM salttolerance WHERE SaltTolerance = %s LIMIT 1),
                    (SELECT ID FROM sunpreference WHERE SunPreferences = %s LIMIT 1),
                    (SELECT ID FROM soildrainage WHERE SoilDrainage = %s LIMIT 1),
                    (SELECT ID FROM soildepth WHERE SoilDepth = %s LIMIT 1),
                    (SELECT ID FROM soilmoisture WHERE SoilMoisture = %s LIMIT 1),
                    (SELECT ID FROM soiltype WHERE Score = %s LIMIT 1),
                    (SELECT ID FROM wetland WHERE WetlandType = %s LIMIT 1),
                    (SELECT ID FROM flammability WHERE Flammability = %s LIMIT 1)
                )
                """
                cursor.execute(insert_plantattribute, (
                    new_plant_id, conservation_score, palatability_score, defoliation_score, growthrate_score,
                    toxicparts_score, height_score, shade_score, shelter_score, canopy_score,
                    foodscore, birdscore, droughttolerance_score, frosttolerance_score,
                    windtolerance_score, salttolerance_score, sunpreference_score,
                    soildrainage_score, soildepth_score, soilmoisture_score, soiltype_score,
                    wetland_score, flammability_score
                ))

        connection.commit()
        flash('Plant attributes updated successfully!', 'success')
        return redirect(url_for('admin.plant_detail'))

    except Exception as e:
        if "Duplicate entry" in str(e):
            flash("Error: Duplicate plant entry. Please ensure unique PlantID.", 'danger')
        elif "Subquery returns more than 1 row" in str(e):
            flash("Error: Duplicate attribute scores found for one or more plant attributes. Please ensure unique scores.", 'danger')
        else:
            flash(f"Error uploading plant attributes: {str(e)}", 'danger')
        return redirect(url_for('admin.plant_detail'))


                               

 
@admin_blueprint.route('/download_excel', methods=['GET'])
def download_excel():
    try:
        cursor = getCursor(dictionary_cursor=True)


        query = """
        SELECT pd.ID as PlantID, pd.BotanicalName, pd.CommonName, pd.Family, pd.Distribution, pd.Habitat, pd.Note,
        ct.ConservationThreatStatus, p.Level as Palatability, d.ToleranceToDefoliation,gr.GrowthRate, tp.ToxicParts,
            h.`PlantHeight (m)`, s.ShadeClass, sl.ShelterClass, c.CanopySize, fs.SourceQuantity, bn.Level as BirdNestingSites, dt.DroughtTolerance,
            ft.FrostTolerance, wt.WindTolerance, st.SaltTolerance, sp.SunPreferences, sd.SoilDrainage, sdp.SoilDepth,
            sm.SoilMoisture, stp.SoilType, wl.WetlandType, f.Flammability
        FROM plantdetail pd
        LEFT JOIN plantattribute pa ON pd.ID = pa.PlantID
        LEFT JOIN conservationthreat ct ON pa.ConservationThreatStatus = ct.ID
        LEFT JOIN palatability p ON pa.Palatability = p.ID
        LEFT JOIN defoliation d ON pa.Defoliation = d.ID
        LEFT JOIN growthrate gr ON pa.GrowthRate = gr.ID
        LEFT JOIN toxicparts tp ON pa.ToxicParts = tp.ID
        LEFT JOIN height h ON pa.Height = h.ID
        LEFT JOIN shade s ON pa.Shade = s.ID
        LEFT JOIN shelter sl ON pa.Shelter = sl.ID
        LEFT JOIN canopy c ON pa.Canopy = c.ID
        LEFT JOIN foodsources fs ON pa.FoodSources = fs.ID
        LEFT JOIN birdnestingsites bn ON pa.BirdNestingSites = bn.ID
        LEFT JOIN droughttolerance dt ON pa.DroughtTolerance = dt.ID
        LEFT JOIN frosttolerance ft ON pa.FrostTolerance = ft.ID
        LEFT JOIN windtolerance wt ON pa.WindTolerance = wt.ID
        LEFT JOIN salttolerance st ON pa.SaltTolerance = st.ID
        LEFT JOIN sunpreference sp ON pa.SunPreferences = sp.ID
        LEFT JOIN soildrainage sd ON pa.SoilDrainage = sd.ID
        LEFT JOIN soildepth sdp ON pa.SoilDepth = sdp.ID
        LEFT JOIN soilmoisture sm ON pa.SoilMoisture = sm.ID
        LEFT JOIN soiltype stp ON pa.SoilType = stp.ID
        LEFT JOIN wetland wl ON pa.Wetland = wl.ID
        LEFT JOIN flammability f ON pa.Flammability = f.ID
        """
        cursor.execute(query)
        plant_data = cursor.fetchall()


        output = BytesIO()
        writer = pd.ExcelWriter(output, engine='xlsxwriter')


        df = pd.DataFrame(plant_data)
        df.to_excel(writer, index=False, sheet_name='Plant Attributes')

        writer.close()

        output.seek(0)


        return send_file(output, download_name="plant_attributes.xlsx", as_attachment=True)

    except Exception as e:
        flash(f"Error downloading plant attributes: {str(e)}", 'danger')
        return redirect(url_for('admin.plant_detail'))
