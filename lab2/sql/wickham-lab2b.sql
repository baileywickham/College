-- BAKERY-1
update goods
set Price = Price - 2
where Food='Cake' and (Flavor='Napoleon' or Flavor='Truffle')

-- BAKERY-2
update goods
set Price = Price * 1.15
where (Flavor='Apricot' or Flavor='Chocolate') and (Price < 5.95)

-- BAKERY-3
drop table if exists wickham.payments;
create table payments (
    Receipt int,
    Amount decimal(10,2),
    PaymentSettled datetime,
    PaymentType varchar(100),
    primary key(Amount, PaymentSettled, PaymentType),
    foreign key (Receipt) references receipts(ReceiptNum)
);
-- BAKERY-4
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

-- AIRLINES-1
create trigger t before insert on flights
for each row
    begin
        if (NEW.SourceAirport = NEW.DestAirport) then
            SIGNAL sqlstate '45000'
            SET message_text = 'Source and Dest cant be the same';
        end if;
    end;

-- AIRLINES-2
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
        SET message_text = 'Invalid Partner';
    end if;
end;


create trigger t2 before update on airlines
for each row
begin
    declare a varchar(255);
    select airlines.Partner into a from airlines where NEW.Abbreviation = airlines.Abbreviation;
    if (NEW.Partner = NEW.Abbreviation) or a != NEW.Abbreviation then
        SIGNAL sqlstate '45000'
        SET message_text = 'Invalid Partner';
    end if;
end;



