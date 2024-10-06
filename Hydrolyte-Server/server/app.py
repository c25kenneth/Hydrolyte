from datetime import datetime
from flask import Flask, request
import pickle
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal

#Initialize AWS DynamoDB and Tables
dynamodb = boto3.resource('dynamodb')

user_table = dynamodb.Table('Hydrolyte')
prediction_table = dynamodb.Table('hydrolyte-user-predictions')
drink_table = dynamodb.Table('hydrolyte-drink-table')
location_table = dynamodb.Table("hydrolyte_locations")

# Load water loss model from pickle file
pickle_in = open('dehydration_estimation_model.pkl', 'rb')
model = pickle.load(pickle_in)

app = Flask(__name__)

#Prediction-based API Methods
@app.route('/put_prediction', methods=['POST'])
def put_prediction():
    current_datetime = datetime.now().isoformat()
    data = request.json
    
    uid = data.get('uid')
    age_years = data.get('age_years')
    height_cm = data.get('height_cm')
    weight_kg = data.get('weight_kg')
    hand_temperature_average = data.get('hand_temperature_average')
    arm_temperature_average = data.get('arm_temperature_average')

    result = model.predict([[age_years, 
    height_cm, 
    weight_kg, 
    hand_temperature_average, 
    arm_temperature_average
    ] ])
    prediction_table.put_item(
    Item={
            'uid': uid,
            'age': age_years,
            'height_cm': Decimal(str(data.get('height_cm'))),
            'weight_kg': Decimal(str(data.get('weight_kg'))),
            'hand_temperature_average': Decimal(str(data.get('hand_temperature_average'))),
            'arm_temperature_average': Decimal(str(data.get('arm_temperature_average'))),
            'prediction_result': Decimal(str(round(result[0], 2))),  
            'timestamp': current_datetime,
    }
    )  
    return str(round(result[0], 2))

@app.route('/get_prediction', methods=['GET'])
def get_prediction():
    uid = request.args.get('uid') 
    if not uid:
        return {'error': 'UID is required'}, 400

    response = prediction_table.query(
        KeyConditionExpression=Key('uid').eq(uid)
    )

    items = response.get('Items', [])

    return {'predictions': items}


# User Authentication/Authorization logic with Firebase AWS DynamoDB
@app.route('/add_user', methods=['POST'])
def add_user():
    data = request.json

    # Provided when calling API through app client. 
    uid = data.get('uid')
    age = int(data.get('age'))  
    weight = Decimal(str(data.get('weight')))
    height = Decimal(str(data.get('height'))) 

    response = user_table.put_item(
        Item={
            'uid': uid,
            'age': age, 
            'weight': weight, 
            'height': height, 
        }
    ) 

    return response

@app.route('/get_user', methods=['GET'])
def get_user():
    uid = request.args.get('uid')

    if not uid:
        return "Missing parameter", 400 

    response = user_table.get_item(
        Key={
            'uid': uid
        }
    )

    if "Item" in response:
        return response["Item"] 
    else:
        return {"message": "No User Found"}, 404

# Updating the user's information (important for ML model in app)
@app.route('/update_user', methods=['PUT'])
def update_user():
    data = request.json

    uid = data.get('uid')
    age = data.get('age') 
    weight = data.get('weight')  
    height = data.get('height')

    update_expression = "SET "
    expression_attribute_values = {}
    
    # Biometric data updating
    if age is not None:
        update_expression += "age = :age, "
        expression_attribute_values[":age"] = int(age)

    if weight is not None:
        update_expression += "weight = :weight, "
        expression_attribute_values[":weight"] = Decimal(str(weight))

    if height is not None:
        update_expression += "height = :height, "
        expression_attribute_values[":height"] = Decimal(str(height))

    update_expression = update_expression.rstrip(", ")

    response = user_table.update_item(
        Key={'uid': uid},
        UpdateExpression=update_expression,
        ExpressionAttributeValues=expression_attribute_values,
        ReturnValues="UPDATED_NEW"  # Returns the updated attributes
    )

    return {
        "message": "User updated successfully",
        "updatedAttributes": response.get("Attributes", {})
    }, 200


# API Methods for water intake
@app.route('/add_water_intake', methods=['POST'])
def add_water_intake():
    data = request.json

    uid = data.get('uid')
    drinkName = data.get('drinkName')
    drinkAmount = Decimal(str(data.get('drinkAmount')))
    isWater = data.get("isWater")
    current_datetime = datetime.now().isoformat()

    response = drink_table.put_item(
        Item={
            'uid': uid,
            'drinkName': drinkName, 
            'drinkAmount': drinkAmount, 
            'isWater': isWater, 
            'timestamp': current_datetime 
        }
    )

    return response 

@app.route('/get_water_intake', methods=['GET'])
def get_water_intake():

    uid = request.args.get('uid')

    response = drink_table.query(
        KeyConditionExpression=Key('uid').eq(uid),
        ScanIndexForward=False  
    )

    drinks = response.get('Items', [])

    return {'drinks': drinks} 

# Get health locations from Dynamo. IDs will be crucial when markers are used.
@app.route('/get_locations', methods=['GET'])
def get_locations():
    try:
        response = location_table.scan()
        locations = response.get('Items', [])

        return {'locations': locations}, 200
    except Exception as e:
        return {'error': str(e)}, 500


if __name__ == '__main__':
    # Hid full url for Github
    app.run(host='XXX.XXX.XX.XX', port=00000, debug=True)