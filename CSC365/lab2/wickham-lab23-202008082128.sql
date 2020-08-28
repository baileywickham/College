-- Lab 2,3
-- wickham
-- Aug 8, 2020

USE `wickham`;
-- AIRLINES
-- Create and populate the AIRLINES database based on the description and data posted to Canvas.
/*
    DROP TABLE IF EXISTS wickham.flights;
    DROP TABLE IF EXISTS wickham.airlines;
    DROP TABLE IF EXISTS wickham.airports;
    */

CREATE TABLE airlines (
    Id INT,
    Airline VARCHAR(255) unique,
    Abbreviation VARCHAR(255) unique,
    Country CHAR(3),
    PRIMARY KEY (ID)
);
CREATE TABLE airports (
    City VARCHAR(100),
    AirportCode CHAR(3),
    AirportName VARCHAR(100),
    Country VARCHAR(100),
    CountryAbbrev VARCHAR(3),
    PRIMARY KEY (AirportCode)
);

CREATE TABLE flights (
    Airline int,
    FlightNo INT,
    SourceAirport VARCHAR(255) not null,
    DestAirport VARCHAR(255) not null,
    primary key (FlightNo, Airline),
    foreign key (Airline) references airlines (Id),
    foreign key (SourceAirport) references airports (AirportCode),
    foreign key (DestAirport) references airports (AirportCode)
);

INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (1,'United Airlines','UAL','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (2,'US Airways','USAir','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (3,'Delta Airlines','Delta','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (4,'Southwest Airlines','Southwest','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (5,'American Airlines','American','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (6,'Northwest Airlines','Northwest','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (7,'Continental Airlines','Continental','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (8,'JetBlue Airways','JetBlue','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (9,'Frontier Airlines','Frontier','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (10,'AirTran Airways','AirTran','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (11,'Allegiant Air','Allegiant','USA');
INSERT INTO airlines (Id, Airline, Abbreviation, Country) VALUES (12,'Virgin America','Virgin','USA');

INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Aberdeen','APG','Phillips AAF','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Aberdeen','ABR','Municipal','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Abilene','DYS','Dyess AFB','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Abilene','ABI','Municipal','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Abingdon','VJI','Virginia Highlands','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Ada','ADT','Ada','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Adak Island','ADK','Adak Island Ns','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Adrian','ADG','Lenawee County','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Afton','AFO','Municipal','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Aiken','AIK','Municipal','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Ainsworth','ANW','Ainsworth','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Akhiok','AKK','Akhiok SPB','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Akiachak','KKI','Spb','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Akiak','AKI','Akiak','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Akron CO','AKO','Colorado Plains Regional Airport','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Akron/Canton OH','CAK','Akron/canton Regional','United States','US');
INSERT INTO airports (City, AirportCode, AirportName, Country, CountryAbbrev  ) VALUES ('Akron/Canton','AKC','Fulton International','United States','US');

INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (1,'28','APG','ABR');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (1,'29','AIK','ADT');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (1,'44','AKO','AKI');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (1,'45','CAK','APG');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (1,'54','AFO','AKO');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (3,'2','AIK','ADT');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (3,'3','DYS','ABI');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (3,'26','AKK','VJI');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (9,'1260','AKO','AKC');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (9,'1261','APG','ABR');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (9,'1286','ABR','APG');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (9,'1287','DYS','ANW');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (10,'6','KKI','AKC');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (10,'7','VJI','APG');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (10,'54','ADT','APG');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (6,'4','AIK','AKO');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (6,'5','CAK','APG');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (6,'28','AKO','ABI');
INSERT INTO flights (Airline,  FlightNo,  SourceAirport,  DestAirport) VALUES (6,'29','ABR','ABI');


USE `wickham`;
-- KATZENJAMMER
-- Create and populate the KATZENJAMMER database
DROP TABLE IF EXISTS wickham.Tracklists;
DROP TABLE IF EXISTS wickham.Albums;
DROP TABLE IF EXISTS wickham.Instruments;
DROP TABLE IF EXISTS wickham.Vocals;
DROP TABLE IF EXISTS wickham.Performance;
DROP TABLE IF EXISTS wickham.Band;
DROP TABLE IF EXISTS wickham.Songs;

create table Songs (
    SongId int primary key,
    Title varchar(100)
);

CREATE TABLE Albums(
    Aid int primary key,
    Title varchar(100),
    Year int,
    Label varchar(100),
    Type varchar(100)
);

CREATE TABLE Band(
    Id int primary key,
    Firstname varchar(100),
    Lastname varchar(100)
);

create table Instruments (
    SongId int,
    BandmateId int,
    Instrument varchar(100),
    primary key (SongId, BandmateId, Instrument),
    foreign key (SongId) references Songs(SongId),
    foreign key (BandmateId) references Band(Id)
);

create table Performance (
    SongId int,
    Bandmate int,
    StagePosition varchar(100),
    primary key (songId, Bandmate),
    foreign key (SongId) references Songs(SongId),
    foreign key (Bandmate) references Band(Id)
);


create table Tracklists(
    AlbumId int,
    Position int,
    SongId int,
    foreign key (SongId) references Songs(SongId),
    foreign key (AlbumId) references Albums(Aid)
);

create table Vocals (
    SongId int,
    Bandmate int,
    Type varchar(100),
    foreign key (SongId) references Songs(SongId),
    foreign key (Bandmate) references Band(Id)
);

INSERT INTO Songs (SongId,Title) VALUES (1,'Overture');
INSERT INTO Songs (SongId,Title) VALUES (2,'A Bar In Amsterdam');
INSERT INTO Songs (SongId,Title) VALUES (3,'Demon Kitty Rag');
INSERT INTO Songs (SongId,Title) VALUES (4,'Tea With Cinnamon');
INSERT INTO Songs (SongId,Title) VALUES (5,'Hey Ho on the Devil\'s Back');
INSERT INTO Songs (SongId,Title) VALUES (6,'Wading in Deeper');
INSERT INTO Songs (SongId,Title) VALUES (7,'Le Pop');
INSERT INTO Songs (SongId,Title) VALUES (8,'Der Kapitan');
INSERT INTO Songs (SongId,Title) VALUES (9,'Virginia Clemm');
INSERT INTO Songs (SongId,Title) VALUES (10,'Play My Darling,  Play');
INSERT INTO Songs (SongId,Title) VALUES (11,'To the Sea');
INSERT INTO Songs (SongId,Title) VALUES (12,'Mother Superior');
INSERT INTO Songs (SongId,Title) VALUES (13,'Aint no Thang');
INSERT INTO Songs (SongId,Title) VALUES (14,'A Kiss Before You Go');
INSERT INTO Songs (SongId,Title) VALUES (15,'I Will Dance (When I Walk Away)');
INSERT INTO Songs (SongId,Title) VALUES (16,'Cherry Pie');
INSERT INTO Songs (SongId,Title) VALUES (17,'Land of Confusion');
INSERT INTO Songs (SongId,Title) VALUES (18,'Lady Marlene');
INSERT INTO Songs (SongId,Title) VALUES (19,'Rock-Paper-Scissors');
INSERT INTO Songs (SongId,Title) VALUES (20,'Cocktails and Ruby Slippers');
INSERT INTO Songs (SongId,Title) VALUES (21,'Soviet Trumpeter');
INSERT INTO Songs (SongId,Title) VALUES (22,'Loathsome M');
INSERT INTO Songs (SongId,Title) VALUES (23,'Shepherds Song');
INSERT INTO Songs (SongId,Title) VALUES (24,'Gypsy Flee');
INSERT INTO Songs (SongId,Title) VALUES (25,'Gods Great Dust Storm');
INSERT INTO Songs (SongId,Title) VALUES (26,'Ouch');
INSERT INTO Songs (SongId,Title) VALUES (27,'Listening to the World');
INSERT INTO Songs (SongId,Title) VALUES (28,'Johnny Blowtorch');
INSERT INTO Songs (SongId,Title) VALUES (29,'Flash');
INSERT INTO Songs (SongId,Title) VALUES (30,'Driving After You');
INSERT INTO Songs (SongId,Title) VALUES (31,'My Own Tune');
INSERT INTO Songs (SongId,Title) VALUES (32,'Badlands');
INSERT INTO Songs (SongId,Title) VALUES (33,'Old De Spain');
INSERT INTO Songs (SongId,Title) VALUES (34,'Oh My God');
INSERT INTO Songs (SongId,Title) VALUES (35,'Lady Gray');
INSERT INTO Songs (SongId,Title) VALUES (36,'Shine Like Neon Rays');
INSERT INTO Songs (SongId,Title) VALUES (37,'Flash in the Dark');
INSERT INTO Songs (SongId,Title) VALUES (38,'My Dear');
INSERT INTO Songs (SongId,Title) VALUES (39,'Bad Girl');
INSERT INTO Songs (SongId,Title) VALUES (40,'Rockland');
INSERT INTO Songs (SongId,Title) VALUES (41,'Curvaceous Needs');
INSERT INTO Songs (SongId,Title) VALUES (42,'Borka');
INSERT INTO Songs (SongId,Title) VALUES (43,'Let it Snow');
INSERT INTO Band (Id,Firstname,Lastname) VALUES (1,'Solveig','Heilo');
INSERT INTO Band (Id,Firstname,Lastname) VALUES (2,'Marianne','Sveen');
INSERT INTO Band (Id,Firstname,Lastname) VALUES (3,'Anne-Marit','Bergheim');
INSERT INTO Band (Id,Firstname,Lastname) VALUES (4,'Turid','Jorgensen');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (1,1,'back');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (1,2,'left');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (1,3,'center');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (1,4,'right');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (2,1,'center');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (2,2,'back');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (2,3,'left');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (2,4,'right');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (3,1,'back');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (3,2,'right');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (3,3,'center');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (3,4,'left');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (4,1,'back');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (4,2,'center');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (4,3,'left');
INSERT INTO Performance (SongId,Bandmate,StagePosition) VALUES (4,4,'right');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (2,1,'lead');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (2,3,'chorus');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (2,4,'chorus');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (3,2,'lead');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (4,1,'chorus');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (4,2,'lead');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (4,3,'chorus');
INSERT INTO Vocals (SongId,Bandmate,Type) VALUES (4,4,'chorus');

INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (1,1,'trumpet');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (1,2,'keyboard');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (1,3,'accordion');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (1,4,'bass balalaika');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (2,1,'trumpet');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (2,2,'drums');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (2,3,'guitar');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (2,4,'bass balalaika');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (3,1,'drums');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (3,1,'ukulele');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (3,2,'banjo');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (3,3,'bass balalaika');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (3,4,'keyboards');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (4,1,'drums');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (4,2,'ukulele');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (4,3,'accordion');
INSERT INTO Instruments (SongId,BandmateId,Instrument) VALUES (4,4,'bass balalaika');
INSERT INTO Albums (AId,Title,Year,Label,Type) VALUES (1,'Le Pop',2008,'Propeller Recordings','Studio');
INSERT INTO Albums (AId,Title,Year,Label,Type) VALUES (2,'A Kiss Before You Go',2011,'Propeller Recordings','Studio');
INSERT INTO Albums (AId,Title,Year,Label,Type) VALUES (3,'A Kiss Before You Go: Live in Hamburg',2012,'Universal Music Group','Live');
INSERT INTO Albums (AId,Title,Year,Label,Type) VALUES (4,'Rockland',2015,'Propeller Recordings','Studio');
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,2,2);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,3,3);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,4,4);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,5,5);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,6,6);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,7,7);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,8,8);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,9,9);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,10,10);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,11,11);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,12,12);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (1,13,13);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,1,14);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,2,15);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,3,16);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,4,17);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,5,18);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,6,19);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,7,20);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,8,21);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,9,22);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,10,23);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,11,24);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (2,12,25);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,1,14);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,2,26);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,3,3);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,4,15);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,5,11);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,6,19);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,7,18);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,8,16);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,9,12);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,10,17);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,11,22);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,12,20);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,13,2);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,14,5);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,15,8);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,16,7);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,17,25);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,18,13);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (3,19,24);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,1,33);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,2,41);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,3,34);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,4,35);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,5,31);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,6,36);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,7,30);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,8,37);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,9,38);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,10,39);
INSERT INTO Tracklists (AlbumId,Position,SongId) VALUES (4,11,40);


