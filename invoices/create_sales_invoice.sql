CREATE TABLE sales_invoice
(
sales_invoice_id            NUMBER(7)               CONSTRAINT sales_invoice_sid_pk PRIMARY KEY,
Employee_id                 NUMBER(4)               NOT NULL,
manager_id                  NUMBER(4),
Customer_id                 VARCHAR2(8)             NOT NULL,
date_sold                   DATE,
terms                       VARCHAR2(15),
CONSTRAINT emp_sales_eid_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
CONSTRAINT emp_sales_mnid_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
CONSTRAINT customer_sales_cid_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
