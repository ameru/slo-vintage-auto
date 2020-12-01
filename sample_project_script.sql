-- Sample Project Script
-- Constraints are named except for NOT NULL constraints.
-- Some constraints are specified at column level,
-- some at table level simply to illustrate how.


-- Drop all tables 
-- smunch kids first, then parents

DROP TABLE dog_License PURGE;
DROP TABLE work_License PURGE;
DROP TABLE trick PURGE;
DROP TABLE attends PURGE;
DROP TABLE training_class PURGE;
DROP TABLE doggie PURGE;
DROP TABLE owner PURGE;


-- Create tables, 
-- create parents first, then kids

-- OWNER TABLE COMMENTS:
-- Address is a composite attibute and
-- so its components are included. 
-- Address itself is not shown.
-- Note if you want a default value
-- you must list it first and then any constraints.
-- (like NOT NULL)

CREATE TABLE owner
(
 owner_id     NUMBER(6) 
              CONSTRAINT owner_oid_pk PRIMARY KEY,
 owner_name   VARCHAR2(15) NOT NULL,
 owner_street VARCHAR2(15) NOT NULL,
 owner_city   VARCHAR2(20) DEFAULT 'SLO' NOT NULL,
 owner_state  CHAR(2) DEFAULT 'CA' NOT NULL,
 owner_zip    CHAR(5)
 );

INSERT INTO owner VALUES (1, 'John Smith', '123 Santa Rosa', 'SLO', 'CA', '93401');
INSERT INTO owner VALUES (2, 'Mary Jones', '111 Santa Rosa', 'SLO', 'CA', '93401');

-- DOGGIE TABLE COMMENTS:
-- Note that age is not included, this
-- is derived and will show up in a view.
-- tricks is multivalued and shows up as
-- a separate table.

 CREATE TABLE doggie
( 
 doggie_ID 	 NUMBER(6) 
             CONSTRAINT doggie_did_pk PRIMARY KEY,
 doggie_name VARCHAR2(15) NOT NULL,
 dob    DATE,
 owner_ID    NUMBER(6) 
             CONSTRAINT doggie_oid_nn NOT NULL,
 CONSTRAINT doggie_oid_fk FOREIGN KEY (owner_ID) 
            REFERENCES owner(owner_ID)
);


INSERT INTO doggie VALUES(1001, 'Spot', '01/01/2011', 1);
INSERT INTO doggie VALUES(1002, 'Rover', '02/02/2012', 1);

-- TRICK TABLE COMMENTS
-- Note that this allows the
-- trick name to be anything one
-- wants. What would you do to
-- assure everyone entered the same
-- name for a particular trick?
-- (e.g., Rollover vs. Roll Over)

CREATE TABLE trick
(
 trick_ID   NUMBER(6) 
            CONSTRAINT trick_tid_pk PRIMARY KEY,
 trick_name VARCHAR2(10) NOT NULL,
 doggie_ID  NUMBER(6) 
            CONSTRAINT trick_did_fk  REFERENCES doggie(doggie_id)
);

INSERT INTO trick VALUES (1, 'Rollover',1001);
INSERT INTO trick VALUES (2, 'Play Dead',1001);


-- LICENSE TABLE COMMENTS
-- Note I left expiration_date with 
-- the same name as in the work license 
-- to show difficulties when we create
-- a view.
-- Note too that this situation is a bit 
-- different than your project where you are
-- asked to connect two of the same kind of 
-- entity to another entity. Don't be confused
-- by this. 

CREATE TABLE dog_license
(
 license_num     NUMBER(6) 
                 CONSTRAINT license_lnum_pk PRIMARY KEY,
 expiration_date DATE NOT NULL,
 doggie_ID       NUMBER(6) NOT NULL 
                 CONSTRAINT lic_did_fk REFERENCES doggie(doggie_id)
                 CONSTRAINT lic_did_uk UNIQUE
);

INSERT INTO dog_license VALUES (10001, '01/01/2017', 1001);
INSERT INTO dog_license VALUES (10002, '01/01/2017', 1002);


CREATE TABLE work_license
(
 work_license_num     NUMBER(6) 
                 CONSTRAINT wlicense_lnum_pk PRIMARY KEY,
 expiration_date DATE NOT NULL,
 doggie_ID       NUMBER(6) NOT NULL  
                 CONSTRAINT wlic_did_fk REFERENCES doggie(doggie_id)
                 CONSTRAINT wlic_did_uk UNIQUE
);

INSERT INTO work_license VALUES (10001, '01/01/2017', 1001);

-- TRAINING CLASS TABLE COMMENTS
-- note that the tax and total cost attributes
-- are not included in the table, they will show up
-- in a view.
-- also this is a one table approach towards modeling
-- the training class entity.

