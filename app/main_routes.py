from flask import Blueprint, render_template, request, session, redirect, send_file, flash, url_for
from datetime import date
import mysql.connector
import connect
from flask import jsonify
from flask import abort
from io import BytesIO
import pandas as pd

main_blueprint = Blueprint('main', __name__)


def getCursor(dictionary_cursor=False):
    global connection
    connection = mysql.connector.connect(user=connect.dbuser, password=connect.dbpass, host=connect.dbhost,
                                         database=connect.dbname, autocommit=True)
    cursor = connection.cursor(dictionary=dictionary_cursor)
    return cursor


@main_blueprint.route('/', methods=['GET', 'POST'])
def homepage():
    cursor = getCursor(dictionary_cursor=True)
    
    # Fetch 4 newest plants for the 'New' section
    cursor.execute("SELECT * FROM plantdetail WHERE is_delete=0 ORDER BY ID DESC LIMIT 4")
    new_plants = cursor.fetchall()

    # Fetch favorite plants if the user is logged in
    favorite_plants = []
    if 'user_logged_in' or 'admin_logged_in' in session:
        user_id = session.get('ID')
        cursor.execute("SELECT plantdetail.ID, plantdetail.BotanicalName, plantdetail.CommonName, plantdetail.Family, plantdetail.Image FROM plantdetail JOIN favorite ON plantdetail.ID = favorite.Plant WHERE favorite.User = %s AND plantdetail.is_delete=0 LIMIT 4", (user_id,))
        favorite_plants = cursor.fetchall()
    
    print(favorite_plants)
    return render_template('home.html',  new_plants=new_plants, favorite_plants=favorite_plants)

@main_blueprint.route('/home', methods=['GET', 'POST'])
def home():
    return render_template('index.html')


# The search function
@main_blueprint.route('/search', methods=['GET'])
def search():
    cursor = getCursor(dictionary_cursor=True)
    search_query = request.args.get('searchQuery', '')
    search_query = "%" + search_query + "%"
    
    query = """
    SELECT pd.ID, pd.BotanicalName, pd.CommonName, pd.Family, pd.Distribution, pd.Habitat, pd.Image
    FROM plantdetail pd
    WHERE pd.is_delete=0 AND (pd.BotanicalName LIKE %s OR pd.CommonName LIKE %s)
    """
    
    cursor.execute(query, (search_query, search_query))
    detailed_plants = cursor.fetchall()
    session['last_view'] = {'view_name': 'search', 'params': request.args.to_dict()}

    if detailed_plants:
        return render_template('filter_result.html', detailed_plants=detailed_plants, from_search=True,weight_dict={})
    else:
        flash("No results found. Please adjust your search criteria and try again.", "info")
        return redirect(request.referrer or url_for('main.index'))



# search suggestions
@main_blueprint.route('/search_suggestions', methods=['GET'])
def search_suggestions():
    search_query = request.args.get('term', '')
    if search_query:
        search_query = f"%{search_query}%"
        query = """
        SELECT pd.BotanicalName,pd.CommonName
        FROM plantdetail pd
        WHERE pd.is_delete=0 AND (pd.BotanicalName LIKE %s OR pd.CommonName LIKE %s)
        LIMIT 10 
        """
        cursor = getCursor(dictionary_cursor=True)
        cursor.execute(query, (search_query, search_query))
        results = cursor.fetchall()
        suggestions = [{"label": f"{result['BotanicalName']}<br><small>{result['CommonName']}</small>",
                        "value": result['BotanicalName']}
                       for result in results]
    else:
        suggestions = []
    return jsonify(suggestions)


