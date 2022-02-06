CREATE USER C##Iteration04 IDENTIFIED BY Koitemp DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
GRANT connect, resource TO C##Iteration04; 
--Create a temporary table space
DROP SEQUENCE Em_id_seq;
DROP SEQUENCE Prod_code_seq; 
DROP SEQUENCE Posn_id_seq; 
DROP SEQUENCE Shift_id_seq;
DROP SEQUENCE Car_id_seq;
DROP SEQUENCE Order_id_seq;
DROP SEQUENCE Item_id_seq;
DROP SEQUENCE Item_trigger_seq;
DROP SEQUENCE Prod_trigger_seq;
DROP SEQUENCE Trxn_id_seq; 
DROP SEQUENCE Ticket_Num_seq;

DROP PROCEDURE Add_Emp;
DROP PROCEDURE Add_Store;
DROP PROCEDURE Add_Product; 
DROP PROCEDURE Add_Pur_order;
DROP PROCEDURE Add_shift;
DROP PROCEDURE Add_time_card;
DROP PROCEDURE Add_item;
--DROP PROCEDURE Add_trxn;
--DROP PROCEDURE Add_Trxn_xref;
DROP PROCEDURE Add_Full_trxn; 

DROP TABLE Manager;
DROP TABLE Server;
DROP TABLE Accountant;
DROP TABLE TimeCard;
DROP TABLE Dessert_splr;
DROP TABLE Bev_splr;
DROP TABLE Prod_order_xref;
DROP TABLE Trxn_Item_Xref;
DROP TABLE Item_price_hist; 
DROP TABLE Drink; 
DROP TABLE Pastry;
DROP TABLE Item;
DROP TABLE Cash;
DROP TABLE Card;
DROP TABLE Gift_card;
DROP TABLE Shift_Xref;
DROP TABLE Pur_order;
DROP TABLE Prod_price_hist; 
DROP TABLE Product;
DROP TABLE Employee;
DROP TABLE Job_desc;
DROP TABLE Supplier;
DROP TABLE Transaction;
DROP TABLE Store;



 


--Create all the Tables 
CREATE TABLE Store (
Store_id DECIMAL(12) GENERATED ALWAYS AS IDENTITY, 
Store_name VARCHAR(100) NOT NULL,
Store_ad VARCHAR(255) NOT NULL,
Store_zip DECIMAL(6) NOT NULL, 
Store_phone DECIMAL(10), 
PRIMARY KEY (Store_id)
);
--SELECT * FROM Store; 

CREATE TABLE Employee(
Em_id DECIMAL(12) NOT NULL,
Gov_id DECIMAL(12) NOT NULL UNIQUE,
Firstname VARCHAR(100) NOT NULL,
Lastname VARCHAR(100) NOT NULL,
EmDOB DATE NOT NULL,
Em_ad VARCHAR(255) NOT NULL,
Em_zip DECIMAL(6) NOT NULL, 
Em_phone DECIMAL(10) NOT NULL,
Em_email VARCHAR(255) NOT NULL, 
Em_start DATE NULL,
Em_end DATE NULL,  
PRIMARY KEY (Em_id)
);
--SELECT * FROM Employee;

CREATE TABLE Job_Desc(
Posn_id DECIMAL(12) NOT NULL PRIMARY KEY,
Posn_name VARCHAR(100) NOT NULL,
JobDesc VARCHAR(4000) 
);
--it won't let me specify MAX for varchar

CREATE TABLE Server(
Posn_id DECIMAL(12) NOT NULL,
Em_id DECIMAL(12) NOT NULL, 
Hourly_Wage DECIMAL(5,3),
PRIMARY KEY (Em_id)
);
--DROP TABLE Server;
ALTER TABLE Server 
ADD CONSTRAINT Server_em_fk FOREIGN KEY (Em_id) REFERENCES Employee(Em_id);
ALTER TABLE Server 
ADD CONSTRAINT Server_pos_fk FOREIGN KEY (Posn_id) REFERENCES Job_Desc(Posn_id);

--SELECT * FROM Server; 

CREATE TABLE Manager(
Posn_id DECIMAL(12) NOT NULL,
Em_id DECIMAL(12) NOT NULL, 
Hourly_Wage DECIMAL(5,3),
PRIMARY KEY(Em_id)
);

ALTER TABLE Manager 
ADD CONSTRAINT Mgmt_em_fk FOREIGN KEY (Em_id) REFERENCES Employee(Em_id);
ALTER TABLE Manager
ADD CONSTRAINT Mgmt_pos_fk FOREIGN KEY (Posn_id) REFERENCES Job_Desc(Posn_id);

--SELECT * FROM Manager; 

CREATE TABLE Accountant(
Posn_id DECIMAL(12) NOT NULL,
Em_id DECIMAL(12) NOT NULL, 
Hourly_Wage DECIMAL(5,3),
PRIMARY KEY (Em_id)
);
ALTER TABLE Accountant
ADD CONSTRAINT Acct_em_fk FOREIGN KEY (Em_id) REFERENCES Employee(Em_id);
ALTER TABLE Accountant
ADD CONSTRAINT Acct_pos_fk FOREIGN KEY (Posn_id) REFERENCES Job_Desc(Posn_id);

CREATE TABLE Shift_Xref(
Shift_id DECIMAL(12) NOT NULL PRIMARY KEY,  
Store_id DECIMAL(12) NOT NULL, 
Em_id DECIMAL(12) NOT NULL, 
Posn_id DECIMAL(12) NOT NULL, 
Sched_date DATE NOT NULL, 
Sched_startime TIMESTAMP, 
Sched_endtime TIMESTAMP,
Tstp_in TIMESTAMP NULL, 
Tstp_out TIMESTAMP NULL
);

ALTER TABLE Shift_Xref
ADD CONSTRAINT Shift_store_fk FOREIGN KEY (Store_id) REFERENCES Store(Store_id);
ALTER TABLE Shift_Xref 
ADD CONSTRAINT Shift_em_fk FOREIGN KEY (Em_id) REFERENCES Employee(Em_id);
ALTER TABLE Shift_Xref 
ADD CONSTRAINT Shift_posn_fk FOREIGN KEY (Posn_id) REFERENCES Job_Desc(Posn_id); 

