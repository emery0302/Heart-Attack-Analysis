# Heart-Attack-Analysis

The data source is from Heart Attack Analysis & Prediction Dataset on Kaggle (RASHIK RAHMAN), avaliable on 2nd April 2023 from: https://www.kaggle.com/datasets/rashikrahmanpritom/heart-attack-analysis-prediction-dataset

# Data description
About this dataset

Age : Age of the patient

Sex : Sex of the patient

exang: exercise induced angina (1 = yes; 0 = no)

ca: number of major vessels (0-3)

cp : Chest Pain type chest pain type

Value 1: typical angina
Value 2: atypical angina
Value 3: non-anginal pain
Value 4: asymptomatic

trtbps : resting blood pressure (in mm Hg)

chol : cholestoral in mg/dl fetched via BMI sensor

fbs : (fasting blood sugar > 120 mg/dl) (1 = true; 0 = false)

rest_ecg : resting electrocardiographic results

Value 0: normal
Value 1: having ST-T wave abnormality (T wave inversions and/or ST elevation or depression of > 0.05 mV)
Value 2: showing probable or definite left ventricular hypertrophy by Estes' criteria

thalach : maximum heart rate achieved

target : 0= less chance of heart attack 1= more chance of heart attack

# data exploration and visulation
The dataset is seperated to two parts to investigated, catagorical and nnumerical variables. I visualized the relationship between outcome and categarical and numerical variable, respectively. Besides, th eheat map is used to obsevered the correlation among numerical values, and we found there is no strong correlaiton among them.

In numerical variables, we notice that the higher thalach (maximum heart rate achieved) might be the reseaon cause heart attacks (Fig). 

In categorical variables, male have much higher proportion in low chacnce to have heart attack, but both genders have similar proportion in high chance to have heart attacks.

Moreover, we build a model to classify whether a patient had a heart attack by the all variables in the dataset. The trained models show more than 80% of accurancy to classify positive and negative results, with a confidence interval of [0.73; 0.91]. Thus, we believe that the variable are helpful to conduct the classificaiton of whether a patient had a heart attack.  











