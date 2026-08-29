# ShopSphere E-Commerce Analytics

## Project Overview

ShopSphere is an e-commerce analytics project built using Excel, SQL, and Power BI.

I started with a raw transactional dataset and worked through the full analytics process, including data cleaning, validation, SQL analysis, and dashboard development.

The analysis focuses on sales, profitability, products, customers, regions, shipping, and trends over time.

## Business Objective

The main questions I wanted to answer were:

- How is the business performing overall?
- Which products generate the most sales and profit?
- Which customers contribute the most revenue?
- Which regions perform best?
- How do sales and profit change over time?
- How many shipments are processed?
- How long does it take to ship orders?

## Dataset

The final cleaned dataset contains 25,000 records.

It includes information on:

- Orders
- Customers
- Products
- Sales
- Pricing
- Discounts
- Regions
- Countries
- Shipping
- Dates

## Data Cleaning and Validation

Excel was used to inspect and clean the original dataset.

Some of the main checks included:

- Duplicate records
- Missing values
- Text consistency
- Date validation
- Shipping-date validation
- Quantity checks
- Sales amount reconciliation
- Region and state consistency

I identified 180 duplicate Order ID + Product ID records and removed them, reducing the dataset from 25,180 to 25,000 records.

I also standardized text fields using TRIM and PROPER.

Missing shipping dates were retained and documented rather than deleted because the absence of a shipping date does not invalidate the transaction.

For records where the calculated sales amount differed from the original Sales Amount, I kept the original value because the underlying business pricing rules were not provided.

## SQL Analysis

SQL was used to analyze the cleaned dataset and answer the business questions.

The analysis covered:

- Sales performance
- Product performance
- Customer performance
- Regional performance
- Shipping performance
- Time-based trends

SQL techniques used include:

- Aggregations
- JOINs
- CASE statements
- CTEs
- Window functions
- Ranking
- Running totals
- LAG and LEAD
- Views

## Power BI Dashboard

The Power BI report contains seven pages:

1. Overview
2. Sales Analysis
3. Regional Analysis
4. Product Analysis
5. Customer Analysis
6. Shipping Analysis
7. Time Analysis

The dashboard includes KPIs, interactive filters, trend analysis, regional comparisons, product analysis, customer analysis, and shipping performance.

## Key Findings

- Gross sales were approximately $19.70M.
- Gross profit was approximately $4.40M.
- Gross margin was approximately 22.34%.
- The East region generated the highest sales at approximately $7.9M.
- Laptop Pro 14 was the highest-selling product at approximately $4.4M.
- Electronics accounted for approximately 69.39% of total sales.
- Average shipping time was approximately 4 days.
- Sales, profit, order volume, and gross margin changed throughout the analyzed period.

## Key Performance Indicators

| KPI | Value |
|---|---:|
| Gross Sales | $19.70M |
| Gross Profit | $4.40M |
| Gross Margin | 22.34% |
| Total Orders | 25K |
| Total Customers | 30 |
| Total Products | 20 |
| Total Shipments | 25K |
| Average Days to Ship | 4 |

## Tools Used

- Excel
- SQL
- Power BI
- DAX

## Project Structure

```text
ShopSphere-E-Commerce-Analytics/
│
├── README.md
├── Excel/
├── SQL/
├── PowerBI/
└── Screenshots/

## Author

**Cynthia Adaku Ogbonna**

Data Analyst | Excel | SQL | Power BI