CREATE TABLE TimeCard(
Card_id DECIMAL(12) NOT NULL, 
Em_id DECIMAL(12)NOT NULL, 
Shift_id DECIMAL(12)NOT NULL,
Start_date DATE NOT NULL,
End_date DATE NOT NULL, 
Hours_Num DECIMAL(4,2),
Hourly_Wage DECIMAL(5,3),
Total_Hrs DECIMAL(5,3),
Total_Wage DECIMAL(10,3),
Cd_Status VARCHAR(6), 
PRIMARY KEY (Card_id)
);
ALTER TABLE TimeCard 
ADD CONSTRAINT Cd_em_fk FOREIGN KEY (Em_id) REFERENCES Employee(Em_id);
ALTER TABLE TimeCard 
ADD CONSTRAINT Cd_shift_fk FOREIGN KEY (Shift_id) REFERENCES Shift_Xref(Shift_id);

CREATE TABLE Supplier(
splr_id DECIMAL(12) NOT NULL, 
splr_name VARCHAR(100) NOT NULL,
splr_ad VARCHAR(255) NOT NULL,
splr_zip DECIMAL(6) NOT NULL, 
splr_phone DECIMAL(10) NOT NULL,
splr_email VARCHAR(255) NOT NULL, 
splr_type VARCHAR(20), 
PRIMARY KEY (splr_id)
);

CREATE TABLE Dessert_splr(
splr_id DECIMAL(12) NOT NULL,
PRIMARY KEY (splr_id)
);
ALTER TABLE Dessert_splr
ADD CONSTRAINT Des_splr_fk FOREIGN KEY (splr_id) REFERENCES Supplier(splr_id);
 
CREATE TABLE Bev_splr(
splr_id DECIMAL(12) NOT NULL,
PRIMARY KEY (splr_id)
); 
AlTER TABLE Bev_splr
ADD CONSTRAINT Bev_splr_fk FOREIGN KEY (splr_id) REFERENCES Supplier(splr_id);

CREATE TABLE Product(
Prod_code DECIMAL(12) NOT NULL,
Prod_name VARCHAR(100),
Prod_desc VARCHAR(1024),
Prod_price DECIMAL(10,3), 
PRIMARY KEY (Prod_code)
);

--SELECT * FROM Product;

CREATE TABLE Pur_order(
Order_id DECIMAL(12) NOT NULL,  
Store_id DECIMAL(12) NOT NULL,
splr_id DECIMAL(12) NOT NULL,
Order_date DATE NOT NULL, 
Deliv_date DATE NULL,
Prod_total DECIMAL(12,3),
Order_tax DECIMAL(6,3),
Order_total DECIMAL(12,3),
Status VARCHAR(8) NULL, 
PRIMARY KEY (Order_id)
);

ALTER TABLE Pur_order
ADD CONSTRAINT Order_store_fk FOREIGN KEY (Store_id) REFERENCES Store(Store_id);
ALTER TABLE Pur_order
ADD CONSTRAINT Order_splr_fk FOREIGN KEY (splr_id) REFERENCES Supplier(splr_id);

CREATE TABLE Prod_order_xref(
Order_id DECIMAL(12) NOT NULL, 
Prod_Code DECIMAL(12) NOT NULL,
Prod_Qty DECIMAL(3) NOT NULL
);
--DROP TABLE Prod_order_xref;
ALTER TABLE Prod_order_xref
ADD CONSTRAINT order_x_fk FOREIGN KEY (Order_id) REFERENCES Pur_order(Order_id);
ALTER TABLE Prod_order_xref
ADD CONSTRAINT Prod_x_fk FOREIGN KEY (Prod_code) REFERENCES Product(Prod_code);

CREATE TABLE Transaction(
Trxn_id DECIMAL(12) NOT NULL, 
Store_id DECIMAL(12) NOT NULL,
Trxn_date DATE, 
Trxn_Sale DECIMAL(10,3),
Trxn_Tax DECIMAL(10,3),   
Payment DECIMAL(12,3),
Tip DECIMAL(12,3),
Ticket_Num DECIMAL(3), 
PRIMARY KEY (Trxn_id)
);
ALTER TABLE Transaction
ADD CONSTRAINT Trxn_store_fk FOREIGN KEY (Store_id) REFERENCES Store(Store_id);


CREATE TABLE Item(
Item_id DECIMAL(12) NOT NULL PRIMARY KEY,
Item_name VARCHAR(255),
Item_price DECIMAL(6,3),
Item_desc VARCHAR(1024)
);
 
CREATE TABLE Trxn_Item_Xref(
Trxn_id DECIMAL(12) NOT NULL,
Item_id DECIMAL(12) NOT NULL,
Item_qty DECIMAL(3), 
PRIMARY KEY (Trxn_id, Item_id) 
);
ALTER TABLE Trxn_Item_Xref
ADD CONSTRAINT Trxn_x_fk FOREIGN KEY (Trxn_id) REFERENCES Transaction(Trxn_id);
ALTER TABLE Trxn_Item_Xref
ADD CONSTRAINT Item_x_fk FOREIGN KEY (Item_id) REFERENCES Item(Item_id);

CREATE TABLE Cash(
Trxn_id DECIMAL(12) NOT NULL,
Paymt DECIMAL(10,3)
);
ALTER TABLE Cash
ADD CONSTRAINT Trxn_cash_fk FOREIGN KEY (Trxn_id) REFERENCES Transaction(Trxn_id);

CREATE TABLE Card(
Trxn_id DECIMAL(12) NOT NULL,
Paymt DECIMAL(10,3)
);
ALTER TABLE Card
ADD CONSTRAINT Trxn_card_fk FOREIGN KEY (Trxn_id) REFERENCES Transaction(Trxn_id);

CREATE TABLE Gift_card(
Trxn_id DECIMAL(12) NOT NULL,
Paymt DECIMAL(10,3),
Gift_num DECIMAL(5), 
PRIMARY KEY (Trxn_id, Gift_num)
);
ALTER TABLE Gift_card
ADD CONSTRAINT Trxn_gift_fk FOREIGN KEY (Trxn_id) REFERENCES Transaction(Trxn_id);

CREATE TABLE Item_price_hist(
I_change_id DECIMAL(12) NOT NULL,
Item_id DECIMAL(12) NOT NULL,
Updated_on DATE NOT NULL,
Old_price DECIMAL(6,3) NOT NULL,
New_price DECIMAL(6,3) NOT NULL,
PRIMARY KEY (I_change_id)
);
ALTER TABLE Item_price_hist 
ADD CONSTRAINT item_fk FOREIGN KEY (Item_id) REFERENCES Item(Item_id); 