CREATE TABLE training_class
(
 class_ID      NUMBER(6) 
               CONSTRAINT tcls_clsid_pk PRIMARY KEY,
 title         VARCHAR2(25) NOT NULL,
 tcls_date     DATE,
 class_cost    NUMBER(7,2) 
               CONSTRAINT tcls_cc_ck CHECK (class_cost > 0),
 class_type    CHAR(2) 
               CONSTRAINT tcls_ct_ck CHECK (class_type IN ('TH', 'AS')),
 exp_study_hrs NUMBER(3)
               CONSTRAINT tcls_esh_ck CHECK (exp_study_hrs >=0),
 location 	   VARCHAR2(20),
 max_enroll    NUMBER(3)
               CONSTRAINT tcls_max_ck CHECK (max_enroll >=0),
 day_time      VARCHAR2(10),
 num_sess      NUMBER(2)
			   CONSTRAINT tcls_num_ck CHECK (num_sess >=0),
 pre_req_id    NUMBER(6)
               CONSTRAINT tc_pre_fk REFERENCES training_class(class_id),
 CONSTRAINT    traincls_pre_ck
               CHECK (class_id <> pre_req_id),
 CONSTRAINT    traincls_type_ck
               CHECK (
			     (class_type = 'TH' 
				  AND exp_study_hrs IS NOT NULL
				  AND location IS NULL
				  AND max_enroll IS NULL
				  AND day_time IS NULL
				  AND num_sess IS NULL)
			    OR
			     (class_type = 'AS' 
				  AND exp_study_hrs IS NULL
				  AND location IS NOT NULL
				  AND max_enroll IS NOT NULL
				  AND day_time IS NOT NULL
				  AND num_sess IS NOT NULL)	
				 )
);
            
            
INSERT INTO training_class VALUES (1, 'Barking for Food', '09/09/2016', 25, 'TH', 5, NULL, NULL, NULL, NULL, NULL );
INSERT INTO training_class VALUES (2, 'How to Wag Effectively', '09/10/2016', 33, 'AS', NULL, 'AG', 30, '3pm', 1, NULL);
            
            
-- ATTEND TABLE COMMENTS
-- Assumes a dog may only attend a class once.

CREATE TABLE attends
(
 doggie_ID   NUMBER(6)
             CONSTRAINT att_did_fk REFERENCES doggie(doggie_id),
 class_ID    NUMBER(6)
             CONSTRAINT att_cid_fk REFERENCES training_class(class_id),
 evaluation  VARCHAR2(10),
 CONSTRAINT attend_did_cid_pk PRIMARY KEY (doggie_ID, class_ID));


INSERT INTO attends VALUES (1001, 1, NULL);
INSERT INTO attends VALUES (1001, 2, NULL);

-- Now we can create some views


CREATE OR REPLACE VIEW training_class_TH 
AS 
(
 SELECT class_ID, title, tcls_date, class_cost, exp_study_hrs
 FROM training_class
 WHERE  class_type = 'TH'
 );

CREATE OR REPLACE VIEW training_class_AS 
AS 
(
 SELECT class_ID, title, tcls_date, class_cost, 
        location, max_enroll, day_time,  num_sess
 FROM training_class
 WHERE  class_type = 'AS'
 );
 
 -- Lets create a view of a doggie. This would be similar
 -- in nature to creating a view of one of your business
 -- documents. Lets include in the view the owner information,
 -- the license information, the number of tricks the dog can do,
 -- and the amount of money the owner spent on classes the dog took.
 
 -- to determine the number of tricks the dog can do, we need to
 -- create a view that counts them. Lets do this first.
 -- (Why do I need to do an outer join? Why do I need to use NVL?)
 
 CREATE OR REPLACE VIEW num_tricks 
 AS 
 (
  SELECT d.doggie_id, NVL(COUNT(t.trick_ID),0) num_of_tricks
  FROM   doggie d
  LEFT OUTER JOIN trick t
  ON (d.doggie_ID = t.doggie_id)
  GROUP BY d.doggie_id
  );
 
 -- to determine the amount of money the owner spent on
 -- classes and the number of classes the dog attended.
 -- we also need to create a view for that.
 -- (Why do I need to do an outer join? Why do I need to use NVL?)
 
 CREATE OR REPLACE VIEW total_class_costs	 
 AS 
 (
  SELECT d.doggie_id, NVL(SUM(c.class_cost * 1.085),0) total_cost_paid, 
  NVL(count(a.class_id),0) num_classes_attended
  FROM   doggie d
  LEFT OUTER JOIN attends a 
  ON (d.doggie_ID = a.doggie_ID)
  LEFT OUTER JOIN training_class c
  ON (a.class_id = c.class_ID)
  GROUP BY d.doggie_id
  );
 
 -- why don't we need to put a LEFT OUTER JOIN to the VIEWS?
 
 CREATE OR REPLACE VIEW doggie_vue
 AS
 (
  SELECT o.owner_name, o.owner_street, o.owner_city,
         o.owner_state, o.owner_zip,
         d.doggie_name, (SYSDATE - d.dob)/365 age, 
		 dl.license_num Reg_License_Num, dl.expiration_date Reg_License_Num_Exp_Date ,
		 wl.work_license_num Wk_License_Num, wl.expiration_date Wk_License_Num_Exp_Date,
		 nt.num_of_tricks, tcc.total_cost_paid, tcc.num_classes_attended
  FROM owner o
  JOIN doggie d
  ON( o.owner_id = d.owner_id)
  LEFT OUTER JOIN dog_license dl
  ON (d.doggie_id = dl.doggie_id)
  LEFT OUTER JOIN work_license wl
  ON( d.doggie_id = wl.doggie_id)
  JOIN num_tricks nt
  ON (d.doggie_id = nt.doggie_id)
  JOIN total_class_costs tcc
  ON (d.doggie_id = tcc.doggie_id)
  );
