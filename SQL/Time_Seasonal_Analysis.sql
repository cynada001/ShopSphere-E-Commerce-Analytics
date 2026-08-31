-- ============================================================
-- TIME & SEASONAL ANALYSIS
-- MONTHLY REVENUE TREND
-- ============================================================

WITH MONTHLY_REVENUE AS (
    SELECT
        YEAR(O.ORDER_DATE) AS ORDER_YEAR,
        MONTH(O.ORDER_DATE) AS ORDER_MONTH,
        SUM(OD.SALES_AMOUNT) AS TOTAL_REVENUE
    FROM ORDERS O
    JOIN ORDERS_DETAILS OD
        ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY
        YEAR(O.ORDER_DATE),
        MONTH(O.ORDER_DATE)
)

SELECT
    ORDER_YEAR,
    ORDER_MONTH,
    TOTAL_REVENUE
FROM MONTHLY_REVENUE
ORDER BY
    ORDER_YEAR,
    ORDER_MONTH;


    -- ============================================================
-- MONTH-OVER-MONTH REVENUE GROWTH
-- ============================================================

WITH MONTHLY_REVENUE AS (
    SELECT
        YEAR(O.ORDER_DATE) AS ORDER_YEAR,
        MONTH(O.ORDER_DATE) AS ORDER_MONTH,
        SUM(OD.SALES_AMOUNT) AS TOTAL_REVENUE
    FROM ORDERS O
    JOIN ORDERS_DETAILS OD
        ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY
        YEAR(O.ORDER_DATE),
        MONTH(O.ORDER_DATE)
),

PREVIOUS_MONTH AS (
    SELECT
        ORDER_YEAR,
        ORDER_MONTH,
        TOTAL_REVENUE,

        LAG(TOTAL_REVENUE) OVER (
            ORDER BY ORDER_YEAR, ORDER_MONTH
        ) AS PREVIOUS_MONTH_REVENUE

    FROM MONTHLY_REVENUE
)

SELECT
    ORDER_YEAR,
    ORDER_MONTH,
    TOTAL_REVENUE,
    PREVIOUS_MONTH_REVENUE,

    ROUND(
        CAST(
            TOTAL_REVENUE - PREVIOUS_MONTH_REVENUE
            AS DECIMAL(18,2)
        )
        / NULLIF(PREVIOUS_MONTH_REVENUE, 0) * 100,
        2
    ) AS MOM_REVENUE_GROWTH_RATE

FROM PREVIOUS_MONTH

ORDER BY
    ORDER_YEAR,
    ORDER_MONTH;

    -- ============================================================
-- YEAR-OVER-YEAR REVENUE GROWTH
-- ============================================================

WITH YEARLY_REVENUE AS (
    SELECT
        YEAR(O.ORDER_DATE) AS ORDER_YEAR,
        SUM(OD.SALES_AMOUNT) AS TOTAL_REVENUE
    FROM ORDERS O
    JOIN ORDERS_DETAILS OD
        ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY
        YEAR(O.ORDER_DATE)
),

PREVIOUS_YEAR AS (
    SELECT
        ORDER_YEAR,
        TOTAL_REVENUE,

        LAG(TOTAL_REVENUE) OVER (
            ORDER BY ORDER_YEAR
        ) AS PREVIOUS_YEAR_REVENUE

    FROM YEARLY_REVENUE
)

SELECT
    ORDER_YEAR,
    TOTAL_REVENUE,
    PREVIOUS_YEAR_REVENUE,

    ROUND(
        CAST(
            TOTAL_REVENUE - PREVIOUS_YEAR_REVENUE
            AS DECIMAL(18,2)
        )
        / NULLIF(PREVIOUS_YEAR_REVENUE, 0) * 100,
        2
    ) AS YOY_REVENUE_GROWTH_RATE

FROM PREVIOUS_YEAR

ORDER BY
    ORDER_YEAR;


    -- ============================================================
-- HIGHEST & LOWEST REVENUE MONTH
-- ============================================================

WITH MONTHLY_REVENUE AS (
    SELECT
        YEAR(O.ORDER_DATE) AS ORDER_YEAR,
        MONTH(O.ORDER_DATE) AS ORDER_MONTH,
        SUM(OD.SALES_AMOUNT) AS TOTAL_REVENUE
    FROM ORDERS O
    JOIN ORDERS_DETAILS OD
        ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY
        YEAR(O.ORDER_DATE),
        MONTH(O.ORDER_DATE)
),

