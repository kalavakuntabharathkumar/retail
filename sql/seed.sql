USE retail_analytics;
-- Load CSV files with your MySQL client's LOAD DATA LOCAL INFILE support.
-- Adjust the absolute paths for your machine.

LOAD DATA LOCAL INFILE 'data/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 ROWS;

INSERT INTO categories(category_name)
VALUES ('Electronics'),('Furniture'),('Grocery'),('Clothing'),('Home');

LOAD DATA LOCAL INFILE 'data/products_staging.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'data/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Payments are generated from transaction IDs:
INSERT INTO payments(transaction_id,payment_method,payment_status)
SELECT transaction_id,
       ELT(1 + MOD(transaction_id,4),'Card','UPI','Cash','Net Banking'),
       CASE WHEN MOD(transaction_id,17)=0 THEN 'Pending' ELSE 'Paid' END
FROM transactions;
