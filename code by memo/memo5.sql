-- MEMO Task 5
DROP TABLE service_invoice CASCADE CONSTRAINTS PURGE;
DROP TABLE purchase_invoice CASCADE CONSTRAINTS PURGE;
DROP TABLE sales_invoice CASCADE CONSTRAINTS PURGE;
DROP TABLE carseller CASCADE CONSTRAINTS PURGE;

DROP TABLE service_list CASCADE CONSTRAINTS PURGE;
DROP TABLE part_list CASCADE CONSTRAINTS PURGE;

-- Create table: Busines Docs(Service Invoice, Purchase Invoice, Sales Invoice) & Car Seller 
    CREATE TABLE carseller
    (
    Seller_ID          	 	   VARCHAR2(10)       	    NOT NULL CONSTRAINT auto_co_pk PRIMARY KEY,
    Seller_Name        		   VARCHAR2(20),
    Seller_Contact        	   VARCHAR2(15)      	    NOT NULL,
    Seller_Street              VARCHAR2(30)     	    NOT NULL,
    Seller_City                VARCHAR2(20)     	    NOT NULL,
    Seller_State               CHAR(2)            	    NOT NULL,
    Seller_Zip_Code            NUMBER(5)          	    NOT NULL,
    Seller_Phone               VARCHAR2(15)         	NOT NULL,
    Seller_Fax                 VARCHAR2(15)
    );

    CREATE TABLE service_invoice
    (
    service_invoice_id          NUMBER(7)               CONSTRAINT service_invoice_sid_pk PRIMARY KEY,
    Employee_id                 NUMBER(4)               NOT NULL,
    manager_id                  NUMBER(4),
    Customer_id                 VARCHAR2(8)             NOT NULL,
    Vehicle_VIN                 VARCHAR2(6)             NOT NULL,
    date_serviced               DATE                    NOT NULL,
    misc_charge                 NUMBER(7),
    Taxes				        NUMBER(5,4)             NOT NULL,
    CONSTRAINT emp_service_eid_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    CONSTRAINT emp_service_mnid_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
    CONSTRAINT customer_service_cid_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT ServiceVehicle_sid_fk FOREIGN KEY (Vehicle_VIN) REFERENCES ServiceVehicle(Vehicle_VIN)
    );
    
    CREATE TABLE purchase_invoice
    (
    purchase_invoice_id         NUMBER(7)               CONSTRAINT purchase_invoice_pid_pk PRIMARY KEY,
    manager_id                  NUMBER(4),
    Seller_id                   VARCHAR2(10),
    date_purchased              DATE                    NOT NULL,
    purchase_shipping           NUMBER(7, 2),
    purchase_taxes              NUMBER(5,4)             NOT NULL,
    CONSTRAINT emp_purchase_mnid_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
    CONSTRAINT CarSeller_purchase_vid_fk FOREIGN KEY (Seller_id) REFERENCES CarSeller(Seller_id)
    );

    CREATE TABLE sales_invoice
    (
    sales_invoice_id            NUMBER(7)               CONSTRAINT sales_invoice_sid_pk PRIMARY KEY,
    Employee_id                 NUMBER(4)               NOT NULL,
    manager_id                  NUMBER(4),
    Customer_id                 VARCHAR2(8)             NOT NULL,
    date_sold                   DATE                    NOT NULL,
    terms                       VARCHAR2(15)            NOT NULL,
    sales_shipping              NUMBER(7, 2),
    sales_discount              NUMBER(7,2),
    sales_taxes                 NUMBER(5,4)             NOT NULL,
    sales_misc                  NUMBER(7,2),
    Sold_Vehicle_VIN            VARCHAR2(6)             NOT NULL,
    TradeIn_Vehicle_VIN         VARCHAR2(6),
    CONSTRAINT emp_sales_eid_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    CONSTRAINT emp_sales_mnid_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
    CONSTRAINT customer_sales_cid_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT salevehicle_sVIN_svin_fk FOREIGN KEY (sold_vehicle_VIN) REFERENCES salevehicle(vehicle_VIN),
    CONSTRAINT salevehicle_tVIN_svin_fk FOREIGN KEY (tradein_vehicle_VIN) REFERENCES salevehicle(vehicle_VIN)
    );
 
    -- Associate Entities: Service List & Part List
        CREATE TABLE service_list
        (Service_code           VARCHAR2(20),
        SERVICE_INVOICE_ID      NUMBER(7,0),
        CONSTRAINT svlist_svcode_fk FOREIGN KEY (service_code) REFERENCES carservice(service_code),
        CONSTRAINT svlist_svinv_fk FOREIGN KEY (SERVICE_INVOICE_ID) REFERENCES service_invoice(SERVICE_INVOICE_ID),
        CONSTRAINT svlist_pk PRIMARY KEY (service_code, service_invoice_id)
        );

        CREATE TABLE part_list
        (part_code           VARCHAR2(20),
        SERVICE_INVOICE_ID      NUMBER(7,0),
        CONSTRAINT plist_partcode_fk FOREIGN KEY (part_code) REFERENCES part(part_code),
        CONSTRAINT plist_svinv_fk FOREIGN KEY (SERVICE_INVOICE_ID) REFERENCES service_invoice(SERVICE_INVOICE_ID),
        CONSTRAINT plist_pk PRIMARY KEY (part_code, service_invoice_id)
        );