HIGHEST_REVENUE_MONTH AS (
    SELECT TOP 1
        ORDER_YEAR,
        ORDER_MONTH,
        TOTAL_REVENUE
    FROM MONTHLY_REVENUE
    ORDER BY
        TOTAL_REVENUE DESC
),

LOWEST_REVENUE_MONTH AS (
    SELECT TOP 1
        ORDER_YEAR,
        ORDER_MONTH,
        TOTAL_REVENUE
    FROM MONTHLY_REVENUE
    ORDER BY
        TOTAL_REVENUE ASC
)

SELECT
    HRM.ORDER_YEAR AS HIGHEST_REVENUE_YEAR,
    HRM.ORDER_MONTH AS HIGHEST_REVENUE_MONTH,
    HRM.TOTAL_REVENUE AS HIGHEST_REVENUE,

    LRM.ORDER_YEAR AS LOWEST_REVENUE_YEAR,
    LRM.ORDER_MONTH AS LOWEST_REVENUE_MONTH,
    LRM.TOTAL_REVENUE AS LOWEST_REVENUE

FROM HIGHEST_REVENUE_MONTH HRM
CROSS JOIN LOWEST_REVENUE_MONTH LRM;


-- ============================================================
-- MONTHLY YEAR-OVER-YEAR REVENUE COMPARISON
-- ============================================================

WITH MONTHLY_REVENUE AS (
    SELECT
        YEAR(O.ORDER_DATE) AS ORDER_YEAR,
        MONTH(O.ORDER_DATE) AS ORDER_MONTH,
        SUM(OD.SALES_AMOUNT) AS TOTAL_REVENUE
    FROM ORDERS O
    JOIN ORDERS_DETAILS OD
        ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY
        YEAR(O.ORDER_DATE),
        MONTH(O.ORDER_DATE)
),

YEARLY_COMPARISON AS (
    SELECT
        ORDER_MONTH,

        MAX(
            CASE
                WHEN ORDER_YEAR = 2024
                THEN TOTAL_REVENUE
            END
        ) AS REVENUE_2024,

        MAX(
            CASE
                WHEN ORDER_YEAR = 2025
                THEN TOTAL_REVENUE
            END
        ) AS REVENUE_2025

    FROM MONTHLY_REVENUE

    GROUP BY
        ORDER_MONTH
)

SELECT
    ORDER_MONTH,
    REVENUE_2024,
    REVENUE_2025,

    ROUND(
        CAST(
            REVENUE_2025 - REVENUE_2024
            AS DECIMAL(18,2)
        )
        / NULLIF(REVENUE_2024, 0) * 100,
        2
    ) AS YOY_REVENUE_GROWTH_RATE

FROM YEARLY_COMPARISON

ORDER BY
    ORDER_MONTH;

--============================================================
-- MONTHLY SEASONALITY ANALYSIS
--============================================================

WITH MONTHLY_REVENUE AS (
    SELECT
        YEAR(O.ORDER_DATE) AS ORDER_YEAR,
        MONTH(O.ORDER_DATE) AS ORDER_MONTH,
        SUM(OD.SALES_AMOUNT) AS TOTAL_REVENUE
    FROM ORDERS O
    JOIN ORDERS_DETAILS OD
        ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY
        YEAR(O.ORDER_DATE),
        MONTH(O.ORDER_DATE)
),

MONTHLY_SEASONALITY AS (
    SELECT
        ORDER_MONTH,

        ROUND(
            AVG(TOTAL_REVENUE),
            2
        ) AS AVERAGE_REVENUE,

        MAX(TOTAL_REVENUE) AS HIGHEST_YEAR_REVENUE,

        MIN(TOTAL_REVENUE) AS LOWEST_YEAR_REVENUE

    FROM MONTHLY_REVENUE

    GROUP BY
        ORDER_MONTH
)

SELECT
    ORDER_MONTH,
    AVERAGE_REVENUE,
    HIGHEST_YEAR_REVENUE,
    LOWEST_YEAR_REVENUE,

    RANK() OVER (
        ORDER BY AVERAGE_REVENUE DESC
    ) AS SEASONAL_REVENUE_RANK

FROM MONTHLY_SEASONALITY

ORDER BY
    SEASONAL_REVENUE_RANK;




