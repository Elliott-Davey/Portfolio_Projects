#!/usr/bin/env python
# coding: utf-8

# In[1]:


# import all neccessary libraries
import numpy as np
import pandas as pd
import pickle
from sklearn.preprocessing import StandardScaler
from sklearn.base import BaseEstimator, TransformerMixin

# the custom scaler class
class CustomScaler(BaseEstimator, TransformerMixin):
    
    def __init__(self, columns):
        self.scaler = StandardScaler()
        self.columns = columns
        
    def fit(self, X, y=None):
        self.scaler.fit(X[self.columns], y)
        self.mean_ = np.mean(X[self.columns])
        self.var_ = np.var(X[self.columns])
        return self
    
    def transform(self, X, y=None):
        init_col_order = X.columns
        X_scaled = pd.DataFrame(self.scaler.transform(X[self.columns]), columns=self.columns)
        X_not_scaled = X.loc[:,~X.columns.isin(self.columns)]
        return pd.concat([X_not_scaled, X_scaled], axis=1)[init_col_order]

# create the special class that we are going to use from here on to predict new data
class absenteeism_model():
    
    def __init__(self, model_file, scaler_file):
        # read the model and scaler files which were saved using pickle
        with open('model', 'rb') as model_file, open('scaler', 'rb') as scaler_file:
            self.reg = pickle.load(model_file)
            self.scaler = pickle.load(scaler_file)
            self.data = None
    
    # take a data file (*.csv) and preprocess it in the same was as in previously done
    def load_and_clean_data(self, data_file):
        
        #import the data
        df = pd.read_csv(data_file, delimiter=',')
        # store data in new variable for later use
        self.df_with_predictions = df.copy()
        # drop the ID column
        df.drop(['ID'], axis=1, inplace=True)
        # to preserve the code we've created in the previous section, we will add a column with 'NaN strings'
        df['Absenteeism Time in Hours'] = 'NaN'
        
        # create the 4 reason columns
        df['Reason 1'] = np.where((df['Reason for Absence'] < 15) & (df['Reason for Absence'] > 0), 1, 0)
        df['Reason 2'] = np.where((df['Reason for Absence'] < 18) & (df['Reason for Absence'] > 14), 1, 0)
        df['Reason 3'] = np.where((df['Reason for Absence'] < 22) & (df['Reason for Absence'] > 17), 1, 0)
        df['Reason 4'] = np.where((df['Reason for Absence'] < 29) & (df['Reason for Absence'] > 21), 1, 0)
        # drop the reason for absence column
        df.drop(['Reason for Absence'], axis=1, inplace=True)
        
        # convert the Date column into datetime
        df['Date'] = pd.to_datetime(df['Date'], format = '%d/%m/%Y')
        # create a month and weekday columns
        df['Month'] = pd.DatetimeIndex(df['Date']).month
        df['Weekday'] = pd.DatetimeIndex(df['Date']).weekday
        # remove the date column
        df.drop(['Date'], axis=1, inplace=True)
        
        # reorder the column names
        reordered_column_names = ['Reason 1', 'Reason 2', 'Reason 3',
       'Reason 4', 'Month', 'Weekday','Transportation Expense', 'Distance to Work', 'Age',
       'Daily Work Load Average', 'Body Mass Index', 'Education', 'Children',
       'Pets', 'Absenteeism Time in Hours']
        df = df[reordered_column_names]
        
        # map education variable to a dummy variable
        df['Education'] = np.where((df['Education'] == 1), 0, 1)
        
        # replace the NaN values
        df = df.fillna(value=0)
        
        # drop the original absenteeism time
        df.drop(['Absenteeism Time in Hours'], axis=1, inplace=True)
        
        # drop the insignificant variables based on the previous notebook
        df.drop(['Weekday', 'Daily Work Load Average', 'Distance to Work'], axis=1, inplace=True)
        
        # include this next line of code if you want to make a copy of the preprocessed data
        self.preprocessed_data = df.copy()
        
        # need this line of code so we can use it in the next functions
        self.data = self.scaler.transform(df)
    
    # a function which outputs the probability of a data point to be 1
    def predicted_probability(self):
        if (self.data is not None):
            pred = self.reg.predict_proba(self.data)[:,1]
            return pred
    
    # a function which outputs 0 or 1 based on our model
    def predicted_output_category(self):
        if (self.data is not None):
            pred_outputs = self.reg.predict(self.data)
            return pred_outputs
    
    # predict the outputs and the probabilites and
    # add columns with these values at the end of the new data
    def predicted_outputs(self):
        if (self.data is not None):
            self.preprocessed_data['Probability'] = self.reg.predict_proba(self.data)[:,1]
            self.preprocessed_data['Prediction'] = self.reg.predict(self.data)
            return self.preprocessed_data
            

