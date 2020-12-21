DROP TABLE employee CASCADE CONSTRAINTS PURGE;
DROP TABLE part CASCADE CONSTRAINTS PURGE;
DROP TABLE carservice CASCADE CONSTRAINTS PURGE;
DROP TABLE preference CASCADE CONSTRAINTS PURGE;
DROP TABLE customer CASCADE CONSTRAINTS PURGE;
 
 -- Create table
CREATE TABLE employee
(
Employee_id     NUMBER(4)        CONSTRAINT emp_id_pk PRIMARY KEY,
First_name      VARCHAR2(15)    NOT NULL,
Last_name       VARCHAR2(15)    NOT NULL,
Employee_street VARCHAR2(40)    NOT NULL,
Employee_city   VARCHAR2(15)    NOT NULL,
Employee_state  CHAR(2)         DEFAULT 'CA' NOT NULL,
Employee_zip    VARCHAR2(5)     NOT NULL,
Employee_phone  VARCHAR2(12)    CONSTRAINT emp_phone_uk UNIQUE,
Employee_email  VARCHAR2(35)    CONSTRAINT emp_em_uk UNIQUE,
Employee_title  VARCHAR2(25)    NOT NULL,
Hire_date   DATE,
Manager_id      NUMBER(4),
Department_type CHAR(2)     CONSTRAINT dep_type_ck CHECK (Department_type IN ('SV','AC','SA')),
Commission_pct  NUMBER(3,2)     CONSTRAINT emp_comm_ck CHECK (commission_pct>0.20 AND Commission_pct<0.30),
CONSTRAINT emp_id_ck CHECK (employee_id>=1000),
CONSTRAINT emp_mnid_fk FOREIGN KEY (Manager_id) REFERENCES employee(employee_id),
CONSTRAINT emp_type_ck CHECK ((department_type = 'SV' AND Commission_pct IS NULL) 
OR (department_type = 'AC' AND Commission_pct IS NULL) 
OR (department_type = 'SA' AND Commission_pct IS NOT NULL))
);

CREATE TABLE carservice
(
Service_code        VARCHAR2(20)       CONSTRAINT sv_code_pk PRIMARY KEY,
Service_desc        VARCHAR2(25)        NOT NULL,
Service_cost     NUMBER(6,2)         CONSTRAINT sv_cost_ck CHECK(service_cost>0) NOT NULL,
Service_price     NUMBER(6,2)        NOT NULL,
Service_months     NUMBER(2),       CONSTRAINT sv_month_ck CHECK (service_months>0),
Service_mileage     NUMBER(6),       CONSTRAINT sv_mile_ck CHECK (service_mileage>0),
CONSTRAINT sv_price_ck CHECK (service_price>service_cost)
);

CREATE TABLE part
(
Part_code       VARCHAR2(20) CONSTRAINT pt_code_pk PRIMARY KEY,
Part_desc       VARCHAR2(25)    NOT NULL,
Part_cost       NUMBER(6,2)     CONSTRAINT pt_cost_ck CHECK (part_cost>0) NOT NULL,
Part_price      NUMBER(6,2)     NOT NULL,
CONSTRAINT pt_price_ck CHECK (part_price>part_cost)
);

CREATE TABLE customer
(
Customer_id     VARCHAR2(8)     CONSTRAINT cust_id_pk PRIMARY KEY,
First_name      VARCHAR2(15)    NOT NULL,
Last_name       VARCHAR2(15)    NOT NULL,
Customer_street VARCHAR2(25)    NOT NULL,
Customer_city   VARCHAR2(15)    NOT NULL,
Customer_state  CHAR(2)         DEFAULT 'CA' NOT NULL,
Customer_zip    VARCHAR2(5)     NOT NULL,
Customer_phone  VARCHAR2(12)    CONSTRAINT cust_phone_uk UNIQUE NOT NULL,
Customer_email  VARCHAR2(35)    CONSTRAINT cust_em_uk UNIQUE NOT NULL
);
 
