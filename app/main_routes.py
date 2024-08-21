from flask import Blueprint, render_template, request, session
from datetime import date
import mysql.connector
import connect
from flask import jsonify
from flask import abort

main_blueprint = Blueprint('main', __name__)


def getCursor(dictionary_cursor=False):
    global connection
    connection = mysql.connector.connect(user=connect.dbuser, password=connect.dbpass, host=connect.dbhost,
                                         database=connect.dbname, autocommit=True)
    cursor = connection.cursor(dictionary=dictionary_cursor)
    return cursor


@main_blueprint.route('/', methods=['GET', 'POST'])
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
    WHERE pd.BotanicalName LIKE %s OR pd.CommonName LIKE %s
    """
    cursor.execute(query, (search_query, search_query))
    detailed_plants = cursor.fetchall()
    session['last_view'] = {'view_name': 'search', 'params': request.args.to_dict()}

    if detailed_plants:
        return render_template('filter_result.html', detailed_plants=detailed_plants, from_search=True)
    else:
        message = "No results found. Please adjust your search criteria and try again."
        return render_template('index.html', message=message)


# search suggestions
@main_blueprint.route('/search_suggestions', methods=['GET'])
def search_suggestions():
    search_query = request.args.get('term', '')
    if search_query:
        search_query = f"%{search_query}%"
        query = """
        SELECT pd.BotanicalName,pd.CommonName
        FROM plantdetail pd
        WHERE pd.BotanicalName LIKE %s OR pd.CommonName LIKE %s
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


# livestock results
def livestock_results(defoliation_weight, growth_rate_weight, palatability_weight, toxic_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score
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
    return cursor.fetchall()


# conservation results
def conservation_results(conservation_threat_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score and limit the results to the top 10
    query = """
    SELECT pa.PlantID,
           (ct.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN conservationthreat ct ON pa.ConservationThreatStatus = ct.ID
    ORDER BY pa.PlantID
    """

    cursor.execute(query, (conservation_threat_weight,))

    return cursor.fetchall()


# shade and shelter results
def shade_shelter_results(height_weight, shade_weight, shelter_weight, canopy_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score and limit the results to the top 10
    query = """
    SELECT pa.PlantID,
           (h.Score * %s + s.Score * %s 
           + sh.Score * %s + c.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN height h ON pa.Height = h.ID
    JOIN shade s ON pa.Shade = s.ID
    JOIN shelter sh ON pa.Shelter = sh.ID
    JOIN canopy c ON pa.Canopy = c.ID
    ORDER BY pa.PlantID
    """

    cursor.execute(query, (height_weight, shade_weight, shelter_weight, canopy_weight))

    return cursor.fetchall()


# bush bird results
def bird_results(bird_weight, food_source_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score and limit the results to the top 10
    query = """
    SELECT pa.PlantID,
           (f.Score * %s + bn.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN foodsources f ON pa.FoodSources = f.ID
    JOIN birdnestingsites bn ON pa.BirdNestingSites = bn.ID
    ORDER BY pa.PlantID
    """

    cursor.execute(query, (food_source_weight, bird_weight))

    return cursor.fetchall()


# environmental results
def environment_results(drought_tolerance_weight, frost_tolerance_weight, wind_tolerance_weight, salt_tolerance,
                        sun_shade_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score and limit the results to the top 10
    query = """
    SELECT pa.PlantID,
           (dt.Score * %s + ft.Score * %s + wt.Score * %s
           + st.Score * %s + sp.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN droughttolerance dt ON pa.DroughtTolerance = dt.ID
    JOIN frosttolerance ft ON pa.FrostTolerance = ft.ID
    JOIN windtolerance wt ON pa.WindTolerance = wt.ID
    JOIN salttolerance st ON pa.SaltTolerance = st.ID
    JOIN sunpreference sp ON pa.SunPreferences = sp.ID
    ORDER BY pa.PlantID
    """

    cursor.execute(query, (drought_tolerance_weight,
                           frost_tolerance_weight, wind_tolerance_weight, salt_tolerance, sun_shade_weight))

    return cursor.fetchall()


# soil results
def soil_results(soil_drainage_weight, soil_depth_weight, soil_moisture_weight, soil_type_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score and limit the results to the top 10
    query = """
    SELECT pa.PlantID,
           (sd.Score * %s + sde.Score * %s + sm.Score * %s + stp.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN soildrainage sd ON pa.SoilDrainage = sd.ID
    JOIN soildepth sde ON pa.SoilDepth = sde.ID
    JOIN soilmoisture sm ON pa.SoilMoisture = sm.ID
    JOIN soiltype stp ON pa.SoilType = stp.ID
    ORDER BY pa.PlantID
    """

    cursor.execute(query, (soil_drainage_weight,
                           soil_depth_weight, soil_moisture_weight, soil_type_weight))

    return cursor.fetchall()


# wetland results
def wetland_results(wetland_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score and limit the results to the top 10
    query = """
    SELECT pa.PlantID, 
           ( wl.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN wetland wl ON pa.Wetland = wl.ID
    ORDER BY pa.PlantID
    """

    cursor.execute(query, (wetland_weight,))

    return cursor.fetchall()


# flammability results
def flammability_results(flammability_weight):
    # connect to database
    cursor = getCursor(dictionary_cursor=True)

    # calculate the overall score and limit the results to the top 10
    query = """
    SELECT pa.PlantID,
           (fl.Score * %s) AS OverallScore
    FROM plantattribute pa
    JOIN flammability fl ON pa.Flammability = fl.ID
    ORDER BY pa.PlantID
    """

    cursor.execute(query, (flammability_weight,))

    return cursor.fetchall()


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
    full_path = request.full_path
    session['full_path'] = full_path
    scores = [
        livestock_results(defoliation_weight, growth_rate_weight, palatability_weight, toxic_weight),
        conservation_results(conservation_threat_weight),
        shade_shelter_results(height_weight, shade_weight, shelter_weight, canopy_weight),
        bird_results(bird_weight, food_source_weight),
        environment_results(drought_tolerance_weight, frost_tolerance_weight, wind_tolerance_weight, salt_tolerance,
                            sun_shade_weight),
        soil_results(soil_drainage_weight, soil_depth_weight, soil_moisture_weight, soil_type_weight),
        wetland_results(wetland_weight),
        flammability_results(flammability_weight)
    ]

    final_scores = {}
    for score_list in scores:
        for entry in score_list:
            plant_id = entry['PlantID']
            if plant_id not in final_scores:
                final_scores[plant_id] = 0
            final_scores[plant_id] += entry['OverallScore']

    top_scores = sorted(final_scores.items(), key=lambda item: item[1], reverse=True)[:20]
    top_plant_ids = [plant[0] for plant in top_scores]

    cursor = getCursor(dictionary_cursor=True)
    query = """
    SELECT pd.ID, pd.BotanicalName, pd.CommonName, pd.Family, pd.Distribution, pd.Habitat, pd.Image
    FROM plantdetail pd
    WHERE pd.ID IN (%s)
    """ % ','.join(['%s'] * len(top_plant_ids))

    cursor.execute(query, top_plant_ids)
    detailed_plants = cursor.fetchall()

    for plant in detailed_plants:
        plant['Score'] = final_scores[plant['ID']]

    detailed_plants.sort(key=lambda plant: plant['Score'], reverse=True)
    session['last_view'] = {'view_name': 'final_scores', 'params': request.form.to_dict()}
    return render_template('filter_result.html', detailed_plants=detailed_plants, from_search=False)


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