-- Insert Data: 

-- Car Sellers
    INSERT INTO carseller
    VALUES (91563, 'Barry Good Cars', 'Barry Floyd', '123 Higuera St.', 'San Luis Obispo', 'CA', 93401, '(805) 457-9823', '(805) 457-8801');
    
    INSERT INTO carseller
    VALUES (92234, 'Wheel n Deal', 'Howie Mandel', '5106 Dealer Way', 'Los Angeles', 'CA', 92310, '(626) 715-8275', '(626) 715-7770');

    INSERT INTO carseller
    VALUES (92335, 'Cars Land', 'Guido Sanchez', '314 Magic Way', 'Anaheim', 'CA', 92830, '(714) 880-7171', '(714) 880-7172');

    INSERT INTO carseller
    VALUES (91392, 'Classic Wheels', 'Tim Cook', '415 Apple Rd', 'Cupertino', 'CA', 95014, '(415) 321-4145', '(415) 321-4140');

    INSERT INTO carseller
    VALUES (93350, 'Automatic Mechanic', 'Bill Gates', '500 Billion Way', 'Los Osos', 'CA', 93402, '(805) 550-6072', '(805) 550-6070');

    INSERT INTO carseller
    VALUES (00001, 'SLO Vintage Auto', 'Larry Margaria', '10000 Los Valley Road', 'San Luis Obispo', 'CA', 93408, '(805) 123-1234', '(805) 123-1235');

--
-- RUNNING THE BUSINESS

-- Buying a New Vehicle from a Car Seller
    INSERT INTO salevehicle VALUES ('1YVHP8', 1967, 'Chevrolet', 'Corvette', 21310, 'Red', NULL, 'Good', 'FORSALE', 155000.00, 170000.00, NULL, 91392, NULL);
    INSERT INTO purchase_invoice VALUES (009, NULL, 91392, '09-09-2020', 199.99, 0.0725);
    UPDATE purchase_invoice SET manager_id = 1000 WHERE purchase_invoice_id = 009;

    INSERT INTO salevehicle VALUES ('4T1BG2', 1974, 'Porsche', '911', 19523, 'White', '2 Door Coupe', 'Excellent', 'FORSALE', 40000.00, 70000.50, NULL, 92234, NULL);
    INSERT INTO purchase_invoice VALUES (007, 1000, 92234, '07-07-2020', 200.77, 0.0725);
    UPDATE purchase_invoice SET manager_id = 1000 WHERE purchase_invoice_id = 007;

    INSERT INTO salevehicle VALUES ('1G2ZJ5', 1975, 'BMW', '3.0 CSL', 18720, 'Black', '2 Door Coupe', 'Excellent', 'FORSALE', 100000.00, 131600.00, NULL, 92335, NULL);
    INSERT INTO purchase_invoice VALUES (008, 1000, 92335, SYSDATE, 284.88, 0.0725);
    UPDATE purchase_invoice SET manager_id = 1000 WHERE purchase_invoice_id = 008;

    INSERT INTO salevehicle VALUES ('1GNCS1', 1965, 'Jaguar', 'E-Type', 22400, 'Blue', 'Fixed Head Coupe', 'Good', 'FORSALE', 150000.00, 187000.00, NULL, 93350, NULL);
    INSERT INTO purchase_invoice VALUES (010, 1000, 93350, '10-10-2020', 310.10, 0.0725);
    UPDATE purchase_invoice SET manager_id = 1000 WHERE purchase_invoice_id = 010;

    INSERT INTO salevehicle VALUES ('1GKEV2', 1966, 'Lamborghini', 'Miura', 20560, 'Green', '2 Door Coupe', 'Excellent', 'FORSALE', 125000.00, 157600.00, NULL, 91563, NULL);
    INSERT INTO purchase_invoice VALUES (006, 1000, 91563, '06-06-2020', 100.00, 0.0725);
    UPDATE purchase_invoice SET manager_id = 1000 WHERE purchase_invoice_id = 006;