CREATE TABLE preference
(
Pref_id         VARCHAR(8)  CONSTRAINT pref_id_pk PRIMARY KEY,
Customer_id     VARCHAR2(8) NOT NULL,
Pref_make       VARCHAR2(10) NOT NULL,
Pref_model      VARCHAR2(20) NOT NULL,
Pref_year       NUMBER(4),
Pref_desc	VARCHAR2(20),
Start_date      DATE DEFAULT SYSDATE NOT NULL,
End_date        DATE,
CONSTRAINT pref_end_ck CHECK(end_date>start_date),
CONSTRAINT pref_cust_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


-- Insert Data 
INSERT INTO customer VALUES (1234, 'Kevin', 'Chang', '2120 Higuera Street', 'San Luis Obispo', DEFAULT, '92010', '7583928475', 'kevkevkev@calpoly.edu' );
INSERT INTO customer VALUES (1456, 'Amy', 'Ru', '2120 Higuera Street', 'San Luis Obispo', DEFAULT, '92010', '8583928475', 'amyamyamy@calpoly.edu' );
INSERT INTO customer VALUES (1785, 'Han', 'Tran', '2121 Higuera Street', 'San Luis Obispo', DEFAULT, '92010', '8584059841', 'hanhanhan@calpoly.edu' );
INSERT INTO customer VALUES (8294, 'Barry', 'Floyd', '839 Higuera St', 'San Luis Obispo',DEFAULT, '93401', '8055420105', 'barbarbar@calpoly.edu' );
INSERT INTO customer VALUES (1875, 'Jennifer', 'Lopez', '858 Foothill Blvd', 'San Luis Obispo', DEFAULT, '93405', '8054392510', 'jenjenjen@calpoly.edu' );
INSERT INTO customer VALUES (8523, 'Miley', 'Cyrus', '1 Grand Avenue', 'San Luis Obispo', 'CA', '93410', '8057561111', 'polpolpol@calpoly.edu' );
INSERT INTO customer VALUES (1954, 'Jack', 'Harlow', '793F Foothill Blvd', 'San Luis Obispo', 'CA', '93405', '8057829766', 'jacjacjac@calpoly.edu' );
INSERT INTO customer VALUES (2435, 'Hannah', 'Montana', '350 High St', 'San Luis Obispo', 'CA', '93401', '8055414738', 'nahnahnah@calpoly.edu' );
INSERT INTO customer VALUES (4619, 'Michelle', 'Obama', '2900 Broad St', 'San Luis Obispo', 'CA', '93401', '8052002978', 'obaobaoba@calpoly.edu' );
INSERT INTO customer VALUES (2928, 'Kamala', 'Harris', '1121 Broad St', 'San Luis Obispo', 'CA', '93401', '8055455401', 'harharhar@calpoly.edu' );

INSERT INTO preference VALUES ('1234A', 1234, 'Porsche', '718 Cayman', '2000',NULL, DEFAULT, '01/01/2021' );
INSERT INTO preference VALUES ('1234B', 1234, 'Toyota', 'Camry Hybrid', '2018',NULL, DEFAULT, '02/14/2021' );
INSERT INTO preference VALUES ('1234C', 1234, 'Chevrolet', 'Impala', '2017','Leather seats', DEFAULT, NULL );
INSERT INTO preference VALUES ('4619A', 4619, 'Lincoln', 'MKZ', '2017','Hybrid', '10/05/2020', '01/15/2021' );
INSERT INTO preference VALUES ('4619B', 4619, 'BMW', 'X3', '2018','Grey', '10/05/2020', '01/15/2021' );
INSERT INTO preference VALUES ('1785A', 1785, 'Porsche', '718 Boxster', '2010','All black','10/20/2020', '12/31/2020' );
INSERT INTO preference VALUES ('1456A', 1456, 'Volkswagen', 'Getta GLI', '2020',NULL, '10/31/2020', '12/31/2020' );
INSERT INTO preference VALUES ('8523A', 8523, 'Porsche', '718 Spyder', '2012','Red or white', '09/05/2019', '09/05/2020' );

INSERT INTO employee VALUES (1000, 'Larry', 'Margaria', '90 Rich Ave', 'San Luis Obispo', DEFAULT, '93405', '8053456789', 'lmargaria@slovintage.com', 'Owner/Manager', '08/08/2005', NULL, NULL, NULL);

INSERT INTO employee VALUES (1021, 'Jim', 'Kaney', '91 Big 4 Ave', 'San Luis Obispo', DEFAULT, '93405', '8055643245', 'jkaney@slovintage.com', 'Accounting Manager', '04/03/2008', 1000, 'AC', NULL);
INSERT INTO employee VALUES (1098, 'Steve', 'Euro', '100 Money Ave', 'San Luis Obispo', DEFAULT, '93405', '8053565245', 'seuro@slovintage.com', 'Cashier', '02/14/2017', 1021, 'AC', NULL);
INSERT INTO employee VALUES (1099, 'Alice', 'Credit', '125 Debit Ave', 'San Luis Obispo', 'CA', '93405', '8059324566', 'acredit@slovintage.com', 'Bookkeeper', '12/24/2018', 1021, 'AC', NULL);

INSERT INTO employee VALUES (1026, 'Norm', 'Allen', '875 Please People Blvd', 'San Luis Obispo', 'CA', '93405', '8052345612', 'nallen@slovintage.com', 'Service Manager', '02/19/2013', 1000, 'SV', NULL);
INSERT INTO employee VALUES (1045, 'Alan', 'Wrench', '835 Please Norm Blvd', 'San Luis Obispo', 'CA', '93405', '8059871236', 'awrench@slovintage.com', 'Service Worker', '01/05/2018', 1026, 'SV', NULL);
INSERT INTO employee VALUES (1036, 'Woody', 'Apple', '835 Orange St', 'San Luis Obispo', 'CA', '93405', '8059871242', 'wapple@slovintage.com', 'Service Worker', '01/14/2016', 1026, 'SV', NULL);
INSERT INTO employee VALUES (1100, 'Sherry', 'Sophomore', '243 Unpaid St', 'San Luis Obispo', 'CA', '93405', '8055562124', 'ssophomore@slovintage.com', 'Cal Poly Intern', '10/05/2020', 1036, 'SV', NULL);

INSERT INTO employee VALUES (1030, 'Mary', 'Long', '1378 Commission St', 'San Luis Obispo', 'CA', '93405', '8052341753', 'mlong@slovintage.com', 'Sales Manager', '12/20/2011', 1000, 'SA', 0.25);
INSERT INTO employee VALUES (1071, 'Adam', 'Packer', '284 Tired St', 'San Luis Obispo', 'CA', '93405', '8052341724', 'apacker@slovintage.com', 'Salesperson', '02/28/2017', 1030, 'SA', 0.22);
INSERT INTO employee VALUES (1079, 'Larry', 'Jones', '123 Boring St', 'San Luis Obispo', 'CA', '93405', '8052353724', 'ljones@slovintage.com', 'Salesperson', '03/15/2017', 1030, 'SA', 0.24);

INSERT INTO carservice VALUES ('OILCHG','Oil Change',9.95, 10.95, 6, 6000);
INSERT INTO carservice VALUES ('TIREROTATE','Tire Rotation',6.95, 9.95, 12, 12000);
INSERT INTO carservice VALUES ('FLUIDS','Fluid Replacement',29.95, 49.96, 30, 30000);
INSERT INTO carservice VALUES ('TUNEUPBASICS','Basic Engine tune up',69.95, 149.95, 18, 18000);
INSERT INTO carservice VALUES ('MULTIPOINTINTSP','Multi-Point Inspection',29.95, 59.95, 6, 6000);
INSERT INTO carservice VALUES ('BRAKEINSPECT','Brake Inspection', 30.95, 70.50, 12, 20000);
INSERT INTO carservice VALUES ('BATTERYREPLACE','Battery Replacement', 30.00, 50.00, 30, 30000);

INSERT INTO part VALUES ('OIL10W30','Oil 10W30', 2.79, 3.95);
INSERT INTO part VALUES ('OILFILTER','Oil Filter', 6.95, 11.95);
INSERT INTO part VALUES ('WINSHIELDFLUID','Windshield Fluid', 2.96, 4.95);
INSERT INTO part VALUES ('SPARKPLUG4','Spark Plug Set (4)', 9.95, 19.95);
INSERT INTO part VALUES ('AIRFILTER','Air Filter', 3.95, 8.95);
INSERT INTO part VALUES ('BATTERY','Lead-acid AGM Battery', 20.75, 28.75);
INSERT INTO part VALUES ('HUBCAP','15 INCH HUB CAPS (4)', 166.50, 200.95);


-- Create views

CREATE OR REPLACE VIEW AllCustomer AS 
(
SELECT first_name "First Name", last_name "Last Name", customer_street "Street", customer_city "City", customer_state "State", customer_zip "Zip Code", customer_phone "Phone", customer_email "Email"
FROM customer
)
ORDER BY last_name;

CREATE OR REPLACE VIEW CustomerWithPref AS
(
SELECT c.first_name "First Name", c.last_name "Last Name", c.customer_phone "Phone", p.pref_make "Preferred Make", p.pref_model "Preferred Model", p.start_date "Start date", p.end_date "End date"
FROM customer c JOIN preference p
ON (c.customer_id = p.customer_id)
);

CREATE OR REPLACE VIEW AllCustomerWithPref AS
(
SELECT c.first_name "First Name", c.last_name "Last Name", c.customer_phone "Phone", p.pref_make "Preferred Make", NVL(p.pref_model,'No Preference') "Preferred Model", p.start_date "Start date", p.end_date "End date"
FROM customer c LEFT JOIN preference p
ON (c.customer_id = p.customer_id)
);

CREATE OR REPLACE VIEW EmpContactList AS
(
SELECT first_name "First Name", last_name "Last Name", employee_phone "Phone", employee_email "Email"
FROM employee
)
ORDER BY last_name;

CREATE OR REPLACE VIEW EmpReportingList AS
(
SELECT m.first_name || ' ' || m.last_name "Manager", m.employee_title "Title", w.first_name ||' '||w.last_name "Reportee", w.employee_title "Employee Title"
FROM employee m JOIN employee w
ON (w.manager_id = m.employee_id)
)
ORDER BY m.last_name;

CREATE OR REPLACE VIEW ServiceList AS
(
SELECT Service_code "Service code", service_desc "Description", service_cost "Cost", service_price "Price", service_months "Months", service_mileage "Mileage"
FROM carservice
)
ORDER BY Service_code;

CREATE OR REPLACE VIEW PartList AS
(
SELECT Part_code "Part code", part_desc "Description", part_cost "Cost", part_price "Price"
FROM part
)
ORDER BY part_code;
