

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
- <img width="1536" height="1024" alt="architectire" src="https://github.com/user-attachments/assets/5c8032c0-7042-4e9d-be20-2a36d4ce0b7e" />

`

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

## 📊 Dataset Description

- **Source:** Kaggle – Global Layoffs Dataset  by swaptr
- **Format:** CSV
- **Link:** https://www.kaggle.com/datasets/swaptr/layoffs-2022 
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
- <img width="1093" height="222" alt="image" src="https://github.com/user-attachments/assets/6d138f73-d97b-4a52-83d8-8c546fc268ef" />


### Main Table (`layoffs`)
Stores **fully cleaned and analytics-ready data**.

📸 *Screenshot to add:*  
- <img width="1240" height="226" alt="image" src="https://github.com/user-attachments/assets/f871bd3a-541f-402e-9579-f5644c1a643b" />


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

* <img width="217" height="41" alt="image" src="https://github.com/user-attachments/assets/de46208b-8d75-488d-aea4-f9ffc1dbc423" />
<img width="1035" height="613" alt="image" src="https://github.com/user-attachments/assets/6f635e0a-d54f-4b90-817c-8f5fd486f2bf" />
<img width="882" height="496" alt="image" src="https://github.com/user-attachments/assets/fd9f390f-836f-443a-b045-1f3b762dd652" />




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

* <img width="923" height="898" alt="image" src="https://github.com/user-attachments/assets/aca8f8a4-8431-4902-b194-6bc6534fc3a7" />
<img width="862" height="691" alt="image" src="https://github.com/user-attachments/assets/8cd1f006-77cb-46df-946a-da17ae4f30a3" />



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

* <img width="1338" height="853" alt="image" src="https://github.com/user-attachments/assets/68b1d078-5b21-4597-a32a-02aaa56aa14d" />


---

## 📊 Tableau Dashboard

The Tableau Public dashboard provides insights such as:

* Layoffs by year
* Layoffs by country and industry
* Company-wise layoffs
* Funding vs layoffs trends

📸 *Screenshot to add:*

* <img width="1645" height="796" alt="image" src="https://github.com/user-attachments/assets/50e22869-90de-4279-b467-7edfb6383d93" />
<img width="1647" height="796" alt="image" src="https://github.com/user-attachments/assets/d0630913-2215-457d-9299-0786629e6a27" />



🔗 **Tableau Public Dashboard Link:**
https://public.tableau.com/views/dashboard_layoffs/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

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


