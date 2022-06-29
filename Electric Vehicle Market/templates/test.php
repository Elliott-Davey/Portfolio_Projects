<!DOCTYPE html>
<html>
    <head>
        <title>Electric Vehicle Price Predictor</title>
    </head>

    <body>
        <form action="/" method="post">
            <label for="brand">Brand:</label>
            <select name="brand" id="brand">
                <option value="select a model">select a model</option>
                <option value="Tesla">Tesla</option>
                <option value="Audi">Audi</option>
                <option value="Volkswagen">Volkswagen</option>
                <option value="MercedesBenz">MercedesBenz</option>
                <option value="Nissan">Nissan</option>
                <option value="Hyundai">Hyundai</option>
                <option value="KIA">KIA</option>
                <option value="Ford">Ford</option>
                <option value="Chevrolet">Chevrolet</option>
                <option value="Renault">Renault</option>
                <option value="BMW">BMW</option>
                <option value="Opel">Opel</option>
                <option value="NIO">NIO</option>
                <option value="Rivian">Rivian</option>
                <option value="Mazda">Mazda</option>
                <option value="Porsche">Porsche</option>
                <option value="Genesis">Genesis</option>
                <option value="e.GO">e.GO</option>
                <option value="Byton">Byton</option>
                <option value="FIAT">FIAT</option>
                <option value="Honda">Honda</option>
                <option value="MINI">MINI</option>
                <option value="SEAT">SEAT</option>
                <option value="smart">smart</option>
                <option value="ŠKODA">ŠKODA</option>
                <option value="MG">MG</option>
                <option value="Jaguar">Jaguar</option>
                <option value="Polestar">Polestar</option>
                <option value="Peugeot">Peugeot</option>
                <option value="Dacia">Dacia</option>
                <option value="Volvo">Volvo</option>
            </select>
            <br>
            <br>
            <label for="model_year">Model Year:</label>
            <input type="number" id="model_year" name="model_year" value="<?php echo isset($_POST['model_year']) ? htmlspecialchars($_POST['model_year'], ENT_QUOTES) : ''; ?>">
            <br>
            <br>
            <input type="submit" value="Submit">
        </form>
        <h1>this is a test and this is the output: {{test_output_1, test_output_2, dataframe}}</h1>
    </body>
</html>