USE `wickham`;
-- BAKERY
-- Create normalized relational tables corresponding to the BAKERY dataset, populate these tables with the data provided on Canvas.
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


USE `wickham`;
-- CUSTOM
-- Create and populate your custom data set. When finished, the "Check" button will mark this exercise as complete (additional validation will be performed manually)
DROP TABLE IF EXISTS wickham.locations;
DROP TABLE IF EXISTS wickham.GIS;
DROP TABLE IF EXISTS wickham.stores;

create table stores (
id int primary key
);

create table locations (
storeid int,
state varchar(100),
location varchar(100),
address varchar(100),
primary key (state, location, address),
foreign key (storeid) references stores(id)
);

create table GIS (
storeid int,
latitude varchar(100),
longitude varchar(100),
foreign key (storeid) references stores(id),
primary key (latitude, longitude)
);

INSERT INTO stores (id) VALUES (0);
INSERT INTO stores (id) VALUES (1);
INSERT INTO stores (id) VALUES (2);
INSERT INTO stores (id) VALUES (3);
INSERT INTO stores (id) VALUES (4);
INSERT INTO stores (id) VALUES (5);
INSERT INTO stores (id) VALUES (6);
INSERT INTO stores (id) VALUES (7);
INSERT INTO stores (id) VALUES (8);
INSERT INTO stores (id) VALUES (9);
INSERT INTO stores (id) VALUES (10);
INSERT INTO stores (id) VALUES (11);
INSERT INTO stores (id) VALUES (12);
INSERT INTO stores (id) VALUES (13);
INSERT INTO stores (id) VALUES (14);
INSERT INTO stores (id) VALUES (15);
INSERT INTO stores (id) VALUES (16);
INSERT INTO stores (id) VALUES (17);
INSERT INTO stores (id) VALUES (18);
INSERT INTO stores (id) VALUES (19);
INSERT INTO stores (id) VALUES (20);
INSERT INTO stores (id) VALUES (21);
INSERT INTO stores (id) VALUES (22);
INSERT INTO stores (id) VALUES (23);
INSERT INTO stores (id) VALUES (24);
INSERT INTO stores (id) VALUES (25);
INSERT INTO stores (id) VALUES (26);
INSERT INTO stores (id) VALUES (27);
INSERT INTO stores (id) VALUES (28);
INSERT INTO stores (id) VALUES (29);
INSERT INTO stores (id) VALUES (30);
INSERT INTO stores (id) VALUES (31);
INSERT INTO stores (id) VALUES (32);
INSERT INTO stores (id) VALUES (33);
INSERT INTO stores (id) VALUES (34);
INSERT INTO stores (id) VALUES (35);
INSERT INTO stores (id) VALUES (36);
INSERT INTO stores (id) VALUES (37);
INSERT INTO stores (id) VALUES (38);
INSERT INTO stores (id) VALUES (39);
INSERT INTO stores (id) VALUES (40);
INSERT INTO stores (id) VALUES (41);
INSERT INTO stores (id) VALUES (42);
INSERT INTO stores (id) VALUES (43);
INSERT INTO stores (id) VALUES (44);
INSERT INTO stores (id) VALUES (45);
INSERT INTO stores (id) VALUES (46);
INSERT INTO stores (id) VALUES (47);
INSERT INTO stores (id) VALUES (48);
INSERT INTO stores (id) VALUES (49);
INSERT INTO stores (id) VALUES (50);
INSERT INTO stores (id) VALUES (51);
INSERT INTO stores (id) VALUES (52);
INSERT INTO stores (id) VALUES (53);
INSERT INTO stores (id) VALUES (54);
INSERT INTO stores (id) VALUES (55);
INSERT INTO stores (id) VALUES (56);
INSERT INTO stores (id) VALUES (57);
INSERT INTO stores (id) VALUES (58);
INSERT INTO stores (id) VALUES (59);
INSERT INTO stores (id) VALUES (60);
INSERT INTO stores (id) VALUES (61);
INSERT INTO stores (id) VALUES (62);
INSERT INTO stores (id) VALUES (63);
INSERT INTO stores (id) VALUES (64);
INSERT INTO stores (id) VALUES (65);
INSERT INTO stores (id) VALUES (66);
INSERT INTO stores (id) VALUES (67);
INSERT INTO stores (id) VALUES (68);
INSERT INTO stores (id) VALUES (69);
INSERT INTO stores (id) VALUES (70);
INSERT INTO stores (id) VALUES (71);
INSERT INTO stores (id) VALUES (72);
INSERT INTO stores (id) VALUES (73);
INSERT INTO stores (id) VALUES (74);
INSERT INTO stores (id) VALUES (75);
INSERT INTO stores (id) VALUES (76);
INSERT INTO stores (id) VALUES (77);
INSERT INTO stores (id) VALUES (78);
INSERT INTO stores (id) VALUES (79);
INSERT INTO stores (id) VALUES (80);
INSERT INTO stores (id) VALUES (81);
INSERT INTO stores (id) VALUES (82);
INSERT INTO stores (id) VALUES (83);
INSERT INTO stores (id) VALUES (84);
INSERT INTO stores (id) VALUES (85);
INSERT INTO stores (id) VALUES (86);
INSERT INTO stores (id) VALUES (87);
INSERT INTO stores (id) VALUES (88);
INSERT INTO stores (id) VALUES (89);
INSERT INTO stores (id) VALUES (90);
INSERT INTO stores (id) VALUES (91);
INSERT INTO stores (id) VALUES (92);
INSERT INTO stores (id) VALUES (93);
INSERT INTO stores (id) VALUES (94);
INSERT INTO stores (id) VALUES (95);
INSERT INTO stores (id) VALUES (96);
INSERT INTO stores (id) VALUES (97);
INSERT INTO stores (id) VALUES (98);
INSERT INTO stores (id) VALUES (99);
INSERT INTO stores (id) VALUES (100);
INSERT INTO locations (storeid, state,location,address) VALUES (0, 'Alabama','Auburn','346 W Magnolia Ave Auburn, AL 36832 US');
INSERT INTO locations (storeid, state,location,address) VALUES (1, 'Alabama','Birmingham','300 20th St S Birmingham, AL 35233 US');
INSERT INTO locations (storeid, state,location,address) VALUES (2, 'Alabama','Birmingham','3220 Morrow Rd Birmingham, AL 35235 US');
INSERT INTO locations (storeid, state,location,address) VALUES (3, 'Alabama','Birmingham','4719 Highway 280 Birmingham, AL 35242 US');
INSERT INTO locations (storeid, state,location,address) VALUES (4, 'Alabama','Cullman','1821 Cherokee Ave SW Cullman, AL 35055 US');
INSERT INTO locations (storeid, state,location,address) VALUES (5, 'Alabama','Hoover','1759 Montgomery Hwy Hoover, AL 35244 US');
INSERT INTO locations (storeid, state,location,address) VALUES (6, 'Alabama','Huntsville','5900 University Dr NW Ste D2 Huntsville, AL 35806 US');
INSERT INTO locations (storeid, state,location,address) VALUES (7, 'Alabama','Mobile','3871 Airport Blvd Mobile, AL 36608 US');
INSERT INTO locations (storeid, state,location,address) VALUES (8, 'Alabama','Mobile','7765 Airport Blvd D100 Mobile, AL 36608 US');
INSERT INTO locations (storeid, state,location,address) VALUES (9, 'Alabama','Montgomery','2560 Berryhill Rd Ste C Montgomery, AL 36117 US');
INSERT INTO locations (storeid, state,location,address) VALUES (10,'Alabama','Opelika','2125 Interstate Dr Opelika, AL 36801 US');
INSERT INTO locations (storeid, state,location,address) VALUES (11,'Alabama','Prattville','2566 Cobbs Ford Rd Prattville, AL 36066 US');
INSERT INTO locations (storeid, state,location,address) VALUES (12,'Alabama','Tuscaloosa','1203 University Blvd Tuscaloosa, AL 35401 US');
INSERT INTO locations (storeid, state,location,address) VALUES (13,'Alabama','Tuscaloosa','1800 McFarland Blvd E Ste 608 Tuscaloosa, AL 35404 US');
INSERT INTO locations (storeid, state,location,address) VALUES (14,'Alabama','Vestavia Hills','1031 Montgomery Hwy Ste 111 Vestavia Hills, AL 35216 US');
INSERT INTO locations (storeid, state,location,address) VALUES (15,'Arizona','Avondale','9925 W McDowell Rd Ste 101 Avondale, AZ 85392 US');
INSERT INTO locations (storeid, state,location,address) VALUES (16, 'Arizona','Buckeye','944 S Watson Rd Buckeye, AZ 85326 US');
INSERT INTO locations (storeid, state,location,address) VALUES (17, 'Arizona','Casa Grande','1775 E Florence Blvd Ste 1 Casa Grande, AZ 85122 US');
INSERT INTO locations (storeid, state,location,address) VALUES (18, 'Arizona','Cave Creek','5355 E Carefree Hwy Bldg E Cave Creek, AZ 85331 US');
INSERT INTO locations (storeid, state,location,address) VALUES (19, 'Arizona','Chandler','2895 S Alma School Rd Ste 1 Chandler, AZ 85286 US');
INSERT INTO locations (storeid, state,location,address) VALUES (20, 'Arizona','Chandler','3395 W Chandler Blvd Suite 1 Chandler, AZ 85226 US');
INSERT INTO locations (storeid, state,location,address) VALUES (21, 'Arizona','Chandler','890 N 54th St Ste 5 Chandler, AZ 85226 US');
INSERT INTO locations (storeid, state,location,address) VALUES (22, 'Arizona','Flagstaff','1111 S Plaza Way Flagstaff, AZ 86001 US');
INSERT INTO locations (storeid, state,location,address) VALUES (23, 'Arizona','Gilbert','1084 S Gilbert Rd Ste 104 Gilbert, AZ 85296 US');
INSERT INTO locations (storeid, state,location,address) VALUES (24, 'Arizona','Gilbert','1546 N Cooper Rd Gilbert, AZ 85233 US');
INSERT INTO locations (storeid, state,location,address) VALUES (25, 'Arizona','Gilbert','2224 E Williams Field Rd Ste 109 Gilbert, AZ 85295 US');
INSERT INTO locations (storeid, state,location,address) VALUES (26, 'Arizona','Gilbert','3757 S Gilbert Rd Ste 110 Gilbert, AZ 85297 US');
INSERT INTO locations (storeid, state,location,address) VALUES (27, 'Arizona','Glendale','20004 N 67th Ave Suite 500 Glendale, AZ 85308 US');
INSERT INTO locations (storeid, state,location,address) VALUES (28, 'Arizona','Glendale','5849 W Northern Ave Ste 500 Glendale, AZ 85301 US');
INSERT INTO locations (storeid, state,location,address) VALUES (29, 'Arizona','Glendale','5880 W Thunderbird Rd Ste 1 Glendale, AZ 85306 US');
INSERT INTO locations (storeid, state,location,address) VALUES (30, 'Arizona','Glendale','7700 W Arrowhead Towne Ctr Ste 2067 Glendale, AZ 85308 US');
INSERT INTO locations (storeid, state,location,address) VALUES (31, 'Arizona','Glendale','9410 W Hanna Ln Ste A101 Glendale, AZ 85305 US');
INSERT INTO locations (storeid, state,location,address) VALUES (32, 'Arizona','Goodyear','1560 N Litchfield Rd Goodyear, AZ 85395 US');
INSERT INTO locations (storeid, state,location,address) VALUES (33, 'Arizona','Green Valley','18725 S Nogales Hwy Green Valley, AZ 85614 US');
INSERT INTO locations (storeid, state,location,address) VALUES (34, 'Arizona','Kingman','3455 N Stockton Hill Rd Ste C Kingman, AZ 86409 US');
INSERT INTO locations (storeid, state,location,address) VALUES (35, 'Arizona','Lake Havasu City','55 Lake Havasu Ave S Ste M Lake Havasu City, AZ 86403 US');
INSERT INTO locations (storeid, state,location,address) VALUES (36, 'Arizona','Laveen','5130 W Baseline Rd Ste 105 Laveen, AZ 85339 US');
INSERT INTO locations (storeid, state,location,address) VALUES (37, 'Arizona','Marana','5940 W Arizona Pavillions Dr Ste 110 Marana, AZ 85743 US');
INSERT INTO locations (storeid, state,location,address) VALUES (38, 'Arizona','Maricopa','21423 N John Wayne Pkwy Ste 105 Maricopa, AZ 85139 US');
INSERT INTO locations (storeid, state,location,address) VALUES (39, 'Arizona','Mesa','1229 E McKellips Rd Ste 102 Mesa, AZ 85203 US');
INSERT INTO locations (storeid, state,location,address) VALUES (40, 'Arizona','Mesa','1335 S Alma School Rd Ste 105 Mesa, AZ 85210 US');
INSERT INTO locations (storeid, state,location,address) VALUES (41, 'Arizona','Mesa','1411 S Power Rd Ste 103 Mesa, AZ 85206 US');
INSERT INTO locations (storeid, state,location,address) VALUES (42, 'Arizona','Mesa','1955 S Signal Butte Rd Ste 101 Mesa, AZ 85209 US');
INSERT INTO locations (storeid, state,location,address) VALUES (43, 'Arizona','Mesa','2849 N Power Rd Ste 101 Mesa, AZ 85215 US');
INSERT INTO locations (storeid, state,location,address) VALUES (44, 'Arizona','Mesa','3440 E Baseline Rd Unit 104 Mesa, AZ 85204 US');
INSERT INTO locations (storeid, state,location,address) VALUES (45, 'Arizona','Mesa','4984 S Power Rd Ste 107 Mesa, AZ 85212 US');
INSERT INTO locations (storeid, state,location,address) VALUES (46, 'Arizona','Oro Valley','10604 N Oracle Rd Ste 101 Oro Valley, AZ 85737 US');
INSERT INTO locations (storeid, state,location,address) VALUES (47, 'Arizona','Peoria','16680 N 83rd Ave Ste 101 Peoria, AZ 85382 US');
INSERT INTO locations (storeid, state,location,address) VALUES (48, 'Arizona','Peoria','9940 W Happy Valley Pkwy Ste 1040 Peoria, AZ 85383 US');
INSERT INTO locations (storeid, state,location,address) VALUES (49, 'Arizona','Phoenix','100 E Camelback Rd 200 Phoenix, AZ 85012 US');
INSERT INTO locations (storeid, state,location,address) VALUES (50, 'Arizona','Phoenix','11 W Washington St Suite 140 Phoenix, AZ 85003 US');
INSERT INTO locations (storeid, state,location,address) VALUES (51, 'Arizona','Phoenix','1515 N 7th Ave Ste 120 Phoenix, AZ 85007 US');
INSERT INTO locations (storeid, state,location,address) VALUES (52, 'Arizona','Phoenix','1660 E Camelback Rd Ste 185 Phoenix, AZ 85016 US');
INSERT INTO locations (storeid, state,location,address) VALUES (53, 'Arizona','Phoenix','16635 N Tatum Blvd Ste 100 Phoenix, AZ 85032 US');
INSERT INTO locations (storeid, state,location,address) VALUES (54, 'Arizona','Phoenix','1818 W Bethany Home Rd Phoenix, AZ 85015 US');
INSERT INTO locations (storeid, state,location,address) VALUES (55, 'Arizona','Phoenix','21001 N Tatum Blvd Phoenix, AZ 85050 US');
INSERT INTO locations (storeid, state,location,address) VALUES (56, 'Arizona','Phoenix','2415 E Baseline Rd Ste 111 Phoenix, AZ 85042 US');
INSERT INTO locations (storeid, state,location,address) VALUES (57, 'Arizona','Phoenix','2450 W Bell Rd Ste 5 Phoenix, AZ 85023 US');
INSERT INTO locations (storeid, state,location,address) VALUES (58, 'Arizona','Phoenix','2470 W Happy Valley Rd Ste 1181 Phoenix, AZ 85085 US');
INSERT INTO locations (storeid, state,location,address) VALUES (59, 'Arizona','Phoenix','3009 W Agua Fria Fwy Ste #1 Phoenix, AZ 85027 US');

