/***********************
*
* Author: Joe O'Regan
* Student No: K00203642
*
* Toy Store
*
* Constraint Names:	Primary Key - pk_table_name
*					Foreign Key - fk_parent_child_table_names (except for unary subcategory)
*					Unique - un_column_name (account, category, supplier)
*					Check - chk_column_name (orders)
*
************************/

DROP DATABASE IF EXISTS ToyStore;
CREATE DATABASE ToyStore;
USE ToyStore;

-- SET default_storage_engine=InnoDB; -- engine=innodb defined in each table

-- Sorted so drops child tables with foreign keys first
DROP TABLE IF EXISTS inventory;			-- References item
DROP TABLE IF EXISTS lineitem;			-- References orders, item
DROP TABLE IF EXISTS wishlist;			-- References account, item
DROP TABLE IF EXISTS item;				-- References product, supplier
DROP TABLE IF EXISTS orderstatus;		-- References orders
DROP TABLE IF EXISTS orders;			-- References account
DROP TABLE IF EXISTS product;			-- References category, series
DROP TABLE IF EXISTS xrefseriesgenre;	-- References series, genre
DROP TABLE IF EXISTS category;  		-- FK Itself
DROP TABLE IF EXISTS account;			-- No FK
DROP TABLE IF EXISTS genre;				-- No FK
DROP TABLE IF EXISTS series;			-- No FK
DROP TABLE IF EXISTS supplier;			-- No FK

-- Table 1. - account - REFERENCED by orders
CREATE TABLE account (
    user_id INT AUTO_INCREMENT,							-- Primary key
    user_name VARCHAR(32) NOT NULL,						-- Set unique at table level
    password VARCHAR(32) NOT NULL,						-- password restricted word
    first_name VARCHAR(32) NOT NULL,					-- VARCHAR - variable length string type
    middle_name VARCHAR(32) NOT NULL,
    last_name VARCHAR(32) NOT NULL,
    birthday DATE NOT NULL,
    gender ENUM('M', 'F') DEFAULT 'M',					-- enum/list
    email VARCHAR(64) NOT NULL,
    address VARCHAR(64) NOT NULL,
    city VARCHAR(32) NOT NULL,
    state_province VARCHAR(32) NOT NULL,
    zip_post_code VARCHAR(10) NOT NULL,
    country CHAR(3) NOT NULL,							-- CHAR - fixed length string type
    phone_number VARCHAR(32) NOT NULL,
    fax_number VARCHAR(32) NOT NULL,
    CONSTRAINT pk_account PRIMARY KEY (user_id),
    CONSTRAINT un_user_name UNIQUE (user_name)			-- Set user_name as named constraint unique
)
ENGINE=InnoDB;											-- TYPE=INNODB gives error

-- Table 2. - category REFERENCED by product
CREATE TABLE category (
	cat_id TINYINT AUTO_INCREMENT,						-- Primary key - product data type "very small range of integers"
    cat_name VARCHAR(64) NOT NULL,						-- Table level unique constraint
    parent_id TINYINT,									-- Foreign key -  category.cat_id (This table)
	CONSTRAINT pk_category PRIMARY KEY (cat_id),
    CONSTRAINT fk_subcategory FOREIGN KEY (parent_id) 
    REFERENCES category(cat_id) ON DELETE RESTRICT, 	-- Foreign Key references its own cat_id field for subcategory
    CONSTRAINT un_cat_name UNIQUE (cat_name)			-- Set cat_name unique
    )
ENGINE=InnoDB;

-- Table 3. - genre REFERENCED by xrefseries
CREATE TABLE genre (
	genre VARCHAR(32),									-- Primary key is unique
    CONSTRAINT pk_genre PRIMARY KEY (genre)
    )
ENGINE=InnoDB;

-- Table 4. series REFERENCED by product, xrefseriesgenre
CREATE TABLE series (
	series VARCHAR(128),								-- Primary key is not null
    CONSTRAINT pk_series PRIMARY KEY (series)
    )
ENGINE=InnoDB;