def livestock_results(defoliation_weight, growth_rate_weight, palatability_weight, toxic_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (p.Score * %s + d.Score * %s + gr.Score * %s + tp.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN palatability p ON pa.Palatability = p.ID
    JOIN defoliation d ON pa.Defoliation = d.ID
    JOIN growthrate gr ON pa.GrowthRate = gr.ID
    JOIN toxicparts tp ON pa.ToxicParts = tp.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (palatability_weight, defoliation_weight, growth_rate_weight, toxic_weight))
    results = cursor.fetchall()

    # Calculate the max score for this category
    query_max = """
    SELECT MAX(p.Score) AS max_pal, MAX(d.Score) AS max_def, MAX(gr.Score) AS max_growth, MAX(tp.Score) AS max_toxic
    FROM palatability p, defoliation d, growthrate gr, toxicparts tp
    """
    cursor.execute(query_max)
    max_scores = cursor.fetchone()

    # Multiply max scores by the weights
    max_total_score = (max_scores['max_pal'] * int(palatability_weight) +
                       max_scores['max_def'] * int(defoliation_weight) +
                       max_scores['max_growth'] * int(growth_rate_weight) +
                       max_scores['max_toxic'] * int(toxic_weight))

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results




# conservation results
def conservation_results(conservation_threat_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (ct.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN conservationthreat ct ON pa.ConservationThreatStatus = ct.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (conservation_threat_weight,))
    results = cursor.fetchall()

    # Calculate the max score
    query_max = "SELECT MAX(ct.Score) FROM conservationthreat ct"
    cursor.execute(query_max)
    max_score = cursor.fetchone()['MAX(ct.Score)']

    max_total_score = max_score * int(conservation_threat_weight)

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results



# shade and shelter results
def shade_shelter_results(height_weight, shade_weight, shelter_weight, canopy_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (h.Score * %s + s.Score * %s + sh.Score * %s + c.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN height h ON pa.Height = h.ID
    JOIN shade s ON pa.Shade = s.ID
    JOIN shelter sh ON pa.Shelter = sh.ID
    JOIN canopy c ON pa.Canopy = c.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (height_weight, shade_weight, shelter_weight, canopy_weight))
    results = cursor.fetchall()

    # Calculate the max score
    query_max = """
    SELECT MAX(h.Score), MAX(s.Score), MAX(sh.Score), MAX(c.Score)
    FROM height h, shade s, shelter sh, canopy c
    """
    cursor.execute(query_max)
    max_scores = cursor.fetchone()

    max_total_score = (max_scores['MAX(h.Score)'] * int(height_weight) +
                       max_scores['MAX(s.Score)'] * int(shade_weight) +
                       max_scores['MAX(sh.Score)'] * int(shelter_weight) +
                       max_scores['MAX(c.Score)'] * int(canopy_weight))

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results



# bush bird results
def bird_results(bird_weight, food_source_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (f.Score * %s + bn.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN foodsources f ON pa.FoodSources = f.ID
    JOIN birdnestingsites bn ON pa.BirdNestingSites = bn.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (food_source_weight, bird_weight))
    results = cursor.fetchall()

    # Calculate the max score
    query_max = """
    SELECT MAX(f.Score), MAX(bn.Score)
    FROM foodsources f, birdnestingsites bn
    """
    cursor.execute(query_max)
    max_scores = cursor.fetchone()

    max_total_score = (max_scores['MAX(f.Score)'] * int(food_source_weight) +
                       max_scores['MAX(bn.Score)'] * int(bird_weight))

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results


# environmental results
def environment_results(drought_tolerance_weight, frost_tolerance_weight, wind_tolerance_weight, salt_tolerance, sun_shade_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (dt.Score * %s + ft.Score * %s + wt.Score * %s + st.Score * %s + sp.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN droughttolerance dt ON pa.DroughtTolerance = dt.ID
    JOIN frosttolerance ft ON pa.FrostTolerance = ft.ID
    JOIN windtolerance wt ON pa.WindTolerance = wt.ID
    JOIN salttolerance st ON pa.SaltTolerance = st.ID
    JOIN sunpreference sp ON pa.SunPreferences = sp.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (drought_tolerance_weight, frost_tolerance_weight, wind_tolerance_weight, salt_tolerance, sun_shade_weight))
    results = cursor.fetchall()

    # Calculate the max score
    query_max = """
    SELECT MAX(dt.Score), MAX(ft.Score), MAX(wt.Score), MAX(st.Score), MAX(sp.Score)
    FROM droughttolerance dt, frosttolerance ft, windtolerance wt, salttolerance st, sunpreference sp
    """
    cursor.execute(query_max)
    max_scores = cursor.fetchone()

    max_total_score = (max_scores['MAX(dt.Score)'] * int(drought_tolerance_weight) +
                       max_scores['MAX(ft.Score)'] * int(frost_tolerance_weight) +
                       max_scores['MAX(wt.Score)'] * int(wind_tolerance_weight) +
                       max_scores['MAX(st.Score)'] * int(salt_tolerance) +
                       max_scores['MAX(sp.Score)'] * int(sun_shade_weight))

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results


# soil results
def soil_results(soil_drainage_weight, soil_depth_weight, soil_moisture_weight, soil_type_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (sd.Score * %s + sde.Score * %s + sm.Score * %s + stp.Score * %s) OverallScore
    FROM plantattribute pa
    JOIN soildrainage sd ON pa.SoilDrainage = sd.ID
    JOIN soildepth sde ON pa.SoilDepth = sde.ID
    JOIN soilmoisture sm ON pa.SoilMoisture = sm.ID
    JOIN soiltype stp ON pa.SoilType = stp.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (soil_drainage_weight, soil_depth_weight, soil_moisture_weight, soil_type_weight))
    results = cursor.fetchall()

    # Calculate the max score
    query_max = """
    SELECT MAX(sd.Score), MAX(sde.Score), MAX(sm.Score), MAX(stp.Score)
    FROM soildrainage sd, soildepth sde, soilmoisture sm, soiltype stp
    """
    cursor.execute(query_max)
    max_scores = cursor.fetchone()

    max_total_score = (max_scores['MAX(sd.Score)'] * int(soil_drainage_weight) +
                       max_scores['MAX(sde.Score)'] * int(soil_depth_weight) +
                       max_scores['MAX(sm.Score)'] * int(soil_moisture_weight) +
                       max_scores['MAX(stp.Score)'] * int(soil_type_weight))

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results



# wetland results
def wetland_results(wetland_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (wl.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN wetland wl ON pa.Wetland = wl.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (wetland_weight,))
    results = cursor.fetchall()

    # Calculate the max score
    query_max = "SELECT MAX(wl.Score) FROM wetland wl"
    cursor.execute(query_max)
    max_score = cursor.fetchone()['MAX(wl.Score)']

    max_total_score = int(max_score) * int(wetland_weight)

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results



# flammability results
def flammability_results(flammability_weight):
    cursor = getCursor(dictionary_cursor=True)

    # Calculate the overall score
    query = """
    SELECT pa.PlantID,
           (fl.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN flammability fl ON pa.Flammability = fl.ID
    ORDER BY pa.PlantID
    """
    cursor.execute(query, (flammability_weight,))
    results = cursor.fetchall()

    # Calculate the max score
    query_max = "SELECT MAX(fl.Score) FROM flammability fl"
    cursor.execute(query_max)
    max_score = cursor.fetchone()['MAX(fl.Score)']

    max_total_score = int(max_score) * int(flammability_weight)

    # Attach the max score to each entry
    for result in results:
        result['MaxScore'] = max_total_score

    return results



@main_blueprint.route('/final_scores', methods=['GET'])
def final_scores():
    
    bird_weight = request.args.get('bird', 1)
    conservation_threat_weight = request.args.get('ConservationThreat', 1)
    defoliation_weight = request.args.get('defoliation', 1)
    growth_rate_weight = request.args.get('GrowthRate', 1)
    palatability_weight = request.args.get('palatability', 1)
    toxic_weight = request.args.get('ToxicElements', 1)
    height_weight = request.args.get('height', 1)
    shade_weight = request.args.get('shade', 1)
    shelter_weight = request.args.get('shelter', 1)
    canopy_weight = request.args.get('canopy', 1)
    food_source_weight = request.args.get('FoodSources', 1)
    drought_tolerance_weight = request.args.get('DroughtTolerance', 1)
    frost_tolerance_weight = request.args.get('FrostTolerance', 1)
    wind_tolerance_weight = request.args.get('WindTolerance', 1)
    salt_tolerance = request.args.get('SaltTolerance', 1)
    sun_shade_weight = request.args.get('SunShade', 1)
    soil_drainage_weight = request.args.get('SoilDrainage', 1)
    soil_depth_weight = request.args.get('SoilDepth', 1)
    soil_moisture_weight = request.args.get('SoilMoisture', 1)
    soil_type_weight = request.args.get('SoilType', 1)
    wetland_weight = request.args.get('wetland', 1)
    flammability_weight = request.args.get('flammability', 1)

    weight_dict = {
        'Bird': bird_weight, 
        'Conservation Threat': conservation_threat_weight,
        'Palatability': palatability_weight,
        'Defoliation': defoliation_weight,
        'Growth Rate': growth_rate_weight,
        'Toxic Elements': toxic_weight,
        'Height': height_weight,
        'Shade': shade_weight,
        'Shelter': shelter_weight,
        'Canopy': canopy_weight,
        'Food Sources': food_source_weight,
        'Drought Tolerance': drought_tolerance_weight,
        'Frost Tolerance': frost_tolerance_weight,
        'Wind Tolerance': wind_tolerance_weight,
        'Salt Tolerance': salt_tolerance,
        'Sun/Shade': sun_shade_weight,
        'Soil Drainage': soil_drainage_weight,
        'Soil Depth': soil_depth_weight,
        'Soil Moisture': soil_moisture_weight,
        'Soil Type': soil_type_weight,
        'Wetland': wetland_weight,
        'Flammability': flammability_weight
    }
    # Save path to session
    full_path = request.full_path
    session['full_path'] = full_path
# Calculate the score for each category
    scores = [
        livestock_results(defoliation_weight, growth_rate_weight, palatability_weight, toxic_weight),
        conservation_results(conservation_threat_weight),
        shade_shelter_results(height_weight, shade_weight, shelter_weight, canopy_weight),
        bird_results(bird_weight, food_source_weight),
        environment_results(drought_tolerance_weight, frost_tolerance_weight, wind_tolerance_weight, salt_tolerance, sun_shade_weight),
        soil_results(soil_drainage_weight, soil_depth_weight, soil_moisture_weight, soil_type_weight),
        wetland_results(wetland_weight),
        flammability_results(flammability_weight)
    ]
    final_scores = {}
    max_scores = {}
    for score_list in scores:
        for entry in score_list:
            print(entry)
            plant_id = entry['PlantID']
            if plant_id not in final_scores:
                final_scores[plant_id] = 0
                max_scores[plant_id] = 0
            final_scores[plant_id] += entry['OverallScore']
            max_scores[plant_id] += int(entry['MaxScore'])

    cursor = getCursor(dictionary_cursor=True)
    query = """
    SELECT pd.ID
    FROM plantdetail pd
    WHERE pd.ID IN (%s) AND pd.is_delete = 0
    """ % ','.join(['%s'] * len(final_scores))

    cursor.execute(query, list(final_scores.keys()))
    filtered_ids = cursor.fetchall()
    filtered_ids = [row['ID'] for row in filtered_ids]
    filtered_final_scores = {plant_id: final_scores[plant_id] for plant_id in filtered_ids}
    filtered_max_scores = {plant_id: max_scores[plant_id] for plant_id in filtered_ids}
    percentages = {plant_id: (filtered_final_scores[plant_id] / filtered_max_scores[plant_id]) * 100 for plant_id in filtered_final_scores}
    top_scores = sorted(filtered_final_scores.items(), key=lambda item: item[1], reverse=True)[:20]
    top_plant_ids = [plant[0] for plant in top_scores]
    query = """
    SELECT pd.ID, pd.BotanicalName, pd.CommonName, pd.Family, pd.Distribution, pd.Habitat, pd.Image
    FROM plantdetail pd
    WHERE pd.ID IN (%s) 
    """ % ','.join(['%s'] * len(top_plant_ids))
    cursor.execute(query, top_plant_ids)
    detailed_plants = cursor.fetchall()
    for plant in detailed_plants:
        plant['Score'] = filtered_final_scores[plant['ID']]
        plant['Percentage'] = percentages[plant['ID']]
        plant['max_scores'] = filtered_max_scores[plant['ID']]
    detailed_plants.sort(key=lambda plant: plant['Score'], reverse=True)
    session['last_view'] = {'view_name': 'final_scores', 'params': request.form.to_dict()}
    session['filtered_plant_ids'] = top_plant_ids
    return render_template('filter_result.html', detailed_plants=detailed_plants, from_search=False,weight_dict=weight_dict)



@main_blueprint.route('/plant/<int:plant_id>')
def plant_detail(plant_id):

    #keep track of the last visited URL
    full_path = session.get('full_path', '')
    print(full_path)
    
    from_favorites = request.args.get('from_favorites', False) == 'True'
    session['from_favorites'] = from_favorites

    cursor = getCursor(dictionary_cursor=True)
    query = """
    SELECT pd.*, pa.*, ct.ConservationThreatStatus, p.Level, d.ToleranceToDefoliation,g.GrowthRate, t.ToxicParts,
    h.`PlantHeight (m)`, s.ShadeClass, sl.ShelterClass, c.CanopySize, fs.SourceQuantity, bn.Level, dt.DroughtTolerance,
    ft.FrostTolerance, wt.WindTolerance, st.SaltTolerance, sp.SunPreferences, sd.SoilDrainage, sdp.SoilDepth,
    sm.SoilMoisture, stp.SoilType, wl.WetlandType, f.Flammability
    FROM plantdetail pd
    LEFT JOIN plantattribute pa ON pd.ID = pa.PlantID
    LEFT JOIN conservationthreat ct ON pa.ConservationThreatStatus = ct.ID
    LEFT JOIN palatability p ON pa.Palatability = p.ID
    LEFT JOIN defoliation d ON pa.Defoliation = d.ID
    LEFT JOIN growthrate g ON pa.GrowthRate = g.ID
    LEFT JOIN toxicparts t ON pa.ToxicParts = t.ID
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
    WHERE pd.ID = %s
    """
    cursor.execute(query, (plant_id,))
    plant_details = cursor.fetchone()

    if not plant_details:
        cursor.close()
        abort(404)

    is_favorite = False
    if 'loggedin' in session:
        user_id = session['ID']
        cursor.execute('SELECT * FROM favorite WHERE User = %s AND Plant = %s', (user_id, plant_id))
        is_favorite = cursor.fetchone() is not None

    cursor.close()
    back_url = request.host_url[0:-1] + full_path
    return render_template('plant_details.html', plant=plant_details, is_favorite=is_favorite, back_url=back_url)




@main_blueprint.route('/download_filtered_excel', methods=['GET'])
def download_filtered_excel():
    try:
        cursor = getCursor(dictionary_cursor=True)

        filtered_plant_ids = session.get('filtered_plant_ids')
        if not filtered_plant_ids:
            flash('No filter results found to download.', 'danger')
            return redirect(url_for('main.final_scores'))
        query = """
        SELECT pd.ID, pd.BotanicalName, pd.CommonName, pd.Family, pd.Distribution, pd.Habitat, pd.Note,
ct.ConservationThreatStatus, p.Level, d.ToleranceToDefoliation,g.GrowthRate, t.ToxicParts,
    h.`PlantHeight (m)`, s.ShadeClass, sl.ShelterClass, c.CanopySize, fs.SourceQuantity, bn.Level, dt.DroughtTolerance,
    ft.FrostTolerance, wt.WindTolerance, st.SaltTolerance, sp.SunPreferences, sd.SoilDrainage, sdp.SoilDepth,
    sm.SoilMoisture, stp.SoilType, wl.WetlandType, f.Flammability
    FROM plantdetail pd
    LEFT JOIN plantattribute pa ON pd.ID = pa.PlantID
    LEFT JOIN conservationthreat ct ON pa.ConservationThreatStatus = ct.ID
    LEFT JOIN palatability p ON pa.Palatability = p.ID
    LEFT JOIN defoliation d ON pa.Defoliation = d.ID
    LEFT JOIN growthrate g ON pa.GrowthRate = g.ID
    LEFT JOIN toxicparts t ON pa.ToxicParts = t.ID
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
        WHERE pd.ID IN (%s)
        """ % ','.join(['%s'] * len(filtered_plant_ids))

        cursor.execute(query, filtered_plant_ids)
        plant_data = cursor.fetchall()

        # Sort the data in the order of top_plant_ids.
        plant_data_sorted = sorted(plant_data, key=lambda x: filtered_plant_ids.index(x['ID']))

        output = BytesIO()
        writer = pd.ExcelWriter(output, engine='xlsxwriter')

        df = pd.DataFrame(plant_data_sorted)
        df.to_excel(writer, index=False, sheet_name='Filtered Plants')

        writer.close()
        output.seek(0)
        return send_file(output, download_name="filtered_plants.xlsx", as_attachment=True)

    except Exception as e:
        flash(f"Error downloading filtered plants: {str(e)}", 'danger')
        return redirect(url_for('main.final_scores'))


