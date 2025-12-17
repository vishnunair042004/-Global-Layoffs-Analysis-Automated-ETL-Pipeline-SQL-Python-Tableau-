CREATE TABLE layoffs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company             VARCHAR(255),
    location            VARCHAR(255),
    total_laid_off     INT,
    date               DATE,
    percentage_laid_off DECIMAL(10,2),
    industry           VARCHAR(255),
    source             TEXT,
    stage              VARCHAR(255),
    funds_raised       INT,
    country            VARCHAR(255),
    date_added         DATE,
    load_timestamp     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE layoffs_staging (
    company             VARCHAR(255),
    location            VARCHAR(255),
    total_laid_off     INT,
    date               DATE,
    percentage_laid_off DECIMAL(10,2),
    industry           VARCHAR(255),
    source             TEXT,
    stage              VARCHAR(255),
    funds_raised       INT,
    country            VARCHAR(255),
    date_added         DATE
);

CREATE DATABASE layoffs_db;
CREATE USER 'etl_user' IDENTIFIED BY 'KANNAN2004';
GRANT ALL PRIVILEGES ON layoffs_db.* TO 'etl_user'@'%';
FLUSH PRIVILEGES;

select * from layoffs;
select * from layoffs_staging;
DESCRIBE layoffs;

select count(*) from layoffs;
select count(*) from layoffs_staging;

-- remove unwanted columns :
alter table layoffs_staging
drop column source,
drop column date_added;

alter table layoffs
drop column source,
drop column date_added;


-- data cleaning
#step 1 Remove Duplicates
with layoff_dupes AS
(
select *,row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) as row_num
from layoffs
)
select * from layoff_dupes where row_num >=2;


-- this is the main duplicate cleaninng
ALTER TABLE layoffs_staging
ADD COLUMN row_num INT;

ALTER TABLE layoffs_staging
ADD COLUMN temp_id INT AUTO_INCREMENT PRIMARY KEY;


UPDATE layoffs_staging ls
JOIN (
    SELECT 
        temp_id,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off,
                         percentage_laid_off, `date`, stage, country, funds_raised
            ORDER BY temp_id
        ) AS rn
    FROM layoffs_staging
) x
ON ls.temp_id = x.temp_id
SET ls.row_num = x.rn;

select * from layoffs_staging where row_num >=2;

DELETE FROM layoffs_staging
WHERE row_num > 1;   # this deleted all the duplicates


-- step 2 Standardizing data
# it means finding issue in ur data and fixing it. Do it by column to column wise

update layoffs_staging set company= trim(company);

# check each columns for some mistakes
select country, count(*)
from layoffs_staging
group by country
order by 1; # here we can see theres a duplication of UAE and united arab emirates since both are same we gonna make it same by converting UAE into United Arab Emirates

select * from layoffs_staging where country is null;  

update layoffs_staging
set country='United Arab Emirates'
where country='UAE';

select * from layoffs_staging where country is NULL; # there were two nulls so i just added country based on the location in the row one was berlin and other was montreal


update layoffs_staging
set country = 'Canada'
where company = 'Ludia';

update layoffs_staging
set country = 'Germany'
where company = 'Fit Analytics';

alter table layoffs_staging
 drop column row_num,
 drop column temp_id;



# creating a stored procedure out of this so that u can call it everytime rather than manually cleaning everytime
# the stored procedure is made out of the above cleaning processl

DELIMITER $$

CREATE PROCEDURE clean_layoffs_staging()
BEGIN

    -- 1️⃣ Add helper columns if they do not exist
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'layoffs_staging' 
          AND COLUMN_NAME = 'row_num'
    ) THEN
        ALTER TABLE layoffs_staging ADD COLUMN row_num INT;
    END IF;

    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'layoffs_staging' 
          AND COLUMN_NAME = 'temp_id'
    ) THEN
        ALTER TABLE layoffs_staging ADD COLUMN temp_id INT AUTO_INCREMENT PRIMARY KEY;
    END IF;

    -- 2️⃣ Assign row numbers for duplicates
    UPDATE layoffs_staging ls
    JOIN (
        SELECT 
            temp_id,
            ROW_NUMBER() OVER (
                PARTITION BY company, location, industry, total_laid_off,
                             percentage_laid_off, `date`, stage, country, funds_raised
                ORDER BY temp_id
            ) AS rn
        FROM layoffs_staging
    ) x
    ON ls.temp_id = x.temp_id
    SET ls.row_num = x.rn;

    -- 3️⃣ Delete duplicates
    DELETE FROM layoffs_staging
    WHERE row_num > 1;

    -- 4️⃣ Standardize company name formatting
    UPDATE layoffs_staging 
    SET company = TRIM(company);

    -- 5️⃣ Standardize country (UAE → United Arab Emirates)
    UPDATE layoffs_staging
    SET country = 'United Arab Emirates'
    WHERE country = 'UAE';

-- 6 add country names to the following company
	update layoffs_staging
	set country = 'Canada'
	where company = 'Ludia';

	update layoffs_staging
	set country = 'Germany'
	where company = 'Fit Analytics';

    -- 7️⃣ Remove helper columns
    ALTER TABLE layoffs_staging DROP COLUMN row_num;
    ALTER TABLE layoffs_staging DROP COLUMN temp_id;

END $$

DELIMITER ;


