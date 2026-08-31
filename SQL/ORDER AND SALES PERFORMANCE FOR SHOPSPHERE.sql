-- ============================================================
-- ORDER & REVENUE PERFORMANCE ANALYSIS
-- ============================================================
-- Purpose:
-- Measure monthly order volume, revenue, AOV, growth rates,
-- and identify the primary driver of revenue performance.
-- ============================================================

WITH MONTHLY_PERFORMANCE AS (

    SELECT
        YEAR(O.ORDER_DATE) AS ORDER_YEAR,
        MONTH(O.ORDER_DATE) AS ORDER_MONTH,

        COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS,

        SUM(OD.SALES_AMOUNT) AS TOTAL_REVENUE

    FROM ORDERS O

    JOIN ORDERS_DETAILS OD
        ON O.ORDER_ID = OD.ORDER_ID

    GROUP BY
        YEAR(O.ORDER_DATE),
        MONTH(O.ORDER_DATE)
),

PREVIOUS_MONTH_METRICS AS (

    SELECT
        ORDER_YEAR,
        ORDER_MONTH,
        TOTAL_ORDERS,
        TOTAL_REVENUE,

        -- Average Order Value
        ROUND(
            TOTAL_REVENUE
            / NULLIF(TOTAL_ORDERS, 0),
            2
        ) AS AOV,

        -- Previous month metrics
        LAG(TOTAL_ORDERS) OVER (
            ORDER BY ORDER_YEAR, ORDER_MONTH
        ) AS PREVIOUS_MONTH_ORDERS,

        LAG(TOTAL_REVENUE) OVER (
            ORDER BY ORDER_YEAR, ORDER_MONTH
        ) AS PREVIOUS_MONTH_REVENUE,

        LAG(
            ROUND(
                TOTAL_REVENUE
                / NULLIF(TOTAL_ORDERS, 0),
                2
            )
        ) OVER (
            ORDER BY ORDER_YEAR, ORDER_MONTH
        ) AS PREVIOUS_MONTH_AOV

    FROM MONTHLY_PERFORMANCE
),

GROWTH_METRICS AS (

    SELECT
        ORDER_YEAR,
        ORDER_MONTH,

        TOTAL_ORDERS,
        TOTAL_REVENUE,
        AOV,

        PREVIOUS_MONTH_ORDERS,
        PREVIOUS_MONTH_REVENUE,
        PREVIOUS_MONTH_AOV,

        -- Order Growth
        ROUND(
            CAST(
                TOTAL_ORDERS - PREVIOUS_MONTH_ORDERS
                AS DECIMAL(18,2)
            )
            / NULLIF(PREVIOUS_MONTH_ORDERS, 0) * 100,
            2
        ) AS ORDER_GROWTH_RATE,

        -- AOV Growth
        ROUND(
            (
                AOV - PREVIOUS_MONTH_AOV
            )
            / NULLIF(PREVIOUS_MONTH_AOV, 0) * 100,
            2
        ) AS AOV_GROWTH_RATE,

        -- Revenue Growth
        ROUND(
            CAST(
                TOTAL_REVENUE - PREVIOUS_MONTH_REVENUE
                AS DECIMAL(18,2)
            )
            / NULLIF(PREVIOUS_MONTH_REVENUE, 0) * 100,
            2
        ) AS REVENUE_GROWTH_RATE

    FROM PREVIOUS_MONTH_METRICS
)

SELECT
    ORDER_YEAR,
    ORDER_MONTH,

    TOTAL_ORDERS,
    TOTAL_REVENUE,

    AOV,

    PREVIOUS_MONTH_ORDERS,
    PREVIOUS_MONTH_REVENUE,
    PREVIOUS_MONTH_AOV,

    ORDER_GROWTH_RATE,
    AOV_GROWTH_RATE,
    REVENUE_GROWTH_RATE,

    CASE

        -- Growth from both higher volume and higher AOV
        WHEN ORDER_GROWTH_RATE > 0
             AND AOV_GROWTH_RATE > 0
             AND REVENUE_GROWTH_RATE > 0
            THEN 'GROWTH: BOTH VOLUME AND VALUE'

        -- Growth despite lower AOV
        WHEN ORDER_GROWTH_RATE > 0
             AND AOV_GROWTH_RATE < 0
             AND REVENUE_GROWTH_RATE > 0
            THEN 'GROWTH: VOLUME DRIVEN'

        -- Growth despite fewer orders
        WHEN ORDER_GROWTH_RATE < 0
             AND AOV_GROWTH_RATE > 0
             AND REVENUE_GROWTH_RATE > 0
            THEN 'GROWTH: VALUE DRIVEN'

        -- Decline from both lower volume and lower AOV
        WHEN ORDER_GROWTH_RATE < 0
             AND AOV_GROWTH_RATE < 0
             AND REVENUE_GROWTH_RATE < 0
            THEN 'DECLINE: BOTH VOLUME AND VALUE'

        -- More orders but lower AOV caused revenue decline
        WHEN ORDER_GROWTH_RATE > 0
             AND AOV_GROWTH_RATE < 0
             AND REVENUE_GROWTH_RATE < 0
            THEN 'DECLINE: AOV PRESSURE'

        -- Higher AOV but fewer orders caused revenue decline
        WHEN ORDER_GROWTH_RATE < 0
             AND AOV_GROWTH_RATE > 0
             AND REVENUE_GROWTH_RATE < 0
            THEN 'DECLINE: VOLUME PRESSURE'

        -- Stable order volume but lower AOV
        WHEN ORDER_GROWTH_RATE = 0
             AND AOV_GROWTH_RATE < 0
             AND REVENUE_GROWTH_RATE < 0
            THEN 'DECLINE: AOV PRESSURE'

        -- Stable order volume but higher AOV
        WHEN ORDER_GROWTH_RATE = 0
             AND AOV_GROWTH_RATE > 0
             AND REVENUE_GROWTH_RATE > 0
            THEN 'GROWTH: AOV DRIVEN'

        ELSE 'NO SIGNIFICANT CHANGE'

    END AS REVENUE_DRIVER

FROM GROWTH_METRICS

ORDER BY
    ORDER_YEAR,
    ORDER_MONTH;


