from flask import Flask, request, render_template
import numpy as np
import pandas as pd
import pickle
import tensorflow
from keras.models import load_model
from sklearn.preprocessing import StandardScaler




# start Flask
application = Flask(__name__)


# render default web page
@application.route('/')
def home():
    return render_template("index.html")

# define prediction function
@application.route('/', methods=['POST', 'GET'])
def prediction():
    # if form is submitted
    if request.method == 'POST':
        # reset the prediction variable
        prediction=""

        # load the model and scaler
        with open('ev_regression_scaler', 'rb') as scaler_file:
             scaler = pickle.load(scaler_file)
        model = load_model('EV ANN Regression Model.h5')

        # get values through the input bars
        brand = request.form["brand"]
        market = request.form["market"]
        # model = request.form["model"] # note that this column may need to be removed because this model is supposed to be used for new vehicles
        model_year = request.form["model_year"]
        body_style = request.form["body_style"]
        curb_weight = request.form["curb_weight"]
        drag_coefficient = request.form["drag_coefficient"]
        front_track = request.form["front_track"]
        gvwr = request.form["gvwr"]
        height = request.form["height"]
        length = request.form["length"]
        materials = request.form["materials"]
        number_of_doors = request.form["number_of_doors"]
        number_of_seats = request.form["number_of_seats"]
        rear_track = request.form["rear_track"]
        trunk_volume = request.form["trunk_volume"]
        wheel_base = request.form["wheel_base"]
        electric_motor_type = request.form["electric_motor_type"]
        location_of_motor = request.form["location_of_motor"]
        power = request.form["power"]
        torque = request.form["torque"]
        acceleration_0_100kph = request.form["acceleration_0_100kph"]
        top_speed = request.form["top_speed"]
        range = request.form["range"]
        efficiency = request.form["efficiency"]
        turning_circle = request.form["turning_circle"]
        axle_ratio = request.form["axle_ratio"]
        drivetrain = request.form["drivetrain"]
        front_brakes = request.form["front_brakes"]
        rear_brakes = request.form["rear_brakes"]
        battery_capacity = request.form["battery_capacity"]
        cooling = request.form["cooling"]
        location = request.form["location"]
        manufacturer = request.form["manufacturer"]
        number_of_cells = request.form["number_of_cells"]
        number_of_modules = request.form["number_of_modules"]
        type_of_reachargeable_battery = request.form["type_of_rechargeable_battery"]
        voltage = request.form["voltage"]
        

        # put inputs into dataframe
        df_input = pd.DataFrame([[brand, market, model_year, body_style, curb_weight, drag_coefficient, front_track, gvwr, height, length, materials,
                                number_of_doors, number_of_seats, rear_track, trunk_volume, wheel_base, electric_motor_type, location_of_motor, power,
                                torque, acceleration_0_100kph, top_speed, range, efficiency, turning_circle, axle_ratio, drivetrain, front_brakes,
                                rear_brakes, battery_capacity, cooling, location, manufacturer, number_of_cells, number_of_modules, type_of_reachargeable_battery,
                                voltage]], 
                                columns=['Brand', 'Market', 'ModelYear', 'BodyStyle', 'CurbWeight', 'DragCoefficient', 'FrontTrack', 
                                'Gvwr', 'Height', 'Length', 'Materials', 'NumberOfDoors', 'NumberOfSeats', 'RearTrack', 'TrunkVolume', 'Wheelbase', 
                                'ElectricMotorType', 'LocationOfTheMotor', 'Power', 'Torque', 'AccelerationFrom0To100Kmperh', 'TopSpeed', 'RangeMiles', 
                                'EfficiencyMPGe', 'TurningCircleMetres', 'AxleRatio', 'Drivetrain', 'FrontBrakes', 'RearBrakes', 'BatteryCapacityKWh', 
                                'Cooling', 'Location', 'Manufacturer', 'NumberOfCells', 'NumberOfModules', 'TypeOfRechargeableBattery', 'VoltageV'])


        # need to set dtypes of df_input
        num_cols = ['ModelYear', 'CurbWeight', 'DragCoefficient', 'FrontTrack',
       'Gvwr', 'Height', 'Length', 'RearTrack', 'TrunkVolume', 'Wheelbase',
       'Power', 'Torque', 'AccelerationFrom0To100Kmperh', 'TopSpeed',
       'RangeMiles', 'EfficiencyMPGe', 'TurningCircleMetres', 'AxleRatio',
       'BatteryCapacityKWh', 'NumberOfCells', 'NumberOfModules', 'VoltageV']
       

       # set numeric dtypes of df_input...all other dtypes should already be object by default
        for col in num_cols:
            df_input[col] = pd.to_numeric(df_input[col])      


        # this is the format the dataframe needs to be in
        df_nn = pd.DataFrame(columns = ['ModelYear', 'CurbWeight', 'DragCoefficient', 'FrontTrack', 'Gvwr', 'Height', 'Length', 'RearTrack', 'TrunkVolume',
                        'Wheelbase', 'Power', 'Torque', 'AccelerationFrom0To100Kmperh', 'TopSpeed', 'RangeMiles', 'EfficiencyMPGe', 'TurningCircleMetres', 'AxleRatio',
                        'BatteryCapacityKWh', 'NumberOfCells', 'NumberOfModules', 'VoltageV', 'Brand_BMW', 'Brand_Byton', 'Brand_Chevrolet', 'Brand_Dacia', 'Brand_FIAT',
                        'Brand_Ford', 'Brand_Genesis', 'Brand_Honda', 'Brand_Hyundai', 'Brand_Jaguar', 'Brand_KIA', 'Brand_MG', 'Brand_MINI', 'Brand_Mazda',
                        'Brand_MercedesBenz', 'Brand_NIO', 'Brand_Nissan', 'Brand_Opel', 'Brand_Peugeot', 'Brand_Polestar', 'Brand_Porsche', 'Brand_Renault',
                        'Brand_Rivian', 'Brand_SEAT', 'Brand_Tesla', 'Brand_Volkswagen', 'Brand_Volvo', 'Brand_e.GO', 'Brand_smart', 'Brand_ŠKODA', 'Market_Europe',
                        'Market_Europe, Australia', 'Market_Europe, China, Australia', 'Market_Europe, South Korea', 'Market_Europe, South Korea, India',
                        'Market_Global', 'Market_North America', 'Market_North America, China', 'Market_North America, Europe', 'Market_North America, Europe, Australia',
                        'Market_North America, Europe, China', 'Market_North America, Europe, China, Australia', 'Market_North America, Europe, China, Australia, Japan',
                        'Market_North America, Europe, South Korea', 'Market_North America, Japan', 'Market_North America, South America, Europe',
                        'Market_North America, South Korea', 'BodyStyle_Coupe', 'BodyStyle_Crossover', 'BodyStyle_Hatchback', 'BodyStyle_Minivan', 'BodyStyle_Pickup',
                        'BodyStyle_Sedan', 'BodyStyle_Sport utility vehicle SUV', 'Materials_93 aluminium 4 boron steel 3 steel',
                        'Materials_Advanced High Strength Steel Aluminium', 'Materials_Advanced HighStrength Steel High Tensile Steel',
                        'Materials_Aluminium High tensile strength steel', 'Materials_Aluminium highstrength boron steel',
                        'Materials_Carbon fiber reinforced polymer Aluminium', 'Materials_Carbon fibrereinforced plastic CFRP Aluminium',
                        'Materials_Carbonfiber Highstrength steel 7075 aluminium alloy', 'Materials_Corrosionresistant high strength steel',
                        'Materials_Extruded aluminium with boron steel', 'Materials_Highstrength steel',
                        'Materials_Mild steel Highstrength steel Ultrahighstrength steel Aluminium','Materials_Plastic Aluminium Highstrength steel',
                        'Materials_Steal Aluminium', 'Materials_Steel', 'Materials_Steel Aluminium', 'Materials_Steel Aluminium Alloy', 'Materials_Steel Carbonfiber',
                        'Materials_Steel Carbonfiber Aluminium', 'NumberOfDoors_3', 'NumberOfDoors_4', 'NumberOfDoors_5', 'NumberOfDoors_nan', 'NumberOfSeats_4',
                        'NumberOfSeats_4  5', 'NumberOfSeats_5', 'NumberOfSeats_5  6  7', 'NumberOfSeats_5  7', 'NumberOfSeats_6', 'NumberOfSeats_6  7',
                        'NumberOfSeats_6  8', 'NumberOfSeats_7', 'NumberOfSeats_nan', 'ElectricMotorType_AC synchronous', 'ElectricMotorType_Brushless DC',
                        'ElectricMotorType_Permanent magnet synchronous', 'ElectricMotorType_Switched reluctance', 'LocationOfTheMotor_Front  Rear',
                        'LocationOfTheMotor_Rear', 'Drivetrain_Fourwheel drive 4WD4x4', 'Drivetrain_Frontwheel drive FWD', 'Drivetrain_Rearwheel drive RWD',
                        'FrontBrakes_Ventilated discs', 'RearBrakes_Drums', 'RearBrakes_Ventilated discs', 'Cooling_Air convection',
                        'Cooling_Air convection Waterbased coolant circulation', 'Cooling_Air convection active', 'Cooling_Air convection passive',
                        'Cooling_Passive cooling', 'Cooling_Waterbased coolant circulation', 'Cooling_Waterbased coolant circulation Heat pipe',
                        'Cooling_Waterbased coolant circulation Heat pipe Battery Heating System', 'Cooling_Waterbased coolant circulation Heat pump',
                        'Cooling_Waterbased coolant circulation Heat pump optional', 'Location_Under the floor, midrear', 'Manufacturer_AESC', 'Manufacturer_CATL',
                        'Manufacturer_Deutsche Accumotive', 'Manufacturer_LG Chem', 'Manufacturer_LG Chem and Deutsche ACCUMOTIVE', 'Manufacturer_Panasonic',
                        'Manufacturer_PanasonicSanyo', 'Manufacturer_Renault and LG Chem', 'Manufacturer_SK Innovation', 'Manufacturer_Samsung SDI',
                        'Manufacturer_Tesla and Panasonic', 'Manufacturer_Tesla and Panasonic, LG Chem','TypeOfRechargeableBattery_LithiumIon'])


        # manipulate the input data so that it is suitable for the machine learning model
        # all numerical values can be copied straight from one dataframe to the other
        for col in df_input.select_dtypes(include='number').columns:
            df_nn.loc[0, col] = df_input.loc[0, col]

        # iterate through each object column and assign the correct dummie column a 1
        for col in df_input.select_dtypes(include='object'):
            dummy_col = col + "_" + str(df_input.loc[0,col])
            df_nn.loc[0, dummy_col] = 1

        # replace all other nan dummy columns with 0
        df_nn.replace(np.nan, 0, inplace=True)

        # set the dtypes of df_nn so the input is correct for the machine learning model
        for col in df_nn.columns:
            df_nn[col] = pd.to_numeric(df_nn[col])

        # reorder columns correctly for the model
        df_nn = df_nn[['ModelYear', 'CurbWeight', 'DragCoefficient', 'FrontTrack', 'Gvwr', 'Height', 'Length', 'RearTrack', 'TrunkVolume',
                        'Wheelbase', 'Power', 'Torque', 'AccelerationFrom0To100Kmperh', 'TopSpeed', 'RangeMiles', 'EfficiencyMPGe', 'TurningCircleMetres', 'AxleRatio',
                        'BatteryCapacityKWh', 'NumberOfCells', 'NumberOfModules', 'VoltageV', 'Brand_BMW', 'Brand_Byton', 'Brand_Chevrolet', 'Brand_Dacia', 'Brand_FIAT',
                        'Brand_Ford', 'Brand_Genesis', 'Brand_Honda', 'Brand_Hyundai', 'Brand_Jaguar', 'Brand_KIA', 'Brand_MG', 'Brand_MINI', 'Brand_Mazda',
                        'Brand_MercedesBenz', 'Brand_NIO', 'Brand_Nissan', 'Brand_Opel', 'Brand_Peugeot', 'Brand_Polestar', 'Brand_Porsche', 'Brand_Renault',
                        'Brand_Rivian', 'Brand_SEAT', 'Brand_Tesla', 'Brand_Volkswagen', 'Brand_Volvo', 'Brand_e.GO', 'Brand_smart', 'Brand_ŠKODA', 'Market_Europe',
                        'Market_Europe, Australia', 'Market_Europe, China, Australia', 'Market_Europe, South Korea', 'Market_Europe, South Korea, India',
                        'Market_Global', 'Market_North America', 'Market_North America, China', 'Market_North America, Europe', 'Market_North America, Europe, Australia',
                        'Market_North America, Europe, China', 'Market_North America, Europe, China, Australia', 'Market_North America, Europe, China, Australia, Japan',
                        'Market_North America, Europe, South Korea', 'Market_North America, Japan', 'Market_North America, South America, Europe',
                        'Market_North America, South Korea', 'BodyStyle_Coupe', 'BodyStyle_Crossover', 'BodyStyle_Hatchback', 'BodyStyle_Minivan', 'BodyStyle_Pickup',
                        'BodyStyle_Sedan', 'BodyStyle_Sport utility vehicle SUV', 'Materials_93 aluminium 4 boron steel 3 steel',
                        'Materials_Advanced High Strength Steel Aluminium', 'Materials_Advanced HighStrength Steel High Tensile Steel',
                        'Materials_Aluminium High tensile strength steel', 'Materials_Aluminium highstrength boron steel',
                        'Materials_Carbon fiber reinforced polymer Aluminium', 'Materials_Carbon fibrereinforced plastic CFRP Aluminium',
                        'Materials_Carbonfiber Highstrength steel 7075 aluminium alloy', 'Materials_Corrosionresistant high strength steel',
                        'Materials_Extruded aluminium with boron steel', 'Materials_Highstrength steel',
                        'Materials_Mild steel Highstrength steel Ultrahighstrength steel Aluminium','Materials_Plastic Aluminium Highstrength steel',
                        'Materials_Steal Aluminium', 'Materials_Steel', 'Materials_Steel Aluminium', 'Materials_Steel Aluminium Alloy', 'Materials_Steel Carbonfiber',
                        'Materials_Steel Carbonfiber Aluminium', 'NumberOfDoors_3', 'NumberOfDoors_4', 'NumberOfDoors_5', 'NumberOfDoors_nan', 'NumberOfSeats_4',
                        'NumberOfSeats_4  5', 'NumberOfSeats_5', 'NumberOfSeats_5  6  7', 'NumberOfSeats_5  7', 'NumberOfSeats_6', 'NumberOfSeats_6  7',
                        'NumberOfSeats_6  8', 'NumberOfSeats_7', 'NumberOfSeats_nan', 'ElectricMotorType_AC synchronous', 'ElectricMotorType_Brushless DC',
                        'ElectricMotorType_Permanent magnet synchronous', 'ElectricMotorType_Switched reluctance', 'LocationOfTheMotor_Front  Rear',
                        'LocationOfTheMotor_Rear', 'Drivetrain_Fourwheel drive 4WD4x4', 'Drivetrain_Frontwheel drive FWD', 'Drivetrain_Rearwheel drive RWD',
                        'FrontBrakes_Ventilated discs', 'RearBrakes_Drums', 'RearBrakes_Ventilated discs', 'Cooling_Air convection',
                        'Cooling_Air convection Waterbased coolant circulation', 'Cooling_Air convection active', 'Cooling_Air convection passive',
                        'Cooling_Passive cooling', 'Cooling_Waterbased coolant circulation', 'Cooling_Waterbased coolant circulation Heat pipe',
                        'Cooling_Waterbased coolant circulation Heat pipe Battery Heating System', 'Cooling_Waterbased coolant circulation Heat pump',
                        'Cooling_Waterbased coolant circulation Heat pump optional', 'Location_Under the floor, midrear', 'Manufacturer_AESC', 'Manufacturer_CATL',
                        'Manufacturer_Deutsche Accumotive', 'Manufacturer_LG Chem', 'Manufacturer_LG Chem and Deutsche ACCUMOTIVE', 'Manufacturer_Panasonic',
                        'Manufacturer_PanasonicSanyo', 'Manufacturer_Renault and LG Chem', 'Manufacturer_SK Innovation', 'Manufacturer_Samsung SDI',
                        'Manufacturer_Tesla and Panasonic', 'Manufacturer_Tesla and Panasonic, LG Chem','TypeOfRechargeableBattery_LithiumIon']]

        # save the df to csv for checking. It is not matching up with the result in jupyter notebook
        # there may be an error with the input values in the html form select boxes
        df_nn.to_csv(r'C:\Python_Projects\Portfolio\Electric Vehicles\df_nn_check.csv')

        # isolate the values
        model_input = df_nn.values.reshape(1, -1)
        
        # use the scaler to transform the input
        scaled_input = scaler.transform(model_input)

        # get prediction
        prediction = "{:,}".format(int(round(model.predict(scaled_input)[0][0], 0)))

    else:
        prediction=""

    return render_template("index.html", output=prediction)



# run flask
if __name__ == "__main__":
    application.run(debug=True)