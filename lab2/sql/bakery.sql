DROP TABLE IF EXISTS wickham.items;
DROP TABLE IF EXISTS wickham.receipts;

DROP TABLE IF EXISTS wickham.customers;
DROP TABLE IF EXISTS wickham.goods;

create table customers (
    CustId int primary key,
    FirstName varchar(100),
    LastName varchar(100)
);

create table goods(
    Item varchar(100) unique,
    Food varchar(100),
    Flavor varchar(100),
    Price decimal(10,2),
    Primary key (Food, Flavor)
);

create table receipts (
    ReceiptNum int primary key,
    CustId int,
    ReceiptDate date,
    foreign key (CustId) references customers(CustId)
);

Create table items (
    ReceiptNum varchar(100),
    ReceiptLine int,
    Item varchar(100),
    primary key (ReceiptNum, ReceiptLine),
    foreign key (item) references goods(Item)
);

INSERT INTO customers (CustId,LastName,FirstName) VALUES (13,'ARNN','KIP');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (16,'CRUZEN','ARIANE');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (10,'DUKELOW','CORETTA');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (5,'DUNLOW','OSVALDO');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (4,'ENGLEY','SIXTA');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (1,'LOGAN','JULIET');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (12,'MCMAHAN','MELLIE');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (6,'SLINGLAND','JOSETTE');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (14,'S\'OPKO','RAYFORD');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (7,'TOUSSAND','SHARRON');
INSERT INTO customers (CustId,LastName,FirstName) VALUES (20,'ZEME','STEPHEN');
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (11548,'2007-10-21',13);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (45873,'2007-10-05',13);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (52013,'2007-10-05',13);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (33456,'2007-10-05',16);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (86162,'2007-10-10',16);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (12396,'2007-10-10',10);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (35904,'2007-10-21',10);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (75468,'2007-10-21',10);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (43752,'2007-10-05',5);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (91192,'2007-10-10',5);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (16034,'2007-10-10',4);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (16532,'2007-10-21',4);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (66227,'2007-10-10',1);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (81517,'2007-10-10',1);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (91937,'2007-10-21',12);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (84665,'2007-10-10',6);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (87454,'2007-10-21',6);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (99994,'2007-10-21',6);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (64451,'2007-10-10',14);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (21622,'2007-10-10',7);
INSERT INTO receipts (ReceiptNum,ReceiptDate,CustId) VALUES (35011,'2007-10-10',20);

INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('45-CO','Coffee','Eclair','3.5');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-APIE-10','Apple','Pie','5.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('70-M-VA-SM-DZ','Vanilla','Meringue','1.15');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('70-W','Walnut','Cookie','0.79');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('50-ALM','Almond','Croissant','1.45');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-ALM-I','Almond','Tart','3.75');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-APP-11','Apple','Tart','3.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('46-11','Napoleon','Cake','13.49');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-BLK-PF','Blackberry','Tart','3.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('51-BLU','Blueberry','Danish','1.15');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('50-CHS','Cheese','Croissant','1.75');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('70-TU','Tuile','Cookie','1.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-BER-11','Berry','Tart','3.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('51-BC','Almond','Bear Claw','1.95');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-APR-PF','Apricot','Tart','3.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('20-CA-7.5','Casino','Cake','15.95');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('70-M-CH-DZ','Chocolate','Meringue','1.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-CHR-11','Cherry','Tart','3.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-BLU-11','Blueberry','Tart','3.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('51-APP','Apple','Danish','1.15');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('51-ATW','Almond','Twist','1.15');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('50-APP','Apple','Croissant','1.45');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('26-8x10','Truffle','Cake','15.95');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('45-CH','Chocolate','Eclair','3.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('70-R','Raspberry','Cookie','1.09');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('70-MAR','Marzipan','Cookie','1.25');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('24-8x10','Opera','Cake','15.95');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('51-APR','Apricot','Danish','1.15');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('25-STR-9','Strawberry','Cake','11.95');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('90-PEC-11','Pecan','Tart','3.75');
INSERT INTO goods (Item,Flavor,Food,Price) VALUES ('50-CH','Chocolate','Croissant','1.75');

INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (11548,1,'45-CO');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (11548,2,'90-APIE-10');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (45873,1,'70-M-VA-SM-DZ');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (52013,1,'70-W');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (52013,2,'50-ALM');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (52013,3,'90-ALM-I');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (52013,4,'90-APP-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (33456,1,'46-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (33456,2,'90-BLK-PF');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (86162,1,'51-BLU');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (86162,2,'50-ALM');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (86162,3,'50-CHS');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (86162,4,'70-TU');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (86162,5,'50-ALM');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (12396,1,'90-BER-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (12396,2,'70-M-VA-SM-DZ');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (12396,3,'51-BC');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (12396,4,'90-APR-PF');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (12396,5,'20-CA-7.5');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (35904,1,'46-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (35904,2,'90-APR-PF');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (75468,1,'70-M-CH-DZ');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (75468,2,'70-M-CH-DZ');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (75468,3,'90-CHR-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (43752,1,'90-BLU-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (91192,1,'51-APP');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (91192,2,'51-ATW');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (91192,3,'50-APP');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16034,1,'46-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16034,2,'26-8x10');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16034,3,'45-CH');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16034,4,'70-R');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16034,5,'46-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16532,1,'50-APP');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16532,2,'70-MAR');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16532,3,'70-TU');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (16532,4,'24-8x10');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (66227,1,'90-APP-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (66227,2,'90-APIE-10');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (66227,3,'70-MAR');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (66227,4,'90-BLK-PF');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (81517,1,'70-M-CH-DZ');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (81517,2,'51-ATW');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (91937,1,'51-BC');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (91937,2,'51-APR');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (84665,1,'90-BER-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (87454,1,'90-APIE-10');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (87454,2,'50-APP');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (99994,1,'25-STR-9');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (99994,2,'26-8x10');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (99994,3,'90-PEC-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (99994,4,'50-CH');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (64451,1,'90-BER-11');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (64451,2,'51-BC');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (64451,3,'24-8x10');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (64451,4,'90-BLK-PF');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (21622,1,'45-CO');
INSERT INTO items (ReceiptNum,ReceiptLine,Item) VALUES (35011,1,'50-CHS');

