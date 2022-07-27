# Folder Structure

## Models & Experiment Data

- ```Data``` - CSV files for empirical data and their probability distributions. Used in generating predictions.

- ```GeneratedPredictions``` - contains CSV files of pre-generated predictions made by prediction models. Primarily useful for plotting predictions in R (using *ggplot*) without needing to generate them (predictions) every time.
    - ```/Social/InterpolatedContextRatings``` - Contains interpolated context ratings initially used in empirical social model approach (see paper for details)

- ```PredictionModel``` - contains R scripts for generating model predictions

- ```Results``` - Experiment results

- ```Analysis``` - Experiment and results analysis

## FormR Surveys
- ```PythonScripts``` - Python scripts used to programatically generate FormR surveys & transform experiment results to tidy-format

- ```Surveys``` - The survey files used in the experiment. These files need to be uploaded as a survey on <a href="formr.org">FormR</a> to run experiment.

