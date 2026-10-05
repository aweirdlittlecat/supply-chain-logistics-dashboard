USE supplychaindb;

LOAD DATA LOCAL INFILE 'C:/Desktop/try and code/supply-chain-project/data/supplychain_clean.csv'
INTO TABLE stg_supplychain
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
    COUNT(*)                     AS total_rows,
    MIN(order_date)               AS earliest_order,
    MAX(order_date)               AS latest_order,
    COUNT(DISTINCT order_id)      AS unique_orders,
    COUNT(DISTINCT order_region)  AS unique_regions
FROM stg_supplychain;