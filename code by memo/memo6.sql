--6-1
CREATE OR REPLACE VIEW CustomersWithPurchases
AS
(SELECT DISTINCT cu.first_name || ' ' || cu.last_name "Customer Name", cu.customer_phone "Customer Phone"
FROM customer cu
JOIN salevehicle sa
ON (cu.customer_id = sa.customer_id)
WHERE sa.status = 'SOLD');

--6-2
CREATE OR REPLACE VIEW CustomersPurchasedWithoutServiced
AS
( SELECT DISTINCT cu.first_name || ' ' || cu.last_name "Customer Name", cu.customer_phone "Customer Phone"
FROM salevehicle sa JOIN  customer cu ON (sa.customer_id = cu.customer_id)
WHERE sa.customer_id NOT IN 
(SELECT cu.customer_id
FROM customer cu
JOIN salevehicle sa
ON (cu.customer_id = sa.customer_id)
JOIN servicevehicle sv
ON (cu.customer_id = sv.customer_id)
WHERE sa.status= 'SOLD'));

--6-3
CREATE OR REPLACE VIEW PreferPorsche
AS
(SELECT DISTINCT cu.first_name || ' ' || cu.last_name "Customer Name", cu.customer_phone "Customer Phone"
FROM customer cu JOIN preference pr ON (cu.customer_id = pr.customer_id)
WHERE pr.PREF_MAKE = 'Porsche' AND pr.end_date >= SYSDATE);

--6-4
CREATE OR REPLACE VIEW BuyNotTrade
AS
(
SELECT DISTINCT  cu.first_name || ' ' || cu.last_name "Customer Name", customer_phone "Customer Phone"
FROM salevehicle sa JOIN customer cu ON (sa.customer_id = cu.customer_id)
WHERE sa.customer_id IN (
SELECT cu.customer_id
FROM customer cu JOIN sales_invoice sa ON (cu.customer_id = sa.customer_id)
WHERE sa.tradein_vehicle_vin IS NULL)
);

--6-5
CREATE OR REPLACE VIEW SoldInLast30Days
AS
(
SELECT iv.date_sold, sa.VEHICLE_VIN, sa.VEHICLE_MAKE, sa.VEHICLE_MODEL, sa.VEHICLE_YEAR, sa.List_price 
FROM salevehicle sa JOIN sales_invoice iv
ON (sa.vehicle_VIN = iv.sold_vehicle_VIN)
WHERE iv.date_sold >= (SYSDATE-30) AND iv.date_sold <= SYSDATE    
);

--6-6
CREATE OR REPLACE VIEW ProfitsFromService
AS
(SELECT sl.service_code "Service", COUNT(*) "Count", SUM(sv.service_price) - SUM(sv.service_cost) "Total Profit"
FROM carservice sv  JOIN  service_list sl 
ON (sv.service_code = sl.service_code)
GROUP BY sl.service_code, sv.service_price, sv.service_cost);

--6-7a
CREATE OR REPLACE VIEW HighestComissions
AS
(
SELECT first_name || ' ' || last_name "Employee Name", commission_pct "Commission"
FROM employee 
WHERE commission_pct = (SELECT MAX(commission_pct) FROM employee WHERE employee_id NOT IN (1030) )
);

CREATE OR REPLACE VIEW MostVehiclesSold
AS
( SELECT sa.employee_id "Employee ID", COUNT(*) "Cars Sold"
FROM employee em JOIN sales_invoice sa
ON (em.employee_id = sa.employee_id)
GROUP BY sa.employee_id
HAVING COUNT(*) =
(SELECT MAX(COUNT(*))
FROM employee em JOIN sales_invoice sa
ON (em.employee_id = sa.employee_id)
GROUP BY sa.employee_id) );

--6-8
CREATE OR REPLACE VIEW VehicleSales -- Our assumption was this implies revenue
AS
(
SELECT SUM(List_Price) "Vehicle Sales"
FROM salevehicle
WHERE Status = 'SOLD'
);

--EC1
CREATE OR REPLACE VIEW OilChangeMileage
AS
(SELECT DISTINCT cu.first_name || ' ' || cu.last_name "Customer Name", cu.customer_phone "Customer Phone",
sv.vehicle_VIN "VIN", sv.vehicle_make "Make"
FROM customer cu, servicevehicle sv
WHERE sv.vehicle_mileage > 6000);

--EC2
CREATE OR REPLACE VIEW OilChangeDate
AS
(SELECT DISTINCT cu.first_name || ' ' || cu.last_name "Customer Name", cu.customer_phone "Customer Phone",
sv.vehicle_VIN "VIN", sv.vehicle_make "Make"
FROM customer cu, servicevehicle sv, service_invoice se
JOIN service_list sl
ON (se.service_invoice_id = sl.service_invoice_id)
WHERE sl.service_code = 'OILCHG' AND se.date_serviced < (SYSDATE - 180));
