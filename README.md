

# 🌍 Global Layoffs Analysis — Automated ETL Pipeline

This project demonstrates a **fully automated data engineering pipeline** built using **Python, MySQL, and Tableau Public** to analyze the **Global Layoffs dataset**.

The pipeline automatically:
- Downloads the dataset from **Kaggle**
- Loads raw data into a **MySQL staging table**
- Cleans and standardizes the data using a **MySQL stored procedure**
- Refreshes a **main (production) table**
- Exports cleaned data to **Google Sheets**
- Automatically refreshes a **Tableau Public dashboard**

This project is designed to closely mimic **real-world ETL and analytics workflows**.

---

## 📌 Project Overview

**End-to-end workflow:**

```

Kaggle Dataset
↓
Python ETL Script
↓
MySQL Staging Table
↓
MySQL Stored Procedure (Cleaning & Deduplication)
↓
MySQL Main Table (Clean Data)
↓
Google Sheets (Automated Export)
↓
Tableau Public Dashboard (Auto Refresh)

```

📸 *Screenshot to add:*  
- `docs/etl_architecture.png`

---

## 🧰 Tech Stack

| Component | Technology |
|---------|-----------|
| Programming | Python |
| Database | MySQL 8.0+ |
| Data Processing | Pandas |
| Automation | Python + Task Scheduler |
| Visualization | Tableau Public |
| Cloud Connector | Google Sheets API |
| Dataset Source | Kaggle |

---

## 📂 Repository Structure

```

global-layoffs-etl/
│
├── scripts/
│   ├── etl_kaggle_to_mysql.py       # Main ETL pipeline
│   ├── export_mysql_to_gsheets.py   # Export cleaned data to Google Sheets
│
├── sql/
│   ├── create_tables.sql            # MySQL table creation scripts
│   ├── stored_procedures.sql        # Data cleaning stored procedure
│
├── docs/
│   ├── etl_architecture.png         # Architecture diagram
│   ├── tableau_dashboard.png        # Dashboard screenshot
│
├── requirements.txt
├── .gitignore
├── .env.example
└── README.md

````

---

## 📊 Dataset Description

- **Source:** Kaggle – Global Layoffs Dataset  
- **Format:** CSV  
- **Key Columns:**
  - Company
  - Location
  - Total layoffs
  - Layoff date
  - Industry
  - Company stage
  - Funds raised
  - Country

---

## 🗄️ Database Design

### Staging Table (`layoffs_staging`)
Used to store **raw ingested data** before cleaning.

📸 *Screenshot to add:*  
- `docs/mysql_staging_table.png`

### Main Table (`layoffs`)
Stores **fully cleaned and analytics-ready data**.

📸 *Screenshot to add:*  
- `docs/mysql_main_table.png`

---

## 🧼 Data Cleaning Using Stored Procedure

All major data cleaning logic is handled **inside MySQL** using a stored procedure.

### Cleaning Tasks Performed:
- Remove duplicate rows using `ROW_NUMBER()`
- Trim text fields (company names)
- Standardize country values (e.g. `UAE → United Arab Emirates`)
- Handle missing country values
- Remove temporary helper columns

### Stored Procedure Execution:
```sql
CALL clean_layoffs_staging();
````

📸 *Screenshot to add:*

* `docs/stored_procedure_execution.png`

---

## 🐍 Python ETL Pipeline

The Python ETL script performs the following steps:

1. Download dataset from Kaggle
2. Extract ZIP file
3. Load CSV into Pandas
4. Convert date and numeric fields
5. Insert data into MySQL staging table
6. Call MySQL stored procedure for cleaning
7. Refresh main table using full reload

📸 *Screenshot to add:*

* `docs/python_etl_run.png`

---

## 🔁 Automation

The ETL script is scheduled to run **daily**, enabling full automation.

### Scheduling Options:

* Windows Task Scheduler
* Linux Cron Job

This ensures:

* Dataset updates are captured automatically
* Cleaning is consistently applied
* Dashboards stay up-to-date

📸 *Screenshot to add:*

* `docs/task_scheduler.png`

---

## 📈 Tableau Public Integration

Since **Tableau Public does not support live MySQL connections**, the cleaned data is exported to **Google Sheets**.

### Workflow:

* Python exports MySQL `layoffs` table to Google Sheets
* Tableau Public connects to Google Sheets
* Tableau Public automatically refreshes data **once per day**

📸 *Screenshot to add:*

* `docs/google_sheets_data.png`

---

## 📊 Tableau Dashboard

The Tableau Public dashboard provides insights such as:

* Layoffs by year
* Layoffs by country and industry
* Company-wise layoffs
* Funding vs layoffs trends

📸 *Screenshot to add:*

* `docs/tableau_dashboard.png`

🔗 **Tableau Public Dashboard Link:**
*Add your public dashboard URL here*

---

## 🚀 How to Run the Project

### 1️⃣ Install Dependencies

```bash
pip install -r requirements.txt
```

### 2️⃣ Configure Environment Variables

```bash
cp .env.example .env
```

Update MySQL and API credentials.

### 3️⃣ Run ETL Pipeline

```bash
python scripts/etl_kaggle_to_mysql.py
```

### 4️⃣ Export to Google Sheets

```bash
python scripts/export_mysql_to_gsheets.py
```

---

## 🔐 Security Practices

* Sensitive credentials stored in `.env`
* `.env` and API keys excluded via `.gitignore`
* Service account used for Google Sheets automation

---

## 🎯 Key Learnings

* Designing ETL pipelines using staging and production tables
* Implementing data cleaning with stored procedures
* Automating data workflows with Python
* Handling Tableau Public limitations professionally
* Building portfolio-ready data engineering projects

---

## 🛠 Future Enhancements

* Incremental loads instead of full refresh
* Logging and alerting
* Dockerized deployment
* Migration to Tableau Cloud for live database connections

---

## 📜 License

This project is licensed under the **MIT License**.

---

## 🙌 Acknowledgements

* Kaggle for the dataset
* Tableau Public for visualization
* Open-source Python community


