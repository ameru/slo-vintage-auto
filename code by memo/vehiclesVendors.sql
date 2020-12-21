DROP TABLE carseller CASCADE CONSTRAINTS PURGE;
DROP TABLE servicevehicle CASCADE CONSTRAINTS PURGE;
DROP TABLE salevehicle CASCADE CONSTRAINTS PURGE;

/* Create Tables: CarSeller, ServiceVehicle, and SaleVehicle */

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
 
CREATE TABLE servicevehicle
(
Vehicle_VIN       		    VARCHAR2(6)     	    NOT NULL CONSTRAINT is_vin_pk PRIMARY KEY,
Vehicle_Year                NUMBER(4)               NOT NULL,
Vehicle_Make                VARCHAR2(20)            NOT NULL,
Vehicle_Model               VARCHAR2(20)            NOT NULL,
Vehicle_Mileage             NUMBER(6)               NOT NULL,
Customer_ID                 VARCHAR2(8)             NOT NULL,
CONSTRAINT is_cid_fk    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
 
CREATE TABLE salevehicle
(
Vehicle_VIN                 VARCHAR2(6)             NOT NULL CONSTRAINT fs_vin_pk PRIMARY KEY,
Vehicle_Year                NUMBER(4)               NOT NULL CONSTRAINT fs_year_ck CHECK(Vehicle_Year > 0),
Vehicle_Make                VARCHAR2(20)            NOT NULL,
Vehicle_Model               VARCHAR2(20)            NOT NULL,
Vehicle_Mileage             NUMBER(6)               NOT NULL CONSTRAINT fs_miles_ck CHECK(Vehicle_Mileage > 0),
Exterior_Color              VARCHAR2(10)            NOT NULL,
Trim                        VARCHAR2(20),
Condition       	        VARCHAR2(10)            NOT NULL,
Status                      VARCHAR2(10)            NOT NULL CHECK(Status IN ('FORSALE', 'SOLD', 'TRADEIN')),
Purchase_Price              NUMBER(15,2)            CONSTRAINT fs_pur_ck CHECK(purchase_price > 0),
List_Price                  NUMBER(15,2)            CONSTRAINT fs_list_ck CHECK(list_price > 0),
Trade_In_Allowance          NUMBER(15,2)            CONSTRAINT fs_all_ck CHECK(trade_in_allowance > 0),
Seller_ID                   VARCHAR2(10),
Customer_ID                 VARCHAR2(8),
CONSTRAINT fs_vid_fk    FOREIGN KEY (Seller_ID) REFERENCES carseller(Seller_ID),
CONSTRAINT fs_cid_fk    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
CONSTRAINT salev_stat_ck CHECK(
                        (Status = 'FORSALE'
                        AND purchase_price IS NOT NULL
                        AND list_price IS NOT NULL
                        AND trade_in_allowance IS NULL
                        AND Seller_ID is NOT NULL
                        AND Customer_ID IS NULL)
                        OR
                        (Status = 'TRADEIN'
                        AND purchase_price IS NULL
                        AND list_price IS NULL
                        AND trade_in_allowance IS NOT NULL
                        AND Seller_ID IS NULL
                        AND Customer_ID IS NOT NULL)
                        OR
                        (Status = 'SOLD'
                        AND purchase_price IS NOT NULL
                        AND list_price IS NOT NULL
                        AND trade_in_allowance IS NULL
                        AND Seller_ID IS NULL
                        AND Customer_ID IS NOT NULL)
                        )
);

/* Insert Data */

/* Car Sellers */
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

/* Service Vehicles */
INSERT INTO servicevehicle
VALUES ('1A1B1C', 1950, 'Rolls-Royce', 'Dawn Drophead', 25340, 1234);

INSERT INTO servicevehicle
VALUES ('2A2B2C', 1954, 'Mercedes-Benz', 'SL 300 Gullwing', 21311, 1456);

INSERT INTO servicevehicle
VALUES ('3A3B3C', 2018, 'Ferrari', '430', 21311, 2928);

INSERT INTO servicevehicle
VALUES ('1D1E1F', 2011, 'Hyundai', 'Sonata', 115641, 8523);

INSERT INTO servicevehicle
VALUES ('2D2E2F', 2020, 'Mercedes-Benz', 'A-Class', 8000, 4619);

INSERT INTO servicevehicle
VALUES ('3D3E3F', 1963, 'Ferrari', '250 GTO', 18970, 1875);
 
/* Sale Vehicles FORSALE: Purchased from Another Car Seller */
INSERT INTO salevehicle
VALUES ('1YVHP8', 1967, 'Chevrolet', 'Corvette', 21310, 'Red', NULL, 'Good', 'FORSALE', 155000.00, 170000.00, NULL, 91392, NULL);

INSERT INTO salevehicle
VALUES ('4T1BG2', 1974, 'Porsche', '911', 19523, 'White', '2 Door Coupe', 'Excellent', 'FORSALE', 40000.00, 70000.50, NULL, 92234, NULL);

INSERT INTO salevehicle
VALUES ('1G2ZJ5', 1975, 'BMW', '3.0 CSL', 18720, 'Black', '2 Door Coupe', 'Excellent', 'FORSALE', 100000.00, 131600.00, NULL, 92335, NULL);

INSERT INTO salevehicle
VALUES ('1GNCS1', 1965, 'Jaguar', 'E-Type', 22400, 'Blue', 'Fixed Head Coupe', 'Good', 'FORSALE', 150000.00, 187000.00, NULL, 93350, NULL);

INSERT INTO salevehicle
VALUES ('1GKEV2', 1966, 'Lamborghini', 'Miura', 20560, 'Green', '2 Door Coupe', 'Excellent', 'FORSALE', 125000.00, 157600.00, NULL, 91563, NULL);

/* Sale Vehicles SOLD: Vehicle Purchased by a Customer */
INSERT INTO salevehicle
VALUES ('1A1B1C', 1953, 'Rolls-Royce', 'Silver Dawn', 25340, 'Grey', 'Bordeaux', 'Good', 'SOLD', 35000.00, 50000.00, NULL, NULL, 1234);

INSERT INTO salevehicle
VALUES ('2A2B2C', 1960, 'Mercedes-Benz', '300 SL', 21311, 'Beige', 'Roadster', 'Excellent', 'SOLD', 89950.00, 1156070.00, NULL, NULL, 1456);

INSERT INTO salevehicle
VALUES ('1FMJU2', 1960, 'Aston Martin', 'DB4', 29856, 'Grey', 'Zagato', 'Excellent', 'SOLD', 9870000.00, 12980000.00, NULL, NULL, 1785);

INSERT INTO salevehicle
VALUES ('1GCPKP', 1990, 'Acura', 'NSX', 70690, 'Blue', '2 Door Coupe', 'Good', 'SOLD', 48000.00, 69995.00, NULL, NULL, 8294);

INSERT INTO salevehicle
VALUES ('3D3E3F', 1963, 'Ferrari', '250 GTO', 18970, 'Red', '2 Door Coupe', 'Excellent', 'SOLD', 40000000.00, 58000000.00, NULL, NULL, 1875);

/* Sale Vehicles TRADEIN: Vehicle Acquired via Trade-In */
INSERT INTO salevehicle
VALUES ('1FTRX1', 2019, 'Tesla', 'Model X', 20798, 'White', 'Utility', 'Good', 'TRADEIN', NULL, NULL, 60000.00, NULL, 1456);

INSERT INTO salevehicle
VALUES ('5N1AR1', 1968, 'Shelby', 'GT350', 24990, 'Green', 'Fastback', 'Excellent', 'TRADEIN', NULL, NULL, 105000.00, NULL, 1785);

INSERT INTO salevehicle
VALUES ('2GKFLX', 2018, 'Lamborghini', 'Aventador', 26823, 'Black', 'S Roadster', 'Good', 'TRADEIN', NULL, NULL, 450000.00, NULL, 1875);

/* Create Views */

CREATE OR REPLACE VIEW VehicleList AS
(
SELECT Vehicle_VIN "VIN", Vehicle_Year "Year", Vehicle_Make "Make", Vehicle_Model "Model", Exterior_Color AS "Exterior Color", Trim, Vehicle_Mileage "Mileage", Condition, Status, List_Price AS "List Base Price"
FROM salevehicle
)
ORDER BY Vehicle_Make, Vehicle_Model;
 
CREATE OR REPLACE VIEW VehiclesForSale AS
(
SELECT Vehicle_VIN "VIN", Vehicle_Year "Year", Vehicle_Make "Make", Vehicle_Model "Model", Exterior_Color AS "Exterior Color", Trim, Vehicle_Mileage "Mileage", Condition, Status, List_Price AS "List Base Price"
FROM salevehicle
WHERE Status = 'FORSALE'
)
ORDER BY Vehicle_Make, Vehicle_Model;
 
CREATE OR REPLACE VIEW VehiclesSold AS
(
SELECT Vehicle_VIN "VIN", Vehicle_Year "Year", Vehicle_Make "Make", Vehicle_Model "Model", Vehicle_Mileage "Mileage", Condition, Status, List_Price AS "List Base Price"
FROM salevehicle
WHERE Status = 'SOLD'
);
 
CREATE OR REPLACE VIEW VehicleInventoryValue AS
(
SELECT SUM(List_Price) AS "Total Value of Vehicles For Sale"
FROM salevehicle
WHERE Status = 'FORSALE'
);
 
CREATE OR REPLACE VIEW InventoryValueByMake AS
(
SELECT Vehicle_Make "Make", SUM(List_Price) AS "Total Value of Vehicles For Sale"
FROM salevehicle
WHERE Status = 'FORSALE'
GROUP BY Vehicle_Make
)
ORDER BY Vehicle_Make;
 
CREATE OR REPLACE VIEW CarSellerList AS
(
SELECT Seller_Name AS "Company Name", Seller_Contact AS "Contact Name", Seller_Street || ' ' || Seller_City || ' ' || Seller_State || ' ' || Seller_Zip_Code "Address", Seller_Phone AS "Phone Number", Seller_Fax AS "Fax Number"
FROM carseller
)
ORDER BY Seller_Name;
