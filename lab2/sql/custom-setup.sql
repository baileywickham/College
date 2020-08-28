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

