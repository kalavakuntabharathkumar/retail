# Retail Sales Analytics & Reporting Dashboard

A portfolio-ready database analytics project using MySQL, Python/Pandas, and Power BI-ready exports.

## Dataset
- 12,000 simulated transactions
- 500 customers
- 20 products
- 5 categories
- 4 regions
- 6 normalized tables in the database model

## Database model
Customers -> Transactions <- Products -> Categories
Transactions -> Payments

## Workflow
1. Create the MySQL schema with `sql/schema.sql`.
2. Load the CSVs using `sql/seed.sql` after adjusting local paths.
3. Run `sql/analytics_queries.sql`.
4. Run `python python/analyze_sales.py`.
5. Import `data/dashboard_exports/*.csv` into Power BI and build the report described in `powerbi/README.md`.

## Note
The dataset is simulated for portfolio/learning use; performance metrics in the resume should only be claimed if independently benchmarked.
