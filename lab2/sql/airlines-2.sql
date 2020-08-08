alter table airlines
add Partner varchar(255);


alter table airlines add constraint foreign key (Partner) references airlines(Abbreviation);

create trigger t1 before insert on airlines
for each row
begin
    declare a varchar(255);
    select airlines.Abbreviation into a from airlines where NEW.Abbreviation = airlines.Abbreviation;
    if (NEW.Partner = NEW.Abbreviation) or a != NULL then
        SIGNAL sqlstate '45000'
        SET message_text = 'Source and Dest cant be the same';
    end if;
end;


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

