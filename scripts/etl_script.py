import pandas as pd
import subprocess
import mysql.connector
from datetime import datetime
import os

# Download dataset
subprocess.run([
    "kaggle", "datasets", "download",
    "-d", "swaptr/layoffs-2022",
    "-p", "./data",
    "--force"
])

import zipfile

zip_path = "./data/layoffs-2022.zip"
with zipfile.ZipFile(zip_path, 'r') as z:
    z.extractall("./data")

df = pd.read_csv("./data/layoffs.csv")

# Convert date fields
df['date'] = pd.to_datetime(df['date'], errors='coerce', dayfirst=False).dt.date

# Fix numeric fields
df['percentage_laid_off'] = df['percentage_laid_off'].fillna(0)
df['total_laid_off'] = df['total_laid_off'].fillna(0).astype(int)
df['funds_raised'] = df['funds_raised'].fillna(0).astype(int)

# REMOVE unwanted columns + enforce correct order
df = df[[
    'company', 'location', 'total_laid_off', 'date',
    'percentage_laid_off', 'industry', 'stage',
    'funds_raised', 'country'
]]

# Connection to mysql
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="VISHNU2004",
    database="layoffs_db"
)
cursor = conn.cursor()

# Clear staging table & insert new data
cursor.execute("TRUNCATE TABLE layoffs_staging")

insert_query = """
INSERT INTO layoffs_staging
(company, location, total_laid_off, date, percentage_laid_off,
 industry, stage, funds_raised, country)
VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
"""

cursor.executemany(insert_query, df.values.tolist())
conn.commit()

##### Clean staging data using stored procedure
cursor.execute("CALL clean_layoffs_staging();")
conn.commit()


# Main table: FULL REFRESH
cursor.execute("TRUNCATE TABLE layoffs")

cursor.execute("""
INSERT INTO layoffs (
    company, location, total_laid_off, date, percentage_laid_off,
    industry, stage, funds_raised, country
)
SELECT
    company, location, total_laid_off, date, percentage_laid_off,
    industry, stage, funds_raised, country
FROM layoffs_staging;
""")

conn.commit()
conn.close()
