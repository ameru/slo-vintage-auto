-- Insert Data
INSERT INTO service_invoice VALUES (001, 1045, 1026, OILFILTER, OILCHG, 1234, '1A1B1C', '01-01-2020', 1, 11);
INSERT INTO service_invoice VALUES (002, 1045, 1026, OILFILTER, OILCHG, 1234, '2A2B2C', '02-02-2020', 2, 22);
INSERT INTO service_invoice VALUES (003, 1045, 1026, SPARKPLUG4, TUNEUPBASICS, 1785, '3A3B3C', '03-03-2020', 3, 33);
INSERT INTO service_invoice VALUES (004, 1036, 1026, AIRFILTER, MULTIPOINTINTSP, 8294, '1D1E1F', '04-04-2020', 4, 44);
INSERT INTO service_invoice VALUES (005, 1036, 1026, BATTERY, BATTERYREPLACE, 8523, '2D2E2F', '05-05-2020', 5, 55);
INSERT INTO service_invoice VALUES (005, 1036, 1026, WINSHIELDFLUID, FLUIDS, 8523, '3D3E3F', '08-08-2020', 8, 88);
INSERT INTO purchase_invoice VALUES (006, 1098, 1021, 1954, 91563, '06-06-2020');
INSERT INTO purchase_invoice VALUES (007, 1098, 1021, 1954, 92234, '07-07-2020');
INSERT INTO purchase_invoice VALUES (008, 1099, 1021, 2435, 92335, SYSDATE);
INSERT INTO purchase_invoice VALUES (009, 1099, 1021, 4619, 00001, '09-09-2020');
INSERT INTO purchase_invoice VALUES (010, 1099, 1021, 4619, 00001, '10-10-2020');
INSERT INTO sales_invoice VALUES (011, 1071, 1234, 4619, '11-11-2020', 'cash');
INSERT INTO sales_invoice VALUES (012, 1071, 1456, 1954, '12-12-2020', 'credit');
INSERT INTO sales_invoice VALUES (013, 1071, 1785, 8523, SYSDATE, 'cash');
INSERT INTO sales_invoice VALUES (014, 1079, 8294, 8523, '10-04-2020', 'bitcoin');
INSERT INTO sales_invoice VALUES (015, 1079, 1875, 4619, '10-05-2020', 'credit');
