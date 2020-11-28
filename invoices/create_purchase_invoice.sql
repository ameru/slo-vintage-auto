CREATE TABLE purchase_invoice
(
purchase_invoice_id         NUMBER(7)               CONSTRAINT purchase_invoice_pid_pk PRIMARY KEY,
Employee_id                 NUMBER(4)               NOT NULL,
manager_id                  NUMBER(4),
Customer_id                 VARCHAR2(8)             NOT NULL,
Vendor_id                   VARCHAR2(10),
date_purchased              DATE,
total_purchase_price        NUMBER(7),
CONSTRAINT emp_purchase_eid_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
CONSTRAINT emp_purchase_mnid_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
CONSTRAINT customer_purchase_cid_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
CONSTRAINT AutoVendor_purchase_vid_fk FOREIGN KEY (Vendor_id) REFERENCES AutoVendor(Vendor_id)
);