-- Selling a Vehicle 

    -- Vehicles Purchased by Customers
        INSERT INTO salevehicle VALUES ('1A1B1C', 1953, 'Rolls-Royce', 'Silver Dawn', 25340, 'Grey', 'Bordeaux', 'Good', 'FORSALE', 35000.00, 50000.00, NULL, NULL, NULL);

        INSERT INTO salevehicle VALUES ('2A2B2C', 1960, 'Mercedes-Benz', '300 SL', 21311, 'Beige', 'Roadster', 'Excellent', 'FORSALE', 89950.00, 1156070.00, NULL, NULL, NULL);

        INSERT INTO salevehicle VALUES ('1FMJU2', 1960, 'Aston Martin', 'DB4', 29856, 'Grey', 'Zagato', 'Excellent', 'FORSALE', 9870000.00, 12980000.00, NULL, NULL, NULL);

        INSERT INTO salevehicle VALUES ('1GCPKP', 1990, 'Acura', 'NSX', 70690, 'Blue', '2 Door Coupe', 'Good', 'FORSALE', 48000.00, 69995.00, NULL, NULL, NULL);

        INSERT INTO salevehicle VALUES ('3D3E3F', 1963, 'Ferrari', '250 GTO', 18970, 'Red', '2 Door Coupe', 'Excellent', 'FORSALE', 40000000.00, 58000000.00, NULL, NULL, NULL);
    
    -- Sales with TRADEINs
    INSERT INTO salevehicle VALUES ('1FTRX1', 2019, 'Tesla', 'Model X', 20798, 'White', 'Utility', 'Good', 'TRADEIN', NULL, NULL, 60000.00, NULL, 1456);
    INSERT INTO Carseller (SELLER_ID, SELLER_CONTACT, SELLER_STREET, SELLER_CITY, SELLER_STATE, SELLER_ZIP_CODE, SELLER_PHONE)
    SELECT	CUSTOMER_ID, First_name || ' ' || Last_name, CUSTOMER_STREET, CUSTOMER_CITY, CUSTOMER_STATE, CUSTOMER_ZIP, CUSTOMER_PHONE
    FROM CUSTOMER
    WHERE CUSTOMER_ID = 1456;
    INSERT INTO purchase_invoice VALUES (011, 1000, 1456, '11-11-2020', 0.00, 0.00);
    INSERT INTO sales_invoice VALUES (011, 1071, NULL, 1456, '11-11-2020', 'cash', 199.99, 2500.00, 0.0725, NULL, '2A2B2C', '1FTRX1');
    UPDATE sales_invoice SET manager_id = 1000 WHERE sales_invoice_id = 011;
    UPDATE salevehicle SET Status = 'FORSALE', Customer_ID = NULL, Purchase_Price = 60000.00, List_Price = 65000.00 WHERE VEHICLE_VIN = '1FTRX1';
    UPDATE salevehicle SET Status = 'SOLD', Customer_ID = 1456 WHERE Vehicle_VIN = '2A2B2C';

    INSERT INTO salevehicle VALUES ('5N1AR1', 1968, 'Shelby', 'GT350', 24990, 'Green', 'Fastback', 'Excellent', 'TRADEIN', NULL, NULL, 105000.00, NULL, 1785);
    INSERT INTO Carseller (SELLER_ID, SELLER_CONTACT, SELLER_STREET, SELLER_CITY, SELLER_STATE, SELLER_ZIP_CODE, SELLER_PHONE)
    SELECT	CUSTOMER_ID, First_name || ' ' || Last_name, CUSTOMER_STREET, CUSTOMER_CITY, CUSTOMER_STATE, CUSTOMER_ZIP, CUSTOMER_PHONE
    FROM CUSTOMER
    WHERE CUSTOMER_ID = 1785;
    INSERT INTO purchase_invoice VALUES (012, 1000, 1785, '10-11-2020', 0.00, 0.00);
    INSERT INTO sales_invoice VALUES (014, 1079, NULL, 1785, '10-04-2020', 'bitcoin', 325.00, 20000.00, 0.0725, NULL, '1FMJU2', '5N1AR1');
    UPDATE sales_invoice SET manager_id = 1000 WHERE sales_invoice_id = 014;
    UPDATE salevehicle SET Status = 'FORSALE', Customer_ID = NULL, Purchase_Price = 105000.00, List_Price = 130000.00 WHERE VEHICLE_VIN = '5N1AR1';
    UPDATE salevehicle SET Status = 'SOLD', Customer_ID = 1785 WHERE Vehicle_VIN = '1FMJU2';

    INSERT INTO salevehicle VALUES ('2GKFLX', 2018, 'Lamborghini', 'Aventador', 26823, 'Black', 'S Roadster', 'Good', 'TRADEIN', NULL, NULL, 450000.00, NULL, 1875);
    INSERT INTO Carseller (SELLER_ID, SELLER_CONTACT, SELLER_STREET, SELLER_CITY, SELLER_STATE, SELLER_ZIP_CODE, SELLER_PHONE)
    SELECT	CUSTOMER_ID, First_name || ' ' || Last_name, CUSTOMER_STREET, CUSTOMER_CITY, CUSTOMER_STATE, CUSTOMER_ZIP, CUSTOMER_PHONE
    FROM CUSTOMER
    WHERE CUSTOMER_ID = 1875;
    INSERT INTO purchase_invoice VALUES (013, 1000, 1875, '10-05-2020', 0.00, 0.00);
    INSERT INTO sales_invoice VALUES (015, 1079, NULL, 1875, '10-05-2020', 'credit', NULL, 54000.00, 0.0725, 256.99, '3D3E3F', '2GKFLX');
    UPDATE sales_invoice SET manager_id = 1030 WHERE sales_invoice_id = 015;
    UPDATE salevehicle SET Status = 'FORSALE', Customer_ID = NULL, Purchase_Price = 450000.00, List_Price = 530000.00 WHERE VEHICLE_VIN = '2GKFLX';
    UPDATE salevehicle SET Status = 'SOLD', Customer_ID = 1875 WHERE Vehicle_VIN = '3D3E3F';

    -- Sales without TRADEINs
    INSERT INTO sales_invoice VALUES (012, 1071, NULL, 1234, '12-12-2020', 'credit', 250.00, NULL, 0.0725, NULL, '1A1B1C', NULL);
    UPDATE sales_invoice SET manager_id = 1030 WHERE sales_invoice_id = 012;
    UPDATE salevehicle SET Status = 'SOLD', Customer_ID = 1234 WHERE Vehicle_VIN = '1A1B1C';

    INSERT INTO sales_invoice VALUES (013, 1071, NULL, 8294, SYSDATE, 'cash', NULL, NULL, 0.0725, 301.33, '1GCPKP', NULL);
    UPDATE sales_invoice SET manager_id = 1000 WHERE sales_invoice_id = 013;
    UPDATE salevehicle SET Status = 'SOLD', Customer_ID = 8294 WHERE Vehicle_VIN = '1GCPKP';


