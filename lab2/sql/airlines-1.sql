create trigger t before insert on flights
for each row
    begin
        if (NEW.SourceAirport = NEW.DestAirport) then
            SIGNAL sqlstate '45000'
            SET message_text = 'Source and Dest cant be the same';
        end if;
    end;
