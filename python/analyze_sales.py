from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
tx = pd.read_csv(ROOT/"data/transactions.csv", parse_dates=["transaction_date"])
customers = pd.read_csv(ROOT/"data/customers.csv")
products = pd.read_csv(ROOT/"data/products.csv")

df = tx.merge(customers, on="customer_id").merge(products, on="product_id")
df["month"] = df["transaction_date"].dt.to_period("M").astype(str)

monthly = df.groupby("month", as_index=False)["sales_amount"].sum()
regional = df.groupby(["region"], as_index=False)["sales_amount"].sum().sort_values("sales_amount", ascending=False)
category = df.groupby(["category"], as_index=False)["sales_amount"].sum().sort_values("sales_amount", ascending=False)

out = ROOT/"data/dashboard_exports"
out.mkdir(exist_ok=True)
monthly.to_csv(out/"monthly_revenue.csv", index=False)
regional.to_csv(out/"regional_revenue.csv", index=False)
category.to_csv(out/"category_revenue.csv", index=False)

print("Rows:", len(df))
print("Revenue:", round(df.sales_amount.sum(), 2))
print("\nMonthly revenue:\n", monthly.to_string(index=False))
print("\nRegional revenue:\n", regional.to_string(index=False))
print("\nCategory revenue:\n", category.to_string(index=False))
