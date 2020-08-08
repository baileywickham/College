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


