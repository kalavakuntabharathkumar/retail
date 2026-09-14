# Power BI Dashboard

This project includes clean CSV exports and a MySQL schema so the dashboard can be recreated in Power BI Desktop.

## Recommended report pages
1. Executive Overview — Revenue, Orders, Units, Average Order Value
2. Regional Performance — revenue by region and monthly trend
3. Category Performance — category revenue, units, and contribution

## Suggested visuals
- KPI cards: Total Revenue, Orders, Units, AOV
- Line chart: Monthly Revenue
- Clustered bar: Revenue by Region
- Treemap/bar: Revenue by Category
- Matrix: Region × Category
- Slicers: Date, Region, Category, Payment Method

## Data refresh
Run `python/analyze_sales.py` to regenerate the dashboard export CSVs, then refresh the Power BI model.
A `.pbix` file is not generated here because Power BI Desktop uses a proprietary binary format.