-- Table 5. supplier REFERENCED by item
CREATE TABLE supplier (
	supplier_id INT AUTO_INCREMENT, 					-- Primary key is not null
    name VARCHAR(64) NOT NULL,
    address VARCHAR(128) NOT NULL,
    city VARCHAR(32) NOT NULL,
    state_province VARCHAR(32) NOT NULL,
    zip_post_code VARCHAR(32) NOT NULL,
    country CHAR(3) NOT NULL DEFAULT 'IRE',
    phone_number VARCHAR(32) NOT NULL,					-- Table level unique constraint
    fax_number VARCHAR(32) NULL,						-- Nulls allowed
    CONSTRAINT pk_supplier PRIMARY KEY(supplier_id),
    CONSTRAINT un_phone_number UNIQUE (phone_number)
    )
ENGINE=InnoDB;
    
-- Table 6.
CREATE TABLE product (
	product_id SMALLINT,								-- Primary key is not null
    cat_id TINYINT,										-- Foreign key - category.cat_id
    name VARCHAR(128) NOT NULL,
 -- description TEXT NOT NULL,   
    description VARCHAR(1028) NOT NULL,					-- VARCHAR up to 65,535 (says 255 on handout), blob or text also usable, Length not specified with blob or text
    series VARCHAR(128) NOT NULL,						-- Foreign key - series.series
    manufacturer VARCHAR(128) NOT NULL,
 -- INDEX (cat_id),										-- On moodle "Enforcing Referential Integrity"
 -- INDEX (series),
    CONSTRAINT pk_product PRIMARY KEY (product_id),
    CONSTRAINT fk_product_category FOREIGN KEY (cat_id) 
    REFERENCES category (cat_id) ON DELETE RESTRICT,
    CONSTRAINT fk_product_series FOREIGN KEY (series) 
    REFERENCES series (series) ON DELETE RESTRICT
    )
ENGINE=InnoDB;
     
-- Table 7. item REFERENCED by inventory, lineitem
CREATE TABLE item (
    item_id INT AUTO_INCREMENT,							-- Primary key is not null
    product_id SMALLINT,								-- Foreign key - product.product_id
    listprice DECIMAL(5,2) NOT NULL,					-- expensive toy if it costs more than 999.99
    unitprice DECIMAL(5,2) NOT NULL,
    supplier_id INT NOT NULL,							-- Foreign key - supplier.supplier_id
    status ENUM('A','O','B','P','R'),
    colour VARCHAR(16) DEFAULT NULL,					-- named "color" on ERD
    size VARCHAR (16) DEFAULT NULL,
    CONSTRAINT pk_item PRIMARY KEY (item_id),
    CONSTRAINT fk_item_product FOREIGN KEY (product_id) 
    REFERENCES product (product_id) ON DELETE RESTRICT,    
    CONSTRAINT fk_item_supplier FOREIGN KEY (supplier_id) 
    REFERENCES supplier (supplier_id) ON DELETE RESTRICT
    )
ENGINE=InnoDB;
    
-- Table 8. inventory
CREATE TABLE inventory (
	item_id INT,										-- Primary key, foreign key - item.item_id
    quantity INT UNSIGNED NOT NULL,
    CONSTRAINT pk_inventory PRIMARY KEY(item_id),
    CONSTRAINT fk_inventory_item FOREIGN KEY (item_id) 
    REFERENCES item(item_id) ON DELETE RESTRICT
    )
ENGINE=InnoDB;
    

-- Table 9. orders - REFERENCED by lineitem, orderstatus
CREATE TABLE orders (
	order_id INT AUTO_INCREMENT,						-- Primary key is not null
    user_id INT NOT NULL,								-- Foreign key - account.user_id
 -- order_date TIMESTAMP DEFAULT NOW(),					-- Tried different time settings - ON UPDATE CURRENT_TIMESTAMP
 -- order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,		-- DATE, GETDATE, NOW()	
 -- order_date DATE DEFAULT NOW(),						-- Invalid default value
 --  order_date DATE DEFAULT GETDATE(),					-- GETDATE() ...said in a few places on the interweb to use this, doesn't work
    order_date DATETIME NOT NULL DEFAULT NOW(),
    total_price DECIMAL(6,2) NOT NULL,					-- 9999.99
    ship_firstname VARCHAR(32) NULL,
    ship_middlename VARCHAR(32) DEFAULT NULL,			-- NULL DEFAULT NULL seemed like a bit too many Nulls
    ship_lastname VARCHAR(32) NULL,
    ship_address VARCHAR(128) NULL,
    ship_city VARCHAR(32) NULL,
    ship_state_province VARCHAR(32) NULL,
    ship_zip_post_code VARCHAR(32) NULL,
    ship_country CHAR(3) NULL,
    courier_id VARCHAR(16) NOT NULL,					-- NOT NULL
    bill_firstname VARCHAR(32) NULL,
    bill_middlename VARCHAR(32) NULL,
    bill_lastname VARCHAR(32) NULL,
    bill_address VARCHAR(32) NULL,
    bill_city VARCHAR(32) NULL,
    bill_state_province VARCHAR(32) NULL,
    bill_zip_post_code VARCHAR(32) NULL,
    bill_country VARCHAR(32) NULL,
    credit_card CHAR(16) NOT NULL,
	-- cc_type VARCHAR(10) NOT NULL CHECK (cc_type IN ('Visa','Mastercard','AMEX')), 	-- Used table level constraint
    -- cc_type ENUM ('Visa', 'Mastercard', 'AMEX') NOT NULL, 							-- Used table level constraint
    cc_type VARCHAR(10) NOT NULL,
    cc_expire DATE NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY(order_id),
    CONSTRAINT fk_orders_account FOREIGN KEY (order_id) 
    REFERENCES account(user_id) ON DELETE RESTRICT,
    CONSTRAINT chk_cc_type CHECK (cc_type IN ('Visa','Mastercard','AMEX'))
    )
