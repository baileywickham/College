update goods
set Price = Price * 1.15
where (Flavor='Apricot' or Flavor='Chocolate') and (Price < 5.95)
