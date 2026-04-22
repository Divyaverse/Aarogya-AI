# 1. IMPORT LIBRARIES
import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split, RandomizedSearchCV, cross_val_score
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from sklearn.preprocessing import OrdinalEncoder

# ❌ REMOVED SMOTE IMPORT (not used, was causing error)
# from imblearn.over_sampling import SMOTE

from sklearn.utils.class_weight import compute_class_weight

from xgboost import XGBClassifier
from lightgbm import LGBMClassifier
from sklearn.ensemble import VotingClassifier

# 2. LOAD DATA (CORRECT PATH)
df = pd.read_csv("stress_prediction_dataset_1000.csv")

# 3. FEATURE ENGINEERING
df['SleepHours'] = df['SleepHours'].replace(0, 0.1)
df['WorkHours'] = df['WorkHours'].replace(0, 0.1)
df['ScreenTime'] = df['ScreenTime'].replace(0, 0.1)

df['Screen_Sleep_Ratio'] = df['ScreenTime'] / df['SleepHours']
df['Work_Sleep_Ratio'] = df['WorkHours'] / df['SleepHours']

# 4. ENCODE CATEGORICAL FEATURE
df['WorkPressure'] = df['WorkPressure'].astype(str)

mapping_dict = {'0': 'Low', '1': 'Medium', '2': 'High'}
df['WorkPressure'] = df['WorkPressure'].replace(mapping_dict)

encoder = OrdinalEncoder(categories=[['Low', 'Medium', 'High']])
df['WorkPressure'] = encoder.fit_transform(df[['WorkPressure']])

# 5. SPLIT FEATURES & TARGET
X = df.drop("StressLevel", axis=1)
y = df["StressLevel"]

# 6. TRAIN-TEST SPLIT
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# 7. ENCODE TARGET
y_encoder = OrdinalEncoder(categories=[['Low', 'Medium', 'High']])
y_train_encoded = y_encoder.fit_transform(y_train.values.reshape(-1, 1)).flatten()
y_test_encoded = y_encoder.transform(y_test.values.reshape(-1, 1)).flatten()

# CLASS WEIGHTS
classes = np.unique(y_train_encoded)
weights = compute_class_weight('balanced', classes=classes, y=y_train_encoded)
class_weights = dict(zip(classes, weights))

# 8. XGBOOST MODEL
xgb = XGBClassifier(
    objective='multi:softmax',
    num_class=3,
    eval_metric='mlogloss',
    n_estimators=300,
    max_depth=8,
    learning_rate=0.05,
    subsample=0.9,
    colsample_bytree=0.9,
    gamma=0,
    random_state=42
)

# 9. HYPERPARAMETER TUNING
param_dist = {
    'n_estimators': [100, 200, 300, 500],
    'max_depth': [4, 6, 8, 10],
    'learning_rate': [0.01, 0.05, 0.1],
    'subsample': [0.7, 0.8, 1.0],
    'colsample_bytree': [0.7, 0.8, 1.0],
    'gamma': [0, 0.1, 0.3]
}

search = RandomizedSearchCV(
    xgb,
    param_distributions=param_dist,
    n_iter=25,
    scoring='accuracy',
    cv=5,
    verbose=2,
    random_state=42,
    n_jobs=-1
)

search.fit(X_train, y_train_encoded)

# 10. ENSEMBLE
xgb = XGBClassifier(
    n_estimators=500,
    max_depth=4,
    learning_rate=0.05,
    subsample=0.8,
    colsample_bytree=0.7,
    gamma=0.3,
    eval_metric='mlogloss',
    objective='multi:softprob',
    num_class=3,
    random_state=42
)

lgb = LGBMClassifier(
    n_estimators=300,
    max_depth=8,
    learning_rate=0.05,
    random_state=42
)

ensemble = VotingClassifier(
    estimators=[('xgb', xgb), ('lgb', lgb)],
    voting='soft'
)

# Train
ensemble.fit(X_train, y_train_encoded)

# Predict
y_pred = ensemble.predict(X_test)

# 11. EVALUATION
print("\nBest Parameters:", search.best_params_)
print("\nAccuracy:", accuracy_score(y_test_encoded, y_pred))
print("\nClassification Report:\n")
print(classification_report(y_test_encoded, y_pred))
print("\nConfusion Matrix:\n")
print(confusion_matrix(y_test_encoded, y_pred))

# CROSS VALIDATION
y_encoded = y_encoder.transform(y.values.reshape(-1, 1)).flatten()
scores = cross_val_score(xgb, X, y_encoded, cv=5)
print(scores.mean())

