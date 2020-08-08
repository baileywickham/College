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