-- Servicing Vehicles
    -- Servicing a Vehicle Sold By Us
        INSERT INTO servicevehicle (Vehicle_VIN, Vehicle_Year, Vehicle_Make, Vehicle_Model, Vehicle_Mileage, Customer_ID)
        SELECT Vehicle_VIN, Vehicle_Year, Vehicle_Make, Vehicle_Model, Vehicle_Mileage, (SELECT Customer_ID FROM salevehicle WHERE Vehicle_VIN = '1A1B1C')
        FROM salevehicle
        WHERE Vehicle_VIN = '1A1B1C';
        INSERT INTO service_invoice VALUES (001, 1045, 1026, 1234, '1A1B1C', '08-08-2020', 1, 0.0725);
            INSERT INTO service_list VALUES ('BATTERYREPLACE', 001);
            INSERT INTO part_list VALUES ('BATTERY', 001);
        
        INSERT INTO servicevehicle (Vehicle_VIN, Vehicle_Year, Vehicle_Make, Vehicle_Model, Vehicle_Mileage, Customer_ID)
        SELECT Vehicle_VIN, Vehicle_Year, Vehicle_Make, Vehicle_Model, Vehicle_Mileage, (SELECT Customer_ID FROM salevehicle WHERE Vehicle_VIN = '2A2B2C')
        FROM salevehicle
        WHERE Vehicle_VIN = '2A2B2C';
        INSERT INTO service_invoice VALUES (002, 1045, 1026, 1456, '2A2B2C', '02-02-2019', 2, 0.0725);
            INSERT INTO service_list VALUES ('BATTERYREPLACE', 002);

        INSERT INTO servicevehicle (Vehicle_VIN, Vehicle_Year, Vehicle_Make, Vehicle_Model, Vehicle_Mileage, Customer_ID)
        SELECT Vehicle_VIN, Vehicle_Year, Vehicle_Make, Vehicle_Model, Vehicle_Mileage, (SELECT Customer_ID FROM salevehicle WHERE Vehicle_VIN = '3D3E3F')
        FROM salevehicle
        WHERE Vehicle_VIN = '3D3E3F';
        INSERT INTO service_invoice VALUES (006, 1036, 1026, 1875, '3D3E3F', '01-01-2019', 8, 0.0725);
            INSERT INTO service_list VALUES ('OILCHG', 006);
            INSERT INTO part_list VALUES ('OIL10W30', 006);

    -- Servicing a Vehicle Not Sold By Us
        INSERT INTO servicevehicle VALUES ('3A3B3C', 2018, 'Ferrari', '430', 21311, 2928);
        INSERT INTO service_invoice VALUES (003, 1045, 1026, 2928, '3A3B3C', '03-03-2020', 3, 0.0725);
            INSERT INTO part_list VALUES ('OIL10W30', 003);

        INSERT INTO servicevehicle VALUES ('1D1E1F', 2011, 'Hyundai', 'Sonata', 115641, 8523);
        INSERT INTO service_invoice VALUES (004, 1036, 1026, 8523, '1D1E1F', '04-04-2020', 4, 0.0725);
            INSERT INTO service_list VALUES ('TUNEUPBASICS', 004);
            INSERT INTO part_list VALUES ('AIRFILTER', 004);

        INSERT INTO servicevehicle VALUES ('2D2E2F', 2020, 'Mercedes-Benz', 'A-Class', 8000, 4619);
        INSERT INTO service_invoice VALUES (005, 1036, 1026, 4619, '2D2E2F', '05-05-2020', 5, 0.0725);
            INSERT INTO service_list VALUES ('MULTIPOINTINTSP', 005);
            INSERT INTO part_list VALUES ('SPARKPLUG4', 005);


