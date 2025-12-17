# export_mysql_to_google_sheets.py
import os
import pandas as pd
import mysql.connector
import gspread
from google.oauth2.service_account import Credentials
from gspread_dataframe import set_with_dataframe

# ---------- CONFIG ----------
GCP_CREDS_JSON = r"C:\Users\vishnu\OneDrive\Desktop\automation\gcp_credentials.json"   # update to your path
SHEET_NAME = "Layoffs Dashboard Data"             # Google Sheet title OR use sheet id
WORKSHEET_NAME = "data"
MYSQL_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'VISHNU2004',    # change to your MySQL password
    'database': 'layoffs_db',
    'raise_on_warnings': True
}
# ----------------------------

def fetch_from_mysql():
    conn = mysql.connector.connect(**MYSQL_CONFIG)
    df = pd.read_sql("SELECT company, location, total_laid_off, `date`, percentage_laid_off, industry, stage, funds_raised, country FROM layoffs", conn)
    conn.close()
    return df

def upload_to_google_sheet(df: pd.DataFrame):
    scopes = [
        "https://www.googleapis.com/auth/spreadsheets",
        "https://www.googleapis.com/auth/drive"
    ]
    creds = Credentials.from_service_account_file(GCP_CREDS_JSON, scopes=scopes)
    client = gspread.authorize(creds)

    try:
        sh = client.open(SHEET_NAME)
    except gspread.SpreadsheetNotFound:
        sh = client.create(SHEET_NAME)

    try:
        worksheet = sh.worksheet(WORKSHEET_NAME)
        worksheet.clear()
    except gspread.exceptions.WorksheetNotFound:
        worksheet = sh.add_worksheet(title=WORKSHEET_NAME, rows="1000", cols="20")

    set_with_dataframe(worksheet, df, include_index=False, include_column_header=True, resize=True)
    print("Upload complete:", SHEET_NAME, "/", WORKSHEET_NAME)

def main():
    df = fetch_from_mysql()
    # Optional cleaning:
    # df = df.fillna('')
    upload_to_google_sheet(df)

if __name__ == "__main__":
    main()