CREATE TABLE Prod_price_hist(
P_change_id DECIMAL(12) NOT NULL,
Prod_code DECIMAL(12) NOT NULL,
Updated_on DATE NOT NULL,
Old_price DECIMAL(6,3) NOT NULL,
New_price DECIMAL(6,3) NOT NULL,
PRIMARY KEY (P_change_id)
);
ALTER TABLE Prod_price_hist 
ADD CONSTRAINT Prod_fk FOREIGN KEY (Prod_code) REFERENCES Product(Prod_code);

CREATE TABLE Drink(
Item_id DECIMAL(12) NOT NULL,
Prod_code DECIMAL(12) NOT NULL,
PRIMARY KEY (Item_id)
);
ALTER TABLE Drink
ADD CONSTRAINT Drink_id_fk FOREIGN KEY (Item_id) REFERENCES Item(Item_id);
ALTER TABLE Drink 
ADD CONSTRAINT Drink_Prod_id FOREIGN KEY (Prod_code) REFERENCES Product(Prod_code);

CREATE TABLE Pastry(
Item_id DECIMAL(12) NOT NULL,
Prod_code DECIMAL(12) NOT NULL,
PRIMARY KEY (Item_id)
);
ALTER TABLE Pastry
ADD CONSTRAINT Pastry_id_fk FOREIGN KEY (Item_id) REFERENCES Item(Item_id);
ALTER TABLE Pastry 
ADD CONSTRAINT Pastry_Prod_id FOREIGN KEY (Prod_code) REFERENCES Product(Prod_code);
COMMIT; 

CREATE INDEX Shift_storeIdx
ON Shift_Xref(Store_id); 
CREATE INDEX Shift_emIdx
ON Shift_Xref(Em_id);
CREATE INDEX Shift_posnIdx
ON Shift_Xref(Posn_id);
CREATE INDEX Card_EmIdx
ON TimeCard(Em_id);
CREATE UNIQUE INDEX Card_shiftIdx
ON TimeCard(Shift_id);
--CREATE UNIQUE INDEX Server_EmIdx
--ON Server(Em_id);
--CREATE UNIQUE INDEX Mgmt_EmIdx
--ON Manager(Em_id);
--CREATE UNIQUE INDEX Account_EmIdx
--ON Accountant(Em_id);
CREATE INDEX Store_orderIdx
ON Pur_order(Store_id);
CREATE INDEX Splr_orderIdx
ON Pur_order(splr_id);
--CREATE INDEX Prod_orderIdx
--ON Pur_order(Prod_code);
CREATE INDEX ProdX_prodIdx
ON Prod_order_Xref(Prod_code);
CREATE INDEX Store_TrxnIdx
ON Transaction(Store_id);
CREATE INDEX Item_TrxnxIdx
ON Trxn_Item_Xref(Item_id);
CREATE INDEX Date_TrxnIdx
ON Transaction(Trxn_date);
CREATE INDEX Fullname_Idx
ON Employee(Firstname, Lastname); 




--Populate all the tables: 



CREATE OR REPLACE PROCEDURE Add_Store(  
    --arg iterate through each argument
    store_name_arg IN VARCHAR, 
    store_ad_arg IN VARCHAR,
    store_zip_arg IN DECIMAL,
    store_phone_arg IN DECIMAL)
IS 
BEGIN 
    INSERT INTO Store (store_name, store_ad, store_zip, store_phone)
    VALUES(store_name_arg, store_ad_arg, store_zip_arg, store_phone_arg);
END; 
/

BEGIN 
    Add_Store('Ao Dai Nguyen' , '324 Nguyen Tat Thanh, TP HCM', 708140, 0168756789);
END;
/
--COMMIT; 

CREATE SEQUENCE Em_id_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE OR REPLACE PROCEDURE Add_emp(
    Em_id_arg IN DECIMAL,
    Gov_id_arg IN DECIMAL, 
    Firstname_arg IN VARCHAR,
    Lastname_arg IN VARCHAR,
    EmDOB_arg IN DATE,
    Em_ad_arg IN VARCHAR,
    Em_zip_arg IN DECIMAL, 
    Em_phone_arg IN DECIMAL,
    Em_email_arg IN VARCHAR, 
    Em_start_arg IN DATE,
    Em_end_arg IN DATE)
IS 
BEGIN 
    INSERT INTO Employee (Em_id ,Gov_id, Firstname, Lastname, EmDOB, Em_ad, Em_zip, 
                            Em_phone, Em_email, Em_start, Em_end)
    VALUES (Em_id_arg, Gov_id_arg, Firstname_arg, Lastname_arg, EmDOB_arg, Em_ad_arg, 
                            Em_zip_arg, Em_phone_arg, Em_email_arg, Em_start_arg, Em_end_arg);
END;
/
BEGIN 
    Add_emp (Em_id_seq.NEXTVAL, 123456789123, 'Ken', 'Nguyen', CAST('23-Mar-2000' AS DATE), 
                '324 Nguyen Tat Thanh TP HCM', 803948, 3974656754, 'ken@gmail.com', CAST('01-Oct-2020' AS DATE), NULL);
END;
/ 
BEGIN 
    Add_emp (Em_id_seq.NEXTVAL, 875639576534, 'Thanh', 'Tran', CAST('21-Apr-2001' AS DATE), '647 Nguyen Tat Thanh TP HCM', 803948, 9864725469, 'thanh@gmail.com', CAST('01-Oct-2020' AS DATE), NULL);
END;
/
BEGIN 
    Add_emp (Em_id_seq.NEXTVAL, 875633574534, 'Thanh', 'Le', CAST('13-Apr-1996' AS DATE), '647 Le Van Luong TP HCM', 803948, 9864726569, 'thanh_le@gmail.com', CAST('01-Oct-2020' AS DATE), NULL);
END;
/
BEGIN 
    Add_emp (Em_id_seq.NEXTVAL, 875633375542, 'Thanh', 'Tran', CAST('21-Apr-1995' AS DATE), '876 Pham Van Dong TP HCM', 809848, 1234325469, 'thanh_95@gmail.com', CAST('01-Oct-2020' AS DATE), NULL);
END;
/
BEGIN 
    Add_emp (Em_id_seq.NEXTVAL, 875633519242, 'Lien', 'Tran', CAST('19-May-1995' AS DATE), '873 Nguyen Dong TP HCM', 099848, 9876325469, 'Lien@gmail.com', CAST('01-Oct-2020' AS DATE), NULL);
