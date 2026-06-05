create database med_supply_chain;
use  med_supply_chain;
show tables;
SELECT * FROM consumption_facility_cleaned;
SELECT * FROM demand_sales_cleaned;
SELECT * FROM inventory_stock_cleaned;
SELECT * FROM supplier_procurement_cleaned;

-- Stored Procedures to find medicines whose stock is below reorder level. --

DELIMITER $$

CREATE PROCEDURE reorder_medicines()
BEGIN
    SELECT Medicine_ID, DrugName, Current_Stock, Reorder_Level FROM inventory_stock_cleaned WHERE Current_Stock < Reorder_Level limit 5;
END $$
DELIMITER ;

CALL reorder_medicines();

-- Add New Column --

ALTER TABLE inventory_stock_cleaned
ADD COLUMN Stock_Status VARCHAR(20);

-- Create Trigger --

DELIMITER $$

CREATE TRIGGER low_stock_trigger
BEFORE UPDATE ON inventory_stock_cleaned
FOR EACH ROW
BEGIN
    IF NEW.Current_Stock < NEW.Min_Required THEN
        SET NEW.Stock_Status = 'Low Stock';
    ELSE
        SET NEW.Stock_Status = 'Normal';
    END IF;
END $$

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

UPDATE inventory_stock_cleaned
SET Current_Stock = 100
WHERE Medicine_ID = 'M07208F17';

SET SQL_SAFE_UPDATES = 1;

SELECT Medicine_ID, DrugName, Current_Stock, Stock_Status FROM inventory_stock_cleaned WHERE Medicine_ID = 'M07208F17';

-- event scheduler --
SET GLOBAL event_scheduler = ON;

DELIMITER $$
CREATE EVENT auto_low_stock_check
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
UPDATE inventory_stock_cleaned
SET Stock_Status = 'Low Stock'
WHERE Current_Stock < Min_Required;
UPDATE inventory_stock_cleaned
SET Stock_Status = 'Normal'
WHERE Current_Stock >= Min_Required;
END $$
DELIMITER ;

-- testing ---

SET SQL_SAFE_UPDATES = 0;

UPDATE inventory_stock_cleaned SET Current_Stock = 10 WHERE Medicine_ID = 'M07208F17';
SET SQL_SAFE_UPDATES = 1;

--- testing after 1 min ----

SELECT Medicine_ID, DrugName, Current_Stock, Stock_Status FROM inventory_stock_cleaned WHERE Medicine_ID = 'M07208F17';

-- Top reliable suppliers.--
select * from supplier_procurement_cleaned; 

SELECT Supplier_Name,Reliability_Score,On_Time_Delivery_Rate,avg_lead_time_days FROM supplier_procurement_cleaned ORDER BY Reliability_Score limit 5;


-- Which ordered medicines were actually consumed?--

SELECT distinct (d.DrugName),d.Order_ID,d.Patient_ID, d.Quantity, c.Total_Consumption, c.Wastage_Units FROM demand_sales_cleaned d JOIN consumption_facility_cleaned c
ON d.Patient_ID = c.Patient_ID limit 10;

-- are high-demand medicines low in stock? --

SELECT distinct (d.DrugName),SUM(d.Quantity) AS Total_Demand,i.Current_Stock,i.Reorder_Level,CASE WHEN i.Current_Stock < i.Reorder_Level THEN 'Reorder Needed'ELSE 'Sufficient Stock'
END AS Stock_Status FROM demand_sales_cleaned d JOIN inventory_stock_cleaned i ON TRIM(d.DrugName) = TRIM(i.DrugName) GROUP BY d.DrugName, i.Current_Stock, i.Reorder_Level limit 5;

-- Which medicines frequently fall below reorder levels?
SELECT DrugName, Category,Current_Stock, Reorder_Level,(Reorder_Level - Current_Stock) AS Shortage_Units
FROM inventory_stock_cleaned WHERE Current_Stock < Reorder_Level ORDER BY Shortage_Units DESC limit 5;

-- Are there categories (antibiotics, injectables, tablets) prone to overstocking or stockouts-

SELECT Category,
SUM(CASE 
    WHEN Current_Stock < Reorder_Level THEN 1 
    ELSE 0 
END) AS Stockout_Count,
SUM(CASE 
    WHEN Current_Stock > (0.8 * Max_Capacity) THEN 1 
    ELSE 0 
END) AS Overstock_Count,
COUNT(*) AS Total_Items
FROM inventory_stock_cleaned GROUP BY Category;

-- How do procurement KPIs (lead time, reliability, on-time rate) correlate with facility  shortages --

SELECT s.Supplier_Name, s.Avg_Lead_Time_Days, s.Reliability_Score, s.On_Time_Delivery_Rate,
COUNT(CASE 
    WHEN i.Current_Stock < i.Reorder_Level THEN 1 
END) AS Shortage_Count FROM supplier_procurement_cleaned s
JOIN inventory_stock_cleaned i ON s.Supplier_ID = i.Vendor_ID
GROUP BY s.Supplier_Name, s.Avg_Lead_Time_Days, s.Reliability_Score, s.On_Time_Delivery_Rate
ORDER BY Shortage_Count desc limit 5;
 