-- Create views
CREATE OR REPLACE VIEW ServiceInvoiceList
AS
(
SELECT se.service_invoice_id "Invoice Number", 
c.first_name || ' ' || c.last_name "Customer Name",
se.Vehicle_VIN "VIN", 
sv.Vehicle_Make "Make", 
sv.Vehicle_Model "Model", 
sv.Vehicle_Mileage "Mileage",
NVL(ROUND(SUM(cs.service_price), 2), 0) "Total Service Charge",
NVL(ROUND(SUM(p.part_price), 2), 0) "Total Parts Charge",
ROUND(NVL(ROUND(SUM(cs.service_price), 2), 0) + NVL(ROUND(SUM(p.part_price), 2), 0), 2) "Subtotal",
ROUND((NVL(SUM(cs.service_price), 0) + NVL(SUM(p.part_price), 0)) * se.Taxes, 2) "Taxes",
se.misc_charge "Misc",
ROUND(NVL(SUM(cs.service_price), 0) + NVL(SUM(p.part_price), 0) + (NVL(SUM(cs.service_price), 0) + NVL(SUM(p.part_price), 0)) * se.Taxes + se.misc_charge, 2) "Total Charges"

FROM service_invoice se
JOIN customer c
ON se.customer_id = c.customer_id
JOIN servicevehicle sv 
ON se.Vehicle_VIN = sv.Vehicle_VIN
LEFT JOIN service_list sl 
ON se.service_invoice_id = sl.service_invoice_id
LEFT JOIN carservice cs 
ON sl.service_code = cs.service_code
LEFT JOIN part_list pl 
ON se.service_invoice_id = pl.service_invoice_id
LEFT JOIN part p 
ON pl.part_code = p.part_code

GROUP BY se.service_invoice_id, c.first_name || ' ' || c.last_name, se.Vehicle_VIN, sv.Vehicle_Make, sv.Vehicle_Model, sv.Vehicle_Mileage, se.Taxes, se.misc_charge
)
ORDER BY se.service_invoice_id;
 
