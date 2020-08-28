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

