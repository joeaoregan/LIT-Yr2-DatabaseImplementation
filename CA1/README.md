# Games Design and Development - Year 2
# Semester 4: Database Implementation
## Continuous Assessment Assignment 1: ToyStore ERD (MySQL)
### Joe O'Regan (K00203642)

### 01/03/2016

---

# Toy Store
## Entity Relationship Diagram


![ToyStore ERD](https://raw.githubusercontent.com/joeaoregan/Yr2-DB_Implementation_CA1/master/Screenshots/ToyStoreERD.jpg "DB Implementation: Toy Store")
###### ToyStore Entity Relationship Diagram

---

* **account:** Anyone who wants to buy something from the online toy store must have an account.
* **category:** The toy store sells products that can be divided into several categories and subcategories. For example, the Wall Art category may be further divided into the subcategories Posters and Wall Scrolls.
* **genre:** Every product may be associated with zero or more genres, such as Fantasy, Magic, and Science Fiction.
* **item:** Every product can be subdivided into one or more items. For example, a Chococat t-shirt may come in a variety of different colours such as White (for boys) and Pink (for girls). It's the same product (a Chococat t-shirt made by a certain manufacturer), but there are two items available for this product, a white t-shirt and a pink t-shirt. Also note that perhaps the t-shirt might come in different sizes, such as small, medium, large, and extra-large.
* **inventory:** A single order may have one or more items associated with it.
* **orders:** The orders table stores all completed orders submitted by account holders. Incomplete or partial order transactions are not stored in the orders table.
* **orderstatus:** Once an order is created, it has to be processed by the toy store and all line items must be packaged and arranged for shipping. In fact, all orders and line items may go through several departments such as packaging and shipping. During this processing, each line item may be in one of several states, such as I (in initial processing), P (in packaging), S (in shipping), and T (shipped and in transit).
* **product:** The product table contains general information about all of the products for sale.
* **series:** All products in our database are associated with an anime television series.
* **supplier:** A supplier is a person or company that provides our toy store with toys. Rarely does a store deal directly with the toy manufacturer. Instead, a store usually deals with a supplier who is able to order toys in heavy bulk directly from the manufacturer.
* **xrefseriesgenre:** Every anime series may be associated with multiple genres.

---

# Assignment 2016 Instructions

You are to create a .sql script file that will created the online shopping Toy Store.  The logical model and metadata have been provided for you in Word file herewith.


Your file should be able to run as a script file, that is run from the command prompt with no errors.  Therefore take note that tables should be deleted before being created, tables need to be created in the right order so as not to violate referential integrity.


The code should be properly formatted with use of comments, and appropriate case used (i.e. uppercase for reserved words, lowercase for database specific words).  All constraints should be named.  Because this system is an OLTP system, ACID needs to be maintained so you need to choose and code in the appropriate engine.


80% of your marks for CA1 will be allocated to this script file.  20% is reserved for an in-class question about this case study which will be asked in-class on Tuesday 23rd Feb at 1pm.  You must be in-class that day to answer the question.


This assignment must be uploaded to Moodle by the evening of Monday 21st February.
If you are unsure about anything, say datatypes not clear, you are to make your best judgement and put in a comment about your decision.


You are not required to populate the database with test data.  You should however write all the appropriate CREATE TABLE statements, and DESC each table.