*****************************************************
CPE 365                 Alex Dekhtyar / Andrew Migler
Cal Poly		  Computer Science Department
San Luis Obispo                College of Engineering 
California            dekhtyar / avondoll@calpoly.edu   
*****************************************************
		  BAKERY DATASET
                   Version 1.1 (flat)
                    July 2020
*****************************************************
Sources:  this is a synthesized dataset. 

******************************************************

This file describes the contents of the unnormalized 
BAKERY dataset developed for the CPE 365, 
Introduction to Databases, course at Cal Poly.

The dataset contains information about one month worth
of sales information for a small bakery shop. The sales
are made to known customers. The dataset contains
information about the customers, an assortment of
baked goods offered for sale and the purchases made.

  The dataset consists of a single file:

   - BAKERY.data.csv : combined sales, customer, and item information


  ReceiptNum: receipt number 
 ReceiptDate: date of the purchase
      CustId: unique identifier of the customer
    LastName: last name of the customer
   FirstName: first name of the customer
 ReceiptLine: position of the purchased item on the
              receipt. (i.e., first purchased item,
              second purchased item, etc...)
        Item: unique identifier of the baked good
      Flavor: flavor/type of the good (e.g., "chocolate", "lemon")
        Food: category of the good (e.g., "cake", "tart")
       Price: item price (in dollars) 


**************************************************************************
**************************************************************************

Permission granted to use and distribute this dataset in its current form, 
provided this file  is kept unchanged and is distributed together with the 
data.

Permission granted to modify and expand this dataset, provided this
file is updated accordingly with new information.

**************************************************************************
**************************************************************************
