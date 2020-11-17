DROP TABLE service CASCADE CONSTRAINTS PURGE;
DROP TABLE accounting CASCADE CONSTRAINTS PURGE;
DROP TABLE sales CASCADE CONSTRAINTS PURGE;
DROP TABLE employee CASCADE CONSTRAINTS PURGE;

DROP TABLE part CASCADE CONSTRAINTS PURGE;
DROP TABLE carservice CASCADE CONSTRAINTS PURGE;
 
DROP TABLE preference CASCADE CONSTRAINTS PURGE;
DROP TABLE customer CASCADE CONSTRAINTS PURGE;


CREATE TABLE employee
(  
Employee_id     VARCHAR2(8) CONSTRAINT emp_ck_pk PRIMARY KEY,
First_name      VARCHAR2(15)    NOT NULL,
Last_name       VARCHAR2(15)    NOT NULL,
Manager_id      VARCHAR2(8),
Position_name   VARCHAR2(15)    NOT NULL,
Department_type VARCHAR2(2),
CONSTRAINT emp_mnid_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
CONSTRAINT emp_type_ck CHECK (Department_type='SA' OR Department_type='AC' OR Department_type='SV')
);

CREATE TABLE service
(
Employee_id     VARCHAR2(8) CONSTRAINT sv_eid_pk PRIMARY KEY
                           CONSTRAINT sv_eid_fk REFERENCES employee(employee_id)
);
 
CREATE TABLE accounting
(
Employee_id     VARCHAR2(8) CONSTRAINT ac_eid_pk PRIMARY KEY
                       CONSTRAINT ac_eid_fk REFERENCES employee(employee_id)
);
 
CREATE TABLE sales
(
Employee_id     VARCHAR2(8) CONSTRAINT sm_eid_pk PRIMARY KEY
                       CONSTRAINT sm_eid_fk REFERENCES employee(employee_id)
);
 

CREATE TABLE part
(
Part_code       NUMBER(8)       CONSTRAINT pt_code_pk PRIMARY KEY,
Part_desc       VARCHAR2(15),
Part_charge     NUMBER(6,2)     CONSTRAINT pt_charge_ck CHECK(part_charge>0)
);
 
CREATE TABLE carservice
(
Service_code        NUMBER(8)       CONSTRAINT sv_code_pk PRIMARY KEY,
Service_desc        VARCHAR2(15),
Service_charge  NUMBER(6,2)     CONSTRAINT sv_charge_ck CHECK(service_charge>0)
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
Customer_phone  VARCHAR2(12)    CONSTRAINT cust_phone_uk UNIQUE,
Customer_email  VARCHAR2(35)    CONSTRAINT cust_em_uk UNIQUE
);
 
CREATE TABLE preference
(
Customer_id     VARCHAR2(8) CONSTRAINT pref_cust_pk PRIMARY KEY,
Pref_color      VARCHAR2(10),
Pref_make       VARCHAR2(10),
Pref_model      VARCHAR2(10),
Pref_seats      NUMBER(2),
Start_date      DATE,
End_date        DATE,
CONSTRAINT pref_end_ck CHECK(end_date>start_date),
CONSTRAINT pref_cust_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
