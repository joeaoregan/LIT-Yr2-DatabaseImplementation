-- Author: Joe O'Regan
-- Student No: K00203642

USE k00203642;

DROP DATABASE ToyStore;
CREATE DATABASE ToyStore;
USE ToyStore;

-- sort so drops foreign keys
DROP TABLE IF EXISTS accountCA;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS orderstatus;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS lineitem;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS xrefseriesgenre;
DROP TABLE IF EXISTS series;

-- CONSTRAINT wishlistpk PRIMARY KEY(userid, item_id)
-- (itemid INT AUTO_INCREMENT PRIMARY KEY -- CONSTRAINT NOT NAMED
-- EXTRA MARKS FOR TABLE LEVEL CONSTRAINTS
-- case
-- comments
-- readability
-- named constraints
-- choosing appropriate data type and length

-- TABLE 1.
CREATE TABLE account (
    user_id CHAR(10) AUTO_INCREMENT,  -- CHAR INSTEAD OF INT FOR AUTO INCREMENT
    password VARCHAR(20), -- password restricted word
    first_name VARCHAR(20),
    middle_name VARCHAR(20),
    last_name VARCHAR(20),
    birthday DATE,
    gender ENUM('M', 'F'),
    email VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(20),
    state_provine VARCHAR(20),
    zip_post_code VARCHAR(10),
    country VARCHAR(20),
    phone_number INT(15),
    fax_number INT(15),
    CONSTRAINT accountpk PRIMARY KEY (user_id)
);

-- TABLE 2.
CREATE TABLE orders (
	order_id INT(10) AUTO_INCREMENT,
    user_id INT(10) AUTO_INCREMENT,
    order_date DATE,
    total_price DECIMAL(6,2),
    ship_firstname VARCHAR(20),
    ship_middlename VARCHAR(20),
    ship_lastname VARCHAR(20),
    ship_address VARCHAR(100),
    ship_city VARCHAR(20),
    ship_state_province VARCHAR(20),
    ship_zip_post_code VARCHAR(10),
    ship_country VARCHAR(20),
    courier_id VARCHAR(20),
    bill_firstname VARCHAR(20),
    bill_middlename VARCHAR(20),
    bill_lastname VARCHAR(20),
    bill_address VARCHAR(100),
    bill_city VARCHAR(20),
    bill_state_province VARCHAR(20),
    bill_zip_post_code VARCHAR(10),
    bill_country VARCHAR(20),
    credit_card VARCHAR(20),
    cc_type VARCHAR(10),
    cc_expire DATE,
    CONSTRAINT ordersPK PRIMARY KEY(order_id)
    );

-- TABLE 3.
CREATE TABLE item (
    item_id INT(10) AUTO_INCREMENT,
    procuct_id VARCHAR(20),
    listprice DECIMAL(6,2),
    unitprice DECIMAL(6,2),
    supplier_id VARCHAR(20),
    status VARCHAR(10),
    color VARCHAR(10),
    size VARCHAR (20),
    CONSTRAINT itemPK PRIMARY KEY(item_id)
    );
    
-- TABLE 4.
CREATE TABLE supplier (
	supplier_id INT(10) AUTO_INCREMENT, -- auto increment only in original
    name VARCHAR(20),
    address VARCHAR(100),
    city VARCHAR(20),
    state_province VARCHAR(20),
    zip_post_code VARCHAR(10),
    country VARCHAR(20),
    phone_number INT(10),
    fax_number INT(10),
    CONSTRAINT supplierPK PRIMARY KEY(supplier_id)
    );
    
-- Table 5.
CREATE TABLE wishlist (
	user_id INT(10),
    item_id INT(10),
    quantity INT(4),
    CONSTRAINT wishlistPK PRIMARY KEY(user_id,item_id)
    );
    
-- Table 6.
CREATE TABLE inventory (
	item_id INT(10),
    quantity INT(4),
    CONTRAINT inventoryPK PRIMARY KEY(item_id)
    );
    
-- Table 7.
CREATE TABLE orderstatus (
	order_id INT(10),
	line_num INT(2),
    timestamp TIMESTAMP,
    status VARCHAR(10),
    CONSTRAINT orderstatusPK PRIMARY KEY(order_id,line_num)
    );
    
-- Table 8.
CREATE TABLE lineitem (
	order_id INT(10),
    line_num INT(10),
    item_id INT(10),
    quantity INT(4),
    CONSTRAINT lineitemPK PRIMARY KEY(order_id)
    );
    
-- Table 9.
CREATE TABLE product (
	product_id CHAR(10),
    cat_id VARCHAR(10),
    name VARCHAR(20),
    description VARCHAR(50),
    series VARCHAR(20),
    manufacturer VARCHAR(20),
    CONSTRAINT productPK PRIMARY KEY (product_id)
    );

-- Table 10.
CREATE TABLE category (
	cat_id	CHAR(5) AUTO_INCREMENT,
    cat_name VARCHAR(20),
    parent_id VARCHAR(20),
	CONSTRAINT categoryPK PRIMARY KEY (cat_id)
    );
    
-- Table 11.
CREATE TABLE genre (
	genre VARCHAR(20),
    CONSTRAINT genrePK PRIMARY KEY (genre)
    );

-- Table 12.
CREATE TABLE xrefseriesgenre (
	series VARCHAR(20),
    genre VARCHAR(20),
    CONSTRAINT xrefseriesgenrePK PRIMARY KEY (series,genre)
    );
    
-- Table 13.
CREATE TABLE series (
	series VARCHAR(20),
    CONSTRAINT seriesPK PRIMARY KEY (series)
    );
    