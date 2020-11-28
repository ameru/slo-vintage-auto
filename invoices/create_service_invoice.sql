CREATE TABLE service_invoice
(
service_invoice_id          NUMBER(7)               CONSTRAINT service_invoice_sid_pk PRIMARY KEY,
Employee_id                 NUMBER(4)               NOT NULL,
manager_id                  NUMBER(4),
Part_code                   VARCHAR2(20),
Service_code                VARCHAR2(20),
Customer_id                 VARCHAR2(8)             NOT NULL,
service_vehicle_VIN         VARCHAR2(17)            NOT NULL,
date_serviced               DATE,
misc_charge                 NUMBER(7),
Taxes		            NUMBER(7),
CONSTRAINT emp_service_eid_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
CONSTRAINT emp_service_mnid_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
CONSTRAINT part_service_pid_fk FOREIGN KEY (part_code) REFERENCES part(part_code),
CONSTRAINT car_service_cid_fk FOREIGN KEY (Service_code) REFERENCES carservice(Service_code),
CONSTRAINT customer_service_cid_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
CONSTRAINT ServiceVehicle_sid_fk FOREIGN KEY (service_vehicle_VIN) REFERENCES ServiceVehicle(service_vehicle_VIN)
);
