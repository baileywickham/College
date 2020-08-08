update goods
set Price = Price - 2
where Food='Cake' and (Flavor='Napoleon' or Flavor='Truffle')