END;
/
BEGIN 
    Add_emp (Em_id_seq.NEXTVAL, 870983598542, 'Loan', 'Tran', CAST('19-Jun-1995' AS DATE), '877 Nguyen Dong TP HCM', 099858, 9876327634, 'Loan@gmail.com', CAST('01-Oct-2020' AS DATE), NULL);
END;
/



CREATE SEQUENCE Posn_id_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;

INSERT INTO Job_Desc (Posn_id, Posn_name, JobDesc)
VALUES (Posn_id_seq.NEXTVAL , 'Manager', NULL);
INSERT INTO Job_Desc (Posn_id, Posn_name, JobDesc)
VALUES (Posn_id_seq.NEXTVAL , 'Server', NULL);
INSERT INTO Job_Desc (Posn_id, Posn_name, JobDesc)
VALUES (Posn_id_seq.NEXTVAL , 'Accountant', NULL);

--COMMIT; 
--SELECT * FROM Job_Desc;
INSERT INTO Server(Posn_id, Em_id, Hourly_wage)
VALUES( (SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Server'), 1 , 40.000);
INSERT INTO Server(Posn_id, Em_id, Hourly_wage)
VALUES( (SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Server'), 3 , 40.000);
INSERT INTO Server(Posn_id, Em_id, Hourly_wage)
VALUES( (SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Server'), 4 , 40.000);
INSERT INTO Server(Posn_id, Em_id, Hourly_wage)
VALUES( (SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Server'), 5 , 40.000);
INSERT INTO Server(Posn_id, Em_id, Hourly_wage)
VALUES( (SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Server'), 6 , 40.000);
--SELECT * FROM Server; 

INSERT INTO Manager(Posn_id, Em_id, Hourly_wage)
VALUES((SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Manager'), 1 , 60.000);
INSERT INTO Manager(Posn_id, Em_id, Hourly_wage)
VALUES((SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Manager'), 2 , 60.000);

INSERT INTO Accountant(Posn_id, Em_id, Hourly_wage)
VALUES((SELECT Posn_id FROM Job_Desc WHERE Posn_name = 'Accountant'), 2 , 50.000);
--COMMIT; 

CREATE SEQUENCE Shift_id_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE Car_id_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;
--DROP SEQUENCE Shift_id_seq;
-- TABLE Shift_Xref; 
CREATE OR REPLACE PROCEDURE Add_shift(
    Shift_id_arg IN DECIMAL,  
    Store_id_arg IN DECIMAL, 
    Em_id_arg IN DECIMAL, 
    Posn_id_arg IN DECIMAL, 
    Sched_date_arg IN DATE, 
    Sched_startime_arg IN TIMESTAMP, 
    Sched_endtime_arg IN TIMESTAMP,
    Tstp_in_arg IN TIMESTAMP, 
    Tstp_out_arg IN TIMESTAMP)
IS
BEGIN 
    INSERT INTO Shift_Xref(Shift_id, Store_id, Em_id, Posn_id, Sched_date, Sched_startime, 
                            Sched_endtime, Tstp_in, Tstp_out)
    VALUES(Shift_id_arg, Store_id_arg, Em_id_arg, Posn_id_arg, Sched_date_arg, Sched_startime_arg, 
            Sched_endtime_arg, Tstp_in_arg, Tstp_out_arg); 
END; 
/ 

--DROP PROCEDURE Add_time_card; 

CREATE OR REPLACE PROCEDURE Add_time_card(
    Card_id_arg IN DECIMAL,
    Shift_id_arg IN DECIMAL,  
    Em_id_arg IN DECIMAL,  
    Start_date_arg IN DATE,
    End_date_arg IN DATE,
    Hourly_Wage_arg IN DECIMAL,
    Hours_arg IN DECIMAL,
    Total_hrs_arg IN DECIMAL, 
    Total_Wage IN DECIMAL, 
    Cd_Status_arg IN VARCHAR)
IS
BEGIN 
    INSERT INTO TimeCard(Card_id, Em_id, Shift_id, Start_date, End_date, Hours_Num, 
                            Hourly_wage, Total_hrs, Total_Wage, Cd_status)
    VALUES(Card_id_arg, Shift_id_arg, Em_id_arg, Start_date_arg, End_date_arg, Hours_arg, 
            Hourly_Wage_arg, Total_hrs_arg, Total_Wage, Cd_Status_arg);
END; 
/ 

BEGIN 
    Add_shift(Shift_id_seq.NEXTVAL, 1, 1, 1, CAST('10-Oct-2020' AS DATE), 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP , NULL, NULL);
END;
/
BEGIN 
    Add_time_card(Car_id_seq.NEXTVAL,1, Shift_id_seq.CURRVAL, CAST('10-Oct-2020' AS DATE), CAST('24-Oct-2020' AS DATE), 0,60, 0, 0,  'Unpaid');  
END; 
/

BEGIN 
    Add_shift(Shift_id_seq.NEXTVAL, 1, 1, 2, CAST('10-Oct-2020' AS DATE), 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP , NULL, NULL);
END;
/
BEGIN 
    Add_time_card(Car_id_seq.NEXTVAL,1, Shift_id_seq.CURRVAL, CAST('10-Oct-2020' AS DATE), CAST('24-Oct-2020' AS DATE), 0,40, 0, 0,  'Unpaid');  
END; 
/
--COMMIT;
--SELECT* FROM Shift_Xref; 

INSERT INTO Supplier(splr_id, splr_name, splr_ad, splr_zip, splr_phone, splr_email, splr_type)
VALUES(1, 'Jen Bakery', '123 Nguyen Hoan HCM', 123456, 0987685776, 'Jen@gmail.com', 'Dessert'); 
INSERT INTO Supplier(splr_id, splr_name, splr_ad, splr_zip, splr_phone, splr_email, splr_type)
VALUES(2, 'Hoa Bakery', '4534 Nguyen Trai HCM', 974456, 0987853676, 'Hoa_Bake@gmail.com', 'Dessert'); 
INSERT INTO Supplier(splr_id, splr_name, splr_ad, splr_zip, splr_phone, splr_email, splr_type)
VALUES(3, 'Da Lat', '123 DakLak Da Lat', 986756, 6475685776, 'Da_Lat@gmail.com', 'Bev'); 

INSERT INTO Dessert_splr(splr_id)
VALUES(1); 
INSERT INTO Dessert_splr(splr_id)
VALUES(2);

INSERT INTO Bev_splr(splr_id)
VALUES(3); 
--COMMIT; 
 
CREATE SEQUENCE Prod_code_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE; 

CREATE OR REPLACE PROCEDURE Add_Product(
    Prod_code_arg IN DECIMAL,
    Prod_name_arg IN VARCHAR,
    Prod_desc_arg IN VARCHAR,
    Prod_price_arg IN DECIMAL)
IS
BEGIN
    INSERT INTO Product( Prod_code, Prod_name, Prod_desc, Prod_price)
    VALUES(Prod_code_arg, Prod_name_arg, Prod_desc_arg, Prod_price_arg);   
END; 
/ 
CREATE SEQUENCE Item_id_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE; 
--DROP PROCEDURE Add_item;
CREATE OR REPLACE PROCEDURE Add_item(
    Item_id_arg IN DECIMAL,
    Item_name_arg IN VARCHAR,
    Item_price_arg IN DECIMAL,
    Item_desc_arg IN VARCHAR)
IS 
BEGIN 
    INSERT INTO Item(Item_id, Item_name, Item_price, Item_desc)
    VALUES(Item_id_arg, Item_name_arg, Item_price_arg, Item_desc_arg);
END;
/

BEGIN 
    Add_Product(Prod_code_seq.NEXTVAL, 'Cheese cake', 'Light creamy cheese cake', 50.000);
END; 
/
BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Fluffy Cheese cake', 80, NULL);
END; 
/
INSERT INTO Pastry (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

BEGIN 
    Add_Product(Prod_code_seq.NEXTVAL, 'Green cake', 'Light creamy green tea cake', 50.000);
END; 
/
BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Fluffy Green Tea cake', 85, NULL);
END; 
/
INSERT INTO Pastry (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

BEGIN 
    Add_Product(Prod_code_seq.NEXTVAL, 'Green tea crepe cake', 'Light creamy green tea layer cake', 50.000);
END; 
/
BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Green Tea Crepe layered cake', 90, NULL);
END; 
/
INSERT INTO Pastry (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

BEGIN 
    Add_Product(Prod_code_seq.NEXTVAL, 'Moon cake', 'Fatty lotus seed cake', 60.000);
END; 
/
BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Sweet Moon cake', 80, NULL);
END; 
/
INSERT INTO Pastry (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

BEGIN 
    Add_Product(Prod_code_seq.NEXTVAL, 'Strawberry cake', 'Strawberry cream cake', 65.000);
END; 
/
BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Red berry cake', 75, NULL);
END; 
/
INSERT INTO Pastry (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

BEGIN 
    Add_Product(Prod_code_seq.NEXTVAL, 'Red bean cake', 'Chewy red bean cake', 20.000);
END; 
/
BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Mochi redbean cake', 50, NULL);
END; 
/
INSERT INTO Pastry (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

BEGIN 
    Add_Product(Prod_code_seq.NEXTVAL, 'Arabica Coffee', 'Arabica beans', 400.000);
END; 
/
BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Black Ice Coffee', 60, NULL);
END; 
/
INSERT INTO Drink (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

BEGIN
    Add_item(Item_id_seq.NEXTVAL,'Milk Ice Coffee', 70, NULL);
END; 
/
INSERT INTO Drink (Item_id, Prod_code)
VALUES(Item_id_seq.CURRVAL, Prod_code_seq.CURRVAL);

--COMMIT; 
 
--DROP SEQUENCE Item_trigger_seq; 
CREATE SEQUENCE Item_trigger_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE; 

CREATE OR REPLACE TRIGGER Price_hist_trigger
AFTER UPDATE ON Item
FOR EACH ROW
BEGIN 
    IF :OLD.Item_price <> :NEW.Item_price THEN
        INSERT INTO Item_price_hist(I_change_id, Item_id, Updated_on, Old_price, New_price)
        VALUES(Item_trigger_seq.NEXTVAL, :NEW.Item_id, TRUNC(sysdate), :OLD.Item_price, :NEW.Item_price); 
    END IF; 
END;
/
 
--UPDATE Item SET Item_price = 100 WHERE Item_id = 2; 

--SELECT * FROM Item; 

CREATE SEQUENCE Prod_trigger_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE OR REPLACE TRIGGER Prod_hist_trigger
AFTER UPDATE ON Product
FOR EACH ROW
BEGIN 
    IF :OLD.Prod_price <> :NEW.Prod_price THEN
        INSERT INTO Prod_price_hist(P_change_id, Prod_code, Updated_on, Old_price, New_price)
        VALUES(Prod_trigger_seq.NEXTVAL, :NEW.Prod_code, TRUNC(sysdate), :OLD.Prod_price, :NEW.Prod_price); 
    END IF; 
END;
/
--COMMIT;
--ROLLBACK; 
--UPDATE Product SET Prod_price = 100 WHERE Prod_code = 1; 
--DROP SEQUENCE Trxn_id_seq;
--DROP SEQUENCE Ticket_Num_seq;
--DROP TABLE Card; 
--DROP TABLE Trxn_Item_xref;
--DROP TABLE Transaction;
--DROP PROCEDURE Add_Trxn_xref; 
CREATE SEQUENCE Trxn_id_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE Ticket_Num_seq START WITH 1 INCREMENT BY 1 MAXVALUE 999 CYCLE; 

CREATE OR REPLACE PROCEDURE Add_Full_trxn(
    Trxn_id_arg IN DECIMAL, 
    Store_id_arg IN DECIMAL,
    Trxn_date_arg IN DATE, 
    Ticket_Num_arg IN DECIMAL,
    Item_id_arg IN DECIMAL,
    Item_qty_arg IN DECIMAL)
IS
BEGIN
    INSERT INTO Transaction(Trxn_id, Store_id, Trxn_date, Ticket_Num)
    VALUES(Trxn_id_arg, Store_id_arg, Trxn_date_arg, Ticket_Num_arg); 
    INSERT INTO Trxn_Item_xref(Trxn_id, Item_id, Item_Qty)
    VALUES(Trxn_id_arg, Item_id_arg, Item_qty_arg);
    UPDATE Transaction SET Trxn_sale = (SELECT Item_Qty *(SELECT Item_price FROM Item WHERE Item_id = Item_id_arg) 
                                    FROM Trxn_Item_xref WHERE Trxn_id = Trxn_id_arg) WHERE Trxn_id = Trxn_id_arg;
    UPDATE Transaction SET Trxn_Tax = (SELECT Trxn_sale *0.06 FROM Transaction WHERE Trxn_id = Trxn_id_arg) 
                                        WHERE Trxn_id = Trxn_id_arg;
    UPDATE Transaction SET Tip = (SELECT Trxn_sale *0.02 FROM Transaction WHERE Trxn_id = Trxn_id_arg) 
                                    WHERE Trxn_id = Trxn_id_arg;
    UPDATE Transaction SET Payment = (SELECT Trxn_sale + Trxn_Tax + Tip FROM Transaction WHERE Trxn_id = Trxn_id_arg) 
                                        WHERE Trxn_id = Trxn_id_arg; 
END;
/

BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('17-Aug-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 4, 2); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('18-Aug-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 1, 4); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('17-Aug-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 2, 5); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('20-Aug-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 3, 8); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('18-Aug-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 5, 5); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('1-Aug-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 4); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('13-Aug-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 7, 8); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('8-Sep-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 8, 2); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('18-Sep-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 8, 10); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('2-Sep-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 2); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('29-Sep-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 4); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('15-Sep-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 7); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('25-Sep-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 4); 
END; 
/
UPDATE ITEM SET Item_price = 60 WHERE Item_name ='Mochi redbean cake'; 
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('25-Oct-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 4); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('29-Oct-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 5); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('23-Oct-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 2); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('1-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 2); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('10-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 3); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('3-Dec-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 6, 4); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('10-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 7, 3); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('9-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 4, 3); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('3-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 8, 10); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('10-Oct-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 2, 10); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('13-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 7, 20); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('1-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 7, 23); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('3-Nov-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 8, 5); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('10-Oct-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 8, 6); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('5-Dec-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 3, 4); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('6-Dec-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 4, 4); 
END; 
/
BEGIN 
    Add_Full_trxn(Trxn_id_seq.NEXTVAL, 1, CAST('4-Dec-2020' AS DATE),Ticket_Num_seq.NEXTVAL, 5, 6); 
END; 
/
--SELECT * FROM Item_price_hist;
--SELECT * FROM Cash;
INSERT INTO Card(Trxn_id, Paymt)
VALUES(1, (SELECT Payment FROM Transaction WHERE Trxn_id = 1));
INSERT INTO Cash(Trxn_id, Paymt)
VALUES(2, (SELECT Payment FROM Transaction WHERE Trxn_id = 2));
INSERT INTO Card(Trxn_id, Paymt)
VALUES(3, (SELECT Payment FROM Transaction WHERE Trxn_id = 3));
INSERT INTO Card(Trxn_id, Paymt)
VALUES(4, (SELECT Payment FROM Transaction WHERE Trxn_id = 4));
INSERT INTO Card(Trxn_id, Paymt)
VALUES(5, (SELECT Payment FROM Transaction WHERE Trxn_id = 5));
INSERT INTO Card(Trxn_id, Paymt)
VALUES(6, (SELECT Payment FROM Transaction WHERE Trxn_id = 6));
INSERT INTO Card(Trxn_id, Paymt)
VALUES(7, (SELECT Payment FROM Transaction WHERE Trxn_id = 7));
INSERT INTO Cash(Trxn_id, Paymt)
VALUES(8, (SELECT Payment FROM Transaction WHERE Trxn_id = 8));
INSERT INTO Cash(Trxn_id, Paymt)
VALUES(9, (SELECT Payment FROM Transaction WHERE Trxn_id = 9)); 
INSERT INTO Gift_card(Trxn_id, Paymt, Gift_Num)
VALUES(10, (SELECT Payment FROM Transaction WHERE Trxn_id = 10), 1);

--COMMIT; 

CREATE SEQUENCE Order_id_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE; 
CREATE OR REPLACE PROCEDURE Add_Pur_order( -- Need to create nested subquery here to calculate total
    Order_id_arg IN DECIMAL, 
    Store_id_arg IN DECIMAL, 
    splr_id_arg IN DECIMAL,  
    Order_date_arg IN DATE, 
    Prod_Code_arg IN DECIMAL, 
    Prod_Qty_arg IN DECIMAL)
IS
BEGIN
    INSERT INTO Pur_order(Order_id, Store_id, splr_id, Order_date)
    VALUES(Order_id_arg, Store_id_arg, splr_id_arg, Order_date_arg);
    INSERT INTO Prod_order_xref(Order_id, Prod_Code, Prod_Qty)
    VALUES(Order_id_arg, Prod_Code_arg, Prod_Qty_arg);
    UPDATE Pur_order SET Prod_total = (SELECT Prod_Qty *(SELECT Prod_price FROM Product WHERE Prod_code = Prod_Code_arg) 
                                        FROM Prod_order_xref WHERE Order_id = Order_id_arg) WHERE Order_id = Order_id_arg;
    UPDATE Pur_order SET Order_tax = (SELECT Prod_total *0.03 FROM Pur_order WHERE Order_id = Order_id_arg) 
                                        WHERE Order_id = Order_id_arg;
    UPDATE Pur_order SET Order_total = (SELECT Prod_total + Order_tax FROM Pur_order WHERE Order_id = Order_id_arg) 
                                        WHERE Order_id = Order_id_arg;
END; 
/

BEGIN 
    Add_Pur_order(Order_id_seq.NEXTVAL, 1, 1, CAST('25-Aug-2020' AS DATE), 4, 60); 
END;
/
BEGIN 
    Add_Pur_order(Order_id_seq.NEXTVAL, 1, 2, CAST('25-Aug-2020' AS DATE), 3, 50); 
END;
/

UPDATE Product SET Prod_price = 55 WHERE Prod_code = 2;  

/** CHECK PROGRESS SO FAR
SELECT * FROM Manager;
SELECT * FROM Server;
SELECT * FROM Accountant;
SELECT * FROM TimeCard;
SELECT * FROM Dessert_splr;
SELECT * FROM Bev_splr;
SELECT * FROM Drink; 
SELECT * FROM Pastry;
SELECT * FROM Item;
SELECT * FROM Cash;
SELECT * FROM Card;
SELECT * FROM Gift_card;
SELECT * FROM Shift_Xref;
SELECT * FROM Pur_order;
SELECT * FROM Prod_order_xref;
SELECT * FROM Trxn_Item_Xref;
SELECT * FROM Item_price_hist; 
SELECT * FROM Prod_price_hist; 
SELECT * FROM Product;
SELECT * FROM Employee;
SELECT * FROM Job_desc;
SELECT * FROM Supplier;
SELECT * FROM Transaction;
SELECT * FROM Store;
COMMIT; 
**/
--LET"S START OPUR QUERIES:


--Which Pastry Item is the most popular ?
SELECT Item.Item_id, Item.Item_name, SUM(Trxn_Item_xref.Item_Qty) AS Qty_Sold  
FROM Trxn_Item_xref 
JOIN Item 
ON Item.Item_id = Trxn_Item_xref.Item_id
GROUP BY Item.Item_id, Item.Item_name
ORDER BY SUM(Trxn_Item_xref.Item_Qty) DESC; 
--Item Popularity Each Month?
SELECT Trxn_Item_xref.Item_id, SUM(Item_Qty), TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month
FROM Trxn_Item_xref 
JOIN Transaction
ON Trxn_Item_xref.Trxn_id = Transaction.Trxn_id
GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM'), Trxn_Item_xref.Item_id
ORDER BY TO_CHAR(Trxn_date, 'YYYY_MM'), SUM(Item_Qty) DESC;
--Item With Highest Gross_profit?
SELECT Item.Item_id, Pastry.Prod_code, Item.Item_name, (Item.Item_price - Product.Prod_price) AS Gross_profit 
FROM Item
JOIN Pastry ON Item.Item_id = Pastry.Item_id
JOIN Product ON Pastry.Prod_code = Product.Prod_code
ORDER BY Gross_profit DESC;
--What is the Monthly Sale Stats?
SELECT AVG(SUM(Trxn_sale)) AS Avg_sale, MAX(SUM(Trxn_sale)) AS Max_sale,  MIN(SUM(Trxn_sale)) AS Min_sale
FROM Transaction 
GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM'); 
--Which Months has the Best and Worst sale?
SELECT TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month, SUM(Trxn_sale) AS Monthly_sale 
FROM Transaction 
GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM')
ORDER BY Monthly_sale DESC;
-- Which Item had a Price Change?
SELECT Item_id, Updated_on 
FROM Item_price_hist; 
--Does Price Change Affect Item Popularity?
SELECT ABS ((SELECT Updated_on FROM Item_price_hist)-(SELECT MIN(Trxn_date) FROM Transaction))/(SELECT SUM(Item_Qty)  
FROM Trxn_Item_xref  
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date < (SELECT Updated_on FROM Item_price_hist))
FROM DUAL
UNION ALL
SELECT ABS ((SELECT MAX(Trxn_date) FROM Transaction)-(SELECT Updated_on FROM Item_price_hist))/(SELECT SUM(Item_Qty)
FROM Trxn_Item_xref 
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date > (SELECT Updated_on FROM Item_price_hist))
FROM DUAL;




 
/**

These are failed trials I saved it for future references.


SELECT SUM(Item_Qty)/(SELECT ABS((SELECT Updated_on FROM Item_price_hist)-(SELECT MIN(Trxn_date) FROM Transaction)) FROM DUAL) 
FROM Trxn_Item_xref 
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date < (SELECT Updated_on FROM Item_price_hist)
UNION 
SELECT SUM(Item_Qty)/(SELECT ABS((SELECT MAX(Trxn_date) FROM Transaction)-(SELECT Updated_on FROM Item_price_hist))FROM DUAL)  
FROM Trxn_Item_xref 
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date > (SELECT Updated_on FROM Item_price_hist);


CREATE UNIQUE INDEX Ser_Wage_Idx
ON Server(Posn_id, Em_id);
CREATE INDEX ProdX_orderIdx
ON Prod_order_Xref(Order_id);

CREATE INDEX Dessert_splrIdx
ON Dessert_splr(splr_id);
DROP INDEX Dessert_splrIdx;

CREATE INDEX Bev_splrIdx
ON Bev_splr(splr_id);

CREATE INDEX Trxn_TrxnxIdx
ON Trxn_Item_Xref(Trxn_id);
CREATE INDEX Cash_TrxnIdx
ON Cash(Trxn_id);
CREATE INDEX Card_TrxnIdx
ON Card(Trxn_id);
CREATE INDEX Gift_card_TrxnIdx
ON Gift_card(Trxn_id);
These were already Indexed



SELECT ABS ((SELECT Updated_on FROM Item_price_hist)-(SELECT MIN(Trxn_date) FROM Transaction))/(SELECT SUM(Item_Qty)  
FROM Trxn_Item_xref  
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date < (SELECT Updated_on FROM Item_price_hist))
FROM DUAL
UNION ALL
SELECT ABS ((SELECT MAX(Trxn_date) FROM Transaction)-(SELECT Updated_on FROM Item_price_hist))/(SELECT SUM(Item_Qty)
FROM Trxn_Item_xref 
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date > (SELECT Updated_on FROM Item_price_hist))
FROM DUAL;

SELECT ABS ((SELECT Updated_on FROM Item_price_hist)-(SELECT MIN(Trxn_date) FROM Transaction))/(SELECT SUM(Item_Qty)  
FROM Trxn_Item_xref  
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date < (SELECT Updated_on FROM Item_price_hist))
FROM DUAL;

SELECT SUM(Item_Qty)
FROM Trxn_Item_xref 
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist)  AND Trxn_date > (SELECT Updated_on FROM Item_price_hist);


SELECT MIN(Trxn_date) FROM Transaction; 
SELECT * FROM Transaction
ORDER BY Trxn_date; 











SELECT SUM(Item_Qty) AS Quantity_Sold_Before, (SELECT Trxn_date FROM Transaction 
                                                WHERE Trxn_date > (SELECT Updated_on FROM Item_price_hist)) AS Before_change
FROM Trxn_Item_xref 
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id =(SELECT Item_id FROM Item_price_hist); 

Trxn_date > (SELECT Updated_on FROM Item_price_hist) OR  Trxn_date < (SELECT Updated_on FROM Item_price_hist) 
                                                          AND Item_id =(SELECT Item_id FROM Item_price_hist);

SELECT SUM(Item_Qty) AS Total_Quantity_Sold
FROM Trxn_Item_xref 
JOIN Transaction ON Transaction.Trxn_id = Trxn_Item_xref.Trxn_id
WHERE Item_id = (SELECT Item_id FROM Item_price_hist) 
GROUP BY Trxn_date > (SELECT Updated_on FROM Item_price_hist), Trxn_date < (SELECT Updated_on FROM Item_price_hist) ;

SELECT Trxn_date FROM Transaction WHERE Trxn_date > (SELECT Updated_on FROM Item_price_hist); 

SELECT MAX(SUM(Trxn_sale)) AS Avg_sale
FROM Transaction 
GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM');

--1- What is the basic statistic for sales each month?
SELECT SUM(Trxn_sale) 
FROM Transaction
WHERE trxn_date < CAST('1-Oct-2020' AS DATE)

; 
SELECT MONTH(Trxn_date) FROM Transaction; 
select to_char(DATE_CREATED, 'YYYY-MM');

SELECT SUM(Trxn_sale) AS Highest_Revenue,

SELECT MAX (SELECT TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month, SUM(Trxn_sale) AS Monthly_sale 
                FROM Transaction 
                GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM'))
FROM Transaction
GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM');
SELECT * FROM Transaction;  

Select * 
from  (MY SELECT STATEMENT order by A desc, B) 
where ROWNUM = 1;

SELECT TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month, AVG(SUM(Trxn_sale)) FROM (SELECT SUM(Trxn_sale) AS Monthly_sale 
                                                                                    FROM Transaction 
                                                                                    GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM'));  
GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM'); 

SELECT AVG(Monthly_sale), MIN(Monthly_sale, MAX(Monthly_sale)
FROM (SELECT TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month, SUM(Trxn_sale) AS Monthly_sale 
        FROM Transaction
        GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM')); 

SELECT SELECT SUM(Trxn_sale) FROM(SELECT TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month, SUM(Trxn_sale) AS Monthly_sale 
                                                        FROM Transaction
                                                        GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM')
                                                        ORDER BY SUM(Trxn_sale) DESC;)
WHERE ROWNUM = 1;

SELECT TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month, SUM(Trxn_sale) AS Monthly_sale 
FROM Transaction
WHERE EXISTS ( SELECT SUM(Trxn_sale) AS Monthly_sale
                FROM Transaction Sale_record
                 
                
                
GROUP BY TO_CHAR(Trxn_date, 'YYYY_MM')
ORDER BY SUM(Trxn_sale) DESC
HAVING Monthly_sale = MAX(Monthly_sale);
TO_CHAR(MAX(suggested_price), '$9999.99')

--Which Pastry Item is the most popular ?





SELECT MAX(SUM(Item_Qty)),(SELECT Trxn_Item_xref.Item_id, TO_CHAR(Trxn_date, 'YYYY_MM') AS Operating_month, 
                            FROM Trxn_Item_xref AS Trxn_table 
                            JOIN Transaction
                            ON Trxn_table.Trxn_id = Transaction.Trxn_id
                            GROUP BY Trxn_Item_xref.Item_id, TO_CHAR(Trxn_date, 'YYYY_MM')) FROM Trxn_Item_xref 
                                                                                            GROUP BY Trxn_Item_xref.Item_id; 
                                        ;                             


SELECT MAX(SUM(Item_Qty)), Trxn_Item_xref.Item_id
FROM Trxn_Item_xref 
GROUP BY Trxn_Item_xref.Item_id, SUM(Item_Qty);

SELECT Trxn_Item_xref.Item_id, SUM(Item_Qty), Prod_price, Item_price 
FROM Item
JOIN Trxn_Item_xref ON Trxn_Item_xref.Item_id = Item.Item_id
JOIN Pastry ON Item.Item_id = Pastry.Item_id
JOIN Product ON Product.Prod_code = Item.Item_id
GROUP BY Trxn_Item_xref.Item_id;
/**
CREATE OR REPLACE PROCEDURE Add_Trxn_xref(
    Trxn_id_arg IN DECIMAL, 
    Item_id_arg IN DECIMAL, 
    Item_qty_arg IN DECIMAL)
IS 
BEGIN
    INSERT INTO Trxn_Item_xref(Trxn_id, Item_id, Item_Qty)
    VALUES(Trxn_id_arg, Item_id_arg, Item_qty_arg);
END;
/

BEGIN 
    Add_trxn(5, 1 ,  CAST('17-oct-2020' AS DATE), NULL, NULL, NULL, NULL, NULL, 1); 
END;
/ 

Trxn_id_seq.NEXTVAL
Ticket_Num_seq.NEXTVAL
Trxn_id_seq.CURRVAL

BEGIN 
    Add_Trxn_xref(5, 1, 4);
END;
/
UPDATE Transaction SET Trxn_sale = (SELECT Item_Qty *(SELECT Item_price FROM Item WHERE Item_id = 1) FROM Trxn_Item_xref WHERE Trxn_id = 5) WHERE Trxn_id = 5;
UPDATE Transaction SET Trxn_Tax = (SELECT Trxn_sale *0.06 FROM Trxn_Item_xref WHERE Trxn_id = 5) WHERE Trxn_id = 5;
UPDATE Transaction SET Tip = (SELECT Trxn_sale *0.02 FROM Trxn_Item_xref WHERE Trxn_id = 5) WHERE Trxn_id = 5;
UPDATE Transaction SET Payment = (SELECT Trxn_sale + Trxn_Tax + Tip FROM Transaction WHERE Trxn_id = 5) WHERE Trxn_id = 5; 

INSERT INTO Card(Trxn_id, Paymt)
VALUES(5, (SELECT Payment FROM Transaction WHERE Trxn_id = 5));
**/

/**
SELECT Transaction.Trxn_id, Item.Item_id, Trxn_Item_xref.Item_Qty, Item.Item_price
FROM Transaction
JOIN Trxn_Item_xref ON Transaction.trxn_id = Trxn_Item_xref.trxn_id
JOIN Item ON Item.Item_id = Trxn_Item_xref.Item_id;

SELECT Item_Qty *(SELECT Item_price FROM Item WHERE Item_id = 1) FROM Trxn_Item_xref WHERE Trxn_id = 4;

SELECT * FROM Transaction;

SELECT Item INDEX(1 Item_TrxnxIdx1) FROM Trxn_Item_xref;
SELECT * FROM Pur_order; 
Deliv_date_arg IN DATE, 
    Prod_total_arg IN DECIMAL, 
    Order_tax_arg IN DECIMAL, 
    Order_total_arg IN DECIMAL, 
    Status_arg IN VARCHAR
BEGIN 
    Add_Pur_order(Order_id_seq.NEXTVAL, 1, 1, CAST( '5-Oct-2020' AS DATE), NULL)  
END;
/

INSERT INTO Prod_order_xref(Order_id, Prod_Code, Prod_Qty)
VALUES(1, 1, 50); 
INSERT INTO Prod_order_xref(Order_id, Prod_Code, Prod_Qty)
VALUES(1, 2, 50);
INSERT INTO Prod_order_xref(Order_id, Prod_Code, Prod_Qty)
VALUES(1, 3, 100);
**/