DROP TABLE IF EXISTS wickham.flights;
DROP TABLE IF EXISTS wickham.airlines;
DROP TABLE IF EXISTS wickham.airports

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
    PRIMARY KEY (AirportCode),
    UNIQUE(AirportName)
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