INSERT INTO locations (storeid, latitude,longitude) VALUES (0, '32.606812966051244','-85.48732833164195');
INSERT INTO locations (storeid, latitude,longitude) VALUES (1, '33.509721495414745','-86.80275567068401');
INSERT INTO locations (storeid, latitude,longitude) VALUES (2, '33.59558141391436','-86.64743684970283');
INSERT INTO locations (storeid, latitude,longitude) VALUES (3, '33.42258214624579','-86.6982794650297');
INSERT INTO locations (storeid, latitude,longitude) VALUES (4, '34.15413376734492','-86.84122007667406');
INSERT INTO locations (storeid, latitude,longitude) VALUES (5, '33.378958029568594','-86.80380210088629');
INSERT INTO locations (storeid, latitude,longitude) VALUES (6, '34.742319254429496','-86.6657204641674');
INSERT INTO locations (storeid, latitude,longitude) VALUES (7, '30.675337809949887','-88.143753929995');
INSERT INTO locations (storeid, latitude,longitude) VALUES (8, '30.68273057569605','-88.22499815689844');
INSERT INTO locations (storeid, latitude,longitude) VALUES (9, '32.35917687650774','-86.16225285227608');
INSERT INTO locations (storeid, latitude,longitude) VALUES (10,'32.616808752194316','-85.40447876717928');
INSERT INTO locations (storeid, latitude,longitude) VALUES (11, '32.459169','-86.391343');
INSERT INTO locations (storeid, latitude,longitude) VALUES (12, '33.21066866513092','-87.55362088910408');
INSERT INTO locations (storeid, latitude,longitude) VALUES (13, '33.19675499999999','-87.52704204662706');
INSERT INTO locations (storeid, latitude,longitude) VALUES (14, '33.439069161673594','-86.78828456747647');
INSERT INTO locations (storeid, latitude,longitude) VALUES (15, '33.46437705872272','-112.27319356506382');
INSERT INTO locations (storeid, latitude,longitude) VALUES (16, '33.4383084','-112.55830390000001');
INSERT INTO locations (storeid, latitude,longitude) VALUES (17, '32.8791300574308','-111.71123532758007');
INSERT INTO locations (storeid, latitude,longitude) VALUES (18, '33.7991455','-111.96608379999999');
INSERT INTO locations (storeid, latitude,longitude) VALUES (19, '33.2639222376452','-111.8572605975222');
INSERT INTO locations (storeid, latitude,longitude) VALUES (20, '33.30528109389568','-111.8999821928628');
INSERT INTO locations (storeid, latitude,longitude) VALUES (21, '33.31742039082265','-111.96882761900793');
INSERT INTO locations (storeid, latitude,longitude) VALUES (22, '35.189859999999996','-111.661643');
INSERT INTO locations (storeid, latitude,longitude) VALUES (23, '33.32988022270755','-111.79089592376448');
INSERT INTO locations (storeid, latitude,longitude) VALUES (24, '33.37792420216465','-111.80763961039871');
INSERT INTO locations (storeid, latitude,longitude) VALUES (25, '33.3081148','-111.74274140000001');
INSERT INTO locations (storeid, latitude,longitude) VALUES (26, '33.281812','-111.78891580000001');
INSERT INTO locations (storeid, latitude,longitude) VALUES (27, '33.6659131','-112.20345379999999');
INSERT INTO locations (storeid, latitude,longitude) VALUES (28, '33.5523649','-112.1856023');
INSERT INTO locations (storeid, latitude,longitude) VALUES (29, '33.61131275531313','-112.18452254968548');
INSERT INTO locations (storeid, latitude,longitude) VALUES (30, '33.64207417858354','-112.22530473871643');
INSERT INTO locations (storeid, latitude,longitude) VALUES (31, '33.535085678021716','-112.26195146901438');
INSERT INTO locations (storeid, latitude,longitude) VALUES (32, '33.463806634713315','-112.35866282944778');
INSERT INTO locations (storeid, latitude,longitude) VALUES (33, '31.909951','-110.9799733');
INSERT INTO locations (storeid, latitude,longitude) VALUES (34, '35.2241165','-114.0370087');
INSERT INTO locations (storeid, latitude,longitude) VALUES (35, '34.47479664860446','-114.34551069653816');
INSERT INTO locations (storeid, latitude,longitude) VALUES (36, '33.37927','-112.16899939999999');
INSERT INTO locations (storeid, latitude,longitude) VALUES (37, '32.354884717102536','-111.09165199846213');
INSERT INTO locations (storeid, latitude,longitude) VALUES (38, '33.0735015','-112.0428503');
INSERT INTO locations (storeid, latitude,longitude) VALUES (39, '33.451065255847375','-111.80335687153051');
INSERT INTO locations (storeid, latitude,longitude) VALUES (40, '33.38960599017438','-111.85682718956663');
INSERT INTO locations (storeid, latitude,longitude) VALUES (41, '33.3898773','-111.68393590000002');
INSERT INTO locations (storeid, latitude,longitude) VALUES (42, '33.379424818134176','-111.60094897883607');
INSERT INTO locations (storeid, latitude,longitude) VALUES (43, '33.467905312396304','-111.68346853282073');
INSERT INTO locations (storeid, latitude,longitude) VALUES (44, '33.37966761390607','-111.75581290980438');
INSERT INTO locations (storeid, latitude,longitude) VALUES (45, '33.32550687825606','-111.68759818374691');
INSERT INTO locations (storeid, latitude,longitude) VALUES (46, '32.3987337','-110.95573970000001');
INSERT INTO locations (storeid, latitude,longitude) VALUES (47, '33.63626807976065','-112.23411100604244');
INSERT INTO locations (storeid, latitude,longitude) VALUES (48, '33.711424900000004','-112.27308059999999');
INSERT INTO locations (storeid, latitude,longitude) VALUES (49, '33.5096598','-112.07167920000002');
INSERT INTO locations (storeid, latitude,longitude) VALUES (50, '33.44806055476972','-112.07445550735758');
INSERT INTO locations (storeid, latitude,longitude) VALUES (51, '33.4655983','-112.08238109999999');
INSERT INTO locations (storeid, latitude,longitude) VALUES (52, '33.51037506402035','-112.04622043510204');
INSERT INTO locations (storeid, latitude,longitude) VALUES (53, '33.63818544112361','-111.97738650921002');
INSERT INTO locations (storeid, latitude,longitude) VALUES (54, '33.524379700000004','-112.0986855');
INSERT INTO locations (storeid, latitude,longitude) VALUES (55, '33.6747533','-111.9752754');
INSERT INTO locations (storeid, latitude,longitude) VALUES (56, '33.377257168580776','-112.02987286502967');
INSERT INTO locations (storeid, latitude,longitude) VALUES (57, '33.640372836488105','-112.11227864140172');
INSERT INTO locations (storeid, latitude,longitude) VALUES (58, '33.714657','-112.1125722');
INSERT INTO locations (storeid, latitude,longitude) VALUES (59, '33.66665768531911','-112.12322165701374');
INSERT INTO locations (storeid, latitude,longitude) VALUES (60, '33.5814625','-112.1251124');


