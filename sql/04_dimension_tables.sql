USE supplychaindb;

DROP TABLE IF EXISTS dim_shipping;

CREATE TABLE dim_shipping (
    shipping_key  INT AUTO_INCREMENT PRIMARY KEY,
    shipping_mode VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO dim_shipping (shipping_mode)
SELECT DISTINCT shipping_mode
FROM stg_supplychain
ORDER BY shipping_mode;

SELECT CONCAT('DIM_Shipping created — ', ROW_COUNT(), ' rows') AS status;

DROP TABLE IF EXISTS dim_region;

CREATE TABLE dim_region (
    region_key   INT AUTO_INCREMENT PRIMARY KEY,
    order_region VARCHAR(100) NOT NULL,
    market       VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO dim_region (order_region, market)
SELECT DISTINCT order_region, market
FROM stg_supplychain
ORDER BY order_region;

SELECT CONCAT('DIM_Region created — ', ROW_COUNT(), ' rows (expect 23)') AS status;

DROP TABLE IF EXISTS dim_geography;

CREATE TABLE dim_geography (
    geo_key          INT AUTO_INCREMENT PRIMARY KEY,
    customer_city    VARCHAR(100),
    customer_state   VARCHAR(100),
    customer_country VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO dim_geography (customer_city, customer_state, customer_country)
SELECT DISTINCT customer_city, customer_state, customer_country
FROM stg_supplychain
ORDER BY customer_country, customer_state, customer_city;

SELECT CONCAT('DIM_Geography created — ', ROW_COUNT(), ' rows') AS status;

DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product (
    product_key     INT AUTO_INCREMENT PRIMARY KEY,
    product_name    VARCHAR(200) NOT NULL,
    category_name   VARCHAR(100),
    department_name VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO dim_product (product_name, category_name, department_name)
SELECT DISTINCT product_name, category_name, department_name
FROM stg_supplychain
ORDER BY product_name;

SELECT CONCAT('DIM_Product created — ', ROW_COUNT(), ' rows') AS status;

DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer (
    customer_key     INT AUTO_INCREMENT PRIMARY KEY,
    customer_segment VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO dim_customer (customer_segment)
SELECT DISTINCT customer_segment
FROM stg_supplychain
ORDER BY customer_segment;

SELECT CONCAT('DIM_Customer created — ', ROW_COUNT(), ' rows') AS status;

SET SESSION cte_max_recursion_depth = 2000;

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key        INT PRIMARY KEY,
    full_date       DATE NOT NULL,
    `year`          INT,
    `quarter`       INT,
    `month`         INT,
    month_name      VARCHAR(20),
    `week`          INT,
    day_of_month    INT,
    day_name        VARCHAR(20),
    is_weekend      INT,
    is_full_year    INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO dim_date
WITH RECURSIVE date_series AS (
    SELECT CAST('2015-01-01' AS DATE) AS dt
    UNION ALL
    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM date_series
    WHERE dt < '2018-02-03'
)
SELECT
    CAST(DATE_FORMAT(dt, '%Y%m%d') AS UNSIGNED) AS date_key,
    dt                                            AS full_date,
    YEAR(dt)                                      AS `year`,
    QUARTER(dt)                                   AS `quarter`,
    MONTH(dt)                                     AS `month`,
    MONTHNAME(dt)                                 AS month_name,
    WEEK(dt, 3)                                   AS `week`,
    DAY(dt)                                       AS day_of_month,
    DAYNAME(dt)                                   AS day_name,
    CASE WHEN DAYOFWEEK(dt) IN (1,7) THEN 1 ELSE 0 END AS is_weekend,
    CASE WHEN YEAR(dt) IN (2015,2016,2017) THEN 1 ELSE 0 END AS is_full_year
FROM date_series;

SELECT CONCAT('DIM_Date created — ', ROW_COUNT(), ' rows') AS status;