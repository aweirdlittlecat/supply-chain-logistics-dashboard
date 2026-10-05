USE supplychaindb;

SELECT
    ROUND(AVG(CAST(is_on_time       AS FLOAT)) * 100, 1) AS otd_rate_pct,
    ROUND(AVG(CAST(is_otif          AS FLOAT)) * 100, 1) AS otif_rate_pct,
    ROUND(AVG(CAST(is_sla_breach    AS FLOAT)) * 100, 1) AS sla_breach_pct,
    ROUND(AVG(CAST(is_perfect_order AS FLOAT)) * 100, 1) AS perfect_order_pct,
    ROUND(AVG(CAST(is_complete      AS FLOAT)) * 100, 1) AS complete_order_pct,
    COUNT(*)                                              AS total_records
FROM stg_supplychain;

SELECT
    order_year,
    COUNT(*) AS record_count
FROM stg_supplychain
GROUP BY order_year
ORDER BY order_year;

SELECT
    shipping_mode,
    COUNT(*)                                            AS total_orders,
    ROUND(AVG(CAST(is_on_time AS FLOAT)) * 100, 1)     AS otd_rate_pct,
    ROUND(AVG(CAST(is_sla_breach AS FLOAT)) * 100, 1)  AS sla_breach_pct
FROM stg_supplychain
GROUP BY shipping_mode
ORDER BY sla_breach_pct DESC;

SELECT
    order_region,
    COUNT(*)                                          AS total_orders,
    ROUND(AVG(CAST(is_on_time AS FLOAT)) * 100, 1)   AS otd_rate_pct
FROM stg_supplychain
GROUP BY order_region
ORDER BY otd_rate_pct ASC;