USE `wickham`;
-- BAKERY-1
-- [revised, 8/5] Using a single SQL statement, reduce the prices of *Truffle* Cake and Napoleon Cake by $2.
update goods
set Price = Price - 2
where Food='Cake' and (Flavor='Napoleon' or Flavor='Truffle');


USE `wickham`;
-- BAKERY-2
-- Using a single SQL statement, increase by 15% the price of all Apricot or Chocolate flavored items with a current price below $5.95.
update goods
set Price = Price * 1.15
where (Flavor='Apricot' or Flavor='Chocolate') and (Price < 5.95);


USE `wickham`;
-- BAKERY-3
-- Add the capability for the database to record payment information for each receipt in a new table named payments (see assignment PDF for task details)
drop table if exists wickham.payments;
create table payments (
Receipt int,
Amount decimal(10,2),
PaymentSettled datetime, 
PaymentType varchar(100),
primary key(Amount, PaymentSettled, PaymentType),
foreign key (Receipt) references receipts(ReceiptNum)
);


USE `wickham`;
-- BAKERY-4
-- Create a trigger to prevent the sale of Meringues (any flavor) and all Almond-flavored items on Saturdays and Sundays.
drop trigger if exists wickham.monday;

create trigger monday before insert on items for each row
begin
    declare disc_date DATE;
    declare food varchar(100);
    declare flavor varchar(100);
    select goods.Flavor into flavor from goods where goods.Item = NEW.Item;
    select goods.Food into food from goods where goods.Item = NEW.Item;
    select receipts.ReceiptDate into disc_date from receipts where NEW.ReceiptNum = receipts.ReceiptNum;
    if (food = 'Meringue' or flavor = 'Almond') and (DAYOFWEEK(disc_date)= 7 or DAYOFWEEK(disc_date) = 1)then
        SIGNAL sqlstate '45000'
        SET message_text = 'No sundays';
    end if;
end;


USE `wickham`;
-- AIRLINES-1
-- Flights should never have the same airport as both source and destination (see assignment PDF)
create trigger t before insert on flights
for each row
begin 
if (NEW.SourceAirport = NEW.DestAirport) then
SIGNAL sqlstate '45000'
SET message_text = 'Source and Dest cant be the same';
    end if;
end;


USE `wickham`;
-- AIRLINES-2
-- Add a "Partner" column to the airlines table to indicate optional corporate partnerships between airline companies (see assignment PDF)
create trigger t2 before update on airlines
for each row
begin 
    declare a varchar(255);
    select airlines.Partner into a from airlines where NEW.Abbreviation = airlines.Abbreviation;
    if (NEW.Partner = NEW.Abbreviation) or a != NEW.Abbreviation then
        SIGNAL sqlstate '45000'
        SET message_text = 'Source and Dest cant be the same';
    end if;
end;


