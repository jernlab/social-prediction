# Folder Structure

## Models & Experiment Data

- ```Data``` - CSV files for empirical data and their probability distributions. Used in generating predictions.

- ```GeneratedPredictions``` - pre-generated predictions made by prediction models.
    - ```/Social/InterpolatedContextRatings``` - Contains interpolated context ratings used in generating social predictions

- ```PredictionModel``` - contains R scripts for generating model predictions

- ```Results``` - Experiment results

- ```Analysis``` - Experiment and results analysis

## FormR Surveys
- ```PythonScripts``` - Python scripts used to programatically generate FormR surveys & transform experiment results to tidy-format

- ```Surveys``` - The survey files used in the experiment. These files need to be uploaded as a survey on <a href="formr.org">FormR</a> to run experiment.