CREATE OR REPLACE VIEW VehiclePurchaseList 
AS
(
SELECT pu.PURCHASE_INVOICE_ID "Purchase Order Number", 
ca.SELLER_NAME "Company Name", 
ca.SELLER_CONTACT "Contact Name", 
sa.VEHICLE_VIN "VIN", 
sa.vehicle_make "Make", 
sa.vehicle_model "Model", 
sa.purchase_price "Sales Amount", 
pu.purchase_shipping "Shipping", 
ROUND(pu.purchase_taxes*(sa.purchase_price+pu.purchase_shipping),2) "Taxes", 
sa.purchase_price + NVL(pu.purchase_shipping,0) + ROUND(pu.purchase_taxes*(sa.purchase_price+pu.purchase_shipping),2) "Total Price",
em.first_name || ' ' || em.last_name "Manager Name"
FROM PURCHASE_INVOICE pu 
JOIN CARSELLER ca ON (pu.SELLER_ID = ca.seller_ID)
JOIN SALEVEHICLE sa ON (pu.SELLER_ID = sa.seller_ID)
JOIN EMPLOYEE em ON (pu.manager_id = em.employee_ID)
);

CREATE OR REPLACE VIEW VehicleSalesList AS
(
SELECT sa.sales_invoice_id "Invoice #", 
cu.first_name || ' ' || cu.last_name "Customer Name", 
emp.first_name || ' ' || emp.last_name "Salesperson", 
mn.first_name || ' ' || mn.last_name "Approved By", 
sa.sold_Vehicle_VIN "Sold Vehicle", 
ve.VEHICLE_MAKE "Make",ve.VEHICLE_model "Model", 
sa.tradein_Vehicle_VIN "Trade In", 
tr.vehicle_make "Trade In Make",
tr.vehicle_model "Trade In Model", 
ve.list_price "Selling Price", 
sa.sales_shipping "Shipping", 
sa.sales_discount "Discount", 
tr.TRADE_IN_ALLOWANCE "Trade In Allowance",
ve.list_price+NVL(sa.sales_shipping,0)-NVL(sa.sales_discount,0)-NVL(tr.TRADE_IN_ALLOWANCE,0) "Subtotal",
ROUND((ve.list_price+NVL(sa.sales_shipping,0)-NVL(sa.sales_discount,0)-NVL(tr.TRADE_IN_ALLOWANCE,0))*sa.sales_taxes, 2) "Tax",
sa.sales_misc "Miscellaneous Charge", 
ve.list_price+NVL(sa.sales_shipping,0)-NVL(sa.sales_discount,0)-NVL(tr.TRADE_IN_ALLOWANCE,0)+ROUND((ve.list_price+NVL(sa.sales_shipping,0)-NVL(sa.sales_discount,0)-NVL(tr.TRADE_IN_ALLOWANCE,0))*sa.sales_taxes,2)+NVL(sa.sales_misc,0) "Total Selling Price"
FROM sales_invoice sa JOIN employee emp
ON (sa.employee_id = emp.employee_id)
LEFT JOIN employee mn
ON (sa.manager_id = mn.employee_id)
JOIN salevehicle ve
ON (sa.Sold_Vehicle_VIN = ve.VEHICLE_VIN)
LEFT JOIN salevehicle tr
ON (sa.tradein_Vehicle_VIN = tr.VEHICLE_VIN)
JOIN customer cu
ON (sa.customer_id = cu.customer_id)
)
ORDER BY sa.sales_invoice_id;
