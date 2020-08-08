drop table if exists wickham.payments;
create table payments (
    Receipt int,
    Amount decimal(10,2),
    PaymentSettled datetime,
    PaymentType varchar(100),
    primary key(Amount, PaymentSettled, PaymentType),
    foreign key (Receipt) references receipts(ReceiptNum)
);