ENGINE=InnoDB;

-- Table 10.
CREATE TABLE lineitem (
	order_id INT,											-- Primary key is not null, Foreign key - orders.order_id
    line_num SMALLINT UNSIGNED,								-- Primary key is not null, unsigned = positive integer
    item_id INT NOT NULL,									-- Foreign key - item.item_id
    quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,			-- unsigned = positive integer
    CONSTRAINT pk_lineitem PRIMARY KEY (order_id,line_num),
    CONSTRAINT fk_lineitem_order FOREIGN KEY (order_id) 
    REFERENCES orders(order_id) ON DELETE RESTRICT,
    CONSTRAINT fk_lineitem_item FOREIGN KEY (item_id) 
    REFERENCES item (item_id) ON DELETE RESTRICT   
    )
ENGINE=InnoDB;
    
-- Table 11.
CREATE TABLE orderstatus (
	order_id INT,											-- not null = primary key, Foreign key orders.order_id
	line_num INT,											-- not null = primary key
 -- timestamp TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 		-- update timestamp as order processes
 -- timestamp TIMESTAMP ON UPDATE NOW(),
	timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM ('I','P','S','T') DEFAULT 'I',
    CONSTRAINT pk_orderstatus PRIMARY KEY (order_id, line_num),
    CONSTRAINT fk_orderstatus_orders FOREIGN KEY (order_id) 
    REFERENCES orders (order_id) ON DELETE RESTRICT
    )
ENGINE=InnoDB;   
     
-- Table 12.
CREATE TABLE xrefseriesgenre (
	series VARCHAR(128),									-- Primary key is not null, foreign key - series.series
    genre VARCHAR(32),										-- Primary key is not null, foreign key - genre.genre
    CONSTRAINT pk_xrefseriesgenre PRIMARY KEY (series, genre),
    CONSTRAINT fk_xref_series FOREIGN KEY (series) 
    REFERENCES series (series) ON DELETE RESTRICT,
    CONSTRAINT fk_xref_genre FOREIGN KEY (genre) 
    REFERENCES genre (genre) ON DELETE RESTRICT
    )
ENGINE=InnoDB;
    
-- Table 13.
CREATE TABLE wishlist (
	user_id INT,											-- Primary key, foreign key - account.user_id
    item_id INT,											-- Primary key, foreign key - item.item_id
    quantity SMALLINT UNSIGNED NOT NULL,					-- Copied data type from quantity column of lineitem, inventory 
    CONSTRAINT pk_wishlist PRIMARY KEY (user_id, item_id),
    CONSTRAINT fk_wishlist_account FOREIGN KEY (user_id) 
    REFERENCES account (user_id) ON DELETE RESTRICT,
    CONSTRAINT fk_wishlist_item FOREIGN KEY (item_id) 
    REFERENCES item (item_id) ON DELETE RESTRICT
    )
ENGINE=InnoDB;

DESC account;
DESC category;
DESC genre;
DESC item;
DESC inventory;
DESC lineitem;
DESC orders;
DESC orderstatus;
DESC product;
DESC series;
DESC supplier;
DESC wishlist;
DESC xrefseriesgenre;