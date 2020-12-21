-- MEMO Task 4
DROP TABLE salevehicle CASCADE CONSTRAINTS PURGE;
DROP TABLE servicevehicle CASCADE CONSTRAINTS PURGE;

-- Create Tables: ServiceVehicle & SaleVehicle
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
                            AND Customer_ID IS NULL)
                            OR
                            (Status = 'TRADEIN'
                            AND purchase_price IS NULL
                            AND list_price IS NULL
                            AND trade_in_allowance IS NOT NULL
                            AND Customer_ID IS NOT NULL)
                            OR
                            (Status = 'SOLD'
                            AND purchase_price IS NOT NULL
                            AND list_price IS NOT NULL
                            AND trade_in_allowance IS NULL
                            AND Customer_ID IS NOT NULL)
                            )
    );

-- Create Views: Task 4

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
