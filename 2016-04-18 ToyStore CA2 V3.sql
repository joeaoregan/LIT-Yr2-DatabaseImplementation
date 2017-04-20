DROP DATABASE toystore;
CREATE DATABASE toystore;
USE toystore;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES=0;

DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS lineitem;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS orderstatus;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS series;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS xrefseriesgenre;
DROP TABLE IF EXISTS wishlist;


CREATE TABLE category
(
 cat_id TINYINT NOT NULL AUTO_INCREMENT,
 cat_name VARCHAR(64) NOT NULL,
 parent_id TINYINT DEFAULT NULL NULL,
 CONSTRAINT pk_category PRIMARY KEY(cat_id),
 CONSTRAINT fk_parent FOREIGN KEY(parent_id) REFERENCES category(cat_id)
) Engine=InnoDB;

CREATE TABLE account
(
 user_id INT NOT NULL AUTO_INCREMENT,
 user_name VARCHAR(32) NOT NULL UNIQUE,
 password VARCHAR(32) NOT NULL,
 first_name VARCHAR(32) NOT NULL,
 middle_name VARCHAR(32) DEFAULT NULL NULL,
 last_name VARCHAR(32) NOT NULL,
 birthday DATE NOT NULL,
 gender CHAR(1) NOT NULL,
 email VARCHAR(64) NOT NULL,
 address VARCHAR(128) NOT NULL,
 city VARCHAR(32) NOT NULL,
 state_province VARCHAR(32) NOT NULL,
 zip_post_code VARCHAR(32) NOT NULL,
 country CHAR(3) NOT NULL,
 phone_number VARCHAR(32) NOT NULL,
 fax_number VARCHAR(32) NULL,
 CONSTRAINT pk_account PRIMARY KEY(user_id)
) Engine=InnoDB;

CREATE TABLE orders
(
 order_id INT NOT NULL AUTO_INCREMENT,
 user_id INT NOT NULL,
 order_date DATE NOT NULL,
 total_price REAL(10, 2) NOT NULL,
 ship_firstname VARCHAR(32) NULL,
 ship_middlename VARCHAR(32) DEFAULT NULL NULL,
 ship_lastname VARCHAR(32) NULL,
 ship_address VARCHAR(128) NULL,
 ship_city VARCHAR(32) NULL,
 ship_state_province VARCHAR(32) NULL,
 ship_zip_post_code VARCHAR(32) NULL,
 ship_country CHAR(3) NULL,
 courier VARCHAR(16) NOT NULL,
 bill_firstname VARCHAR(32) NULL,
 bill_middlename VARCHAR(32) DEFAULT NULL NULL,
 bill_lastname VARCHAR(32) NULL,
 bill_address VARCHAR(128) NULL,
 bill_city VARCHAR(32) NULL,
 bill_state_province VARCHAR(32) NULL,
 bill_zip_post_code VARCHAR(32) NULL,
 bill_country CHAR(3) NULL,
 credit_card VARCHAR(32) NOT NULL,
 cc_type VARCHAR(32) NOT NULL,
 cc_expire DATE NOT NULL,
 CONSTRAINT pk_order PRIMARY KEY(order_id),
 CONSTRAINT fk_user_id FOREIGN KEY(user_id) REFERENCES account(user_id)
) Engine=InnoDB;

CREATE TABLE orderstatus
(
 order_id INT NOT NULL,
 line_num INT NOT NULL,
 timestamp DATE NOT NULL,
 status VARCHAR(32) NOT NULL,
 CONSTRAINT pk_orderstatus PRIMARY KEY(order_id, line_num),
 CONSTRAINT fk_orderstatus_order FOREIGN KEY(order_id)
  REFERENCES orders(order_id)
) Engine=InnoDB;

CREATE TABLE genre
(
 genre VARCHAR(32) NOT NULL,
 CONSTRAINT pk_genre PRIMARY KEY(genre)
) Engine=InnoDB;

CREATE TABLE series
(
 series VARCHAR(128) NOT NULL,
 CONSTRAINT pk_series PRIMARY KEY(series)
) Engine=InnoDB;

CREATE TABLE product
(
 product_id MEDIUMINT NOT NULL AUTO_INCREMENT,
 cat_id TINYINT NOT NULL,
 name VARCHAR(128) NOT NULL,
 description VARCHAR(1028) NULL,
 series VARCHAR(128) NOT NULL,
 manufacturer VARCHAR(128) NOT NULL,
 CONSTRAINT pk_product PRIMARY KEY(product_id),
 CONSTRAINT fk_product_category FOREIGN KEY(cat_id) REFERENCES category(cat_id),
 CONSTRAINT fk_product_series FOREIGN KEY(series) REFERENCES series(series) 
) Engine=InnoDB;

CREATE TABLE xrefseriesgenre
(
 series VARCHAR(128) NOT NULL,
 genre VARCHAR(32) NOT NULL,
 CONSTRAINT pk_genrelist PRIMARY KEY(series, genre),
 CONSTRAINT fk_xrpg_series FOREIGN KEY(series) REFERENCES series(series),
 CONSTRAINT fk_xrpg_genre FOREIGN KEY(genre) REFERENCES genre(genre)
) Engine=InnoDB;

CREATE TABLE supplier
(
 supplier_id INT NOT NULL AUTO_INCREMENT,
 name VARCHAR(64) NOT NULL,
 address VARCHAR(128) NOT NULL,
 city VARCHAR(32) NOT NULL,
 state_province VARCHAR(32) NOT NULL,
 zip_post_code VARCHAR(32) NOT NULL,
 country CHAR(3) NOT NULL,
 phone_number VARCHAR(32) NOT NULL,
 fax_number VARCHAR(32) NULL,
 CONSTRAINT pk_supplier PRIMARY KEY(supplier_id)
) Engine=InnoDB;

CREATE TABLE item
(
 item_id INT NOT NULL AUTO_INCREMENT,
 product_id MEDIUMINT NOT NULL,
 listprice REAL(10, 2) NOT NULL,
 unitprice REAL(10, 2) NOT NULL,
 supplier_id INT NOT NULL,
 status VARCHAR(32) NOT NULL,
 color VARCHAR(16) NULL,
 size VARCHAR(16) NULL,
 CONSTRAINT pk_item PRIMARY KEY(item_id),
 CONSTRAINT fk_product_item FOREIGN KEY(product_id) REFERENCES product(product_id),
 CONSTRAINT fk_product_supplier FOREIGN KEY(supplier_id) REFERENCES supplier(supplier_id)
) Engine=InnoDB;

CREATE TABLE lineitem
(
 order_id INT NOT NULL,
 line_num INT NOT NULL,
 item_id INT NOT NULL,
 quantity INT NOT NULL,
 CONSTRAINT pk_lineitem PRIMARY KEY(order_id, line_num),
 CONSTRAINT fk_lineitem_order FOREIGN KEY(order_id) REFERENCES orders(order_id),
 CONSTRAINT fk_lineitem_item FOREIGN KEY(item_id) REFERENCES item(item_id)
) Engine=InnoDB;

CREATE TABLE inventory
(
 item_id INT NOT NULL,
 quantity INT NOT NULL,
 CONSTRAINT pk_inventory PRIMARY KEY(item_id),
 CONSTRAINT fk_inventory_item FOREIGN KEY(item_id) REFERENCES item(item_id)
) Engine=InnoDB;

CREATE TABLE wishlist
(
 user_id INT NOT NULL,
 item_id INT NOT NULL,
 quantity INT NOT NULL,
 CONSTRAINT pk_wishlist PRIMARY KEY(user_id, item_id),
 CONSTRAINT pk_wl_user FOREIGN KEY(user_id) REFERENCES account(user_id),
 CONSTRAINT pk_wl_item FOREIGN KEY(item_id) REFERENCES item(item_id)
) Engine=InnoDB;

--
-- CATEGORIES
--


INSERT INTO category VALUES(0, 'Apparel', NULL);
INSERT INTO category VALUES(0, 'Books', NULL);
INSERT INTO category VALUES(0, 'DVDs', NULL);
INSERT INTO category VALUES(0, 'Merchandise', NULL);
INSERT INTO category VALUES(0, 'Model Kits', NULL);
INSERT INTO category VALUES(0, 'Music', NULL);
INSERT INTO category VALUES(0, 'Toys and Figures', NULL);
INSERT INTO category VALUES(0, 'Wall Art', NULL);

--
-- SUBCATEGORIES
--


INSERT INTO category SELECT 0, 'Hats/Head Gear', (SELECT cat_id FROM category WHERE cat_name = 'Apparel');
INSERT INTO category SELECT 0, 'Jackets/Sweaters', (SELECT cat_id FROM category WHERE cat_name = 'Apparel');
INSERT INTO category SELECT 0, 'Pants', (SELECT cat_id FROM category WHERE cat_name = 'Apparel');
INSERT INTO category SELECT 0, 'T-Shirts', (SELECT cat_id FROM category WHERE cat_name = 'Apparel');
INSERT INTO category SELECT 0, 'Art Books', (SELECT cat_id FROM category WHERE cat_name = 'Books');
INSERT INTO category SELECT 0, 'Instructional', (SELECT cat_id FROM category WHERE cat_name = 'Books');
INSERT INTO category SELECT 0, 'Magazines', (SELECT cat_id FROM category WHERE cat_name = 'Books');
INSERT INTO category SELECT 0, 'Manga Books', (SELECT cat_id FROM category WHERE cat_name = 'Books');
INSERT INTO category SELECT 0, 'Manga Sets', (SELECT cat_id FROM category WHERE cat_name = 'Books');
INSERT INTO category SELECT 0, 'Novels', (SELECT cat_id FROM category WHERE cat_name = 'Books');
INSERT INTO category SELECT 0, 'Anime', (SELECT cat_id FROM category WHERE cat_name = 'DVDs');
INSERT INTO category SELECT 0, 'Box Sets', (SELECT cat_id FROM category WHERE cat_name = 'DVDs');
INSERT INTO category SELECT 0, 'Live Action', (SELECT cat_id FROM category WHERE cat_name = 'DVDs');
INSERT INTO category SELECT 0, 'Accessories', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Art Supplies', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Bags and Backpacks', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Games', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Key Chains', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Patches', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Pins and Buttons', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Wristbands', (SELECT cat_id FROM category WHERE cat_name = 'Merchandise');
INSERT INTO category SELECT 0, 'Anime Music', (SELECT cat_id FROM category WHERE cat_name = 'Music');
INSERT INTO category SELECT 0, 'Game Music', (SELECT cat_id FROM category WHERE cat_name = 'Music');
INSERT INTO category SELECT 0, 'Anime Figures', (SELECT cat_id FROM category WHERE cat_name = 'Toys and Figures');
INSERT INTO category SELECT 0, 'Other Figures', (SELECT cat_id FROM category WHERE cat_name = 'Toys and Figures');
INSERT INTO category SELECT 0, 'Plush Toys', (SELECT cat_id FROM category WHERE cat_name = 'Toys and Figures');
INSERT INTO category SELECT 0, 'Trading Figures', (SELECT cat_id FROM category WHERE cat_name = 'Toys and Figures');
INSERT INTO category SELECT 0, 'Posters', (SELECT cat_id FROM category WHERE cat_name = 'Wall Art');
INSERT INTO category SELECT 0, 'Wall Scrolls', (SELECT cat_id FROM category WHERE cat_name = 'Wall Art');

--
-- ACCOUNTS
--




INSERT INTO account VALUES(0, 'MHouse', 'frwutmtw', 'Madeline', NULL, 'House', '1986-12-07', 'F', 'MHouse@yahoo.com', '72823 Oakwood Ave', 'PENNSVILLE', 'OH', '43787', 'USA', '4287896423', NULL);
INSERT INTO account VALUES(0, 'DGordon', 'ymqfoztp', 'Dwight', NULL, 'Gordon', '1982-05-27', 'M', 'DGordon@verizon.net', '96814 Pine Creek St', 'AMELIA COURT HOU', 'VA', '23002', 'USA', '2368805578', NULL);
INSERT INTO account VALUES(0, 'MGonzalez', 'xwcbjpoo', 'Maryellen', NULL, 'Gonzalez', '1988-07-14', 'F', 'MGonzalez@hotmail.com', '14483 Baypointe Ave', 'FAIRVIEW', 'NC', '28730', 'USA', '1734748419', NULL);
INSERT INTO account VALUES(0, 'MMckinney', 'wnoqtwpp', 'Maureen', NULL, 'Mckinney', '1980-10-19', 'F', 'MMckinney@hotmail.com', '41411 Elbert Ave', 'BANKS', 'OR', '97106', 'USA', '3178533255', NULL);
INSERT INTO account VALUES(0, 'CLivingston', 'xdjbobpo', 'Cassie', NULL, 'Livingston', '1985-02-25', 'F', 'CLivingston@sbcglobal.net', '21161 Edilyn Ave', 'DWIGHT', 'IL', '60420', 'USA', '7819316218', NULL);
INSERT INTO account VALUES(0, 'FHolden', 'wqcbpyux', 'Francis', NULL, 'Holden', '1955-12-24', 'M', 'FHolden@verizon.net', '97867 Potomac Ave', 'SCOTTVILLE', 'IL', '62683', 'USA', '6432317010', NULL);
INSERT INTO account VALUES(0, 'DHudson', 'kkqhaktm', 'Deloris', NULL, 'Hudson', '1985-03-06', 'F', 'DHudson@hotmail.com', '97858 Stone View Ave', 'PECULIAR', 'MO', '64078', 'USA', '9198174451', NULL);
INSERT INTO account VALUES(0, 'BHuff', 'arwfnfsw', 'Brett', NULL, 'Huff', '1981-08-06', 'M', 'BHuff@hotmail.com', '58191 Miners Ave', 'ROCK CAVE', 'WV', '26234', 'USA', '2437851971', NULL);
INSERT INTO account VALUES(0, 'LJones', 'sfjnapuw', 'Leanna', NULL, 'Jones', '1963-03-10', 'F', 'LJones@sbcglobal.net', '47582 Shuford Ave', 'DECATUR', 'GA', '30030', 'USA', '1219123309', NULL);
INSERT INTO account VALUES(0, 'GWilson', 'gxapwuiu', 'Gabriel', NULL, 'Wilson', '1982-04-08', 'M', 'GWilson@sbcglobal.net', '41887 Leighway Ave', 'RIFLE', 'CO', '81650', 'USA', '3095918422', NULL);
INSERT INTO account VALUES(0, 'KSutton', 'jomafmmq', 'Kathy', NULL, 'Sutton', '1983-01-01', 'F', 'KSutton@hotmail.com', '51389 Braids Ave', 'FRANKLIN', 'VA', '23851', 'USA', '6263500397', NULL);
INSERT INTO account VALUES(0, 'JDay', 'erzebwze', 'James', NULL, 'Day', '1983-08-19', 'M', 'JDay@verizon.net', '92595 Wheatfield Ave', 'ARKADELPHIA', 'AR', '71923', 'USA', '8508171741', NULL);
INSERT INTO account VALUES(0, 'TConner', 'ibhbszsh', 'Tiffany', NULL, 'Conner', '1989-08-17', 'F', 'TConner@yahoo.com', '74949 Linwood Ave', 'WALKERTON', 'VA', '23177', 'USA', '9861146470', NULL);
INSERT INTO account VALUES(0, 'RIrwin', 'lhtacwib', 'Roxanne', NULL, 'Irwin', '1969-12-11', 'F', 'RIrwin@gmail.com', '71672 Rosewood Ave', 'JUNIPER HILLS', 'CA', '93553', 'USA', '7667913721', NULL);
INSERT INTO account VALUES(0, 'SWarner', 'bxyqyjiv', 'Shawna', NULL, 'Warner', '1984-05-26', 'F', 'SWarner@yahoo.com', '98363 Freeman Ave', 'SHAWNEE', 'KS', '66216', 'USA', '4892841804', NULL);
INSERT INTO account VALUES(0, 'RGibson', 'zjedxrbw', 'Ramon', NULL, 'Gibson', '1949-01-09', 'M', 'RGibson@verizon.net', '71894 Olenbrook Ave', 'MINGO', 'WV', '26294', 'USA', '1556731725', NULL);
INSERT INTO account VALUES(0, 'CChandler', 'qpeollmt', 'Christopher', NULL, 'Chandler', '1967-04-11', 'M', 'CChandler@sbcglobal.net', '23183 Coyan Ave', 'NEW PLYMOUTH', 'ID', '83655', 'USA', '6897380861', NULL);
INSERT INTO account VALUES(0, 'TSaunders', 'muqpaexw', 'Tamera', NULL, 'Saunders', '1975-06-27', 'F', 'TSaunders@verizon.net', '12524 Sanderling Ave', 'GLENDALE', 'CA', '91207', 'USA', '1867912361', NULL);
INSERT INTO account VALUES(0, 'JKim', 'qmtstmje', 'Jordan', NULL, 'Kim', '1980-09-03', 'M', 'JKim@sbcglobal.net', '77766 Brandie Ave', 'SOUR LAKE', 'TX', '77659', 'USA', '5129665364', NULL);
INSERT INTO account VALUES(0, 'LWilder', 'kumibukd', 'Lucile', NULL, 'Wilder', '1980-07-02', 'F', 'LWilder@verizon.net', '38342 County Home Ave', 'HENNEPIN', 'IL', '61327', 'USA', '8806956363', NULL);
INSERT INTO account VALUES(0, 'JBell', 'yiqnkwqw', 'Janet', NULL, 'Bell', '1987-09-03', 'F', 'JBell@yahoo.com', '15591 Bartlett Ave', 'RICHLAND', 'WA', '99352', 'USA', '3208958654', NULL);
INSERT INTO account VALUES(0, 'NFreeman', 'gdegaadt', 'Nathan', NULL, 'Freeman', '1989-03-31', 'M', 'NFreeman@gmail.com', '82324 River Ave', 'SACRAMENTO', 'CA', '95814', 'USA', '6804685831', NULL);
INSERT INTO account VALUES(0, 'MKnapp', 'ydyzwywx', 'Melva', NULL, 'Knapp', '1951-02-14', 'F', 'MKnapp@gmail.com', '44381 Williams Ave', 'SIOUX FALLS', 'SD', '57103', 'USA', '8794415703', NULL);
INSERT INTO account VALUES(0, 'GMatthews', 'cbjboonp', 'Genevieve', NULL, 'Matthews', '1983-12-03', 'F', 'GMatthews@sbcglobal.net', '27126 Glenaire Ave', 'ANAHEIM', 'CA', '92806', 'USA', '2106216515', NULL);
INSERT INTO account VALUES(0, 'HBolton', 'tigqkhff', 'Holly', NULL, 'Bolton', '1983-11-21', 'F', 'HBolton@yahoo.com', '99476 Water Willow Ave', 'ALPINE', 'TN', '38543', 'USA', '8113091166', NULL);
INSERT INTO account VALUES(0, 'SHuff', 'rxjfznvt', 'Shawn', NULL, 'Huff', '1984-03-22', 'F', 'SHuff@yahoo.com', '38951 Seckel Ave', 'ALPINE', 'AL', '35014', 'USA', '1301755783', NULL);
INSERT INTO account VALUES(0, 'JSalas', 'hypkhasg', 'Justin', NULL, 'Salas', '1982-10-26', 'M', 'JSalas@verizon.net', '58814 Parkbridge Ave', 'MONTROSE', 'MO', '64770', 'USA', '5267550903', NULL);
INSERT INTO account VALUES(0, 'DBoyd', 'dxdamkyr', 'Darrell', NULL, 'Boyd', '1985-06-03', 'M', 'DBoyd@hotmail.com', '75179 Sonnington Ave', 'SILVER STAR', 'MT', '59751', 'USA', '6381145353', NULL);
INSERT INTO account VALUES(0, 'CDalton', 'ccqgrwpi', 'Candice', NULL, 'Dalton', '1972-08-31', 'F', 'CDalton@verizon.net', '36116 Front St', 'SHARONVILLE', 'OH', '45241', 'USA', '2539950371', NULL);
INSERT INTO account VALUES(0, 'SSalinas', 'ivvwxwcm', 'Summer', NULL, 'Salinas', '1968-11-18', 'F', 'SSalinas@gmail.com', '11142 Abbey Orchard Ave', 'HETH', 'AR', '72346', 'USA', '1279334706', NULL);
INSERT INTO account VALUES(0, 'HHart', 'lcpgynlw', 'Hester', NULL, 'Hart', '1983-12-02', 'F', 'HHart@verizon.net', '19716 Blayney Ave', 'LAKE CITY', 'CA', '96115', 'USA', '3601456398', NULL);
INSERT INTO account VALUES(0, 'CMorin', 'oxrvolyd', 'Chris', NULL, 'Morin', '1988-08-12', 'M', 'CMorin@sbcglobal.net', '38537 Hansgrove Ave', 'BEAR', 'DE', '19701', 'USA', '8521684099', NULL);
INSERT INTO account VALUES(0, 'JRios', 'pbixcyqe', 'Jacqueline', NULL, 'Rios', '1981-12-09', 'F', 'JRios@yahoo.com', '96818 Hodges Ave', 'LOMA LINDA', 'CA', '92354', 'USA', '8813420791', NULL);
INSERT INTO account VALUES(0, 'MDunn', 'cwmwvvgx', 'Mario', NULL, 'Dunn', '1981-07-27', 'M', 'MDunn@sbcglobal.net', '59618 Deseret Ave', 'KENT', 'CT', '06757', 'USA', '3285925019', NULL);
INSERT INTO account VALUES(0, 'JWhitfield', 'dzoiqowh', 'Jacquelyn', NULL, 'Whitfield', '1985-04-04', 'F', 'JWhitfield@hotmail.com', '87863 Carefree Ave', 'SCOTTS', 'MI', '49088', 'USA', '5662578292', NULL);
INSERT INTO account VALUES(0, 'TBlevins', 'dhyuijoe', 'Tracy', NULL, 'Blevins', '1985-01-15', 'M', 'TBlevins@verizon.net', '13975 Clubhouse Ave', 'CLINTON', 'MT', '59825', 'USA', '7199360732', NULL);
INSERT INTO account VALUES(0, 'JDuke', 'boqpctst', 'Jaime', NULL, 'Duke', '1983-06-23', 'M', 'JDuke@yahoo.com', '73176 Kennebec Ave', 'BRIMSON', 'MN', '55602', 'USA', '4868786067', NULL);
INSERT INTO account VALUES(0, 'JSellers', 'mqhjvboj', 'Joel', NULL, 'Sellers', '1987-06-13', 'M', 'JSellers@gmail.com', '73246 Scarborough St', 'BAUXITE', 'AR', '72011', 'USA', '8016489266', NULL);
INSERT INTO account VALUES(0, 'SGay', 'lqznjyes', 'Sharron', NULL, 'Gay', '1944-03-24', 'F', 'SGay@yahoo.com', '45917 Bay Forest Ave', 'CANANDAIGUA', 'NY', '14425', 'USA', '3407518532', NULL);
INSERT INTO account VALUES(0, 'APotter', 'noaoakmh', 'Andy', NULL, 'Potter', '1965-09-02', 'M', 'APotter@sbcglobal.net', '86196 Palmer Ave', 'VILLA PARK', 'IL', '60181', 'USA', '5146189788', NULL);
INSERT INTO account VALUES(0, 'JMcknight', 'bpfjojgm', 'James', NULL, 'Mcknight', '1985-10-13', 'M', 'JMcknight@sbcglobal.net', '26314 Dubois St', 'PHILADELPHIA', 'PA', '19150', 'USA', '4617216113', NULL);
INSERT INTO account VALUES(0, 'MGonzalez1941', 'mwrcvgrl', 'Mallory', NULL, 'Gonzalez', '1983-04-22', 'F', 'MGonzalez1941@gmail.com', '43635 Big Sur Ave', 'HUNTSVILLE', 'AL', '35808', 'USA', '1027595491', NULL);
INSERT INTO account VALUES(0, 'AShort', 'kmjxopne', 'Alvin', NULL, 'Short', '1985-08-12', 'M', 'AShort@sbcglobal.net', '25711 Bandon Ave', 'ALCOA', 'TN', '37701', 'USA', '1061104268', NULL);
INSERT INTO account VALUES(0, 'GFry', 'hokokhqk', 'Gabriel', NULL, 'Fry', '1988-03-07', 'M', 'GFry@yahoo.com', '93222 Lone Tree Ave', 'LIBERTY FARMS', 'CA', '95620', 'USA', '9926556144', NULL);
INSERT INTO account VALUES(0, 'EThomas', 'ejpbdehu', 'Everett', NULL, 'Thomas', '1976-05-10', 'M', 'EThomas@sbcglobal.net', '66655 Parker St', 'OSSINEKE', 'MI', '49766', 'USA', '4493364312', NULL);
INSERT INTO account VALUES(0, 'KBarron', 'fskpoefa', 'Kevin', NULL, 'Barron', '1983-03-10', 'M', 'KBarron@sbcglobal.net', '29479 Parkgrove Ave', 'JERUSALEM', 'OH', '43747', 'USA', '8059666544', NULL);
INSERT INTO account VALUES(0, 'NTran', 'uwmesygi', 'Nathan', NULL, 'Tran', '1980-10-05', 'M', 'NTran@sbcglobal.net', '93148 Jericho Ave', 'PETERSBURG', 'IN', '47567', 'USA', '7492287448', NULL);
INSERT INTO account VALUES(0, 'ASweeney', 'xfifwlvs', 'Alyce', NULL, 'Sweeney', '1988-08-27', 'F', 'ASweeney@yahoo.com', '66286 Macbeth Ave', 'POINT LAY', 'AK', '99759', 'USA', '6979923001', NULL);
INSERT INTO account VALUES(0, 'JCastro', 'bykxoviy', 'Jose', NULL, 'Castro', '1980-03-02', 'M', 'JCastro@sbcglobal.net', '42972 Gosling St', 'SANBORN', 'MN', '56083', 'USA', '1653669927', NULL);
INSERT INTO account VALUES(0, 'BBurnett', 'zvygrqrx', 'Bruce', NULL, 'Burnett', '1981-08-31', 'M', 'BBurnett@verizon.net', '88586 Surf Ave', 'ALTON', 'TX', '78572', 'USA', '5253689773', NULL);
INSERT INTO account VALUES(0, 'LHendrix', 'togiyadi', 'Larry', NULL, 'Hendrix', '1948-08-30', 'M', 'LHendrix@gmail.com', '79277 Norma Ave', 'DENHOFF', 'ND', '58430', 'USA', '5521699203', NULL);
INSERT INTO account VALUES(0, 'LWilkins', 'ztbzkojq', 'Luz', NULL, 'Wilkins', '1980-03-13', 'F', 'LWilkins@yahoo.com', '77648 Avemore Ave', 'PONTOTOC', 'TX', '76869', 'USA', '7075547204', NULL);
INSERT INTO account VALUES(0, 'KChen', 'cvacwint', 'Katherine', NULL, 'Chen', '1986-01-27', 'F', 'KChen@sbcglobal.net', '83282 Windward Ave', 'ESSEX', 'MD', '21221', 'USA', '7865914574', NULL);
INSERT INTO account VALUES(0, 'YBruce', 'nkebojju', 'Young', NULL, 'Bruce', '1987-04-11', 'F', 'YBruce@yahoo.com', '15843 Hammond Ave', 'CLALLAM BAY', 'WA', '98326', 'USA', '5204264502', NULL);
INSERT INTO account VALUES(0, 'FGonzalez', 'cpytiscr', 'Fred', NULL, 'Gonzalez', '1968-03-04', 'M', 'FGonzalez@gmail.com', '66765 Cline Ave', 'AXSON', 'GA', '31624', 'USA', '2648720674', NULL);
INSERT INTO account VALUES(0, 'MPearson', 'ywsbrccm', 'Mario', NULL, 'Pearson', '1978-02-27', 'M', 'MPearson@gmail.com', '28953 Mill Stream Ave', 'SAN DIEGO', 'CA', '92117', 'USA', '6565987500', NULL);
INSERT INTO account VALUES(0, 'MSpears', 'noygktvj', 'Mariana', NULL, 'Spears', '1967-01-15', 'F', 'MSpears@yahoo.com', '64688 Cottonwood Ave', 'PACIFIC HOUSE', 'CA', '95726', 'USA', '4597994836', NULL);
INSERT INTO account VALUES(0, 'FOsborn', 'pjftqkxn', 'Fay', NULL, 'Osborn', '1971-03-22', 'F', 'FOsborn@verizon.net', '31962 Reid Ave', 'DOVE CREEK', 'CO', '81324', 'USA', '8972255462', NULL);
INSERT INTO account VALUES(0, 'LSutton', 'wyouzads', 'Leon', NULL, 'Sutton', '1982-07-07', 'M', 'LSutton@hotmail.com', '33864 Richards Ave', 'BROOKLEY FIELD', 'AL', '36615', 'USA', '7415109466', NULL);
INSERT INTO account VALUES(0, 'JNorton', 'tpkcjzvn', 'John', NULL, 'Norton', '1987-10-22', 'M', 'JNorton@yahoo.com', '76486 Cliff Ave', 'EVANSTON', 'IL', '60203', 'USA', '1138535209', NULL);
INSERT INTO account VALUES(0, 'FDudley', 'wrzscapk', 'Fernando', NULL, 'Dudley', '1966-12-23', 'M', 'FDudley@sbcglobal.net', '13339 Fox Path Ave', 'HARRELLS', 'NC', '28444', 'USA', '2378752853', NULL);
INSERT INTO account VALUES(0, 'PAbbott', 'zfmygkyn', 'Patrick', NULL, 'Abbott', '1980-11-13', 'M', 'PAbbott@verizon.net', '57359 Chicory Ave', 'ELK SPRINGS', 'CO', '81633', 'USA', '5847874713', NULL);
INSERT INTO account VALUES(0, 'ECarpenter', 'wulinizb', 'Esperanza', NULL, 'Carpenter', '1988-06-17', 'F', 'ECarpenter@hotmail.com', '73823 Walnut Ridge Ave', 'TINSMAN', 'AR', '71767', 'USA', '1512922074', NULL);
INSERT INTO account VALUES(0, 'SMack', 'uqpcpydw', 'Shawn', NULL, 'Mack', '1983-12-15', 'M', 'SMack@sbcglobal.net', '32414 Downing Ln', 'STAMFORD', 'CT', '06907', 'USA', '9011747238', NULL);
INSERT INTO account VALUES(0, 'RHuffman', 'mzwlbbyu', 'Roy', NULL, 'Huffman', '1982-06-11', 'M', 'RHuffman@gmail.com', '45439 Gallopers Ave', 'PENLLYN', 'PA', '19422', 'USA', '7123754385', NULL);
INSERT INTO account VALUES(0, 'SWolfe', 'zunmsnxp', 'Shari', NULL, 'Wolfe', '1988-03-26', 'F', 'SWolfe@verizon.net', '68351 Golf Village Ave', 'ELDRED', 'MN', '56523', 'USA', '1968007756', NULL);
INSERT INTO account VALUES(0, 'AOdonnell', 'sjigsaaz', 'Angela', NULL, 'Odonnell', '1944-09-04', 'F', 'AOdonnell@yahoo.com', '41242 Ulster St', 'ELROY', 'WI', '53929', 'USA', '5403537910', NULL);
INSERT INTO account VALUES(0, 'BFry', 'vaaioezx', 'Brandon', NULL, 'Fry', '1976-12-09', 'M', 'BFry@hotmail.com', '19119 Highland View Ave', 'REXBURG', 'ID', '83440', 'USA', '5359716069', NULL);
INSERT INTO account VALUES(0, 'SLittle', 'yrxdnxgp', 'Sam', NULL, 'Little', '1980-03-27', 'M', 'SLittle@yahoo.com', '21852 Merchant Ave', 'CHESTERFIELD', 'IN', '46017', 'USA', '9685382806', NULL);
INSERT INTO account VALUES(0, 'CConner', 'jzmgujbv', 'Carissa', NULL, 'Conner', '1981-04-19', 'F', 'CConner@yahoo.com', '87443 Altair St', 'HILL AIR FORCE B', 'UT', '84056', 'USA', '7057169918', NULL);
INSERT INTO account VALUES(0, 'RWarner', 'bsdzurrb', 'Rosalinda', NULL, 'Warner', '1983-06-09', 'F', 'RWarner@gmail.com', '73257 Barassie Ave', 'BEAVER', 'OH', '45613', 'USA', '8343750433', NULL);
INSERT INTO account VALUES(0, 'CGates', 'usqfsufv', 'Chad', NULL, 'Gates', '1982-02-16', 'M', 'CGates@hotmail.com', '56752 Westerview Ave', 'BROKEN BOW', 'OK', '74728', 'USA', '6836728243', NULL);
INSERT INTO account VALUES(0, 'DCantu', 'pqwiyzzm', 'Debbie', NULL, 'Cantu', '1982-01-31', 'F', 'DCantu@sbcglobal.net', '74424 Glenaire Ave', 'BLAIRSVILLE', 'PA', '15717', 'USA', '2439821129', NULL);
INSERT INTO account VALUES(0, 'SCraft', 'lafcjiod', 'Sonya', NULL, 'Craft', '1983-05-22', 'F', 'SCraft@gmail.com', '82592 Mason Ave', 'WOONSOCKET', 'SD', '57385', 'USA', '1648524123', NULL);
INSERT INTO account VALUES(0, 'THorn', 'ofbcwhpf', 'Tracy', NULL, 'Horn', '1953-01-17', 'M', 'THorn@hotmail.com', '91329 Tiller St', 'ALBION', 'MI', '49224', 'USA', '4096797671', NULL);
INSERT INTO account VALUES(0, 'JFitzgerald', 'zxsfuino', 'Jonathan', NULL, 'Fitzgerald', '1982-04-07', 'M', 'JFitzgerald@sbcglobal.net', '28853 Bluff Ridge St', 'MEEKER', 'OK', '74855', 'USA', '7009020592', NULL);
INSERT INTO account VALUES(0, 'RCherry', 'xvyrhwgg', 'Randy', NULL, 'Cherry', '1987-10-21', 'M', 'RCherry@verizon.net', '16395 Estelle Ave', 'CLEARFIELD', 'UT', '84015', 'USA', '3096179782', NULL);
INSERT INTO account VALUES(0, 'CHoover', 'eapextha', 'Clifton', NULL, 'Hoover', '1985-11-16', 'M', 'CHoover@yahoo.com', '44875 Blue Bonnet Ave', 'SCOTTSDALE', 'AZ', '85259', 'USA', '3763784627', NULL);
INSERT INTO account VALUES(0, 'SFlowers', 'bzuowqro', 'Sergio', NULL, 'Flowers', '1982-11-08', 'M', 'SFlowers@hotmail.com', '96628 Morningside Ave', 'STEPHENVILLE', 'TX', '76401', 'USA', '9923048902', NULL);
INSERT INTO account VALUES(0, 'KBeck', 'ugivotkj', 'Kathrine', NULL, 'Beck', '1984-06-20', 'F', 'KBeck@sbcglobal.net', '52784 Park View Ave', 'MILLWOOD', 'NY', '10546', 'USA', '4397101413', NULL);
INSERT INTO account VALUES(0, 'FAndrews', 'nlvcfsib', 'Florine', NULL, 'Andrews', '1985-11-06', 'F', 'FAndrews@verizon.net', '85856 Wedgewood Place St', 'BASOM', 'NY', '14013', 'USA', '7109168770', NULL);
INSERT INTO account VALUES(0, 'PWall', 'epwrdsxn', 'Peter', NULL, 'Wall', '1988-08-16', 'M', 'PWall@hotmail.com', '73982 Donerail St', 'LEWES', 'DE', '19958', 'USA', '2723812989', NULL);
INSERT INTO account VALUES(0, 'VWare', 'xgyracvv', 'Virgil', NULL, 'Ware', '1986-02-10', 'M', 'VWare@yahoo.com', '58983 Manchester Ave', 'LEXINGTON', 'KY', '40508', 'USA', '4825108492', NULL);
INSERT INTO account VALUES(0, 'VBonner', 'agecpbkl', 'Victoria', NULL, 'Bonner', '1988-05-06', 'F', 'VBonner@hotmail.com', '81686 Spinnaker Ave', 'WALKER', 'MN', '56484', 'USA', '7192350744', NULL);
INSERT INTO account VALUES(0, 'SGraves', 'nbvhrdsc', 'Sheila', NULL, 'Graves', '1984-01-28', 'F', 'SGraves@sbcglobal.net', '51691 Eventrail Ave', 'MALDEN', 'MO', '63863', 'USA', '7839915686', NULL);
INSERT INTO account VALUES(0, 'DLara', 'fiotlrfy', 'Darrell', NULL, 'Lara', '1985-10-10', 'M', 'DLara@sbcglobal.net', '72956 Smokey Hollow St', 'OAKLAND MILLS', 'PA', '17076', 'USA', '7804406839', NULL);
INSERT INTO account VALUES(0, 'ASantos', 'ipltqokv', 'Albert', NULL, 'Santos', '1980-12-07', 'M', 'ASantos@sbcglobal.net', '16162 Jean Ave', 'ORANGEBURG', 'SC', '29115', 'USA', '6101866767', NULL);
INSERT INTO account VALUES(0, 'RBurnett', 'lnbtmenk', 'Ross', NULL, 'Burnett', '1988-03-13', 'M', 'RBurnett@sbcglobal.net', '22632 Whispering Creek St', 'SUSANVILLE', 'CA', '96130', 'USA', '1179320623', NULL);
INSERT INTO account VALUES(0, 'RPotts', 'jbzwkgci', 'Roberto', NULL, 'Potts', '1985-08-09', 'M', 'RPotts@sbcglobal.net', '62944 Tanera More Ave', 'FORKS TOWNSHIP', 'PA', '18042', 'USA', '6866889220', NULL);
INSERT INTO account VALUES(0, 'HDuran', 'iarwvpuw', 'Hattie', NULL, 'Duran', '1987-07-10', 'F', 'HDuran@gmail.com', '72858 Helen Ave', 'SAINT PAUL', 'MN', '55104', 'USA', '1217487358', NULL);
INSERT INTO account VALUES(0, 'EGillespie', 'lmzvgjbq', 'Enrique', NULL, 'Gillespie', '1982-02-17', 'M', 'EGillespie@hotmail.com', '34365 Bay Harbor Ave', 'LAFONTAINE', 'KS', '66736', 'USA', '5831583733', NULL);
INSERT INTO account VALUES(0, 'TRichards', 'brgesnnh', 'Tyrone', NULL, 'Richards', '1980-06-22', 'M', 'TRichards@yahoo.com', '25728 Jefferson Ave', 'CAVE SPRINGS', 'AR', '72718', 'USA', '6043857776', NULL);
INSERT INTO account VALUES(0, 'MPerry', 'jcgfkbkz', 'Mark', NULL, 'Perry', '1989-02-05', 'M', 'MPerry@hotmail.com', '89752 Cheyenne Creek Ave', 'PERRYSVILLE', 'OH', '44864', 'USA', '8215246495', NULL);
INSERT INTO account VALUES(0, 'NDodson', 'saixrebo', 'Nathaniel', NULL, 'Dodson', '1985-11-22', 'M', 'NDodson@yahoo.com', '17182 Saberly Ave', 'ROUND LAKE', 'IL', '60073', 'USA', '4192884122', NULL);
INSERT INTO account VALUES(0, 'PVelasquez', 'vwnwfurj', 'Phillip', NULL, 'Velasquez', '1988-09-13', 'M', 'PVelasquez@gmail.com', '53517 Bank Ave', 'SEATTLE', 'WA', '98106', 'USA', '9483037586', NULL);
INSERT INTO account VALUES(0, 'WDaniels', 'rpcukeqi', 'Warren', NULL, 'Daniels', '1981-04-16', 'M', 'WDaniels@sbcglobal.net', '76222 Wheatfield Ave', 'CHILHOWIE', 'VA', '24319', 'USA', '5246423542', NULL);
INSERT INTO account VALUES(0, 'RBernard', 'oeiocysz', 'Ray', NULL, 'Bernard', '1987-03-22', 'M', 'RBernard@yahoo.com', '77515 Little Leaf Ave', 'BETHANY', 'WV', '26032', 'USA', '1266689878', NULL);
INSERT INTO account VALUES(0, 'ACruz', 'qeqgfiew', 'Aida', NULL, 'Cruz', '1984-03-15', 'F', 'ACruz@verizon.net', '29884 Calumet Ave', 'CROYDON', 'PA', '19021', 'USA', '1525459513', NULL);
INSERT INTO account VALUES(0, 'SBruce', 'mbangfnl', 'Sergio', NULL, 'Bruce', '1987-11-18', 'M', 'SBruce@gmail.com', '35258 Pagett Ave', 'MC RAE', 'AR', '72102', 'USA', '2873590074', NULL);
INSERT INTO account VALUES(0, 'FAlexander', 'nwceyagv', 'Felix', NULL, 'Alexander', '1988-09-09', 'M', 'FAlexander@verizon.net', '43951 Cali Glen St', 'ROCKWOOD', 'IL', '62280', 'USA', '8433395056', NULL);

--
-- GENRES
--



INSERT INTO genre VALUES('Action/Adventure');
INSERT INTO genre VALUES('Comedy');
INSERT INTO genre VALUES('Drama');
INSERT INTO genre VALUES('Ecchi');
INSERT INTO genre VALUES('Family');
INSERT INTO genre VALUES('Fantasy');
INSERT INTO genre VALUES('Harem');
INSERT INTO genre VALUES('Historical');
INSERT INTO genre VALUES('Horror');
INSERT INTO genre VALUES('Magic');
INSERT INTO genre VALUES('Martial Arts');
INSERT INTO genre VALUES('Mecha');
INSERT INTO genre VALUES('Mystery');
INSERT INTO genre VALUES('Romance');
INSERT INTO genre VALUES('School Life');
INSERT INTO genre VALUES('Science Fiction');
INSERT INTO genre VALUES('Sports');
INSERT INTO genre VALUES('Supernatural');
INSERT INTO genre VALUES('Thriller');
INSERT INTO genre VALUES('War');
INSERT INTO genre VALUES('Yaoi');

--
-- SERIES
--




INSERT INTO series VALUES('Akira');
INSERT INTO series VALUES('Aria');
INSERT INTO series VALUES('Bamboo Blade');
INSERT INTO series VALUES('Bubblegum Crisis');
INSERT INTO series VALUES('Chococat');
INSERT INTO series VALUES('Cowboy Bebop');
INSERT INTO series VALUES('Darker Than Black');
INSERT INTO series VALUES('Death Note');
INSERT INTO series VALUES('Edelweiss');
INSERT INTO series VALUES('eX-Driver');
INSERT INTO series VALUES('Fate/Stay Night');
INSERT INTO series VALUES('Fullmetal Alchemist');
INSERT INTO series VALUES('Ghost in the Shell');
INSERT INTO series VALUES('Gun X Sword');
INSERT INTO series VALUES('Gundam');
INSERT INTO series VALUES('Hayate no Gotoku');
INSERT INTO series VALUES('Hell Girl');
INSERT INTO series VALUES('Hello Kitty');
INSERT INTO series VALUES('InuYasha');
INSERT INTO series VALUES('Iria: Zeiram the Animation');
INSERT INTO series VALUES('Macross');
INSERT INTO series VALUES('Natsu no Sora');
INSERT INTO series VALUES('Princess Resurrection');
INSERT INTO series VALUES('Shakugan no Shana');
INSERT INTO series VALUES('Spice and Wolf');
INSERT INTO series VALUES('Uninhabited Planet Survive');
INSERT INTO series VALUES('Zero no Tsukaima');

--
-- PRODUCTS
--

-- Akira Products (OK)

INSERT INTO product VALUES(1, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Akira Book 01 (Manga)', 'Katsuhiro Otomo\'s stunning science-fiction masterpiece, Akira!', 'Akira', 'Dark Horse');
INSERT INTO product VALUES(2, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Akira Book 02 (Manga)', 'Katsuhiro Otomo\'s stunning science-fiction masterpiece, Akira!', 'Akira', 'Dark Horse');
INSERT INTO product VALUES(3, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Akira Book 03 (Manga)', 'Katsuhiro Otomo\'s stunning science-fiction masterpiece, Akira!', 'Akira', 'Dark Horse');
INSERT INTO product VALUES(4, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Akira Book 04 (Manga)', 'Katsuhiro Otomo\'s stunning science-fiction masterpiece, Akira!', 'Akira', 'Dark Horse');
INSERT INTO product VALUES(5, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Akira Book 05 (Manga)', 'Katsuhiro Otomo\'s stunning science-fiction masterpiece, Akira!', 'Akira', 'Dark Horse');
INSERT INTO product VALUES(6, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Akira Book 06 (Manga)', 'Katsuhiro Otomo\'s stunning science-fiction masterpiece, Akira!', 'Akira', 'Dark Horse');
INSERT INTO product VALUES(7, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Akira (DVD)', 'Neo-Tokyo has risen from the ashes of World War III to become a dark and dangerous megalopolis infested with gangs and terrorists.', 'Akira', 'Geneon');
INSERT INTO product VALUES(8, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Akira Signature Series (DVD)', 'Neo-Tokyo has risen from the ashes of World War III to become a dark and dangerous megalopolis infested with gangs and terrorists.', 'Akira', 'Geneon');
INSERT INTO product VALUES(9, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Akira: Tetsuo PVC Statue', NULL, 'Akira', 'Mushroom Japan');
INSERT INTO product VALUES(10, (SELECT cat_id FROM category WHERE cat_name='Anime Music'), 'Akira Symphonic Suite Soundtrack', 'There\'s no arguing that AKIRA is one of the top anime theatrical features of all time, with a uniquely unorthodox soundtrack that retains its futuristic, yet modern-day appeal, becoming an integral part of this groundbreaking film.', 'Akira', 'Geneon');
INSERT INTO product VALUES(11, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Akira Club', 'Katsuhiro Otomo\'s epic manga, Akira.', 'Akira', 'Dark Horse');

-- Aria Products (OK)

INSERT INTO product VALUES(12, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Aria TV: Season 1 Collection (DVD Box Set)', 'In the early 24th century, Mars has been terraformed by mankind into a sparkling planet covered in water.', 'Aria', 'Right Stuf');
INSERT INTO product VALUES(13, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Aria: Alice 6\" Figure', 'Aria is a modern-day fairy tale that blends fantasy and reality in a world where mortals and immortals co-exist for survival.', 'Aria', 'Yujin');
INSERT INTO product VALUES(14, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Aria Akira Ferrari 1/6 Scale PVC Statue', NULL, 'Aria', 'Toys Works');
INSERT INTO product VALUES(15, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Aria Alice Carroll 1/6 Scale PVC Figure', NULL, 'Aria', 'Toys Works');
INSERT INTO product VALUES(16, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Aria: Alicia Florence 1/8 Scale PVC Figure', NULL, 'Aria', 'Good Smile Company');
INSERT INTO product VALUES(17, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Aria Vol. 1', 'On the planet Aqua, a world once known as Mars, Akari Mizunashi has just made her home in the town of Neo-VENEZIA, a futuristic imitation of the ancient city of Venice.', 'Aria', 'Tokyo Pop');
INSERT INTO product VALUES(18, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Aria Vol. 2', 'On the planet Aqua, a world once known as Mars, Akari Mizunashi has just made her home in the town of Neo-VENEZIA, a futuristic imitation of the ancient city of Venice.', 'Aria', 'Tokyo Pop');
INSERT INTO product VALUES(19, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Aria Vol. 3', 'On the planet Aqua, a world once known as Mars, Akari Mizunashi has just made her home in the town of Neo-VENEZIA, a futuristic imitation of the ancient city of Venice.', 'Aria', 'Tokyo Pop');

-- Bamboo Blade Products (OK)
INSERT INTO product VALUES(20, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Bamboo Blade Tamaki Kawazoe 1/8 PVC Figure', NULL, 'Bamboo Blade', 'Kotobukiya');

-- Bubblegum Crisis Products (OK)
INSERT INTO product VALUES(21, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Bubblegum Crisis Motoslave w/ Priss 1/15 Scale Metallic Action Figure', NULL, 'Bubblegum Crisis', 'Yamato');
INSERT INTO product VALUES(22, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Bubblegum Crisis Motoslave w/ Nene 1/15 Scale PVC Action Figure', 'Yamato completes its 1/15 Bubblegum Crisis collection with the addition of Motoslave (Linna) and Motoslave (Nene).', 'Bubblegum Crisis', 'Yamato');
INSERT INTO product VALUES(23, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Bubblegum Crisis Motoslave w/ Linna 1/15 Scale PVC Action Figure', 'Yamato completes its 1/15 Bubblegum Crisis collection with the addition of Motoslave (Linna) and Motoslave (Nene).', 'Bubblegum Crisis', 'Yamato');
INSERT INTO product VALUES(24, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Bubblegum Crisis: Motoslave w/ Sylia 1/15 Scale PVC Action Figure', 'Yamato marks an all new milestone in toy engineering with its 1/15 transformable Motoslaves from Bubblegum Crisis.', 'Bubblegum Crisis', 'Yamato');
INSERT INTO product VALUES(25, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Bubblegum Crisis Tokyo 2040: Complete Collection (DVD Box Set)', 'In the aftermath of the great earthquake, one ruthless corporation stands ready to take over the devastated city of Tokyo with an army of synthetic monsters.', 'Bubblegum Crisis', 'ADV');
INSERT INTO product VALUES(26, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Bubblegum Total Crash (DVD)', 'In the aftermath of the great earthquake, one ruthless corporation stands ready to take over the devastated city of Tokyo with an army of synthetic monsters.', 'Bubblegum Crisis', 'Animeigo');
INSERT INTO product VALUES(27, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Bubblegum Crisis Tokyo 2040 Vol. 1 (Essential Anime Collection) (DVD)', 'In the aftermath of the great earthquake, one ruthless corporation stands ready to take over the devastated city of Tokyo with an army of synthetic monsters.', 'Bubblegum Crisis', 'ADV');
INSERT INTO product VALUES(28, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Bubblegum Crisis Tokyo 2040 Vol. 2 (Essential Anime Collection) (DVD)', 'In the aftermath of the great earthquake, one ruthless corporation stands ready to take over the devastated city of Tokyo with an army of synthetic monsters.', 'Bubblegum Crisis', 'ADV');
INSERT INTO product VALUES(29, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Bubblegum Crisis Tokyo 2040 Vol. 3 (Essential Anime Collection) (DVD)', 'In the aftermath of the great earthquake, one ruthless corporation stands ready to take over the devastated city of Tokyo with an army of synthetic monsters.', 'Bubblegum Crisis', 'ADV');
INSERT INTO product VALUES(30, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Bubblegum Crisis (Remastered Edition) (DVD)', 'MegaTokyo is rising from the ashes of a devastating earthquake.', 'Bubblegum Crisis', 'Animeigo');

-- Chococat Products (OK)
INSERT INTO product VALUES(31, (SELECT cat_id FROM category WHERE cat_name='Accessories'), 'Chococat: Wallet - Brown', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(32, (SELECT cat_id FROM category WHERE cat_name='Accessories'), 'Chococat: Coin Purse', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(33, (SELECT cat_id FROM category WHERE cat_name='Hats/Head Gear'), 'Chococat: Cap - Blue', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(34, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Chococat: Shoulder Bag - Blue', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(35, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Chococat: Shoulder Pouch - Brown', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(36, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Chococat: Shoulder Tote Bag - Brown', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(37, (SELECT cat_id FROM category WHERE cat_name='Accessories'), 'Chococat: Mini Cushion', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(38, (SELECT cat_id FROM category WHERE cat_name='Accessories'), 'Chococat: Magnet Set', NULL, 'Chococat', 'Sanrio');
INSERT INTO product VALUES(39, (SELECT cat_id FROM category WHERE cat_name='Accessories'), 'Chococat: Spiral Notebook', NULL, 'Chococat', 'Sanrio');

-- Cowboy Bebop Products (OK)
INSERT INTO product VALUES(40, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Cowboy Bebop Film Manga Vol. 1 (Manga)', 'Spike has a past he can\'t forget. Together with his partner Jet Black, he travels on board the ship Bebop chasing bounties and making a meager living.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(41, (SELECT cat_id FROM category WHERE cat_name='Manga Sets'), 'Cowboy Bebop Graphic Novel Complete Box Set (Manga)', 'Cowboy Bebop Volumes 1-3 and Cowboy Bebop: Shooting Star Volumes 1-2 - all 5 vols in one intergalactically groovy boxed set!', 'Cowboy Bebop', 'Tokyo Pop');
INSERT INTO product VALUES(42, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Cowboy Bebop Vol. 1 (Manga)', 'What\'s money between friends? But, wait... who said they were friends?', 'Cowboy Bebop', 'Tokyo Pop');
INSERT INTO product VALUES(43, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Cowboy Bebop Vol. 2 (Manga)', 'The hippest bounty hunters in the galaxy are back!', 'Cowboy Bebop', 'Tokyo Pop');
INSERT INTO product VALUES(44, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Cowboy Bebop Vol. 3 (Manga)', 'One of the most popular anime series ever has inspired one of the hottest manga in America!', 'Cowboy Bebop', 'Tokyo Pop');
INSERT INTO product VALUES(45, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Cowboy Bebop: Shooting Star Vol. 1 (Manga)', 'Nearly twenty years ago the Earth was devastated in a catastrophic accident that left the solar system politically unstable.', 'Cowboy Bebop', 'Tokyo Pop');
INSERT INTO product VALUES(46, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Cowboy Bebop: Shooting Star Vol. 2 (Manga)', 'The Bebop crew runs into a modern day Robin Hood who has designs on thwarting the taxation practices of an unyielding government, whether or not there is a method to their madness.', 'Cowboy Bebop', 'Tokyo Pop');
INSERT INTO product VALUES(47, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop Best Sessions (DVD)', 'Meet Spike and Jet, a drifter and a retired cyborg cop who have formed a partnership in a bounty hunting enterprise.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(48, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop Vol. 3 (DVD)', 'First, the crew must fight against a strange organism that\'s boarded the Bebop.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(49, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop Vol. 4 (DVD)', 'The crew of the Bebop unravels more mysteries in their quest for making a living.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(50, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop Vol. 5 (DVD)', 'Follow the adventures of Spike, Faye, Jet, Ed, and Ein as they continue their endless search for cash.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(51, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop Vol. 6 (DVD)', 'It\'s the end of the road for the Bebop.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(52, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop: REMIX Vol. 1 (DVD)', 'Enjoy true Dolby Digital Surround and be immersed once again with Jet, Spike and the rest of the crew of the Bebop as they travel around the galaxy in search for the wanted criminals one bounty at a time!', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(53, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop: REMIX Vol. 2 (DVD)', 'Spike and Vicious conclude their reunion with a deadly duel.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(54, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop: REMIX Vol. 3 (DVD)', 'The crew must first fight a strange organism that\'s boarded the Bebop.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(55, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop: REMIX Vol. 4 (DVD)', 'The crew of the Bebop unravels more mysteries in their quest for making a living.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(56, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop: REMIX Vol. 5 (DVD)', 'Spike, Faye, Jet, Ed, and Ein continue their endless search for cash.', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(57, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop REMIX Vol. 6 (DVD)', 'Its the end of the road for Bebop', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(58, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop: The Movie: Knocking on Heaven\'s Door (DVD)', 'It\'s just another day when they are after a bounty on Mars, when a strange event unfolds.', 'Cowboy Bebop', 'Colombia Tristar');
INSERT INTO product VALUES(59, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Cowboy Bebop: Complete Collection (Anime Legends)', 'The First Time Cowboy Bebop Remix Complete Collection ever released in North America!!!', 'Cowboy Bebop', 'Bandai');
INSERT INTO product VALUES(60, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Cowboy Bebop: 8 1/2\" PVC Statue - Julia', 'Julia, the woman from Spike\'s Speigel\'s past, the woman around whom so many of his memories revolve.', 'Cowboy Bebop', 'Yamato');
INSERT INTO product VALUES(61, (SELECT cat_id FROM category WHERE cat_name='Plush Toys'), 'Cowboy Bebop: Ed with Ein 8\" Plush', NULL, 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(62, (SELECT cat_id FROM category WHERE cat_name='Posters'), 'Cowboy Bebop Poster', 'Size: 36\"X24\" Licensed by GE Entertainment', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(63, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Faye & Spike Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(64, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Faye & Spike Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(65, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(66, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Black & White Group Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(67, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Faye & Spike Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(68, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(69, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Faye Sitting Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(70, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(71, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Cowboy Bebop Faye Sitting Wall Scroll', 'Cowboy Bebop Wall Scroll Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(72, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Back Pack: Cowboy Bebop - Faye', NULL, 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(73, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Hand Bag: Cowboy Bebop Ein', NULL, 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(74, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Messenger Bag: Cowboy Bebop - Faye', NULL, 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(75, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Messenger Bag: Cowboy Bebop - Spike', NULL, 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(76, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Messenger Bag: Cowboy Bebop - Spike Shadow', NULL, 'Cowboy Bebop', 'GE Animation');
INSERT INTO product VALUES(77, (SELECT cat_id FROM category WHERE cat_name='Bags and Backpacks'), 'Messenger Bag: Cowboy Bebop - Spike w/ Bullet Holes', NULL, 'Cowboy Bebop', 'GE Animation');

-- Darker Than Black Products (OK)
INSERT INTO product VALUES(78, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Darker Than Black Vol. 1 w/ Art Box (DVD)', 'Ten years ago, an inscrutable and abnormal territory known as Hell\'s Gate appeared in Tokyo, altering the sky and decimating the landscape.', 'Darker Than Black', 'Funimation');
INSERT INTO product VALUES(79, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Darker Than Black Vol. 1 (DVD)', 'Ten years ago, an inscrutable and abnormal territory known as Hell\'s Gate appeared in Tokyo, altering the sky and decimating the landscape.', 'Darker Than Black', 'Funimation');

-- Death Note Products (OK)
INSERT INTO product VALUES( 80, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 1 (Manga)', 'Light Yagami is an ace student with great prospects-and he\'s bored out of his mind. But all that changes when he finds the Death Note.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 81, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 2 (Manga)', 'Light thinks he\'s put an end to his troubles with the FBI-by using the Death Note to kill off the FBI agents working the case in Japan.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 82, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 3 (Manga)', 'Light is chaffing under L\'s extreme surveillance, but 64 mikes and cameras hidden in his room aren\'t enough to stop him.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 83, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 4 (Manga)', 'With two Kiras on the loose, L asks Light to join the taskforce and pose as the real Kira in order to catch the copycat.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 84, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 5 (Manga)', 'After a week locked up with no one but Ryuk for company, Light is ready to give up his Death Note and all memories of it.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 85, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 6 (Manga)', 'Although they\'ve collected plenty of evidence tying the seven Yotsuba members to the newest Kira, Light, L and the rest of the taskforce are no closer to discovering which one actually possesses the Death Note.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 86, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 7 (Manga)', 'After a high-speed chase, Light and the taskforce apprehend the newest Kira who was using the power of the Death Note to advance his career.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 87, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 8 (Manga)', 'Light, working as Kira, the newest member of the NPA intelligence bureau, and L, has nearly succeeded in creating his ideal world.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 88, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Death Note Vol. 9 (Manga)', 'Light has always been confident in his ability to outthink everyone, but L\'s proteges are proving to be more of a challenge than he anticipated.', 'Death Note', 'Viz');
INSERT INTO product VALUES( 89, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 1', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 90, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 2', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 91, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 3', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 92, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 4', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 93, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 5', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 94, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 6', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 95, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 7', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 96, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Death Note Vol. 8', 'DEATH NOTE © 2003 by Tsugumi Ohba, Takeshi Obata', 'Death Note', 'Viz');
INSERT INTO product VALUES( 97, (SELECT cat_id FROM category WHERE cat_name='Live Action'), 'Death Note: Movie 1 (Live Action) (DVD)', NULL, 'Death Note', 'Viz');
INSERT INTO product VALUES( 98, (SELECT cat_id FROM category WHERE cat_name='Live Action'), 'Death Note: Movie 2 (Live Action) (DVD)', NULL, 'Death Note', 'Viz');
INSERT INTO product VALUES( 99, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Death Note 1/6 Scale RAH Light Yagami Figure', NULL, 'Death Note', 'Mediacom');
INSERT INTO product VALUES(100, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Death Note 1/6 Scale RAH L Lawliet Figure', NULL, 'Death Note', 'Mediacom');
INSERT INTO product VALUES(101, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Death Note 1/6 Scale RAH 1/6 Misa Amane Figure', NULL, 'Death Note', 'Mediacom');
INSERT INTO product VALUES(102, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Death Note Misa Amane MoeArt Collection 1/6 Scale PVC Statue', description, 'Death Note', 'Jun Planning');
INSERT INTO product VALUES(103, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Death Note: Visual Collection Doll Ryuk 12\" Action Figure', NULL, 'Death Note', 'Mediacom');

-- Edelweiss and eX-Driver Products (OK)
INSERT INTO product VALUES(104, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Edelweiss: Fumie 1/7 Scale PVC Figure', NULL, 'Edelweiss', 'Orchid Seed');
INSERT INTO product VALUES(105, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'eX-Driver Perfect Collection (DVD)', 'The cars are hot but the girls are hotter! Pull over, highway patrol!', 'eX-Driver', 'Media Blasters');

-- Fate/Stay Night Products (OK)
INSERT INTO product VALUES(106, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Stay Night: Rin 1/8 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Kotobukiya');
INSERT INTO product VALUES(107, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Stay Night: Saber 1/8 Scale PVC Figure',  NULL, 'Fate/Stay Night', 'Kotobukiya');
INSERT INTO product VALUES(108, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Hollow Ataraxia: Saber Maid Hallucination 1/8 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Alter');
INSERT INTO product VALUES(109, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Fate/Stay Night Vol. 1: Advent of the Magi', 'The Holy Grail War Begins!', 'Fate/Stay Night', 'Geneon');
INSERT INTO product VALUES(110, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Fate/Stay Night Vol. 2: War of the Magi', 'The Magi have assembled and the War for the Grail has begun.', 'Fate/Stay Night', 'Geneon');
INSERT INTO product VALUES(111, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Fate/Stay Night Vol. 3: Master & Servant', 'Obsessed with obtaining the Holy Grail at any costs, Shinji and his Servant, Rider, press their attack on a still weakened Saber.', 'Fate/Stay Night', 'Geneon');
INSERT INTO product VALUES(112, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Fate/Stay Night Vol. 4: Archer', 'The battle they knew was coming is finally at hand and the choice to run has been taken away.', 'Fate/Stay Night', 'Geneon');
INSERT INTO product VALUES(113, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Fate/Stay Night Vol. 5: Medea', 'In the aftermath of the last battle, only four Servants remain.', 'Fate/Stay Night', 'Geneon');
INSERT INTO product VALUES(114, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Fate/Stay Night Vol. 6: The Holy Grail **LIMITED EDITION**', 'The mysterious eighth Servant attacks, seeking to dominate Saber in order to claim her as his own.', 'Fate/Stay Night', 'Geneon');
INSERT INTO product VALUES(115, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Hollow Ataraxia: Saber (Maid Outfit) 1/6 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Clayz');
INSERT INTO product VALUES(116, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Stay Night: Saber Hyper Fate Collection 1/8 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Enterbrain');
INSERT INTO product VALUES(117, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Hollow Ataraxia: Saber Maid w/ Mop 1/6 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Alter');
INSERT INTO product VALUES(118, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Stay Night Archer Hyper Fate Collection 1/8 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Enterbrain');
INSERT INTO product VALUES(119, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Hollow Ataraxia: Magical Girl Rin 1/6 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Good Smile Company');
INSERT INTO product VALUES(120, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Stay Night: Saber Battle Pose 1/8 Scale PVC Figure', NULL, 'Fate/Stay Night', 'Good Smile Company');
INSERT INTO product VALUES(121, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Fate/Stay Night: Rider 1/7 Scale Figure', NULL, 'Fate/Stay Night', 'Enterbrain');

-- Fullmetal Alchemist Products (OK)
INSERT INTO product VALUES(122, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 1 (Manga)', 'Alchemy: the mystical power to alter the natural world, somewhere between magic, art and science.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(123, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 2 (Manga)', 'In the aftermath of an alchemical ritual gone wrong, Edward Elric became an auto-mail cyborg and his brother, Alphonse, became a living suit of armor.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(124, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 3 (Manga)', 'Accompanied by their blustering bodyguard Alex Armstrong, our heroes seek out a childhood friend: Winry Rockbell, mechanic extraordinaire, who can fix their battered automail bodyparts.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(125, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 4 (Manga)', 'Edward Elric\'s battle at the alchemical lab ends in disaster.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(126, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 5 (Manga)', 'Winry, Ed and Alphonse go south in search of Izumi Curtis, the master alchemist who taught the brothers how to use alchemy many years ago.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(127, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 6 (Manga)', 'The origin of the Elric Brothers! Once Edward and Alphonse Elric were willing to do anything to become alchemists.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(128, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 7 (Manga)', 'Where did Alphonse Elric go during the few short minutes he was wiped from existence, body and soul?', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(129, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'FullMetal Alchemist Vol. 8 (Manga)', 'The raid on the Devil\'s Nest becomes a slaughter, as government troops -- led by the Fuhrer President himself, King Bradley -- exterminate the half-human forces of the Homunculus Greed.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(130, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Movie: Conqueror of Shamballa (DVD)', 'The movie you\'ve been waiting for is here!', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(131, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 1 (DVD)', 'Edward Elric changed the night he trapped his younger brother\'s spirit in the unfeeling steel of an ancient suit of armor.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(132, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 2: Scarred Man of the East (DVD)', 'He is a refugee, a loner from a land scarred with the wounds of war, tortured by memories of a happier time.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(133, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 3: Equivalent Exchange (DVD)', 'The Fullmetal Alchemist, Edward Elric, is given his first assignment.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(134, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 4: The Fall of Ishball (DVD)', 'Ed and Al leave for the countryside to search for Doctor Marcoh, a State Alchemist who deserted during the Eastern Rebellion and is now a fugitive of the state.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(135, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 5: The Cost of Living (DVD)', 'The hobbled Elrics return to their childhood village for the first time in four years.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(136, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 6: Captured Souls (DVD)', 'While Al defends himself against the transmuted Barry the Chopper, Ed discovers more about the dark alchemic experiments deep within Lab Five.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(137, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 7: Reunion on Yock Island (DVD)', 'Ever since Ed and Al attempted human transmutation, they have desperately avoided one person: their childhood teacher, Izumi.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(138, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 8: The Altar of Stone (DVD)', 'As the Elric brothers are leaving Yock Island, a strange boy emerges from the foliage, with no memory of how he arrived.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(139, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 9: Pain and Lust (DVD)', 'Al has been kidnapped.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(140, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 10: Journey to Ishbal (DVD)', 'Al prompts a heated brawl with Ed by questioning him about the direction of their mission for the first time.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(141, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 11: Becoming the Stone (DVD)', 'Edward faces his destiny and the burdens of his actions as chaos surrounding the quest for the Philosopher\'s Stone reaches full boil.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(142, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 12: Truth Behind Truths (DVD)', 'The quest for the Philosopher\'s Stone is wrought with madness.', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(143, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'FullMetal Alchemist Vol. 13: Brotherhood (DVD)', 'At the end of destiny, where will peace be found?', 'Fullmetal Alchemist', 'Funimation');
INSERT INTO product VALUES(144, (SELECT cat_id FROM category WHERE cat_name='Art Books'), 'The Art of FullMetal Alchemist', 'Translated faithfully from the Japanese edition, this coffee table book contains all the FULLMETAL ALCHEMIST color artwork by manga artist Hiromu Arakawa from 2001 to 2003.', 'Fullmetal Alchemist', 'Viz');
INSERT INTO product VALUES(145, (SELECT cat_id FROM category WHERE cat_name='Plush Toys'), 'Fullmetal Alchemist: Alphonse Elric 8\" Plush', NULL, 'Fullmetal Alchemist', 'GE Animation');
INSERT INTO product VALUES(146, (SELECT cat_id FROM category WHERE cat_name='Plush Toys'), 'Fullmetal Alchemist: Alphonse Elric Pillow', NULL, 'Fullmetal Alchemist', 'GE Animation');
INSERT INTO product VALUES(147, (SELECT cat_id FROM category WHERE cat_name='Plush Toys'), 'Fullmetal Alchemist: Roy Sitting 8\" Plush', NULL, 'Fullmetal Alchemist', 'GE Animation');

-- Ghost in the Shell Products (OK)
INSERT INTO product VALUES(148, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Ghost in the Shell SAC: Motoko Kusanagi 1/6 Scale RAH Action Figure', NULL, 'Ghost in the Shell', 'Medicom');
INSERT INTO product VALUES(149, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Ghost in the Shell SAC 2nd GIG 1/7 Motoko Kusanagi PVC Statue', 'Ghost in the Shell Motoko Kusanagi PVC Statue. Imported from Japan.', 'Ghost in the Shell', 'Vice');
INSERT INTO product VALUES(150, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Ghost in the Shell (2nd Edition) (Manga)', 'Ghost in the Shell Volume 1 returns!', 'Ghost in the Shell', 'Dark Horse');
INSERT INTO product VALUES(151, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Ghost In the Shell (DVD)', 'One of the smash hits of the summer.', 'Ghost in the Shell', 'Manga Entertainment');
INSERT INTO product VALUES(152, (SELECT cat_id FROM category WHERE cat_name='Novels'), 'Ghost in the Shell 2: Innocence After the Long Goodbye Novel', 'It is 2032, and Batou, veteran of a hundred urban black ops in Public Security Section 9, lives deadly and miserably between the cornershops where he haggles with holograms over dog food.', 'Ghost in the Shell', 'Viz');
INSERT INTO product VALUES(153, (SELECT cat_id FROM category WHERE cat_name='Novels'), 'Ghost in the Shell: Stand Alone Complex Novel', 'In the not-too-distant future of 2032, the frontier dividing humans and machines has been crossed.', 'Ghost in the Shell', 'Viz');
INSERT INTO product VALUES(154, (SELECT cat_id FROM category WHERE cat_name='Key Chains'), 'Ghost in the Shell: Acrylic Key Chain', NULL, 'Ghost in the Shell', 'GE Animation');
INSERT INTO product VALUES(155, (SELECT cat_id FROM category WHERE cat_name='Plush Toys'), 'Ghost in the Shell SAC: Tachikoma Plush', NULL, 'Ghost in the Shell', 'GE Animation');
INSERT INTO product VALUES(156, (SELECT cat_id FROM category WHERE cat_name='Hats/Head Gear'), 'Baseball Cap: Ghost in the Shell Major Kusanagi', NULL, 'Ghost in the Shell', 'GE Animation');
INSERT INTO product VALUES(157, (SELECT cat_id FROM category WHERE cat_name='Hats/Head Gear'), 'Baseball Cap: Ghost in the Shell S.A.C.', NULL, 'Ghost in the Shell', 'GE Animation');

-- Gun X Sword Products (OK)
INSERT INTO product VALUES(158, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Gun X Sword: Carmen 99 1/8 Scale PVC Figure', 'Every adventure series needs a sultry vixen that kicks butt.', 'Gun X Sword', 'Max Factory');
INSERT INTO product VALUES(159, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Gun X Sword: Van 1/8 Scale PVC Figure', 'Say hello to Van of the hit anime series, Gun X Sword.', 'Gun X Sword', 'Max Factory');
INSERT INTO product VALUES(160, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Gun X Sword: Wendy 1/8 Scale PVC Figure', 'What do you do when a stranger in black named Van with an arm slave that falls from space comes to your town in search of a man with metal claws?', 'Gun X Sword', 'Max Factory');
INSERT INTO product VALUES(161, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Gun X Sword: Wendy Garret (Standing Ver.) 1/8 Scale PVC Figure', 'Meet Wendy Garret from the forthcoming anime release from Geneon Entertainment, GUNxSWORD.', 'Gun X Sword', 'Max Factory');
INSERT INTO product VALUES(162, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Gun X Sword Fasalina 1/8 Scale PVC Figure', NULL, 'Gun X Sword', 'Max Factory');
INSERT INTO product VALUES(163, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Gun X Sword: Dan of Thursday Action Figure', NULL, 'Gun X Sword', 'Max Factory');
INSERT INTO product VALUES(164, (SELECT cat_id FROM category WHERE cat_name='Trading Figures'), 'Gun X Sword: Trading Figures (Display of 8)', 'Girls just want to have fun in the sun!', 'Gun X Sword', 'Max Factory');
INSERT INTO product VALUES(165, (SELECT cat_id FROM category WHERE cat_name='Anime Music'), 'Gun X Sword OST Vol. 1', 'With an addictive opening theme song reminiscent in style to the hypnotic chanting found in Akira, Gun Sword is a well-rounded soundtrack made up of 24 tunes.', 'Gun X Sword', 'Geneon');
INSERT INTO product VALUES(166, (SELECT cat_id FROM category WHERE cat_name='Anime Music'), 'Gun X Sword OST Vol. 2', NULL, 'Gun X Sword', 'Geneon');
INSERT INTO product VALUES(167, (SELECT cat_id FROM category WHERE cat_name='Pins and Buttons'), 'Gun X Sword: PVC Pins', NULL, 'Gun X Sword', 'GE Animation');
INSERT INTO product VALUES(168, (SELECT cat_id FROM category WHERE cat_name='Hats/Head Gear'), 'Gun X Sword: Military Hat', NULL, 'Gun X Sword', 'GE Animation');
INSERT INTO product VALUES(169, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Gun Sword Group Wall Scroll', 'Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Gun X Sword', 'GE Animation');
INSERT INTO product VALUES(170, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Gunsword Wendy & Van Wall Scroll', 'Size: 80x110cm (31.5x43.31in) Licensed by GE Ent.', 'Gun X Sword', 'GE Animation');

-- Gundam Products (OK)
INSERT INTO product VALUES(171, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Gundam SEED Destiny Meer Campbell 1/8 Scale Figure', NULL, 'Gundam', 'MegaHouse');
INSERT INTO product VALUES(172, (SELECT cat_id FROM category WHERE cat_name='Model Kits'), 'Gundam SEED Destiny: Strike Freedom. 1/100 (MG)', NULL, 'Gundam', 'Bandai');

-- Hayate no Gotoku Products
-- Nothing.

-- Hell Girl Products (OK)
INSERT INTO product VALUES(173, (SELECT cat_id FROM category WHERE cat_name='Key Chains'), 'Hell Girl: Key Chain - Straw Doll', NULL, 'Hell Girl', 'GE Animation');
INSERT INTO product VALUES(174, (SELECT cat_id FROM category WHERE cat_name='Wall Scrolls'), 'Hell Girl Enma Wall Scroll', NULL, 'Hell Girl', 'GE Animation');

-- Hello Kitty Products (OK)
INSERT INTO product VALUES(175, (SELECT cat_id FROM category WHERE cat_name='Hats/Head Gear'), 'Hello Kitty: Knit Hat', NULL, 'Hello Kitty', 'Sanrio');
INSERT INTO product VALUES(176, (SELECT cat_id FROM category WHERE cat_name='Apparel'), 'Hello Kitty: Knit Scarf', NULL, 'Hello Kitty', 'Sanrio');

-- InuYasha Products
INSERT INTO product VALUES(177, (SELECT cat_id FROM category WHERE cat_name='Plush Toys'), 'InuYasha: Sesshomaru Ver. 2 8\" Plush', NULL, 'InuYasha', 'GE Animation');
INSERT INTO product VALUES(178, (SELECT cat_id FROM category WHERE cat_name='Hats/Head Gear'), 'InuYasha: Cosplay Kirara Fleece Cap', NULL, 'InuYasha', 'GE Animation');

-- Iria Products
INSERT INTO product VALUES(179, (SELECT cat_id FROM category WHERE cat_name='Anime'), 'Iria: Zeiram, the Animation: Complete', 'Iria and her brother, Gren, are a pair of young bounty hunters.', 'Iria: Zeiram the Animation', 'Media Blasters');
INSERT INTO product VALUES(180, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Iria: Zeiram Movie Zeiram Action Figure', NULL, 'Iria: Zeiram the Animation', 'Kaiyodo');
INSERT INTO product VALUES(181, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Iria: Zeiram Movie Iria Action Figure', NULL, 'Iria: Zeiram the Animation', 'Kaiyodo');

-- Macross Products
INSERT INTO product VALUES(182, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Macross: Super Valkyrie VF-1A Max Sterling Tamashi 1/55 Action Figure', NULL, 'Macross', 'Toynami Tamashi');
INSERT INTO product VALUES(183, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Macross: Super Valkyrie VF-1A Ichigo Hikaru Tamashi 1/55 Action Figure', NULL, 'Macross', 'Toynami Tamashi');
INSERT INTO product VALUES(184, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Macross Plus Valkyrie YF-21 Gald Revoltech Action Figure', NULL, 'Macross', 'Kaiyodo');
INSERT INTO product VALUES(185, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Macross Plus Valkyrie YF-19 Isamu Revoltech Action Figure', NULL, 'Macross', 'Kaiyodo');
INSERT INTO product VALUES(186, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Macross Transformable 1/5000 SDF-1 Movie Color Complete', NULL, 'Macross', 'Wave');
INSERT INTO product VALUES(187, (SELECT cat_id FROM category WHERE cat_name='Anime Music'), 'Macross II OST', 'Total Running Time: Approximately 52 mins.', 'Macross', 'RightStuf');

-- Natsu no Sora Products
-- None! Too new!

-- Princess Resurrection Prodcuts
INSERT INTO product VALUES(188, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Princess Resurrection Vol. 1', NULL, 'Princess Resurrection', 'Del Ray');
INSERT INTO product VALUES(189, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Princess Resurrection Vol. 2', NULL, 'Princess Resurrection', 'Del Ray');
INSERT INTO product VALUES(190, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Princess Resurrection Vol. 3', NULL, 'Princess Resurrection', 'Del Ray');
INSERT INTO product VALUES(191, (SELECT cat_id FROM category WHERE cat_name='Manga Books'), 'Princess Resurrection Vol. 4', NULL, 'Princess Resurrection', 'Del Ray');

-- Shakugan no Shana Products
INSERT INTO product VALUES(192, (SELECT cat_id FROM category WHERE cat_name='Novels'), 'Shakugan no Shana Novel: The Girl With Fire in Her Eyes', NULL, 'Shakugan no Shana', 'Viz');
INSERT INTO product VALUES(193, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Shana 2 Shana Red Hair Ver. Non-Scale Figma Action Figure', NULL, 'Shakugan no Shana', 'Max Factory');
INSERT INTO product VALUES(194, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Shakugan no Shana Maid Dress 1/6 PVC Figure', NULL, 'Shakugan no Shana', 'Cospa');
INSERT INTO product VALUES(195, (SELECT cat_id FROM category WHERE cat_name='Pins and Buttons'), 'Shakugan no Shana: Pins - Shana & Yuji (Set of 2)', NULL, 'Shakugan no Shana', 'GE Animation');

-- Spice and Wolf Products
INSERT INTO product VALUES(196, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Spice and Wolf Holo Wise Wolf 1/6 PVC Figure', 'Removable Clothing. Adults only', 'Spice and Wolf', 'Taki');
INSERT INTO product VALUES(197, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Spice and Wolf Holo 1/8 Scale PVC Figure', 'Kotobukiya presents a new release of pre-painted PVC statues based off of the light novel series Spice and Wolf.', 'Spice and Wolf', 'Kotobukiya');

-- Uninhabited Planet Survive Products
-- None! Too obscure!

-- Zero no Tsukaima Products
INSERT INTO product VALUES(198, (SELECT cat_id FROM category WHERE cat_name='Box Sets'), 'Familiar of Zero: Complete Collection (DVD Box Set)', NULL, 'Zero no Tsukaima', 'Geneon');
INSERT INTO product VALUES(199, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Familiar of Zero Louise Uniform 1/8 Scale Figure', NULL, 'Zero no Tsukaima', 'Alter');
INSERT INTO product VALUES(200, (SELECT cat_id FROM category WHERE cat_name='Anime Figures'), 'Zero no Tsukaima: Siesta 1/8 Scale PVC Figure', NULL, 'Zero no Tsukaima', 'Alter');

--
-- PRODUCT GENRES
--

-- Akira Genres
INSERT INTO xrefseriesgenre VALUES('Akira', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Akira', 'Horror');
INSERT INTO xrefseriesgenre VALUES('Akira', 'Science Fiction');

-- Aria Genres
INSERT INTO xrefseriesgenre VALUES('Aria', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Aria', 'Drama');
INSERT INTO xrefseriesgenre VALUES('Aria', 'Science Fiction');

-- Bamboo Blade Genres
-- No products associated with any genres!

-- Bubblegum Crisis Genres
INSERT INTO xrefseriesgenre VALUES('Bubblegum Crisis', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Bubblegum Crisis', 'Mecha');
INSERT INTO xrefseriesgenre VALUES('Bubblegum Crisis', 'Science Fiction');

-- Chococat Genres
-- No products associated with any genres!

-- Cowboy Bebop Genres
INSERT INTO xrefseriesgenre VALUES('Cowboy Bebop', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Cowboy Bebop', 'Comedy');
INSERT INTO xrefseriesgenre VALUES('Cowboy Bebop', 'Science Fiction');

-- Darker Than Black Genres
-- No products associated with any genres!

-- Death Note Genres
INSERT INTO xrefseriesgenre VALUES('Death Note', 'Drama');
INSERT INTO xrefseriesgenre VALUES('Death Note', 'Fantasy');
INSERT INTO xrefseriesgenre VALUES('Death Note', 'Horror');
INSERT INTO xrefseriesgenre VALUES('Death Note', 'Mystery');
INSERT INTO xrefseriesgenre VALUES('Death Note', 'Supernatural');

-- Edelweiss Genres
INSERT INTO xrefseriesgenre VALUES('Edelweiss', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Edelweiss', 'Science Fiction');

-- Fate/Stay Night Genres
INSERT INTO xrefseriesgenre VALUES('Fate/Stay Night', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Fate/Stay Night', 'Drama');
INSERT INTO xrefseriesgenre VALUES('Fate/Stay Night', 'Magic');

-- Fullmetal Alchemist Genres
INSERT INTO xrefseriesgenre VALUES('Fullmetal Alchemist', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Fullmetal Alchemist', 'Comedy');
INSERT INTO xrefseriesgenre VALUES('Fullmetal Alchemist', 'Drama');
INSERT INTO xrefseriesgenre VALUES('Fullmetal Alchemist', 'Magic');

-- Ghost in the Shell Genres
INSERT INTO xrefseriesgenre VALUES('Ghost in the Shell', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Ghost in the Shell', 'Drama');
INSERT INTO xrefseriesgenre VALUES('Ghost in the Shell', 'Science Fiction');

-- Gun X Sword Genres
INSERT INTO xrefseriesgenre VALUES('Gun X Sword', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Gun X Sword', 'Drama');
INSERT INTO xrefseriesgenre VALUES('Gun X Sword', 'Science Fiction');

-- Gundam Genres
INSERT INTO xrefseriesgenre VALUES('Gundam', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Gundam', 'Drama');
INSERT INTO xrefseriesgenre VALUES('Gundam', 'Mecha');
INSERT INTO xrefseriesgenre VALUES('Gundam', 'Science Fiction');

-- Hell Girl Genres
-- No genre specified!

-- Hello Kitty Genres
-- No genre specified!

-- InuYasha Genres
INSERT INTO xrefseriesgenre VALUES('InuYasha', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('InuYasha', 'Comedy');
INSERT INTO xrefseriesgenre VALUES('InuYasha', 'Drama');
INSERT INTO xrefseriesgenre VALUES('InuYasha', 'Magic');

-- Iria Genres
INSERT INTO xrefseriesgenre VALUES('Iria: Zeiram the Animation', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Iria: Zeiram the Animation', 'Science Fiction');

-- Macross Genres
INSERT INTO xrefseriesgenre VALUES('Macross', 'Action/Adventure');
INSERT INTO xrefseriesgenre VALUES('Macross', 'Mecha');
INSERT INTO xrefseriesgenre VALUES('Macross', 'Science Fiction');

-- Princess Resurrection Genres
INSERT INTO xrefseriesgenre VALUES('Princess Resurrection', 'Comedy');
INSERT INTO xrefseriesgenre VALUES('Princess Resurrection', 'Horror');

-- Shakugan no Shana Genres
-- No genre specified.

-- Spice and Wolf Genres
-- No genre specified.

-- Zero no Tsukaima Genres
-- No genre specified.
INSERT INTO xrefseriesgenre VALUES('Zero no Tsukaima', 'Comedy');
INSERT INTO xrefseriesgenre VALUES('Zero no Tsukaima', 'Ecchi');
INSERT INTO xrefseriesgenre VALUES('Zero no Tsukaima', 'Magic');

--
-- SUPPLIERS
--

INSERT INTO supplier VALUES(1, 'Premium Toy Supply', '79546 Ashbury Ave', 'FOSTORIA', 'OH', '44830', 'USA', '2182467069', NULL);
INSERT INTO supplier VALUES(2, 'Japanese Toy Supply', '55462 Old Oak Ave', 'REED', 'AR', '71670', 'USA', '6514773155', NULL);
INSERT INTO supplier VALUES(3, 'AnimeXPress', '96196 Winslow St', 'DARLINGTON', 'PA', '16115', 'USA', '2472747902', NULL);
INSERT INTO supplier VALUES(4, 'Anime Toy Suppliers', '41187 Rainbow Ave', 'TEMPERANCE', 'MI', '48182', 'USA', '4654827670', NULL);
INSERT INTO supplier VALUES(5, 'Robots and More', '27493 Upper Cambridge St', 'STOCKBRIDGE', 'VT', '05772', 'USA', '5767235652', NULL);
INSERT INTO supplier VALUES(6, 'The Anime Figurine Co.', '78373 Corsham Ave', 'GARDNERS', 'PA', '17324', 'USA', '5459357419', NULL);
INSERT INTO supplier VALUES(7, 'Hot Toys', '76217 Medallion Ave', 'BRIGHTON', 'MI', '48116', 'USA', '2426966537', NULL);
INSERT INTO supplier VALUES(8, 'The Anime Toy Shop', '87292 Liberty Ridge Ave', 'WILLIAMS', 'MN', '56686', 'USA', '8139619512', NULL);
INSERT INTO supplier VALUES(9, 'The Little House of Anime', '25211 Creek Bend Ave', 'ANDREW', 'IL', '62707', 'USA', '5399911398', NULL);
 
--
-- ITEMS
--

-- Akira Items
INSERT INTO item VALUES( 1,  1, 29.95, 22.46, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 2,  2, 29.95, 22.46, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 3,  3, 29.95, 22.46, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 4,  4, 29.95, 22.46, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 5,  5, 29.95, 22.46, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 6,  6, 29.95, 22.46, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 7,  7, 24.98, 20.73, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 8,  8, 19.98, 16.58, 3, 'A', NULL, NULL);
INSERT INTO item VALUES( 9,  9, 35.00, 29.95, 3, 'A', NULL, NULL);
INSERT INTO item VALUES(10, 10, 14.98, 12.43, 3, 'A', NULL, NULL);
INSERT INTO item VALUES(11, 11, 29.95, 22.46, 3, 'A', NULL, NULL);

-- Aria Items
INSERT INTO item VALUES(12, 12, 21.99, 18.25, 2, 'O', NULL, NULL);
INSERT INTO item VALUES(13, 13, 49.99, 44.99, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(14, 14, 79.99, 67.99, 2, 'O', NULL, NULL);
INSERT INTO item VALUES(15, 15, 79.99, 67.99, 2, 'O', NULL, NULL);
INSERT INTO item VALUES(16, 16, 69.99, 59.99, 2, 'O', NULL, NULL);
INSERT INTO item VALUES(17, 17,  9.99,  7.49, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(18, 18,  9.99,  7.49, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(19, 19,  9.99,  7.49, 1, 'A', NULL, NULL);

-- Bamboo Blade Items
INSERT INTO item VALUES(20, 20, 74.95, 59.96, 1, 'A', NULL, NULL);

-- Bubblegum Crisis Items
INSERT INTO item VALUES(21, 21, 74.99, 67.49, 5, 'P', NULL, NULL);
INSERT INTO item VALUES(22, 22, 74.99, 67.49, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(23, 23, 74.99, 67.49, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(24, 24, 74.99, 67.49, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(25, 25, 49.98, 44.98, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(26, 26, 24.95, 20.71, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(27, 27, 19.98, 16.58, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(28, 28, 19.98, 16.58, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(29, 29, 19.98, 16.58, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(30, 30, 69.98, 58.08, 5, 'A', NULL, NULL);

-- Chococat Items
INSERT INTO item VALUES(31, 31, 19.99, 17.99, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(32, 32, 10.99,  9.89, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(33, 33, 19.99, 17.99, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(34, 34, 24.99, 22.49, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(35, 35, 24.99, 22.49, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(36, 36, 29.99, 26.99, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(37, 37, 14.99, 13.49, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(38, 38,  4.95,  4.46, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(39, 39,  4.99,  4.49, 2, 'A', NULL, NULL);

-- Cowboy Bebop Items
INSERT INTO item VALUES(40, 40,  9.99,  7.49, 4, 'A', NULL, NULL);
INSERT INTO item VALUES(41, 41, 44.99, 33.74, 4, 'O', NULL, NULL);
INSERT INTO item VALUES(42, 42,  9.99,  7.49, 4, 'A', NULL, NULL);
INSERT INTO item VALUES(43, 43,  9.99,  7.49, 4, 'A', NULL, NULL);
INSERT INTO item VALUES(44, 44,  9.99,  7.49, 4, 'A', NULL, NULL);
INSERT INTO item VALUES(45, 45,  9.99,  7.49, 4, 'A', NULL, NULL);
INSERT INTO item VALUES(46, 46,  9.99,  7.49, 4, 'A', NULL, NULL);
INSERT INTO item VALUES(47, 47, 19.98, 16.58, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(48, 48, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(49, 49, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(50, 50, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(51, 51, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(52, 52, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(53, 53, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(54, 54, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(55, 55, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(56, 56, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(57, 57, 29.98, 24.88, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(58, 58, 26.95, 22.37, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(59, 59, 49.98, 47.48, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(60, 60, 39.99, 24.99, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(61, 61, 12.99, 10.78, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(62, 62,  4.50,  3.74, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(63, 63, 16.99, 13.59, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(64, 64, 16.99, 13.59, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(65, 65, 16.99, 13.59, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(66, 66, 16.99, 13.59, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(67, 67, 16.99, 13.59, 7, 'O', NULL, NULL);
INSERT INTO item VALUES(68, 68, 16.99, 13.59, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(69, 69, 16.99, 13.59, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(70, 70, 16.99, 13.59, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(71, 71, 16.99, 13.59, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(72, 72, 35.00, 29.05, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(73, 73, 16.00, 13.28, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(74, 74, 35.00, 29.05, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(75, 75, 35.00, 29.05, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(76, 76, 35.00, 29.05, 7, 'A', NULL, NULL);
INSERT INTO item VALUES(77, 77, 35.00, 29.05, 7, 'A', NULL, NULL);

-- Darker Than Black Items
INSERT INTO item VALUES(78, 78, 39.98, 35.98, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(79, 79, 29.98, 26.98, 8, 'A', NULL, NULL);

-- Death Note Items
INSERT INTO item VALUES( 80,  80,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 81,  81,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 82,  82,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 83,  83,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 84,  84,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 85,  85,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 86,  86,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 87,  87,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 88,  88,  7.99,  5.99, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 89,  89, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 90,  90, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 91,  91, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 92,  92, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 93,  93, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 94,  94, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 95,  95, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 96,  96, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 97,  97, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 98,  98, 24.98, 22.98, 9, 'A', NULL, NULL);
INSERT INTO item VALUES( 99,  99, 169.99, 152.99, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(100, 100, 169.99, 169.99, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(101, 101, 169.99, 152.99, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(102, 102,  79.99,  68.99, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(103, 103, 219.99, 197.99, 6, 'O', NULL, NULL);

-- Edelweiss Items
INSERT INTO item VALUES(104, 104, 74.99, 67.49, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(105, 105, 29.95, 24.86, 6, 'A', NULL, NULL);

-- Fate/Stay Night Items
INSERT INTO item VALUES(106, 106, 29.99, 24.89, 8, 'A', NULL, NULL);

INSERT INTO item VALUES(107, 107, 29.99, 24.89, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(108, 108, 64.95, 58.45, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(109, 109, 29.98, 24.88, 8, 'O', NULL, NULL);
INSERT INTO item VALUES(110, 110, 29.98, 24.88, 8, 'O', NULL, NULL);
INSERT INTO item VALUES(111, 111, 29.98, 24.88, 8, 'O', NULL, NULL);
INSERT INTO item VALUES(112, 112, 29.98, 28.48, 8, 'O', NULL, NULL);
INSERT INTO item VALUES(113, 113, 29.98, 25.48, 8, 'O', NULL, NULL);
INSERT INTO item VALUES(114, 114, 39.98, 33.18, 8, 'O', NULL, NULL);
INSERT INTO item VALUES(115, 115, 74.99, 74.99, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(116, 116, 89.99, 74.99, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(117, 117, 89.99, 74.99, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(118, 118, 89.99, 74.99, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(119, 119, 74.99, 74.99, 8, 'A', NULL, NULL);
INSERT INTO item VALUES(120, 120, 65.99, 59.39, 8, 'O', NULL, NULL);
INSERT INTO item VALUES(121, 121, 99.99, 89.99, 8, 'P', NULL, NULL);

-- Fullmetal Alchemist Items
INSERT INTO item VALUES(122, 122,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(123, 123,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(124, 124,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(125, 125,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(126, 126,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(127, 127,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(128, 128,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(129, 129,  9.99,  7.49, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(130, 130, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(131, 131, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(132, 132, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(133, 133, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(134, 134, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(135, 135, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(136, 136, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(137, 137, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(138, 138, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(139, 139, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(140, 140, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(141, 141, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(142, 142, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(143, 143, 29.98, 24.88, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(144, 144, 19.99, 14.99, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(145, 145, 11.99,  9.95, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(146, 146, 19.99, 16.59, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(147, 147, 11.99,  9.95, 1, 'A', NULL, NULL);

-- Ghost in the Shell Items
INSERT INTO item VALUES(148, 148, 174.99, 139.95, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(149, 149,  89.99,  69.95, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(150, 150,  24.95,  18.71, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(151, 151,  19.98,  16.58, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(152, 152,  19.99,  14.99, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(153, 153,   8.95,   6.71, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(154, 154,   2.99,   2.48, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(155, 155,  29.95,  22.46, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(156, 156,  14.99,  12.44, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(157, 157,  14.99,  12.44, 5, 'A', NULL, NULL);

-- Gun X Sword Items
INSERT INTO item VALUES(158, 158,  49.99,  46.95, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(159, 159,  71.99,  59.75, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(160, 160,  48.00,  39.84, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(161, 161,  37.95,  31.50, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(162, 162,  74.99,  72.95, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(163, 163, 133.99, 111.21, 6, 'O', NULL, NULL);
INSERT INTO item VALUES(164, 164,  49.99,  41.49, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(165, 165,  14.98,  12.43, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(166, 166,  14.98,  14.23, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(167, 167,   5.99,   4.97, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(168, 168,  15.99,  13.27, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(169, 169,  16.99,  13.59, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(170, 170,  16.99,  13.59, 5, 'A', NULL, NULL);

-- Gundam Items
INSERT INTO item VALUES(171, 171, 40.00, 36.00, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(172, 172, 59.99, 53.99, 5, 'A', NULL, NULL);

-- Hell Girl Items
INSERT INTO item VALUES(173, 173,  6.99,  6.29, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(174, 174, 16.99, 15.29, 1, 'A', NULL, NULL);

-- Hello Kitty Items
INSERT INTO item VALUES(175, 175, 15.99, 14.39, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(176, 176, 14.99, 13.49, 2, 'A', NULL, NULL);

-- InuYasha Items
INSERT INTO item VALUES(177, 177, 11.99,  9.95, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(178, 178, 14.99, 12.44, 1, 'A', NULL, NULL);

-- Iria Items
INSERT INTO item VALUES(179, 179, 24.95, 20.71, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(180, 180, 45.99, 41.39, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(181, 181, 34.99, 31.49, 6, 'A', NULL, NULL);

-- Macross Items
INSERT INTO item VALUES(182, 182,  99.99,  89.98, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(183, 183,  99.99,  89.98, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(184, 184,  24.95,  21.20, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(185, 185,  24.95,  21.20, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(186, 186, 179.99, 161.99, 5, 'A', NULL, NULL);
INSERT INTO item VALUES(187, 187,  29.95,  22.46, 5, 'A', NULL, NULL);

-- Natsu no Sora Items
-- None! Too new!

-- Princess Resurrection Items
INSERT INTO item VALUES(188, 188, 10.95, 8.21, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(189, 189, 10.95, 8.21, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(190, 190, 10.95, 8.21, 9, 'A', NULL, NULL);
INSERT INTO item VALUES(191, 191, 10.95, 8.21, 9, 'A', NULL, NULL);

-- Shakugan no Shana Items
INSERT INTO item VALUES(192, 192,  9.99,  7.49, 1, 'A', NULL, NULL);
INSERT INTO item VALUES(193, 193, 32.99, 26.69, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(194, 194, 94.95, 85.45, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(195, 195,  5.99,  4.97, 1, 'A', NULL, NULL);

-- Spice and Wolf Items
INSERT INTO item VALUES(196, 196, 110.95, 94.95, 6, 'A', NULL, NULL);
INSERT INTO item VALUES(197, 197,  44.95, 38.20, 6, 'A', NULL, NULL);

-- Uninhabited Planet Survive Items
-- None! Too obscure!

-- Zero no Tsukaima Items
INSERT INTO item VALUES(198, 198, 59.98, 53.98, 2, 'A', NULL, NULL);
INSERT INTO item VALUES(199, 199, 83.99, 75.99, 6, 'P', NULL, NULL);
INSERT INTO item VALUES(200, 200, 63.99, 57.59, 6, 'A', NULL, NULL);

--
-- TEMPORARY TABLE
--
DROP TABLE IF EXISTS TEMP;

CREATE TABLE TEMP
(
 temp_id INT NOT NULL,
 temp DOUBLE(10, 2) NOT NULL
) Engine=InnoDB;

INSERT INTO TEMP VALUES(1, 0.00);

--
-- ORDERS, ORDER STATUS, AND LINE ITEMS (SHIPPED)
--
INSERT INTO orders VALUES(1, 92, '2014-02-13', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 92), (SELECT middle_name FROM account WHERE user_id = 92), (SELECT last_name FROM account WHERE user_id = 92), (SELECT address FROM account WHERE user_id = 92), (SELECT city FROM account WHERE user_id = 92), (SELECT state_province FROM account WHERE user_id = 92), (SELECT zip_post_code FROM account WHERE user_id = 92), 'USA', '5316728309813118002', 'MasterCard', '2012-05-04');
INSERT INTO lineitem VALUES(1, 1, 90, 1);
INSERT INTO orderstatus VALUES(1, 1, '2014-02-13', 'T');
INSERT INTO lineitem VALUES(1, 2, 193, 1);
INSERT INTO orderstatus VALUES(1, 2, '2014-02-13', 'T');
INSERT INTO lineitem VALUES(1, 3, 7, 2);
INSERT INTO orderstatus VALUES(1, 3, '2014-02-13', 'T');
INSERT INTO lineitem VALUES(1, 4, 143, 1);
INSERT INTO orderstatus VALUES(1, 4, '2014-02-13', 'T');

UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 1) WHERE temp_id = 1;

UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 1;

INSERT INTO orders VALUES(2, 68, '2014-09-28', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 68), (SELECT middle_name FROM account WHERE user_id = 68), (SELECT last_name FROM account WHERE user_id = 68), (SELECT address FROM account WHERE user_id = 68), (SELECT city FROM account WHERE user_id = 68), (SELECT state_province FROM account WHERE user_id = 68), (SELECT zip_post_code FROM account WHERE user_id = 68), 'USA', '2498897094898119725', 'Visa', '2010-04-23');
INSERT INTO lineitem VALUES(2, 1, 185, 2);
INSERT INTO orderstatus VALUES(2, 1, '2014-09-28', 'T');
INSERT INTO lineitem VALUES(2, 2, 165, 2);
INSERT INTO orderstatus VALUES(2, 2, '2014-09-28', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 2) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 2;

INSERT INTO orders VALUES(3, 28, '2014-07-05', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 28), (SELECT middle_name FROM account WHERE user_id = 28), (SELECT last_name FROM account WHERE user_id = 28), (SELECT address FROM account WHERE user_id = 28), (SELECT city FROM account WHERE user_id = 28), (SELECT state_province FROM account WHERE user_id = 28), (SELECT zip_post_code FROM account WHERE user_id = 28), 'USA', '3709348769786049320', 'MasterCard', '2011-02-17');
INSERT INTO lineitem VALUES(3, 1, 124, 1);
INSERT INTO orderstatus VALUES(3, 1, '2014-07-05', 'T');
INSERT INTO lineitem VALUES(3, 2, 192, 1);
INSERT INTO orderstatus VALUES(3, 2, '2014-07-05', 'T');
INSERT INTO lineitem VALUES(3, 3, 57, 1);
INSERT INTO orderstatus VALUES(3, 3, '2014-07-05', 'T');
INSERT INTO lineitem VALUES(3, 4, 67, 2);
INSERT INTO orderstatus VALUES(3, 4, '2014-07-05', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 3) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 3;

INSERT INTO orders VALUES(4, 58, '2015-06-17', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 58), (SELECT middle_name FROM account WHERE user_id = 58), (SELECT last_name FROM account WHERE user_id = 58), (SELECT address FROM account WHERE user_id = 58), (SELECT city FROM account WHERE user_id = 58), (SELECT state_province FROM account WHERE user_id = 58), (SELECT zip_post_code FROM account WHERE user_id = 58), 'USA', '6523964828744882728', 'MasterCard', '2010-08-23');
INSERT INTO lineitem VALUES(4, 1, 36, 2);
INSERT INTO orderstatus VALUES(4, 1, '2015-06-17', 'T');
INSERT INTO lineitem VALUES(4, 2, 76, 1);
INSERT INTO orderstatus VALUES(4, 2, '2015-06-17', 'T');
INSERT INTO lineitem VALUES(4, 3, 157, 2);
INSERT INTO orderstatus VALUES(4, 3, '2015-06-17', 'T');
INSERT INTO lineitem VALUES(4, 4, 4, 2);
INSERT INTO orderstatus VALUES(4, 4, '2015-06-17', 'T');
INSERT INTO lineitem VALUES(4, 5, 119, 1);
INSERT INTO orderstatus VALUES(4, 5, '2015-06-17', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 4) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 4;

INSERT INTO orders VALUES(5, 35, '2014-07-02', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 35), (SELECT middle_name FROM account WHERE user_id = 35), (SELECT last_name FROM account WHERE user_id = 35), (SELECT address FROM account WHERE user_id = 35), (SELECT city FROM account WHERE user_id = 35), (SELECT state_province FROM account WHERE user_id = 35), (SELECT zip_post_code FROM account WHERE user_id = 35), 'USA', '7026806782916594427', 'American Express', '2011-10-13');
INSERT INTO lineitem VALUES(5, 1, 121, 2);
INSERT INTO orderstatus VALUES(5, 1, '2014-07-02', 'T');
INSERT INTO lineitem VALUES(5, 2, 100, 2);
INSERT INTO orderstatus VALUES(5, 2, '2014-07-02', 'T');
INSERT INTO lineitem VALUES(5, 3, 193, 2);
INSERT INTO orderstatus VALUES(5, 3, '2014-07-02', 'T');
INSERT INTO lineitem VALUES(5, 4, 64, 2);
INSERT INTO orderstatus VALUES(5, 4, '2014-07-02', 'T');
INSERT INTO lineitem VALUES(5, 5, 24, 2);
INSERT INTO orderstatus VALUES(5, 5, '2014-07-02', 'T');
INSERT INTO lineitem VALUES(5, 6, 6, 1);
INSERT INTO orderstatus VALUES(5, 6, '2014-07-02', 'T');
INSERT INTO lineitem VALUES(5, 7, 144, 2);
INSERT INTO orderstatus VALUES(5, 7, '2014-07-02', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 5) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 5;

INSERT INTO orders VALUES(6, 72, '2014-05-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 72), (SELECT middle_name FROM account WHERE user_id = 72), (SELECT last_name FROM account WHERE user_id = 72), (SELECT address FROM account WHERE user_id = 72), (SELECT city FROM account WHERE user_id = 72), (SELECT state_province FROM account WHERE user_id = 72), (SELECT zip_post_code FROM account WHERE user_id = 72), 'USA', '6142365472320134169', 'Visa', '2011-12-18');
INSERT INTO lineitem VALUES(6, 1, 102, 2);
INSERT INTO orderstatus VALUES(6, 1, '2014-05-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 6) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 6;

INSERT INTO orders VALUES(7, 99, '2014-11-03', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 99), (SELECT middle_name FROM account WHERE user_id = 99), (SELECT last_name FROM account WHERE user_id = 99), (SELECT address FROM account WHERE user_id = 99), (SELECT city FROM account WHERE user_id = 99), (SELECT state_province FROM account WHERE user_id = 99), (SELECT zip_post_code FROM account WHERE user_id = 99), 'USA', '7400844388043025311', 'American Express', '2012-04-01');
INSERT INTO lineitem VALUES(7, 1, 198, 1);
INSERT INTO orderstatus VALUES(7, 1, '2014-11-03', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 7) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 7;

INSERT INTO orders VALUES(8, 100, '2015-12-12', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 100), (SELECT middle_name FROM account WHERE user_id = 100), (SELECT last_name FROM account WHERE user_id = 100), (SELECT address FROM account WHERE user_id = 100), (SELECT city FROM account WHERE user_id = 100), (SELECT state_province FROM account WHERE user_id = 100), (SELECT zip_post_code FROM account WHERE user_id = 100), 'USA', '3938827026987502103', 'Visa', '2011-05-03');
INSERT INTO lineitem VALUES(8, 1, 33, 1);
INSERT INTO orderstatus VALUES(8, 1, '2015-12-12', 'T');
INSERT INTO lineitem VALUES(8, 2, 39, 1);
INSERT INTO orderstatus VALUES(8, 2, '2015-12-12', 'T');
INSERT INTO lineitem VALUES(8, 3, 158, 1);
INSERT INTO orderstatus VALUES(8, 3, '2015-12-12', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 8) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 8;

INSERT INTO orders VALUES(9, 1, '2014-06-07', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 1), (SELECT middle_name FROM account WHERE user_id = 1), (SELECT last_name FROM account WHERE user_id = 1), (SELECT address FROM account WHERE user_id = 1), (SELECT city FROM account WHERE user_id = 1), (SELECT state_province FROM account WHERE user_id = 1), (SELECT zip_post_code FROM account WHERE user_id = 1), 'USA', '7972718479220720222', 'MasterCard', '2010-01-02');
INSERT INTO lineitem VALUES(9, 1, 126, 2);
INSERT INTO orderstatus VALUES(9, 1, '2014-06-07', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 9) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 9;

INSERT INTO orders VALUES(10, 81, '2016-01-27', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 81), (SELECT middle_name FROM account WHERE user_id = 81), (SELECT last_name FROM account WHERE user_id = 81), (SELECT address FROM account WHERE user_id = 81), (SELECT city FROM account WHERE user_id = 81), (SELECT state_province FROM account WHERE user_id = 81), (SELECT zip_post_code FROM account WHERE user_id = 81), 'USA', '1955344373259063101', 'MasterCard', '2010-10-31');
INSERT INTO lineitem VALUES(10, 1, 120, 2);
INSERT INTO orderstatus VALUES(10, 1, '2016-01-27', 'T');
INSERT INTO lineitem VALUES(10, 2, 89, 2);
INSERT INTO orderstatus VALUES(10, 2, '2016-01-27', 'T');
INSERT INTO lineitem VALUES(10, 3, 179, 1);
INSERT INTO orderstatus VALUES(10, 3, '2016-01-27', 'T');
INSERT INTO lineitem VALUES(10, 4, 113, 1);
INSERT INTO orderstatus VALUES(10, 4, '2016-01-27', 'T');
INSERT INTO lineitem VALUES(10, 5, 30, 2);
INSERT INTO orderstatus VALUES(10, 5, '2016-01-27', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 10) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 10;

INSERT INTO orders VALUES(11, 20, '2014-01-24', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 20), (SELECT middle_name FROM account WHERE user_id = 20), (SELECT last_name FROM account WHERE user_id = 20), (SELECT address FROM account WHERE user_id = 20), (SELECT city FROM account WHERE user_id = 20), (SELECT state_province FROM account WHERE user_id = 20), (SELECT zip_post_code FROM account WHERE user_id = 20), 'USA', '1656551812817468294', 'MasterCard', '2012-04-28');
INSERT INTO lineitem VALUES(11, 1, 123, 2);
INSERT INTO orderstatus VALUES(11, 1, '2014-01-24', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 11) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 11;

INSERT INTO orders VALUES(12, 9, '2016-08-05', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 9), (SELECT middle_name FROM account WHERE user_id = 9), (SELECT last_name FROM account WHERE user_id = 9), (SELECT address FROM account WHERE user_id = 9), (SELECT city FROM account WHERE user_id = 9), (SELECT state_province FROM account WHERE user_id = 9), (SELECT zip_post_code FROM account WHERE user_id = 9), 'USA', '7704314534021158229', 'American Express', '2010-01-06');
INSERT INTO lineitem VALUES(12, 1, 180, 1);
INSERT INTO orderstatus VALUES(12, 1, '2016-08-05', 'T');
INSERT INTO lineitem VALUES(12, 2, 59, 1);
INSERT INTO orderstatus VALUES(12, 2, '2016-08-05', 'T');
INSERT INTO lineitem VALUES(12, 3, 48, 2);
INSERT INTO orderstatus VALUES(12, 3, '2016-08-05', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 12) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 12;

INSERT INTO orders VALUES(13, 9, '2014-11-08', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 9), (SELECT middle_name FROM account WHERE user_id = 9), (SELECT last_name FROM account WHERE user_id = 9), (SELECT address FROM account WHERE user_id = 9), (SELECT city FROM account WHERE user_id = 9), (SELECT state_province FROM account WHERE user_id = 9), (SELECT zip_post_code FROM account WHERE user_id = 9), 'USA', '5971843646102583263', 'American Express', '2012-01-28');
INSERT INTO lineitem VALUES(13, 1, 143, 2);
INSERT INTO orderstatus VALUES(13, 1, '2014-11-08', 'T');
INSERT INTO lineitem VALUES(13, 2, 66, 1);
INSERT INTO orderstatus VALUES(13, 2, '2014-11-08', 'T');
INSERT INTO lineitem VALUES(13, 3, 62, 2);
INSERT INTO orderstatus VALUES(13, 3, '2014-11-08', 'T');
INSERT INTO lineitem VALUES(13, 4, 157, 1);
INSERT INTO orderstatus VALUES(13, 4, '2014-11-08', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 13) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 13;

INSERT INTO orders VALUES(14, 3, '2015-07-14', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 3), (SELECT middle_name FROM account WHERE user_id = 3), (SELECT last_name FROM account WHERE user_id = 3), (SELECT address FROM account WHERE user_id = 3), (SELECT city FROM account WHERE user_id = 3), (SELECT state_province FROM account WHERE user_id = 3), (SELECT zip_post_code FROM account WHERE user_id = 3), 'USA', '5172240067829440949', 'MasterCard', '2010-08-26');
INSERT INTO lineitem VALUES(14, 1, 7, 2);
INSERT INTO orderstatus VALUES(14, 1, '2015-07-14', 'T');
INSERT INTO lineitem VALUES(14, 2, 199, 1);
INSERT INTO orderstatus VALUES(14, 2, '2015-07-14', 'T');
INSERT INTO lineitem VALUES(14, 3, 160, 1);
INSERT INTO orderstatus VALUES(14, 3, '2015-07-14', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 14) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 14;

INSERT INTO orders VALUES(15, 75, '2016-06-02', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 75), (SELECT middle_name FROM account WHERE user_id = 75), (SELECT last_name FROM account WHERE user_id = 75), (SELECT address FROM account WHERE user_id = 75), (SELECT city FROM account WHERE user_id = 75), (SELECT state_province FROM account WHERE user_id = 75), (SELECT zip_post_code FROM account WHERE user_id = 75), 'USA', '3763880218793208234', 'MasterCard', '2012-02-24');
INSERT INTO lineitem VALUES(15, 1, 54, 1);
INSERT INTO orderstatus VALUES(15, 1, '2016-06-02', 'T');
INSERT INTO lineitem VALUES(15, 2, 38, 1);
INSERT INTO orderstatus VALUES(15, 2, '2016-06-02', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 15) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 15;

INSERT INTO orders VALUES(16, 22, '2015-10-17', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 22), (SELECT middle_name FROM account WHERE user_id = 22), (SELECT last_name FROM account WHERE user_id = 22), (SELECT address FROM account WHERE user_id = 22), (SELECT city FROM account WHERE user_id = 22), (SELECT state_province FROM account WHERE user_id = 22), (SELECT zip_post_code FROM account WHERE user_id = 22), 'USA', '9199005837295302464', 'Visa', '2011-12-30');
INSERT INTO lineitem VALUES(16, 1, 117, 2);
INSERT INTO orderstatus VALUES(16, 1, '2015-10-17', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 16) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 16;

INSERT INTO orders VALUES(17, 17, '2015-03-12', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 17), (SELECT middle_name FROM account WHERE user_id = 17), (SELECT last_name FROM account WHERE user_id = 17), (SELECT address FROM account WHERE user_id = 17), (SELECT city FROM account WHERE user_id = 17), (SELECT state_province FROM account WHERE user_id = 17), (SELECT zip_post_code FROM account WHERE user_id = 17), 'USA', '2576513070216300265', 'MasterCard', '2012-04-05');
INSERT INTO lineitem VALUES(17, 1, 46, 2);
INSERT INTO orderstatus VALUES(17, 1, '2015-03-12', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 17) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 17;

INSERT INTO orders VALUES(18, 14, '2015-02-27', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 14), (SELECT middle_name FROM account WHERE user_id = 14), (SELECT last_name FROM account WHERE user_id = 14), (SELECT address FROM account WHERE user_id = 14), (SELECT city FROM account WHERE user_id = 14), (SELECT state_province FROM account WHERE user_id = 14), (SELECT zip_post_code FROM account WHERE user_id = 14), 'USA', '4361033736594462153', 'Visa', '2011-10-20');
INSERT INTO lineitem VALUES(18, 1, 108, 1);
INSERT INTO orderstatus VALUES(18, 1, '2015-02-27', 'T');
INSERT INTO lineitem VALUES(18, 2, 49, 2);
INSERT INTO orderstatus VALUES(18, 2, '2015-02-27', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 18) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 18;

INSERT INTO orders VALUES(19, 45, '2016-01-21', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 45), (SELECT middle_name FROM account WHERE user_id = 45), (SELECT last_name FROM account WHERE user_id = 45), (SELECT address FROM account WHERE user_id = 45), (SELECT city FROM account WHERE user_id = 45), (SELECT state_province FROM account WHERE user_id = 45), (SELECT zip_post_code FROM account WHERE user_id = 45), 'USA', '8082914239150816790', 'MasterCard', '2010-11-05');
INSERT INTO lineitem VALUES(19, 1, 25, 1);
INSERT INTO orderstatus VALUES(19, 1, '2016-01-21', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 19) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 19;

INSERT INTO orders VALUES(20, 94, '2015-02-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 94), (SELECT middle_name FROM account WHERE user_id = 94), (SELECT last_name FROM account WHERE user_id = 94), (SELECT address FROM account WHERE user_id = 94), (SELECT city FROM account WHERE user_id = 94), (SELECT state_province FROM account WHERE user_id = 94), (SELECT zip_post_code FROM account WHERE user_id = 94), 'USA', '1374240961418204724', 'MasterCard', '2010-05-27');
INSERT INTO lineitem VALUES(20, 1, 86, 1);
INSERT INTO orderstatus VALUES(20, 1, '2015-02-18', 'T');
INSERT INTO lineitem VALUES(20, 2, 123, 1);
INSERT INTO orderstatus VALUES(20, 2, '2015-02-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 20) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 20;

INSERT INTO orders VALUES(21, 43, '2016-07-31', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 43), (SELECT middle_name FROM account WHERE user_id = 43), (SELECT last_name FROM account WHERE user_id = 43), (SELECT address FROM account WHERE user_id = 43), (SELECT city FROM account WHERE user_id = 43), (SELECT state_province FROM account WHERE user_id = 43), (SELECT zip_post_code FROM account WHERE user_id = 43), 'USA', '9775898958313926306', 'MasterCard', '2010-06-16');
INSERT INTO lineitem VALUES(21, 1, 64, 1);
INSERT INTO orderstatus VALUES(21, 1, '2016-07-31', 'T');
INSERT INTO lineitem VALUES(21, 2, 121, 1);
INSERT INTO orderstatus VALUES(21, 2, '2016-07-31', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 21) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 21;

INSERT INTO orders VALUES(22, 37, '2014-04-23', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 37), (SELECT middle_name FROM account WHERE user_id = 37), (SELECT last_name FROM account WHERE user_id = 37), (SELECT address FROM account WHERE user_id = 37), (SELECT city FROM account WHERE user_id = 37), (SELECT state_province FROM account WHERE user_id = 37), (SELECT zip_post_code FROM account WHERE user_id = 37), 'USA', '2923267852644743787', 'MasterCard', '2012-07-13');
INSERT INTO lineitem VALUES(22, 1, 186, 1);
INSERT INTO orderstatus VALUES(22, 1, '2014-04-23', 'T');
INSERT INTO lineitem VALUES(22, 2, 104, 1);
INSERT INTO orderstatus VALUES(22, 2, '2014-04-23', 'T');
INSERT INTO lineitem VALUES(22, 3, 63, 1);
INSERT INTO orderstatus VALUES(22, 3, '2014-04-23', 'T');
INSERT INTO lineitem VALUES(22, 4, 199, 2);
INSERT INTO orderstatus VALUES(22, 4, '2014-04-23', 'T');
INSERT INTO lineitem VALUES(22, 5, 33, 2);
INSERT INTO orderstatus VALUES(22, 5, '2014-04-23', 'T');
INSERT INTO lineitem VALUES(22, 6, 77, 1);
INSERT INTO orderstatus VALUES(22, 6, '2014-04-23', 'T');
INSERT INTO lineitem VALUES(22, 7, 172, 1);
INSERT INTO orderstatus VALUES(22, 7, '2014-04-23', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 22) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 22;

INSERT INTO orders VALUES(23, 8, '2015-10-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 8), (SELECT middle_name FROM account WHERE user_id = 8), (SELECT last_name FROM account WHERE user_id = 8), (SELECT address FROM account WHERE user_id = 8), (SELECT city FROM account WHERE user_id = 8), (SELECT state_province FROM account WHERE user_id = 8), (SELECT zip_post_code FROM account WHERE user_id = 8), 'USA', '6169656336092987161', 'MasterCard', '2012-11-16');
INSERT INTO lineitem VALUES(23, 1, 179, 2);
INSERT INTO orderstatus VALUES(23, 1, '2015-10-15', 'T');
INSERT INTO lineitem VALUES(23, 2, 141, 1);
INSERT INTO orderstatus VALUES(23, 2, '2015-10-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 23) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 23;

INSERT INTO orders VALUES(24, 18, '2016-06-02', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 18), (SELECT middle_name FROM account WHERE user_id = 18), (SELECT last_name FROM account WHERE user_id = 18), (SELECT address FROM account WHERE user_id = 18), (SELECT city FROM account WHERE user_id = 18), (SELECT state_province FROM account WHERE user_id = 18), (SELECT zip_post_code FROM account WHERE user_id = 18), 'USA', '5050044853544998938', 'American Express', '2010-01-24');
INSERT INTO lineitem VALUES(24, 1, 90, 1);
INSERT INTO orderstatus VALUES(24, 1, '2016-06-02', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 24) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 24;

INSERT INTO orders VALUES(25, 53, '2015-05-31', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 53), (SELECT middle_name FROM account WHERE user_id = 53), (SELECT last_name FROM account WHERE user_id = 53), (SELECT address FROM account WHERE user_id = 53), (SELECT city FROM account WHERE user_id = 53), (SELECT state_province FROM account WHERE user_id = 53), (SELECT zip_post_code FROM account WHERE user_id = 53), 'USA', '5436698855049733294', 'Visa', '2010-05-04');
INSERT INTO lineitem VALUES(25, 1, 194, 1);
INSERT INTO orderstatus VALUES(25, 1, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 2, 76, 1);
INSERT INTO orderstatus VALUES(25, 2, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 3, 55, 2);
INSERT INTO orderstatus VALUES(25, 3, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 4, 111, 1);
INSERT INTO orderstatus VALUES(25, 4, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 5, 75, 1);
INSERT INTO orderstatus VALUES(25, 5, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 6, 34, 1);
INSERT INTO orderstatus VALUES(25, 6, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 7, 21, 2);
INSERT INTO orderstatus VALUES(25, 7, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 8, 175, 1);
INSERT INTO orderstatus VALUES(25, 8, '2015-05-31', 'T');
INSERT INTO lineitem VALUES(25, 9, 112, 1);
INSERT INTO orderstatus VALUES(25, 9, '2015-05-31', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 25) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 25;

INSERT INTO orders VALUES(26, 32, '2016-04-17', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 32), (SELECT middle_name FROM account WHERE user_id = 32), (SELECT last_name FROM account WHERE user_id = 32), (SELECT address FROM account WHERE user_id = 32), (SELECT city FROM account WHERE user_id = 32), (SELECT state_province FROM account WHERE user_id = 32), (SELECT zip_post_code FROM account WHERE user_id = 32), 'USA', '7312865871099654146', 'Visa', '2011-05-06');
INSERT INTO lineitem VALUES(26, 1, 138, 2);
INSERT INTO orderstatus VALUES(26, 1, '2016-04-17', 'T');
INSERT INTO lineitem VALUES(26, 2, 191, 2);
INSERT INTO orderstatus VALUES(26, 2, '2016-04-17', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 26) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 26;

INSERT INTO orders VALUES(27, 9, '2014-09-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 9), (SELECT middle_name FROM account WHERE user_id = 9), (SELECT last_name FROM account WHERE user_id = 9), (SELECT address FROM account WHERE user_id = 9), (SELECT city FROM account WHERE user_id = 9), (SELECT state_province FROM account WHERE user_id = 9), (SELECT zip_post_code FROM account WHERE user_id = 9), 'USA', '1089232000654096004', 'American Express', '2012-11-08');
INSERT INTO lineitem VALUES(27, 1, 89, 2);
INSERT INTO orderstatus VALUES(27, 1, '2014-09-15', 'T');
INSERT INTO lineitem VALUES(27, 2, 71, 2);
INSERT INTO orderstatus VALUES(27, 2, '2014-09-15', 'T');
INSERT INTO lineitem VALUES(27, 3, 12, 2);
INSERT INTO orderstatus VALUES(27, 3, '2014-09-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 27) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 27;

INSERT INTO orders VALUES(28, 38, '2014-09-24', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 38), (SELECT middle_name FROM account WHERE user_id = 38), (SELECT last_name FROM account WHERE user_id = 38), (SELECT address FROM account WHERE user_id = 38), (SELECT city FROM account WHERE user_id = 38), (SELECT state_province FROM account WHERE user_id = 38), (SELECT zip_post_code FROM account WHERE user_id = 38), 'USA', '8638586570476486539', 'American Express', '2012-01-31');
INSERT INTO lineitem VALUES(28, 1, 54, 2);
INSERT INTO orderstatus VALUES(28, 1, '2014-09-24', 'T');
INSERT INTO lineitem VALUES(28, 2, 58, 1);
INSERT INTO orderstatus VALUES(28, 2, '2014-09-24', 'T');
INSERT INTO lineitem VALUES(28, 3, 176, 1);
INSERT INTO orderstatus VALUES(28, 3, '2014-09-24', 'T');
INSERT INTO lineitem VALUES(28, 4, 24, 2);
INSERT INTO orderstatus VALUES(28, 4, '2014-09-24', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 28) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 28;

INSERT INTO orders VALUES(29, 93, '2015-04-05', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 93), (SELECT middle_name FROM account WHERE user_id = 93), (SELECT last_name FROM account WHERE user_id = 93), (SELECT address FROM account WHERE user_id = 93), (SELECT city FROM account WHERE user_id = 93), (SELECT state_province FROM account WHERE user_id = 93), (SELECT zip_post_code FROM account WHERE user_id = 93), 'USA', '2595471541119182174', 'MasterCard', '2012-01-01');
INSERT INTO lineitem VALUES(29, 1, 108, 2);
INSERT INTO orderstatus VALUES(29, 1, '2015-04-05', 'T');
INSERT INTO lineitem VALUES(29, 2, 4, 1);
INSERT INTO orderstatus VALUES(29, 2, '2015-04-05', 'T');
INSERT INTO lineitem VALUES(29, 3, 85, 2);
INSERT INTO orderstatus VALUES(29, 3, '2015-04-05', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 29) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 29;

INSERT INTO orders VALUES(30, 92, '2016-05-25', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 92), (SELECT middle_name FROM account WHERE user_id = 92), (SELECT last_name FROM account WHERE user_id = 92), (SELECT address FROM account WHERE user_id = 92), (SELECT city FROM account WHERE user_id = 92), (SELECT state_province FROM account WHERE user_id = 92), (SELECT zip_post_code FROM account WHERE user_id = 92), 'USA', '4336943060076909626', 'MasterCard', '2011-08-15');
INSERT INTO lineitem VALUES(30, 1, 107, 1);
INSERT INTO orderstatus VALUES(30, 1, '2016-05-25', 'T');
INSERT INTO lineitem VALUES(30, 2, 37, 2);
INSERT INTO orderstatus VALUES(30, 2, '2016-05-25', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 30) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 30;

INSERT INTO orders VALUES(31, 56, '2014-06-07', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 56), (SELECT middle_name FROM account WHERE user_id = 56), (SELECT last_name FROM account WHERE user_id = 56), (SELECT address FROM account WHERE user_id = 56), (SELECT city FROM account WHERE user_id = 56), (SELECT state_province FROM account WHERE user_id = 56), (SELECT zip_post_code FROM account WHERE user_id = 56), 'USA', '5257368742772464832', 'Visa', '2011-02-26');
INSERT INTO lineitem VALUES(31, 1, 122, 1);
INSERT INTO orderstatus VALUES(31, 1, '2014-06-07', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 31) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 31;

INSERT INTO orders VALUES(32, 85, '2016-09-02', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 85), (SELECT middle_name FROM account WHERE user_id = 85), (SELECT last_name FROM account WHERE user_id = 85), (SELECT address FROM account WHERE user_id = 85), (SELECT city FROM account WHERE user_id = 85), (SELECT state_province FROM account WHERE user_id = 85), (SELECT zip_post_code FROM account WHERE user_id = 85), 'USA', '5944567204907130992', 'American Express', '2011-09-15');
INSERT INTO lineitem VALUES(32, 1, 43, 1);
INSERT INTO orderstatus VALUES(32, 1, '2016-09-02', 'T');
INSERT INTO lineitem VALUES(32, 2, 182, 1);
INSERT INTO orderstatus VALUES(32, 2, '2016-09-02', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 32) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 32;

INSERT INTO orders VALUES(33, 48, '2016-10-25', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 48), (SELECT middle_name FROM account WHERE user_id = 48), (SELECT last_name FROM account WHERE user_id = 48), (SELECT address FROM account WHERE user_id = 48), (SELECT city FROM account WHERE user_id = 48), (SELECT state_province FROM account WHERE user_id = 48), (SELECT zip_post_code FROM account WHERE user_id = 48), 'USA', '3816890719586251544', 'Visa', '2011-05-13');
INSERT INTO lineitem VALUES(33, 1, 138, 2);
INSERT INTO orderstatus VALUES(33, 1, '2016-10-25', 'T');
INSERT INTO lineitem VALUES(33, 2, 5, 2);
INSERT INTO orderstatus VALUES(33, 2, '2016-10-25', 'T');
INSERT INTO lineitem VALUES(33, 3, 28, 1);
INSERT INTO orderstatus VALUES(33, 3, '2016-10-25', 'T');
INSERT INTO lineitem VALUES(33, 4, 64, 2);
INSERT INTO orderstatus VALUES(33, 4, '2016-10-25', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 33) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 33;

INSERT INTO orders VALUES(34, 4, '2015-10-28', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 4), (SELECT middle_name FROM account WHERE user_id = 4), (SELECT last_name FROM account WHERE user_id = 4), (SELECT address FROM account WHERE user_id = 4), (SELECT city FROM account WHERE user_id = 4), (SELECT state_province FROM account WHERE user_id = 4), (SELECT zip_post_code FROM account WHERE user_id = 4), 'USA', '7934582660671182551', 'MasterCard', '2011-06-10');
INSERT INTO lineitem VALUES(34, 1, 25, 1);
INSERT INTO orderstatus VALUES(34, 1, '2015-10-28', 'T');
INSERT INTO lineitem VALUES(34, 2, 50, 1);
INSERT INTO orderstatus VALUES(34, 2, '2015-10-28', 'T');
INSERT INTO lineitem VALUES(34, 3, 144, 1);
INSERT INTO orderstatus VALUES(34, 3, '2015-10-28', 'T');
INSERT INTO lineitem VALUES(34, 4, 44, 1);
INSERT INTO orderstatus VALUES(34, 4, '2015-10-28', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 34) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 34;

INSERT INTO orders VALUES(35, 78, '2016-01-23', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 78), (SELECT middle_name FROM account WHERE user_id = 78), (SELECT last_name FROM account WHERE user_id = 78), (SELECT address FROM account WHERE user_id = 78), (SELECT city FROM account WHERE user_id = 78), (SELECT state_province FROM account WHERE user_id = 78), (SELECT zip_post_code FROM account WHERE user_id = 78), 'USA', '7032001087414820281', 'Visa', '2012-05-26');
INSERT INTO lineitem VALUES(35, 1, 13, 1);
INSERT INTO orderstatus VALUES(35, 1, '2016-01-23', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 35) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 35;

INSERT INTO orders VALUES(36, 59, '2014-02-05', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 59), (SELECT middle_name FROM account WHERE user_id = 59), (SELECT last_name FROM account WHERE user_id = 59), (SELECT address FROM account WHERE user_id = 59), (SELECT city FROM account WHERE user_id = 59), (SELECT state_province FROM account WHERE user_id = 59), (SELECT zip_post_code FROM account WHERE user_id = 59), 'USA', '2190203202087998758', 'American Express', '2010-04-02');
INSERT INTO lineitem VALUES(36, 1, 192, 2);
INSERT INTO orderstatus VALUES(36, 1, '2014-02-05', 'T');
INSERT INTO lineitem VALUES(36, 2, 42, 1);
INSERT INTO orderstatus VALUES(36, 2, '2014-02-05', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 36) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 36;

INSERT INTO orders VALUES(37, 63, '2015-03-28', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 63), (SELECT middle_name FROM account WHERE user_id = 63), (SELECT last_name FROM account WHERE user_id = 63), (SELECT address FROM account WHERE user_id = 63), (SELECT city FROM account WHERE user_id = 63), (SELECT state_province FROM account WHERE user_id = 63), (SELECT zip_post_code FROM account WHERE user_id = 63), 'USA', '4994116561157549085', 'MasterCard', '2012-05-14');
INSERT INTO lineitem VALUES(37, 1, 77, 2);
INSERT INTO orderstatus VALUES(37, 1, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 2, 72, 2);
INSERT INTO orderstatus VALUES(37, 2, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 3, 106, 2);
INSERT INTO orderstatus VALUES(37, 3, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 4, 94, 1);
INSERT INTO orderstatus VALUES(37, 4, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 5, 105, 1);
INSERT INTO orderstatus VALUES(37, 5, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 6, 26, 1);
INSERT INTO orderstatus VALUES(37, 6, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 7, 143, 2);
INSERT INTO orderstatus VALUES(37, 7, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 8, 131, 2);
INSERT INTO orderstatus VALUES(37, 8, '2015-03-28', 'T');
INSERT INTO lineitem VALUES(37, 9, 25, 1);
INSERT INTO orderstatus VALUES(37, 9, '2015-03-28', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 37) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 37;

INSERT INTO orders VALUES(38, 45, '2015-09-13', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 45), (SELECT middle_name FROM account WHERE user_id = 45), (SELECT last_name FROM account WHERE user_id = 45), (SELECT address FROM account WHERE user_id = 45), (SELECT city FROM account WHERE user_id = 45), (SELECT state_province FROM account WHERE user_id = 45), (SELECT zip_post_code FROM account WHERE user_id = 45), 'USA', '3844361765760027347', 'MasterCard', '2010-02-01');
INSERT INTO lineitem VALUES(38, 1, 180, 2);
INSERT INTO orderstatus VALUES(38, 1, '2015-09-13', 'T');
INSERT INTO lineitem VALUES(38, 2, 90, 1);
INSERT INTO orderstatus VALUES(38, 2, '2015-09-13', 'T');
INSERT INTO lineitem VALUES(38, 3, 180, 1);
INSERT INTO orderstatus VALUES(38, 3, '2015-09-13', 'T');
INSERT INTO lineitem VALUES(38, 4, 144, 2);
INSERT INTO orderstatus VALUES(38, 4, '2015-09-13', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 38) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 38;

INSERT INTO orders VALUES(39, 22, '2015-11-26', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 22), (SELECT middle_name FROM account WHERE user_id = 22), (SELECT last_name FROM account WHERE user_id = 22), (SELECT address FROM account WHERE user_id = 22), (SELECT city FROM account WHERE user_id = 22), (SELECT state_province FROM account WHERE user_id = 22), (SELECT zip_post_code FROM account WHERE user_id = 22), 'USA', '6264500389299789886', 'American Express', '2010-07-25');
INSERT INTO lineitem VALUES(39, 1, 156, 2);
INSERT INTO orderstatus VALUES(39, 1, '2015-11-26', 'T');
INSERT INTO lineitem VALUES(39, 2, 78, 2);
INSERT INTO orderstatus VALUES(39, 2, '2015-11-26', 'T');
INSERT INTO lineitem VALUES(39, 3, 2, 1);
INSERT INTO orderstatus VALUES(39, 3, '2015-11-26', 'T');
INSERT INTO lineitem VALUES(39, 4, 78, 1);
INSERT INTO orderstatus VALUES(39, 4, '2015-11-26', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 39) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 39;

INSERT INTO orders VALUES(40, 2, '2016-01-26', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 2), (SELECT middle_name FROM account WHERE user_id = 2), (SELECT last_name FROM account WHERE user_id = 2), (SELECT address FROM account WHERE user_id = 2), (SELECT city FROM account WHERE user_id = 2), (SELECT state_province FROM account WHERE user_id = 2), (SELECT zip_post_code FROM account WHERE user_id = 2), 'USA', '1607146403092635405', 'American Express', '2012-02-01');
INSERT INTO lineitem VALUES(40, 1, 80, 2);
INSERT INTO orderstatus VALUES(40, 1, '2016-01-26', 'T');
INSERT INTO lineitem VALUES(40, 2, 82, 2);
INSERT INTO orderstatus VALUES(40, 2, '2016-01-26', 'T');
INSERT INTO lineitem VALUES(40, 3, 119, 1);
INSERT INTO orderstatus VALUES(40, 3, '2016-01-26', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 40) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 40;

INSERT INTO orders VALUES(41, 36, '2016-05-10', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 36), (SELECT middle_name FROM account WHERE user_id = 36), (SELECT last_name FROM account WHERE user_id = 36), (SELECT address FROM account WHERE user_id = 36), (SELECT city FROM account WHERE user_id = 36), (SELECT state_province FROM account WHERE user_id = 36), (SELECT zip_post_code FROM account WHERE user_id = 36), 'USA', '9162091263195166201', 'Visa', '2010-07-29');
INSERT INTO lineitem VALUES(41, 1, 1, 1);
INSERT INTO orderstatus VALUES(41, 1, '2016-05-10', 'T');
INSERT INTO lineitem VALUES(41, 2, 197, 2);
INSERT INTO orderstatus VALUES(41, 2, '2016-05-10', 'T');
INSERT INTO lineitem VALUES(41, 3, 195, 1);
INSERT INTO orderstatus VALUES(41, 3, '2016-05-10', 'T');
INSERT INTO lineitem VALUES(41, 4, 49, 2);
INSERT INTO orderstatus VALUES(41, 4, '2016-05-10', 'T');
INSERT INTO lineitem VALUES(41, 5, 55, 2);
INSERT INTO orderstatus VALUES(41, 5, '2016-05-10', 'T');
INSERT INTO lineitem VALUES(41, 6, 95, 2);
INSERT INTO orderstatus VALUES(41, 6, '2016-05-10', 'T');
INSERT INTO lineitem VALUES(41, 7, 180, 1);
INSERT INTO orderstatus VALUES(41, 7, '2016-05-10', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 41) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 41;

INSERT INTO orders VALUES(42, 53, '2016-10-16', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 53), (SELECT middle_name FROM account WHERE user_id = 53), (SELECT last_name FROM account WHERE user_id = 53), (SELECT address FROM account WHERE user_id = 53), (SELECT city FROM account WHERE user_id = 53), (SELECT state_province FROM account WHERE user_id = 53), (SELECT zip_post_code FROM account WHERE user_id = 53), 'USA', '7084899132886804716', 'MasterCard', '2010-01-07');
INSERT INTO lineitem VALUES(42, 1, 157, 1);
INSERT INTO orderstatus VALUES(42, 1, '2016-10-16', 'T');
INSERT INTO lineitem VALUES(42, 2, 40, 1);
INSERT INTO orderstatus VALUES(42, 2, '2016-10-16', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 42) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 42;

INSERT INTO orders VALUES(43, 68, '2014-04-11', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 68), (SELECT middle_name FROM account WHERE user_id = 68), (SELECT last_name FROM account WHERE user_id = 68), (SELECT address FROM account WHERE user_id = 68), (SELECT city FROM account WHERE user_id = 68), (SELECT state_province FROM account WHERE user_id = 68), (SELECT zip_post_code FROM account WHERE user_id = 68), 'USA', '2909600072468740594', 'American Express', '2012-10-12');
INSERT INTO lineitem VALUES(43, 1, 11, 2);
INSERT INTO orderstatus VALUES(43, 1, '2014-04-11', 'T');
INSERT INTO lineitem VALUES(43, 2, 59, 1);
INSERT INTO orderstatus VALUES(43, 2, '2014-04-11', 'T');
INSERT INTO lineitem VALUES(43, 3, 148, 2);
INSERT INTO orderstatus VALUES(43, 3, '2014-04-11', 'T');

UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 43) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 43;

INSERT INTO orders VALUES(44, 82, '2016-07-08', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 82), (SELECT middle_name FROM account WHERE user_id = 82), (SELECT last_name FROM account WHERE user_id = 82), (SELECT address FROM account WHERE user_id = 82), (SELECT city FROM account WHERE user_id = 82), (SELECT state_province FROM account WHERE user_id = 82), (SELECT zip_post_code FROM account WHERE user_id = 82), 'USA', '1207161676512417060', 'American Express', '2011-07-23');
INSERT INTO lineitem VALUES(44, 1, 89, 1);
INSERT INTO orderstatus VALUES(44, 1, '2016-07-08', 'T');
INSERT INTO lineitem VALUES(44, 2, 26, 1);
INSERT INTO orderstatus VALUES(44, 2, '2016-07-08', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 44) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 44;

INSERT INTO orders VALUES(45, 42, '2014-11-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 42), (SELECT middle_name FROM account WHERE user_id = 42), (SELECT last_name FROM account WHERE user_id = 42), (SELECT address FROM account WHERE user_id = 42), (SELECT city FROM account WHERE user_id = 42), (SELECT state_province FROM account WHERE user_id = 42), (SELECT zip_post_code FROM account WHERE user_id = 42), 'USA', '6435707870367760833', 'American Express', '2010-05-20');
INSERT INTO lineitem VALUES(45, 1, 189, 2);
INSERT INTO orderstatus VALUES(45, 1, '2014-11-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 45) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 45;

INSERT INTO orders VALUES(46, 50, '2015-11-07', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 50), (SELECT middle_name FROM account WHERE user_id = 50), (SELECT last_name FROM account WHERE user_id = 50), (SELECT address FROM account WHERE user_id = 50), (SELECT city FROM account WHERE user_id = 50), (SELECT state_province FROM account WHERE user_id = 50), (SELECT zip_post_code FROM account WHERE user_id = 50), 'USA', '4438849134234226220', 'MasterCard', '2011-08-26');
INSERT INTO lineitem VALUES(46, 1, 11, 1);
INSERT INTO orderstatus VALUES(46, 1, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 2, 40, 1);
INSERT INTO orderstatus VALUES(46, 2, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 3, 142, 2);
INSERT INTO orderstatus VALUES(46, 3, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 4, 9, 2);
INSERT INTO orderstatus VALUES(46, 4, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 5, 66, 1);
INSERT INTO orderstatus VALUES(46, 5, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 6, 10, 1);
INSERT INTO orderstatus VALUES(46, 6, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 7, 151, 2);
INSERT INTO orderstatus VALUES(46, 7, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 8, 100, 1);
INSERT INTO orderstatus VALUES(46, 8, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 9, 123, 1);
INSERT INTO orderstatus VALUES(46, 9, '2015-11-07', 'T');
INSERT INTO lineitem VALUES(46, 10, 83, 2);
INSERT INTO orderstatus VALUES(46, 10, '2015-11-07', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 46) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 46;

INSERT INTO orders VALUES(47, 87, '2014-10-22', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 87), (SELECT middle_name FROM account WHERE user_id = 87), (SELECT last_name FROM account WHERE user_id = 87), (SELECT address FROM account WHERE user_id = 87), (SELECT city FROM account WHERE user_id = 87), (SELECT state_province FROM account WHERE user_id = 87), (SELECT zip_post_code FROM account WHERE user_id = 87), 'USA', '1425263713929597786', 'American Express', '2012-04-10');
INSERT INTO lineitem VALUES(47, 1, 84, 1);
INSERT INTO orderstatus VALUES(47, 1, '2014-10-22', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 47) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 47;

INSERT INTO orders VALUES(48, 83, '2015-06-11', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 83), (SELECT middle_name FROM account WHERE user_id = 83), (SELECT last_name FROM account WHERE user_id = 83), (SELECT address FROM account WHERE user_id = 83), (SELECT city FROM account WHERE user_id = 83), (SELECT state_province FROM account WHERE user_id = 83), (SELECT zip_post_code FROM account WHERE user_id = 83), 'USA', '7007197458691254902', 'MasterCard', '2011-10-06');
INSERT INTO lineitem VALUES(48, 1, 187, 1);
INSERT INTO orderstatus VALUES(48, 1, '2015-06-11', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 48) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 48;

INSERT INTO orders VALUES(49, 86, '2015-08-27', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 86), (SELECT middle_name FROM account WHERE user_id = 86), (SELECT last_name FROM account WHERE user_id = 86), (SELECT address FROM account WHERE user_id = 86), (SELECT city FROM account WHERE user_id = 86), (SELECT state_province FROM account WHERE user_id = 86), (SELECT zip_post_code FROM account WHERE user_id = 86), 'USA', '9476574654412129212', 'American Express', '2011-10-07');
INSERT INTO lineitem VALUES(49, 1, 109, 1);
INSERT INTO orderstatus VALUES(49, 1, '2015-08-27', 'T');
INSERT INTO lineitem VALUES(49, 2, 14, 2);
INSERT INTO orderstatus VALUES(49, 2, '2015-08-27', 'T');
INSERT INTO lineitem VALUES(49, 3, 130, 1);
INSERT INTO orderstatus VALUES(49, 3, '2015-08-27', 'T');
INSERT INTO lineitem VALUES(49, 4, 82, 2);
INSERT INTO orderstatus VALUES(49, 4, '2015-08-27', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 49) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 49;

INSERT INTO orders VALUES(50, 27, '2014-08-10', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 27), (SELECT middle_name FROM account WHERE user_id = 27), (SELECT last_name FROM account WHERE user_id = 27), (SELECT address FROM account WHERE user_id = 27), (SELECT city FROM account WHERE user_id = 27), (SELECT state_province FROM account WHERE user_id = 27), (SELECT zip_post_code FROM account WHERE user_id = 27), 'USA', '3363611203706072878', 'MasterCard', '2010-04-24');
INSERT INTO lineitem VALUES(50, 1, 67, 2);
INSERT INTO orderstatus VALUES(50, 1, '2014-08-10', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 50) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 50;

INSERT INTO orders VALUES(51, 11, '2014-08-12', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 11), (SELECT middle_name FROM account WHERE user_id = 11), (SELECT last_name FROM account WHERE user_id = 11), (SELECT address FROM account WHERE user_id = 11), (SELECT city FROM account WHERE user_id = 11), (SELECT state_province FROM account WHERE user_id = 11), (SELECT zip_post_code FROM account WHERE user_id = 11), 'USA', '5154556799103302912', 'Visa', '2010-05-21');
INSERT INTO lineitem VALUES(51, 1, 132, 2);
INSERT INTO orderstatus VALUES(51, 1, '2014-08-12', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 51) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 51;

INSERT INTO orders VALUES(52, 14, '2016-05-08', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 14), (SELECT middle_name FROM account WHERE user_id = 14), (SELECT last_name FROM account WHERE user_id = 14), (SELECT address FROM account WHERE user_id = 14), (SELECT city FROM account WHERE user_id = 14), (SELECT state_province FROM account WHERE user_id = 14), (SELECT zip_post_code FROM account WHERE user_id = 14), 'USA', '6711975859012863057', 'MasterCard', '2011-05-02');
INSERT INTO lineitem VALUES(52, 1, 172, 2);
INSERT INTO orderstatus VALUES(52, 1, '2016-05-08', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 52) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 52;

INSERT INTO orders VALUES(53, 45, '2014-01-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 45), (SELECT middle_name FROM account WHERE user_id = 45), (SELECT last_name FROM account WHERE user_id = 45), (SELECT address FROM account WHERE user_id = 45), (SELECT city FROM account WHERE user_id = 45), (SELECT state_province FROM account WHERE user_id = 45), (SELECT zip_post_code FROM account WHERE user_id = 45), 'USA', '8938410641520094658', 'American Express', '2011-05-08');
INSERT INTO lineitem VALUES(53, 1, 118, 2);
INSERT INTO orderstatus VALUES(53, 1, '2014-01-15', 'T');
INSERT INTO lineitem VALUES(53, 2, 23, 1);
INSERT INTO orderstatus VALUES(53, 2, '2014-01-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 53) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 53;

INSERT INTO orders VALUES(54, 53, '2015-10-27', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 53), (SELECT middle_name FROM account WHERE user_id = 53), (SELECT last_name FROM account WHERE user_id = 53), (SELECT address FROM account WHERE user_id = 53), (SELECT city FROM account WHERE user_id = 53), (SELECT state_province FROM account WHERE user_id = 53), (SELECT zip_post_code FROM account WHERE user_id = 53), 'USA', '8185580242312673132', 'MasterCard', '2011-08-21');
INSERT INTO lineitem VALUES(54, 1, 175, 2);
INSERT INTO orderstatus VALUES(54, 1, '2015-10-27', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 54) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 54;

INSERT INTO orders VALUES(55, 36, '2015-04-24', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 36), (SELECT middle_name FROM account WHERE user_id = 36), (SELECT last_name FROM account WHERE user_id = 36), (SELECT address FROM account WHERE user_id = 36), (SELECT city FROM account WHERE user_id = 36), (SELECT state_province FROM account WHERE user_id = 36), (SELECT zip_post_code FROM account WHERE user_id = 36), 'USA', '4682689768317108995', 'American Express', '2011-06-25');
INSERT INTO lineitem VALUES(55, 1, 49, 2);
INSERT INTO orderstatus VALUES(55, 1, '2015-04-24', 'T');
INSERT INTO lineitem VALUES(55, 2, 16, 2);
INSERT INTO orderstatus VALUES(55, 2, '2015-04-24', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 55) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 55;

INSERT INTO orders VALUES(56, 22, '2015-05-01', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 22), (SELECT middle_name FROM account WHERE user_id = 22), (SELECT last_name FROM account WHERE user_id = 22), (SELECT address FROM account WHERE user_id = 22), (SELECT city FROM account WHERE user_id = 22), (SELECT state_province FROM account WHERE user_id = 22), (SELECT zip_post_code FROM account WHERE user_id = 22), 'USA', '4186278617687185019', 'MasterCard', '2011-11-06');
INSERT INTO lineitem VALUES(56, 1, 63, 1);
INSERT INTO orderstatus VALUES(56, 1, '2015-05-01', 'T');
INSERT INTO lineitem VALUES(56, 2, 1, 1);
INSERT INTO orderstatus VALUES(56, 2, '2015-05-01', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 56) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 56;

INSERT INTO orders VALUES(57, 70, '2015-05-11', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 70), (SELECT middle_name FROM account WHERE user_id = 70), (SELECT last_name FROM account WHERE user_id = 70), (SELECT address FROM account WHERE user_id = 70), (SELECT city FROM account WHERE user_id = 70), (SELECT state_province FROM account WHERE user_id = 70), (SELECT zip_post_code FROM account WHERE user_id = 70), 'USA', '9125487027249546513', 'Visa', '2012-03-26');
INSERT INTO lineitem VALUES(57, 1, 53, 1);
INSERT INTO orderstatus VALUES(57, 1, '2015-05-11', 'T');
INSERT INTO lineitem VALUES(57, 2, 163, 2);
INSERT INTO orderstatus VALUES(57, 2, '2015-05-11', 'T');
INSERT INTO lineitem VALUES(57, 3, 81, 1);
INSERT INTO orderstatus VALUES(57, 3, '2015-05-11', 'T');
INSERT INTO lineitem VALUES(57, 4, 96, 2);
INSERT INTO orderstatus VALUES(57, 4, '2015-05-11', 'T');
INSERT INTO lineitem VALUES(57, 5, 125, 1);
INSERT INTO orderstatus VALUES(57, 5, '2015-05-11', 'T');
INSERT INTO lineitem VALUES(57, 6, 94, 2);
INSERT INTO orderstatus VALUES(57, 6, '2015-05-11', 'T');
INSERT INTO lineitem VALUES(57, 7, 158, 1);
INSERT INTO orderstatus VALUES(57, 7, '2015-05-11', 'T');
INSERT INTO lineitem VALUES(57, 8, 192, 1);
INSERT INTO orderstatus VALUES(57, 8, '2015-05-11', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 57) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 57;

INSERT INTO orders VALUES(58, 84, '2014-04-11', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 84), (SELECT middle_name FROM account WHERE user_id = 84), (SELECT last_name FROM account WHERE user_id = 84), (SELECT address FROM account WHERE user_id = 84), (SELECT city FROM account WHERE user_id = 84), (SELECT state_province FROM account WHERE user_id = 84), (SELECT zip_post_code FROM account WHERE user_id = 84), 'USA', '9875174965116945457', 'MasterCard', '2012-02-07');
INSERT INTO lineitem VALUES(58, 1, 186, 1);
INSERT INTO orderstatus VALUES(58, 1, '2014-04-11', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 58) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 58;

INSERT INTO orders VALUES(59, 18, '2014-10-22', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 18), (SELECT middle_name FROM account WHERE user_id = 18), (SELECT last_name FROM account WHERE user_id = 18), (SELECT address FROM account WHERE user_id = 18), (SELECT city FROM account WHERE user_id = 18), (SELECT state_province FROM account WHERE user_id = 18), (SELECT zip_post_code FROM account WHERE user_id = 18), 'USA', '9384371365077954510', 'Visa', '2010-08-29');
INSERT INTO lineitem VALUES(59, 1, 62, 2);
INSERT INTO orderstatus VALUES(59, 1, '2014-10-22', 'T');
INSERT INTO lineitem VALUES(59, 2, 56, 1);
INSERT INTO orderstatus VALUES(59, 2, '2014-10-22', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 59) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 59;

INSERT INTO orders VALUES(60, 60, '2014-08-02', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 60), (SELECT middle_name FROM account WHERE user_id = 60), (SELECT last_name FROM account WHERE user_id = 60), (SELECT address FROM account WHERE user_id = 60), (SELECT city FROM account WHERE user_id = 60), (SELECT state_province FROM account WHERE user_id = 60), (SELECT zip_post_code FROM account WHERE user_id = 60), 'USA', '1059503083606444109', 'Visa', '2012-02-19');
INSERT INTO lineitem VALUES(60, 1, 29, 1);
INSERT INTO orderstatus VALUES(60, 1, '2014-08-02', 'T');
INSERT INTO lineitem VALUES(60, 2, 136, 2);
INSERT INTO orderstatus VALUES(60, 2, '2014-08-02', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 60) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 60;

INSERT INTO orders VALUES(61, 56, '2014-05-06', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 56), (SELECT middle_name FROM account WHERE user_id = 56), (SELECT last_name FROM account WHERE user_id = 56), (SELECT address FROM account WHERE user_id = 56), (SELECT city FROM account WHERE user_id = 56), (SELECT state_province FROM account WHERE user_id = 56), (SELECT zip_post_code FROM account WHERE user_id = 56), 'USA', '9480288397702488441', 'MasterCard', '2012-12-20');
INSERT INTO lineitem VALUES(61, 1, 93, 1);
INSERT INTO orderstatus VALUES(61, 1, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 2, 166, 1);
INSERT INTO orderstatus VALUES(61, 2, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 3, 12, 1);
INSERT INTO orderstatus VALUES(61, 3, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 4, 24, 1);
INSERT INTO orderstatus VALUES(61, 4, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 5, 55, 2);
INSERT INTO orderstatus VALUES(61, 5, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 6, 2, 1);
INSERT INTO orderstatus VALUES(61, 6, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 7, 11, 1);
INSERT INTO orderstatus VALUES(61, 7, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 8, 36, 2);
INSERT INTO orderstatus VALUES(61, 8, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 9, 179, 1);
INSERT INTO orderstatus VALUES(61, 9, '2014-05-06', 'T');
INSERT INTO lineitem VALUES(61, 10, 52, 2);
INSERT INTO orderstatus VALUES(61, 10, '2014-05-06', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 61) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 61;

INSERT INTO orders VALUES(62, 28, '2014-08-26', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 28), (SELECT middle_name FROM account WHERE user_id = 28), (SELECT last_name FROM account WHERE user_id = 28), (SELECT address FROM account WHERE user_id = 28), (SELECT city FROM account WHERE user_id = 28), (SELECT state_province FROM account WHERE user_id = 28), (SELECT zip_post_code FROM account WHERE user_id = 28), 'USA', '6904683057131767599', 'American Express', '2010-09-20');
INSERT INTO lineitem VALUES(62, 1, 87, 1);
INSERT INTO orderstatus VALUES(62, 1, '2014-08-26', 'T');
INSERT INTO lineitem VALUES(62, 2, 139, 2);
INSERT INTO orderstatus VALUES(62, 2, '2014-08-26', 'T');
INSERT INTO lineitem VALUES(62, 3, 137, 2);
INSERT INTO orderstatus VALUES(62, 3, '2014-08-26', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 62) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 62;

INSERT INTO orders VALUES(63, 97, '2016-08-07', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 97), (SELECT middle_name FROM account WHERE user_id = 97), (SELECT last_name FROM account WHERE user_id = 97), (SELECT address FROM account WHERE user_id = 97), (SELECT city FROM account WHERE user_id = 97), (SELECT state_province FROM account WHERE user_id = 97), (SELECT zip_post_code FROM account WHERE user_id = 97), 'USA', '1785701067214525478', 'Visa', '2010-07-20');
INSERT INTO lineitem VALUES(63, 1, 106, 2);
INSERT INTO orderstatus VALUES(63, 1, '2016-08-07', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 63) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 63;

INSERT INTO orders VALUES(64, 3, '2014-02-06', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 3), (SELECT middle_name FROM account WHERE user_id = 3), (SELECT last_name FROM account WHERE user_id = 3), (SELECT address FROM account WHERE user_id = 3), (SELECT city FROM account WHERE user_id = 3), (SELECT state_province FROM account WHERE user_id = 3), (SELECT zip_post_code FROM account WHERE user_id = 3), 'USA', '1430530513997125171', 'American Express', '2011-02-13');
INSERT INTO lineitem VALUES(64, 1, 33, 2);
INSERT INTO orderstatus VALUES(64, 1, '2014-02-06', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 64) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 64;

INSERT INTO orders VALUES(65, 32, '2016-05-14', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 32), (SELECT middle_name FROM account WHERE user_id = 32), (SELECT last_name FROM account WHERE user_id = 32), (SELECT address FROM account WHERE user_id = 32), (SELECT city FROM account WHERE user_id = 32), (SELECT state_province FROM account WHERE user_id = 32), (SELECT zip_post_code FROM account WHERE user_id = 32), 'USA', '7706058392046404251', 'MasterCard', '2012-07-15');
INSERT INTO lineitem VALUES(65, 1, 198, 2);
INSERT INTO orderstatus VALUES(65, 1, '2016-05-14', 'T');
INSERT INTO lineitem VALUES(65, 2, 181, 1);
INSERT INTO orderstatus VALUES(65, 2, '2016-05-14', 'T');
INSERT INTO lineitem VALUES(65, 3, 41, 2);
INSERT INTO orderstatus VALUES(65, 3, '2016-05-14', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 65) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 65;

INSERT INTO orders VALUES(66, 42, '2016-01-21', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 42), (SELECT middle_name FROM account WHERE user_id = 42), (SELECT last_name FROM account WHERE user_id = 42), (SELECT address FROM account WHERE user_id = 42), (SELECT city FROM account WHERE user_id = 42), (SELECT state_province FROM account WHERE user_id = 42), (SELECT zip_post_code FROM account WHERE user_id = 42), 'USA', '7067155583255859993', 'MasterCard', '2010-02-04');
INSERT INTO lineitem VALUES(66, 1, 3, 1);
INSERT INTO orderstatus VALUES(66, 1, '2016-01-21', 'T');
INSERT INTO lineitem VALUES(66, 2, 191, 1);
INSERT INTO orderstatus VALUES(66, 2, '2016-01-21', 'T');
INSERT INTO lineitem VALUES(66, 3, 23, 2);
INSERT INTO orderstatus VALUES(66, 3, '2016-01-21', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 66) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 66;

INSERT INTO orders VALUES(67, 96, '2016-05-09', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 96), (SELECT middle_name FROM account WHERE user_id = 96), (SELECT last_name FROM account WHERE user_id = 96), (SELECT address FROM account WHERE user_id = 96), (SELECT city FROM account WHERE user_id = 96), (SELECT state_province FROM account WHERE user_id = 96), (SELECT zip_post_code FROM account WHERE user_id = 96), 'USA', '2024721162805193760', 'Visa', '2011-11-11');
INSERT INTO lineitem VALUES(67, 1, 137, 1);
INSERT INTO orderstatus VALUES(67, 1, '2016-05-09', 'T');
INSERT INTO lineitem VALUES(67, 2, 15, 2);
INSERT INTO orderstatus VALUES(67, 2, '2016-05-09', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 67) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 67;

INSERT INTO orders VALUES(68, 33, '2014-11-14', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 33), (SELECT middle_name FROM account WHERE user_id = 33), (SELECT last_name FROM account WHERE user_id = 33), (SELECT address FROM account WHERE user_id = 33), (SELECT city FROM account WHERE user_id = 33), (SELECT state_province FROM account WHERE user_id = 33), (SELECT zip_post_code FROM account WHERE user_id = 33), 'USA', '6705973607059007846', 'Visa', '2010-03-24');
INSERT INTO lineitem VALUES(68, 1, 78, 2);
INSERT INTO orderstatus VALUES(68, 1, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 2, 112, 2);
INSERT INTO orderstatus VALUES(68, 2, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 3, 11, 2);
INSERT INTO orderstatus VALUES(68, 3, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 4, 66, 2);
INSERT INTO orderstatus VALUES(68, 4, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 5, 4, 2);
INSERT INTO orderstatus VALUES(68, 5, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 6, 105, 1);
INSERT INTO orderstatus VALUES(68, 6, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 7, 50, 1);
INSERT INTO orderstatus VALUES(68, 7, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 8, 132, 1);
INSERT INTO orderstatus VALUES(68, 8, '2014-11-14', 'T');
INSERT INTO lineitem VALUES(68, 9, 56, 2);
INSERT INTO orderstatus VALUES(68, 9, '2014-11-14', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 68) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 68;

INSERT INTO orders VALUES(69, 86, '2016-07-01', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 86), (SELECT middle_name FROM account WHERE user_id = 86), (SELECT last_name FROM account WHERE user_id = 86), (SELECT address FROM account WHERE user_id = 86), (SELECT city FROM account WHERE user_id = 86), (SELECT state_province FROM account WHERE user_id = 86), (SELECT zip_post_code FROM account WHERE user_id = 86), 'USA', '5755268658349332588', 'Visa', '2010-06-04');
INSERT INTO lineitem VALUES(69, 1, 3, 2);
INSERT INTO orderstatus VALUES(69, 1, '2016-07-01', 'T');
INSERT INTO lineitem VALUES(69, 2, 125, 2);
INSERT INTO orderstatus VALUES(69, 2, '2016-07-01', 'T');
INSERT INTO lineitem VALUES(69, 3, 67, 1);
INSERT INTO orderstatus VALUES(69, 3, '2016-07-01', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 69) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 69;

INSERT INTO orders VALUES(70, 59, '2014-08-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 59), (SELECT middle_name FROM account WHERE user_id = 59), (SELECT last_name FROM account WHERE user_id = 59), (SELECT address FROM account WHERE user_id = 59), (SELECT city FROM account WHERE user_id = 59), (SELECT state_province FROM account WHERE user_id = 59), (SELECT zip_post_code FROM account WHERE user_id = 59), 'USA', '5133235319417944745', 'American Express', '2012-11-07');
INSERT INTO lineitem VALUES(70, 1, 8, 1);
INSERT INTO orderstatus VALUES(70, 1, '2014-08-18', 'T');
INSERT INTO lineitem VALUES(70, 2, 171, 2);
INSERT INTO orderstatus VALUES(70, 2, '2014-08-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 70) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 70;

INSERT INTO orders VALUES(71, 75, '2014-10-11', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 75), (SELECT middle_name FROM account WHERE user_id = 75), (SELECT last_name FROM account WHERE user_id = 75), (SELECT address FROM account WHERE user_id = 75), (SELECT city FROM account WHERE user_id = 75), (SELECT state_province FROM account WHERE user_id = 75), (SELECT zip_post_code FROM account WHERE user_id = 75), 'USA', '3542945178028566885', 'MasterCard', '2012-03-23');
INSERT INTO lineitem VALUES(71, 1, 61, 2);
INSERT INTO orderstatus VALUES(71, 1, '2014-10-11', 'T');
INSERT INTO lineitem VALUES(71, 2, 177, 1);
INSERT INTO orderstatus VALUES(71, 2, '2014-10-11', 'T');
INSERT INTO lineitem VALUES(71, 3, 182, 1);
INSERT INTO orderstatus VALUES(71, 3, '2014-10-11', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 71) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 71;

INSERT INTO orders VALUES(72, 7, '2015-09-28', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 7), (SELECT middle_name FROM account WHERE user_id = 7), (SELECT last_name FROM account WHERE user_id = 7), (SELECT address FROM account WHERE user_id = 7), (SELECT city FROM account WHERE user_id = 7), (SELECT state_province FROM account WHERE user_id = 7), (SELECT zip_post_code FROM account WHERE user_id = 7), 'USA', '3939032737325309975', 'Visa', '2011-11-01');
INSERT INTO lineitem VALUES(72, 1, 34, 2);
INSERT INTO orderstatus VALUES(72, 1, '2015-09-28', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 72) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 72;

INSERT INTO orders VALUES(73, 46, '2015-08-13', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 46), (SELECT middle_name FROM account WHERE user_id = 46), (SELECT last_name FROM account WHERE user_id = 46), (SELECT address FROM account WHERE user_id = 46), (SELECT city FROM account WHERE user_id = 46), (SELECT state_province FROM account WHERE user_id = 46), (SELECT zip_post_code FROM account WHERE user_id = 46), 'USA', '9455813064234497918', 'American Express', '2012-03-12');
INSERT INTO lineitem VALUES(73, 1, 110, 2);
INSERT INTO orderstatus VALUES(73, 1, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 2, 92, 1);
INSERT INTO orderstatus VALUES(73, 2, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 3, 25, 2);
INSERT INTO orderstatus VALUES(73, 3, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 4, 108, 2);
INSERT INTO orderstatus VALUES(73, 4, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 5, 126, 2);
INSERT INTO orderstatus VALUES(73, 5, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 6, 140, 2);
INSERT INTO orderstatus VALUES(73, 6, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 7, 58, 2);
INSERT INTO orderstatus VALUES(73, 7, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 8, 189, 2);
INSERT INTO orderstatus VALUES(73, 8, '2015-08-13', 'T');
INSERT INTO lineitem VALUES(73, 9, 153, 1);
INSERT INTO orderstatus VALUES(73, 9, '2015-08-13', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 73) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 73;

INSERT INTO orders VALUES(74, 41, '2015-09-07', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 41), (SELECT middle_name FROM account WHERE user_id = 41), (SELECT last_name FROM account WHERE user_id = 41), (SELECT address FROM account WHERE user_id = 41), (SELECT city FROM account WHERE user_id = 41), (SELECT state_province FROM account WHERE user_id = 41), (SELECT zip_post_code FROM account WHERE user_id = 41), 'USA', '5444963287669964308', 'Visa', '2012-03-25');
INSERT INTO lineitem VALUES(74, 1, 42, 2);
INSERT INTO orderstatus VALUES(74, 1, '2015-09-07', 'T');
INSERT INTO lineitem VALUES(74, 2, 119, 1);
INSERT INTO orderstatus VALUES(74, 2, '2015-09-07', 'T');
INSERT INTO lineitem VALUES(74, 3, 90, 2);
INSERT INTO orderstatus VALUES(74, 3, '2015-09-07', 'T');
INSERT INTO lineitem VALUES(74, 4, 128, 2);
INSERT INTO orderstatus VALUES(74, 4, '2015-09-07', 'T');
INSERT INTO lineitem VALUES(74, 5, 150, 1);
INSERT INTO orderstatus VALUES(74, 5, '2015-09-07', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 74) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 74;

INSERT INTO orders VALUES(75, 99, '2016-01-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 99), (SELECT middle_name FROM account WHERE user_id = 99), (SELECT last_name FROM account WHERE user_id = 99), (SELECT address FROM account WHERE user_id = 99), (SELECT city FROM account WHERE user_id = 99), (SELECT state_province FROM account WHERE user_id = 99), (SELECT zip_post_code FROM account WHERE user_id = 99), 'USA', '2411462876625340124', 'Visa', '2011-11-10');
INSERT INTO lineitem VALUES(75, 1, 41, 1);
INSERT INTO orderstatus VALUES(75, 1, '2016-01-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 75) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 75;

INSERT INTO orders VALUES(76, 7, '2015-11-29', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 7), (SELECT middle_name FROM account WHERE user_id = 7), (SELECT last_name FROM account WHERE user_id = 7), (SELECT address FROM account WHERE user_id = 7), (SELECT city FROM account WHERE user_id = 7), (SELECT state_province FROM account WHERE user_id = 7), (SELECT zip_post_code FROM account WHERE user_id = 7), 'USA', '7543180708944106867', 'American Express', '2012-01-12');
INSERT INTO lineitem VALUES(76, 1, 98, 1);
INSERT INTO orderstatus VALUES(76, 1, '2015-11-29', 'T');
INSERT INTO lineitem VALUES(76, 2, 3, 2);
INSERT INTO orderstatus VALUES(76, 2, '2015-11-29', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 76) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 76;

INSERT INTO orders VALUES(77, 17, '2014-12-11', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 17), (SELECT middle_name FROM account WHERE user_id = 17), (SELECT last_name FROM account WHERE user_id = 17), (SELECT address FROM account WHERE user_id = 17), (SELECT city FROM account WHERE user_id = 17), (SELECT state_province FROM account WHERE user_id = 17), (SELECT zip_post_code FROM account WHERE user_id = 17), 'USA', '6681325010441771347', 'American Express', '2012-09-12');
INSERT INTO lineitem VALUES(77, 1, 76, 2);
INSERT INTO orderstatus VALUES(77, 1, '2014-12-11', 'T');
INSERT INTO lineitem VALUES(77, 2, 174, 1);
INSERT INTO orderstatus VALUES(77, 2, '2014-12-11', 'T');
INSERT INTO lineitem VALUES(77, 3, 96, 2);
INSERT INTO orderstatus VALUES(77, 3, '2014-12-11', 'T');
INSERT INTO lineitem VALUES(77, 4, 58, 1);
INSERT INTO orderstatus VALUES(77, 4, '2014-12-11', 'T');
INSERT INTO lineitem VALUES(77, 5, 70, 1);
INSERT INTO orderstatus VALUES(77, 5, '2014-12-11', 'T');
INSERT INTO lineitem VALUES(77, 6, 76, 2);
INSERT INTO orderstatus VALUES(77, 6, '2014-12-11', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 77) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 77;

INSERT INTO orders VALUES(78, 89, '2015-10-29', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 89), (SELECT middle_name FROM account WHERE user_id = 89), (SELECT last_name FROM account WHERE user_id = 89), (SELECT address FROM account WHERE user_id = 89), (SELECT city FROM account WHERE user_id = 89), (SELECT state_province FROM account WHERE user_id = 89), (SELECT zip_post_code FROM account WHERE user_id = 89), 'USA', '8894491971429039627', 'American Express', '2010-10-20');
INSERT INTO lineitem VALUES(78, 1, 22, 2);
INSERT INTO orderstatus VALUES(78, 1, '2015-10-29', 'T');
INSERT INTO lineitem VALUES(78, 2, 71, 2);
INSERT INTO orderstatus VALUES(78, 2, '2015-10-29', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 78) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 78;

INSERT INTO orders VALUES(79, 52, '2016-02-25', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 52), (SELECT middle_name FROM account WHERE user_id = 52), (SELECT last_name FROM account WHERE user_id = 52), (SELECT address FROM account WHERE user_id = 52), (SELECT city FROM account WHERE user_id = 52), (SELECT state_province FROM account WHERE user_id = 52), (SELECT zip_post_code FROM account WHERE user_id = 52), 'USA', '6189421902684376068', 'American Express', '2010-04-23');
INSERT INTO lineitem VALUES(79, 1, 68, 2);
INSERT INTO orderstatus VALUES(79, 1, '2016-02-25', 'T');
INSERT INTO lineitem VALUES(79, 2, 24, 2);
INSERT INTO orderstatus VALUES(79, 2, '2016-02-25', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 79) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 79;

INSERT INTO orders VALUES(80, 8, '2015-11-06', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 8), (SELECT middle_name FROM account WHERE user_id = 8), (SELECT last_name FROM account WHERE user_id = 8), (SELECT address FROM account WHERE user_id = 8), (SELECT city FROM account WHERE user_id = 8), (SELECT state_province FROM account WHERE user_id = 8), (SELECT zip_post_code FROM account WHERE user_id = 8), 'USA', '4180777596793839932', 'American Express', '2012-12-31');
INSERT INTO lineitem VALUES(80, 1, 116, 1);
INSERT INTO orderstatus VALUES(80, 1, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 2, 138, 1);
INSERT INTO orderstatus VALUES(80, 2, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 3, 97, 1);
INSERT INTO orderstatus VALUES(80, 3, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 4, 185, 1);
INSERT INTO orderstatus VALUES(80, 4, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 5, 125, 2);
INSERT INTO orderstatus VALUES(80, 5, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 6, 35, 2);
INSERT INTO orderstatus VALUES(80, 6, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 7, 45, 1);
INSERT INTO orderstatus VALUES(80, 7, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 8, 90, 2);
INSERT INTO orderstatus VALUES(80, 8, '2015-11-06', 'T');
INSERT INTO lineitem VALUES(80, 9, 87, 2);
INSERT INTO orderstatus VALUES(80, 9, '2015-11-06', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 80) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 80;

INSERT INTO orders VALUES(81, 45, '2015-03-22', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 45), (SELECT middle_name FROM account WHERE user_id = 45), (SELECT last_name FROM account WHERE user_id = 45), (SELECT address FROM account WHERE user_id = 45), (SELECT city FROM account WHERE user_id = 45), (SELECT state_province FROM account WHERE user_id = 45), (SELECT zip_post_code FROM account WHERE user_id = 45), 'USA', '4271518707720407590', 'MasterCard', '2012-10-25');
INSERT INTO lineitem VALUES(81, 1, 54, 2);
INSERT INTO orderstatus VALUES(81, 1, '2015-03-22', 'T');
INSERT INTO lineitem VALUES(81, 2, 20, 1);
INSERT INTO orderstatus VALUES(81, 2, '2015-03-22', 'T');
INSERT INTO lineitem VALUES(81, 3, 127, 1);
INSERT INTO orderstatus VALUES(81, 3, '2015-03-22', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 81) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 81;

INSERT INTO orders VALUES(82, 79, '2015-09-23', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 79), (SELECT middle_name FROM account WHERE user_id = 79), (SELECT last_name FROM account WHERE user_id = 79), (SELECT address FROM account WHERE user_id = 79), (SELECT city FROM account WHERE user_id = 79), (SELECT state_province FROM account WHERE user_id = 79), (SELECT zip_post_code FROM account WHERE user_id = 79), 'USA', '4746699291794820711', 'Visa', '2011-08-24');
INSERT INTO lineitem VALUES(82, 1, 50, 1);
INSERT INTO orderstatus VALUES(82, 1, '2015-09-23', 'T');
INSERT INTO lineitem VALUES(82, 2, 113, 2);
INSERT INTO orderstatus VALUES(82, 2, '2015-09-23', 'T');
INSERT INTO lineitem VALUES(82, 3, 95, 2);
INSERT INTO orderstatus VALUES(82, 3, '2015-09-23', 'T');
INSERT INTO lineitem VALUES(82, 4, 190, 2);
INSERT INTO orderstatus VALUES(82, 4, '2015-09-23', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 82) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 82;

INSERT INTO orders VALUES(83, 70, '2015-09-29', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 70), (SELECT middle_name FROM account WHERE user_id = 70), (SELECT last_name FROM account WHERE user_id = 70), (SELECT address FROM account WHERE user_id = 70), (SELECT city FROM account WHERE user_id = 70), (SELECT state_province FROM account WHERE user_id = 70), (SELECT zip_post_code FROM account WHERE user_id = 70), 'USA', '3948130095187644698', 'American Express', '2012-04-25');
INSERT INTO lineitem VALUES(83, 1, 63, 2);
INSERT INTO orderstatus VALUES(83, 1, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 2, 147, 2);
INSERT INTO orderstatus VALUES(83, 2, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 3, 140, 1);
INSERT INTO orderstatus VALUES(83, 3, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 4, 194, 2);
INSERT INTO orderstatus VALUES(83, 4, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 5, 24, 2);
INSERT INTO orderstatus VALUES(83, 5, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 6, 20, 1);
INSERT INTO orderstatus VALUES(83, 6, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 7, 37, 2);
INSERT INTO orderstatus VALUES(83, 7, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 8, 42, 2);
INSERT INTO orderstatus VALUES(83, 8, '2015-09-29', 'T');
INSERT INTO lineitem VALUES(83, 9, 28, 1);
INSERT INTO orderstatus VALUES(83, 9, '2015-09-29', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 83) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 83;

INSERT INTO orders VALUES(84, 99, '2015-10-13', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 99), (SELECT middle_name FROM account WHERE user_id = 99), (SELECT last_name FROM account WHERE user_id = 99), (SELECT address FROM account WHERE user_id = 99), (SELECT city FROM account WHERE user_id = 99), (SELECT state_province FROM account WHERE user_id = 99), (SELECT zip_post_code FROM account WHERE user_id = 99), 'USA', '7214201747789993716', 'Visa', '2010-08-14');
INSERT INTO lineitem VALUES(84, 1, 134, 1);
INSERT INTO orderstatus VALUES(84, 1, '2015-10-13', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 84) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 84;

INSERT INTO orders VALUES(85, 31, '2014-07-14', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 31), (SELECT middle_name FROM account WHERE user_id = 31), (SELECT last_name FROM account WHERE user_id = 31), (SELECT address FROM account WHERE user_id = 31), (SELECT city FROM account WHERE user_id = 31), (SELECT state_province FROM account WHERE user_id = 31), (SELECT zip_post_code FROM account WHERE user_id = 31), 'USA', '4709376895945144910', 'Visa', '2012-12-18');
INSERT INTO lineitem VALUES(85, 1, 67, 2);
INSERT INTO orderstatus VALUES(85, 1, '2014-07-14', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 85) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 85;

INSERT INTO orders VALUES(86, 82, '2014-04-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 82), (SELECT middle_name FROM account WHERE user_id = 82), (SELECT last_name FROM account WHERE user_id = 82), (SELECT address FROM account WHERE user_id = 82), (SELECT city FROM account WHERE user_id = 82), (SELECT state_province FROM account WHERE user_id = 82), (SELECT zip_post_code FROM account WHERE user_id = 82), 'USA', '7436575207206554484', 'American Express', '2011-02-24');
INSERT INTO lineitem VALUES(86, 1, 46, 2);
INSERT INTO orderstatus VALUES(86, 1, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 2, 7, 2);
INSERT INTO orderstatus VALUES(86, 2, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 3, 17, 2);
INSERT INTO orderstatus VALUES(86, 3, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 4, 153, 1);
INSERT INTO orderstatus VALUES(86, 4, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 5, 156, 1);
INSERT INTO orderstatus VALUES(86, 5, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 6, 82, 1);
INSERT INTO orderstatus VALUES(86, 6, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 7, 185, 1);
INSERT INTO orderstatus VALUES(86, 7, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 8, 10, 1);
INSERT INTO orderstatus VALUES(86, 8, '2014-04-19', 'T');
INSERT INTO lineitem VALUES(86, 9, 170, 2);
INSERT INTO orderstatus VALUES(86, 9, '2014-04-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 86) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 86;

INSERT INTO orders VALUES(87, 33, '2014-11-11', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 33), (SELECT middle_name FROM account WHERE user_id = 33), (SELECT last_name FROM account WHERE user_id = 33), (SELECT address FROM account WHERE user_id = 33), (SELECT city FROM account WHERE user_id = 33), (SELECT state_province FROM account WHERE user_id = 33), (SELECT zip_post_code FROM account WHERE user_id = 33), 'USA', '4492243991931643802', 'Visa', '2011-10-25');
INSERT INTO lineitem VALUES(87, 1, 84, 2);
INSERT INTO orderstatus VALUES(87, 1, '2014-11-11', 'T');
INSERT INTO lineitem VALUES(87, 2, 130, 2);
INSERT INTO orderstatus VALUES(87, 2, '2014-11-11', 'T');
INSERT INTO lineitem VALUES(87, 3, 183, 2);
INSERT INTO orderstatus VALUES(87, 3, '2014-11-11', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 87) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 87;

INSERT INTO orders VALUES(88, 32, '2014-06-20', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 32), (SELECT middle_name FROM account WHERE user_id = 32), (SELECT last_name FROM account WHERE user_id = 32), (SELECT address FROM account WHERE user_id = 32), (SELECT city FROM account WHERE user_id = 32), (SELECT state_province FROM account WHERE user_id = 32), (SELECT zip_post_code FROM account WHERE user_id = 32), 'USA', '7945868494750343499', 'Visa', '2011-12-28');
INSERT INTO lineitem VALUES(88, 1, 45, 2);
INSERT INTO orderstatus VALUES(88, 1, '2014-06-20', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 88) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 88;

INSERT INTO orders VALUES(89, 57, '2014-10-14', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 57), (SELECT middle_name FROM account WHERE user_id = 57), (SELECT last_name FROM account WHERE user_id = 57), (SELECT address FROM account WHERE user_id = 57), (SELECT city FROM account WHERE user_id = 57), (SELECT state_province FROM account WHERE user_id = 57), (SELECT zip_post_code FROM account WHERE user_id = 57), 'USA', '4818010807262924269', 'MasterCard', '2011-11-21');
INSERT INTO lineitem VALUES(89, 1, 148, 1);
INSERT INTO orderstatus VALUES(89, 1, '2014-10-14', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 89) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 89;

INSERT INTO orders VALUES(90, 14, '2016-06-28', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 14), (SELECT middle_name FROM account WHERE user_id = 14), (SELECT last_name FROM account WHERE user_id = 14), (SELECT address FROM account WHERE user_id = 14), (SELECT city FROM account WHERE user_id = 14), (SELECT state_province FROM account WHERE user_id = 14), (SELECT zip_post_code FROM account WHERE user_id = 14), 'USA', '1533864733870741506', 'Visa', '2010-09-19');
INSERT INTO lineitem VALUES(90, 1, 98, 2);
INSERT INTO orderstatus VALUES(90, 1, '2016-06-28', 'T');
INSERT INTO lineitem VALUES(90, 2, 15, 1);
INSERT INTO orderstatus VALUES(90, 2, '2016-06-28', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 90) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 90;

INSERT INTO orders VALUES(91, 7, '2014-12-12', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 7), (SELECT middle_name FROM account WHERE user_id = 7), (SELECT last_name FROM account WHERE user_id = 7), (SELECT address FROM account WHERE user_id = 7), (SELECT city FROM account WHERE user_id = 7), (SELECT state_province FROM account WHERE user_id = 7), (SELECT zip_post_code FROM account WHERE user_id = 7), 'USA', '7956058845956323804', 'American Express', '2010-03-21');
INSERT INTO lineitem VALUES(91, 1, 63, 2);
INSERT INTO orderstatus VALUES(91, 1, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 2, 130, 1);
INSERT INTO orderstatus VALUES(91, 2, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 3, 100, 2);
INSERT INTO orderstatus VALUES(91, 3, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 4, 80, 2);
INSERT INTO orderstatus VALUES(91, 4, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 5, 163, 1);
INSERT INTO orderstatus VALUES(91, 5, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 6, 4, 1);
INSERT INTO orderstatus VALUES(91, 6, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 7, 115, 1);
INSERT INTO orderstatus VALUES(91, 7, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 8, 55, 1);
INSERT INTO orderstatus VALUES(91, 8, '2014-12-12', 'T');
INSERT INTO lineitem VALUES(91, 9, 63, 1);
INSERT INTO orderstatus VALUES(91, 9, '2014-12-12', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 91) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 91;

INSERT INTO orders VALUES(92, 45, '2014-11-06', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 45), (SELECT middle_name FROM account WHERE user_id = 45), (SELECT last_name FROM account WHERE user_id = 45), (SELECT address FROM account WHERE user_id = 45), (SELECT city FROM account WHERE user_id = 45), (SELECT state_province FROM account WHERE user_id = 45), (SELECT zip_post_code FROM account WHERE user_id = 45), 'USA', '3986098476035923233', 'Visa', '2012-04-18');
INSERT INTO lineitem VALUES(92, 1, 152, 2);
INSERT INTO orderstatus VALUES(92, 1, '2014-11-06', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 92) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 92;

INSERT INTO orders VALUES(93, 60, '2016-09-28', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 60), (SELECT middle_name FROM account WHERE user_id = 60), (SELECT last_name FROM account WHERE user_id = 60), (SELECT address FROM account WHERE user_id = 60), (SELECT city FROM account WHERE user_id = 60), (SELECT state_province FROM account WHERE user_id = 60), (SELECT zip_post_code FROM account WHERE user_id = 60), 'USA', '8519379899257339713', 'Visa', '2012-12-16');
INSERT INTO lineitem VALUES(93, 1, 176, 1);
INSERT INTO orderstatus VALUES(93, 1, '2016-09-28', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 93) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 93;

INSERT INTO orders VALUES(94, 26, '2016-02-07', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 26), (SELECT middle_name FROM account WHERE user_id = 26), (SELECT last_name FROM account WHERE user_id = 26), (SELECT address FROM account WHERE user_id = 26), (SELECT city FROM account WHERE user_id = 26), (SELECT state_province FROM account WHERE user_id = 26), (SELECT zip_post_code FROM account WHERE user_id = 26), 'USA', '3467730410151042835', 'MasterCard', '2011-12-13');
INSERT INTO lineitem VALUES(94, 1, 172, 2);
INSERT INTO orderstatus VALUES(94, 1, '2016-02-07', 'T');
INSERT INTO lineitem VALUES(94, 2, 40, 1);
INSERT INTO orderstatus VALUES(94, 2, '2016-02-07', 'T');
INSERT INTO lineitem VALUES(94, 3, 167, 1);
INSERT INTO orderstatus VALUES(94, 3, '2016-02-07', 'T');
INSERT INTO lineitem VALUES(94, 4, 173, 1);
INSERT INTO orderstatus VALUES(94, 4, '2016-02-07', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 94) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 94;

INSERT INTO orders VALUES(95, 14, '2015-02-16', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 14), (SELECT middle_name FROM account WHERE user_id = 14), (SELECT last_name FROM account WHERE user_id = 14), (SELECT address FROM account WHERE user_id = 14), (SELECT city FROM account WHERE user_id = 14), (SELECT state_province FROM account WHERE user_id = 14), (SELECT zip_post_code FROM account WHERE user_id = 14), 'USA', '2912025287317795448', 'American Express', '2010-05-09');
INSERT INTO lineitem VALUES(95, 1, 55, 2);
INSERT INTO orderstatus VALUES(95, 1, '2015-02-16', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 95) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 95;

INSERT INTO orders VALUES(96, 37, '2015-08-03', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 37), (SELECT middle_name FROM account WHERE user_id = 37), (SELECT last_name FROM account WHERE user_id = 37), (SELECT address FROM account WHERE user_id = 37), (SELECT city FROM account WHERE user_id = 37), (SELECT state_province FROM account WHERE user_id = 37), (SELECT zip_post_code FROM account WHERE user_id = 37), 'USA', '3755952060208843257', 'American Express', '2010-09-29');
INSERT INTO lineitem VALUES(96, 1, 106, 1);
INSERT INTO orderstatus VALUES(96, 1, '2015-08-03', 'T');
INSERT INTO lineitem VALUES(96, 2, 50, 2);
INSERT INTO orderstatus VALUES(96, 2, '2015-08-03', 'T');
INSERT INTO lineitem VALUES(96, 3, 154, 1);
INSERT INTO orderstatus VALUES(96, 3, '2015-08-03', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 96) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 96;

INSERT INTO orders VALUES(97, 51, '2014-07-09', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 51), (SELECT middle_name FROM account WHERE user_id = 51), (SELECT last_name FROM account WHERE user_id = 51), (SELECT address FROM account WHERE user_id = 51), (SELECT city FROM account WHERE user_id = 51), (SELECT state_province FROM account WHERE user_id = 51), (SELECT zip_post_code FROM account WHERE user_id = 51), 'USA', '8760722811538564852', 'Visa', '2010-08-25');
INSERT INTO lineitem VALUES(97, 1, 38, 2);
INSERT INTO orderstatus VALUES(97, 1, '2014-07-09', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 97) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 97;

INSERT INTO orders VALUES(98, 7, '2014-01-21', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 7), (SELECT middle_name FROM account WHERE user_id = 7), (SELECT last_name FROM account WHERE user_id = 7), (SELECT address FROM account WHERE user_id = 7), (SELECT city FROM account WHERE user_id = 7), (SELECT state_province FROM account WHERE user_id = 7), (SELECT zip_post_code FROM account WHERE user_id = 7), 'USA', '7824812681789020113', 'American Express', '2012-01-12');
INSERT INTO lineitem VALUES(98, 1, 98, 1);
INSERT INTO orderstatus VALUES(98, 1, '2014-01-21', 'T');
INSERT INTO lineitem VALUES(98, 2, 12, 2);
INSERT INTO orderstatus VALUES(98, 2, '2014-01-21', 'T');
INSERT INTO lineitem VALUES(98, 3, 54, 1);
INSERT INTO orderstatus VALUES(98, 3, '2014-01-21', 'T');
INSERT INTO lineitem VALUES(98, 4, 148, 1);
INSERT INTO orderstatus VALUES(98, 4, '2014-01-21', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 98) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 98;

INSERT INTO orders VALUES(99, 18, '2014-09-27', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 18), (SELECT middle_name FROM account WHERE user_id = 18), (SELECT last_name FROM account WHERE user_id = 18), (SELECT address FROM account WHERE user_id = 18), (SELECT city FROM account WHERE user_id = 18), (SELECT state_province FROM account WHERE user_id = 18), (SELECT zip_post_code FROM account WHERE user_id = 18), 'USA', '1483435534223454393', 'MasterCard', '2012-09-07');
INSERT INTO lineitem VALUES(99, 1, 89, 1);
INSERT INTO orderstatus VALUES(99, 1, '2014-09-27', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 99) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 99;

INSERT INTO orders VALUES(100, 74, '2015-03-23', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 74), (SELECT middle_name FROM account WHERE user_id = 74), (SELECT last_name FROM account WHERE user_id = 74), (SELECT address FROM account WHERE user_id = 74), (SELECT city FROM account WHERE user_id = 74), (SELECT state_province FROM account WHERE user_id = 74), (SELECT zip_post_code FROM account WHERE user_id = 74), 'USA', '2968623931109183930', 'American Express', '2011-09-08');
INSERT INTO lineitem VALUES(100, 1, 11, 2);
INSERT INTO orderstatus VALUES(100, 1, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 2, 30, 2);
INSERT INTO orderstatus VALUES(100, 2, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 3, 25, 2);
INSERT INTO orderstatus VALUES(100, 3, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 4, 103, 1);
INSERT INTO orderstatus VALUES(100, 4, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 5, 196, 1);

INSERT INTO orderstatus VALUES(100, 5, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 6, 162, 2);
INSERT INTO orderstatus VALUES(100, 6, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 7, 68, 1);
INSERT INTO orderstatus VALUES(100, 7, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 8, 70, 1);
INSERT INTO orderstatus VALUES(100, 8, '2015-03-23', 'T');
INSERT INTO lineitem VALUES(100, 9, 193, 1);
INSERT INTO orderstatus VALUES(100, 9, '2015-03-23', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 100) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 100;

INSERT INTO orders VALUES(101, 86, '2016-02-29', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 86), (SELECT middle_name FROM account WHERE user_id = 86), (SELECT last_name FROM account WHERE user_id = 86), (SELECT address FROM account WHERE user_id = 86), (SELECT city FROM account WHERE user_id = 86), (SELECT state_province FROM account WHERE user_id = 86), (SELECT zip_post_code FROM account WHERE user_id = 86), 'USA', '7910703009312685893', 'American Express', '2010-02-27');
INSERT INTO lineitem VALUES(101, 1, 169, 1);
INSERT INTO orderstatus VALUES(101, 1, '2016-02-29', 'T');
INSERT INTO lineitem VALUES(101, 2, 43, 2);
INSERT INTO orderstatus VALUES(101, 2, '2016-02-29', 'T');
INSERT INTO lineitem VALUES(101, 3, 9, 1);
INSERT INTO orderstatus VALUES(101, 3, '2016-02-29', 'T');
INSERT INTO lineitem VALUES(101, 4, 19, 2);
INSERT INTO orderstatus VALUES(101, 4, '2016-02-29', 'T');
INSERT INTO lineitem VALUES(101, 5, 27, 1);
INSERT INTO orderstatus VALUES(101, 5, '2016-02-29', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 101) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 101;

INSERT INTO orders VALUES(102, 16, '2015-06-26', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 16), (SELECT middle_name FROM account WHERE user_id = 16), (SELECT last_name FROM account WHERE user_id = 16), (SELECT address FROM account WHERE user_id = 16), (SELECT city FROM account WHERE user_id = 16), (SELECT state_province FROM account WHERE user_id = 16), (SELECT zip_post_code FROM account WHERE user_id = 16), 'USA', '1005669713308444909', 'American Express', '2011-11-29');
INSERT INTO lineitem VALUES(102, 1, 56, 1);
INSERT INTO orderstatus VALUES(102, 1, '2015-06-26', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 102) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 102;

INSERT INTO orders VALUES(103, 23, '2016-01-09', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 23), (SELECT middle_name FROM account WHERE user_id = 23), (SELECT last_name FROM account WHERE user_id = 23), (SELECT address FROM account WHERE user_id = 23), (SELECT city FROM account WHERE user_id = 23), (SELECT state_province FROM account WHERE user_id = 23), (SELECT zip_post_code FROM account WHERE user_id = 23), 'USA', '2634846253477546508', 'MasterCard', '2012-03-02');
INSERT INTO lineitem VALUES(103, 1, 124, 1);
INSERT INTO orderstatus VALUES(103, 1, '2016-01-09', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 103) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 103;

INSERT INTO orders VALUES(104, 88, '2014-05-27', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 88), (SELECT middle_name FROM account WHERE user_id = 88), (SELECT last_name FROM account WHERE user_id = 88), (SELECT address FROM account WHERE user_id = 88), (SELECT city FROM account WHERE user_id = 88), (SELECT state_province FROM account WHERE user_id = 88), (SELECT zip_post_code FROM account WHERE user_id = 88), 'USA', '6880441813513879953', 'Visa', '2011-05-20');
INSERT INTO lineitem VALUES(104, 1, 173, 2);
INSERT INTO orderstatus VALUES(104, 1, '2014-05-27', 'T');
INSERT INTO lineitem VALUES(104, 2, 16, 1);
INSERT INTO orderstatus VALUES(104, 2, '2014-05-27', 'T');
INSERT INTO lineitem VALUES(104, 3, 136, 2);
INSERT INTO orderstatus VALUES(104, 3, '2014-05-27', 'T');
INSERT INTO lineitem VALUES(104, 4, 166, 2);
INSERT INTO orderstatus VALUES(104, 4, '2014-05-27', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 104) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 104;

INSERT INTO orders VALUES(105, 18, '2016-08-05', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 18), (SELECT middle_name FROM account WHERE user_id = 18), (SELECT last_name FROM account WHERE user_id = 18), (SELECT address FROM account WHERE user_id = 18), (SELECT city FROM account WHERE user_id = 18), (SELECT state_province FROM account WHERE user_id = 18), (SELECT zip_post_code FROM account WHERE user_id = 18), 'USA', '5004332494911494201', 'MasterCard', '2012-10-22');
INSERT INTO lineitem VALUES(105, 1, 68, 1);
INSERT INTO orderstatus VALUES(105, 1, '2016-08-05', 'T');
INSERT INTO lineitem VALUES(105, 2, 40, 1);
INSERT INTO orderstatus VALUES(105, 2, '2016-08-05', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 105) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 105;

INSERT INTO orders VALUES(106, 66, '2014-09-30', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 66), (SELECT middle_name FROM account WHERE user_id = 66), (SELECT last_name FROM account WHERE user_id = 66), (SELECT address FROM account WHERE user_id = 66), (SELECT city FROM account WHERE user_id = 66), (SELECT state_province FROM account WHERE user_id = 66), (SELECT zip_post_code FROM account WHERE user_id = 66), 'USA', '6561604440254589119', 'MasterCard', '2011-09-06');
INSERT INTO lineitem VALUES(106, 1, 52, 2);
INSERT INTO orderstatus VALUES(106, 1, '2014-09-30', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 106) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 106;

INSERT INTO orders VALUES(107, 83, '2015-10-26', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 83), (SELECT middle_name FROM account WHERE user_id = 83), (SELECT last_name FROM account WHERE user_id = 83), (SELECT address FROM account WHERE user_id = 83), (SELECT city FROM account WHERE user_id = 83), (SELECT state_province FROM account WHERE user_id = 83), (SELECT zip_post_code FROM account WHERE user_id = 83), 'USA', '2608008976199416649', 'American Express', '2018-06-30');
INSERT INTO lineitem VALUES(107, 1, 114, 1);
INSERT INTO orderstatus VALUES(107, 1, '2015-10-26', 'T');
INSERT INTO lineitem VALUES(107, 2, 75, 2);
INSERT INTO orderstatus VALUES(107, 2, '2015-10-26', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 107) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 107;

INSERT INTO orders VALUES(108, 63, '2015-07-16', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 63), (SELECT middle_name FROM account WHERE user_id = 63), (SELECT last_name FROM account WHERE user_id = 63), (SELECT address FROM account WHERE user_id = 63), (SELECT city FROM account WHERE user_id = 63), (SELECT state_province FROM account WHERE user_id = 63), (SELECT zip_post_code FROM account WHERE user_id = 63), 'USA', '2450550723970845858', 'American Express', '2018-10-03');
INSERT INTO lineitem VALUES(108, 1, 21, 1);
INSERT INTO orderstatus VALUES(108, 1, '2015-07-16', 'T');
INSERT INTO lineitem VALUES(108, 2, 193, 2);
INSERT INTO orderstatus VALUES(108, 2, '2015-07-16', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 108) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 108;

INSERT INTO orders VALUES(109, 64, '2016-07-31', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 64), (SELECT middle_name FROM account WHERE user_id = 64), (SELECT last_name FROM account WHERE user_id = 64), (SELECT address FROM account WHERE user_id = 64), (SELECT city FROM account WHERE user_id = 64), (SELECT state_province FROM account WHERE user_id = 64), (SELECT zip_post_code FROM account WHERE user_id = 64), 'USA', '2368749702626028630', 'Visa', '2017-02-20');
INSERT INTO lineitem VALUES(109, 1, 170, 1);
INSERT INTO orderstatus VALUES(109, 1, '2016-07-31', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 109) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 109;

INSERT INTO orders VALUES(110, 76, '2016-10-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 76), (SELECT middle_name FROM account WHERE user_id = 76), (SELECT last_name FROM account WHERE user_id = 76), (SELECT address FROM account WHERE user_id = 76), (SELECT city FROM account WHERE user_id = 76), (SELECT state_province FROM account WHERE user_id = 76), (SELECT zip_post_code FROM account WHERE user_id = 76), 'USA', '4153150084540083202', 'American Express', '2016-12-30');
INSERT INTO lineitem VALUES(110, 1, 114, 1);
INSERT INTO orderstatus VALUES(110, 1, '2016-10-19', 'T');
INSERT INTO lineitem VALUES(110, 2, 64, 2);
INSERT INTO orderstatus VALUES(110, 2, '2016-10-19', 'T');
INSERT INTO lineitem VALUES(110, 3, 53, 1);
INSERT INTO orderstatus VALUES(110, 3, '2016-10-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 110) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 110;

INSERT INTO orders VALUES(111, 99, '2014-02-26', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 99), (SELECT middle_name FROM account WHERE user_id = 99), (SELECT last_name FROM account WHERE user_id = 99), (SELECT address FROM account WHERE user_id = 99), (SELECT city FROM account WHERE user_id = 99), (SELECT state_province FROM account WHERE user_id = 99), (SELECT zip_post_code FROM account WHERE user_id = 99), 'USA', '8406937806058821594', 'Visa', '2018-08-13');
INSERT INTO lineitem VALUES(111, 1, 87, 2);
INSERT INTO orderstatus VALUES(111, 1, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 2, 175, 2);
INSERT INTO orderstatus VALUES(111, 2, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 3, 1, 2);
INSERT INTO orderstatus VALUES(111, 3, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 4, 125, 1);
INSERT INTO orderstatus VALUES(111, 4, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 5, 191, 1);
INSERT INTO orderstatus VALUES(111, 5, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 6, 131, 2);
INSERT INTO orderstatus VALUES(111, 6, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 7, 20, 1);
INSERT INTO orderstatus VALUES(111, 7, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 8, 118, 2);
INSERT INTO orderstatus VALUES(111, 8, '2014-02-26', 'T');
INSERT INTO lineitem VALUES(111, 9, 25, 1);
INSERT INTO orderstatus VALUES(111, 9, '2014-02-26', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 111) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 111;

INSERT INTO orders VALUES(112, 48, '2014-05-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 48), (SELECT middle_name FROM account WHERE user_id = 48), (SELECT last_name FROM account WHERE user_id = 48), (SELECT address FROM account WHERE user_id = 48), (SELECT city FROM account WHERE user_id = 48), (SELECT state_province FROM account WHERE user_id = 48), (SELECT zip_post_code FROM account WHERE user_id = 48), 'USA', '3819551613014044303', 'MasterCard', '2018-07-16');
INSERT INTO lineitem VALUES(112, 1, 78, 1);
INSERT INTO orderstatus VALUES(112, 1, '2014-05-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 112) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 112;

INSERT INTO orders VALUES(113, 78, '2016-04-28', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 78), (SELECT middle_name FROM account WHERE user_id = 78), (SELECT last_name FROM account WHERE user_id = 78), (SELECT address FROM account WHERE user_id = 78), (SELECT city FROM account WHERE user_id = 78), (SELECT state_province FROM account WHERE user_id = 78), (SELECT zip_post_code FROM account WHERE user_id = 78), 'USA', '9179145724582152558', 'MasterCard', '2017-08-30');
INSERT INTO lineitem VALUES(113, 1, 94, 2);
INSERT INTO orderstatus VALUES(113, 1, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 2, 133, 2);
INSERT INTO orderstatus VALUES(113, 2, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 3, 115, 2);
INSERT INTO orderstatus VALUES(113, 3, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 4, 75, 1);
INSERT INTO orderstatus VALUES(113, 4, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 5, 64, 1);
INSERT INTO orderstatus VALUES(113, 5, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 6, 102, 1);
INSERT INTO orderstatus VALUES(113, 6, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 7, 142, 2);
INSERT INTO orderstatus VALUES(113, 7, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 8, 96, 2);
INSERT INTO orderstatus VALUES(113, 8, '2016-04-28', 'T');
INSERT INTO lineitem VALUES(113, 9, 196, 2);
INSERT INTO orderstatus VALUES(113, 9, '2016-04-28', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 113) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 113;

INSERT INTO orders VALUES(114, 97, '2015-02-22', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 97), (SELECT middle_name FROM account WHERE user_id = 97), (SELECT last_name FROM account WHERE user_id = 97), (SELECT address FROM account WHERE user_id = 97), (SELECT city FROM account WHERE user_id = 97), (SELECT state_province FROM account WHERE user_id = 97), (SELECT zip_post_code FROM account WHERE user_id = 97), 'USA', '8748010015280156504', 'MasterCard', '2016-12-13');
INSERT INTO lineitem VALUES(114, 1, 162, 2);
INSERT INTO orderstatus VALUES(114, 1, '2015-02-22', 'T');
INSERT INTO lineitem VALUES(114, 2, 94, 1);
INSERT INTO orderstatus VALUES(114, 2, '2015-02-22', 'T');
INSERT INTO lineitem VALUES(114, 3, 90, 1);
INSERT INTO orderstatus VALUES(114, 3, '2015-02-22', 'T');
INSERT INTO lineitem VALUES(114, 4, 186, 1);
INSERT INTO orderstatus VALUES(114, 4, '2015-02-22', 'T');
INSERT INTO lineitem VALUES(114, 5, 124, 1);
INSERT INTO orderstatus VALUES(114, 5, '2015-02-22', 'T');
INSERT INTO lineitem VALUES(114, 6, 97, 1);
INSERT INTO orderstatus VALUES(114, 6, '2015-02-22', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 114) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 114;

INSERT INTO orders VALUES(115, 75, '2014-03-27', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 75), (SELECT middle_name FROM account WHERE user_id = 75), (SELECT last_name FROM account WHERE user_id = 75), (SELECT address FROM account WHERE user_id = 75), (SELECT city FROM account WHERE user_id = 75), (SELECT state_province FROM account WHERE user_id = 75), (SELECT zip_post_code FROM account WHERE user_id = 75), 'USA', '8579734622078080959', 'MasterCard', '2018-09-12');
INSERT INTO lineitem VALUES(115, 1, 122, 1);
INSERT INTO orderstatus VALUES(115, 1, '2014-03-27', 'T');
INSERT INTO lineitem VALUES(115, 2, 128, 2);
INSERT INTO orderstatus VALUES(115, 2, '2014-03-27', 'T');
INSERT INTO lineitem VALUES(115, 3, 198, 1);
INSERT INTO orderstatus VALUES(115, 3, '2014-03-27', 'T');
INSERT INTO lineitem VALUES(115, 4, 89, 2);
INSERT INTO orderstatus VALUES(115, 4, '2014-03-27', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 115) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 115;

INSERT INTO orders VALUES(116, 22, '2014-02-22', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 22), (SELECT middle_name FROM account WHERE user_id = 22), (SELECT last_name FROM account WHERE user_id = 22), (SELECT address FROM account WHERE user_id = 22), (SELECT city FROM account WHERE user_id = 22), (SELECT state_province FROM account WHERE user_id = 22), (SELECT zip_post_code FROM account WHERE user_id = 22), 'USA', '7664359098282362281', 'MasterCard', '2017-06-12');
INSERT INTO lineitem VALUES(116, 1, 175, 2);
INSERT INTO orderstatus VALUES(116, 1, '2014-02-22', 'T');
INSERT INTO lineitem VALUES(116, 2, 114, 1);
INSERT INTO orderstatus VALUES(116, 2, '2014-02-22', 'T');
INSERT INTO lineitem VALUES(116, 3, 138, 2);
INSERT INTO orderstatus VALUES(116, 3, '2014-02-22', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 116) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 116;

INSERT INTO orders VALUES(117, 48, '2015-05-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 48), (SELECT middle_name FROM account WHERE user_id = 48), (SELECT last_name FROM account WHERE user_id = 48), (SELECT address FROM account WHERE user_id = 48), (SELECT city FROM account WHERE user_id = 48), (SELECT state_province FROM account WHERE user_id = 48), (SELECT zip_post_code FROM account WHERE user_id = 48), 'USA', '9510391622408627780', 'Visa', '2017-11-17');
INSERT INTO lineitem VALUES(117, 1, 51, 1);
INSERT INTO orderstatus VALUES(117, 1, '2015-05-15', 'T');
INSERT INTO lineitem VALUES(117, 2, 50, 2);
INSERT INTO orderstatus VALUES(117, 2, '2015-05-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 117) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 117;

INSERT INTO orders VALUES(118, 97, '2014-08-14', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 97), (SELECT middle_name FROM account WHERE user_id = 97), (SELECT last_name FROM account WHERE user_id = 97), (SELECT address FROM account WHERE user_id = 97), (SELECT city FROM account WHERE user_id = 97), (SELECT state_province FROM account WHERE user_id = 97), (SELECT zip_post_code FROM account WHERE user_id = 97), 'USA', '2817121923597731629', 'Visa', '2019-08-12');
INSERT INTO lineitem VALUES(118, 1, 181, 2);
INSERT INTO orderstatus VALUES(118, 1, '2014-08-14', 'T');
INSERT INTO lineitem VALUES(118, 2, 193, 1);
INSERT INTO orderstatus VALUES(118, 2, '2014-08-14', 'T');
INSERT INTO lineitem VALUES(118, 3, 6, 2);
INSERT INTO orderstatus VALUES(118, 3, '2014-08-14', 'T');
INSERT INTO lineitem VALUES(118, 4, 36, 1);
INSERT INTO orderstatus VALUES(118, 4, '2014-08-14', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 118) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 118;

INSERT INTO orders VALUES(119, 23, '2015-12-26', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 23), (SELECT middle_name FROM account WHERE user_id = 23), (SELECT last_name FROM account WHERE user_id = 23), (SELECT address FROM account WHERE user_id = 23), (SELECT city FROM account WHERE user_id = 23), (SELECT state_province FROM account WHERE user_id = 23), (SELECT zip_post_code FROM account WHERE user_id = 23), 'USA', '4466028322542174501', 'Visa', '2018-11-18');
INSERT INTO lineitem VALUES(119, 1, 138, 2);
INSERT INTO orderstatus VALUES(119, 1, '2015-12-26', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 119) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 119;

INSERT INTO orders VALUES(120, 38, '2015-06-12', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 38), (SELECT middle_name FROM account WHERE user_id = 38), (SELECT last_name FROM account WHERE user_id = 38), (SELECT address FROM account WHERE user_id = 38), (SELECT city FROM account WHERE user_id = 38), (SELECT state_province FROM account WHERE user_id = 38), (SELECT zip_post_code FROM account WHERE user_id = 38), 'USA', '4302039092671429548', 'MasterCard', '2020-02-04');
INSERT INTO lineitem VALUES(120, 1, 80, 2);
INSERT INTO orderstatus VALUES(120, 1, '2015-06-12', 'T');
INSERT INTO lineitem VALUES(120, 2, 37, 2);
INSERT INTO orderstatus VALUES(120, 2, '2015-06-12', 'T');
INSERT INTO lineitem VALUES(120, 3, 119, 1);
INSERT INTO orderstatus VALUES(120, 3, '2015-06-12', 'T');
INSERT INTO lineitem VALUES(120, 4, 20, 1);
INSERT INTO orderstatus VALUES(120, 4, '2015-06-12', 'T');
INSERT INTO lineitem VALUES(120, 5, 58, 1);
INSERT INTO orderstatus VALUES(120, 5, '2015-06-12', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 120) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 120;

INSERT INTO orders VALUES(121, 51, '2014-01-31', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 51), (SELECT middle_name FROM account WHERE user_id = 51), (SELECT last_name FROM account WHERE user_id = 51), (SELECT address FROM account WHERE user_id = 51), (SELECT city FROM account WHERE user_id = 51), (SELECT state_province FROM account WHERE user_id = 51), (SELECT zip_post_code FROM account WHERE user_id = 51), 'USA', '5037448668705980455', 'Visa', '2016-11-26');
INSERT INTO lineitem VALUES(121, 1, 56, 2);
INSERT INTO orderstatus VALUES(121, 1, '2014-01-31', 'T');
INSERT INTO lineitem VALUES(121, 2, 121, 2);
INSERT INTO orderstatus VALUES(121, 2, '2014-01-31', 'T');
INSERT INTO lineitem VALUES(121, 3, 78, 2);
INSERT INTO orderstatus VALUES(121, 3, '2014-01-31', 'T');
INSERT INTO lineitem VALUES(121, 4, 153, 1);
INSERT INTO orderstatus VALUES(121, 4, '2014-01-31', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 121) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 121;

INSERT INTO orders VALUES(122, 68, '2016-07-20', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 68), (SELECT middle_name FROM account WHERE user_id = 68), (SELECT last_name FROM account WHERE user_id = 68), (SELECT address FROM account WHERE user_id = 68), (SELECT city FROM account WHERE user_id = 68), (SELECT state_province FROM account WHERE user_id = 68), (SELECT zip_post_code FROM account WHERE user_id = 68), 'USA', '9277615791417704747', 'American Express', '2018-11-19');
INSERT INTO lineitem VALUES(122, 1, 174, 1);
INSERT INTO orderstatus VALUES(122, 1, '2016-07-20', 'T');
INSERT INTO lineitem VALUES(122, 2, 46, 2);
INSERT INTO orderstatus VALUES(122, 2, '2016-07-20', 'T');
INSERT INTO lineitem VALUES(122, 3, 47, 1);
INSERT INTO orderstatus VALUES(122, 3, '2016-07-20', 'T');
INSERT INTO lineitem VALUES(122, 4, 157, 2);
INSERT INTO orderstatus VALUES(122, 4, '2016-07-20', 'T');
INSERT INTO lineitem VALUES(122, 5, 63, 2);
INSERT INTO orderstatus VALUES(122, 5, '2016-07-20', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 122) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 122;

INSERT INTO orders VALUES(123, 68, '2014-02-25', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 68), (SELECT middle_name FROM account WHERE user_id = 68), (SELECT last_name FROM account WHERE user_id = 68), (SELECT address FROM account WHERE user_id = 68), (SELECT city FROM account WHERE user_id = 68), (SELECT state_province FROM account WHERE user_id = 68), (SELECT zip_post_code FROM account WHERE user_id = 68), 'USA', '2154702441162194569', 'MasterCard', '2019-12-19');
INSERT INTO lineitem VALUES(123, 1, 123, 2);
INSERT INTO orderstatus VALUES(123, 1, '2014-02-25', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 123) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 123;

INSERT INTO orders VALUES(124, 63, '2014-03-23', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 63), (SELECT middle_name FROM account WHERE user_id = 63), (SELECT last_name FROM account WHERE user_id = 63), (SELECT address FROM account WHERE user_id = 63), (SELECT city FROM account WHERE user_id = 63), (SELECT state_province FROM account WHERE user_id = 63), (SELECT zip_post_code FROM account WHERE user_id = 63), 'USA', '2727383713528662667', 'Visa', '2018-05-26');
INSERT INTO lineitem VALUES(124, 1, 188, 2);
INSERT INTO orderstatus VALUES(124, 1, '2014-03-23', 'T');
INSERT INTO lineitem VALUES(124, 2, 25, 2);
INSERT INTO orderstatus VALUES(124, 2, '2014-03-23', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 124) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 124;

--
-- ORDERS, ORDER STATUS, AND LINE ITEMS (UNSHIPPED)
--
INSERT INTO orders VALUES(125, 30, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 30), (SELECT middle_name FROM account WHERE user_id = 30), (SELECT last_name FROM account WHERE user_id = 30), (SELECT address FROM account WHERE user_id = 30), (SELECT city FROM account WHERE user_id = 30), (SELECT state_province FROM account WHERE user_id = 30), (SELECT zip_post_code FROM account WHERE user_id = 30), 'USA', '7183167283098131180', 'Visa', '2018-11-20');
INSERT INTO lineitem VALUES(125, 1, 117, 2);
INSERT INTO orderstatus VALUES(125, 1, '2016-11-18', 'T');
INSERT INTO lineitem VALUES(125, 2, 129, 1);
INSERT INTO orderstatus VALUES(125, 2, '2016-11-18', 'T');
INSERT INTO lineitem VALUES(125, 3, 7, 2);
INSERT INTO orderstatus VALUES(125, 3, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 125) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 125;

INSERT INTO orders VALUES(126, 16, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 16), (SELECT middle_name FROM account WHERE user_id = 16), (SELECT last_name FROM account WHERE user_id = 16), (SELECT address FROM account WHERE user_id = 16), (SELECT city FROM account WHERE user_id = 16), (SELECT state_province FROM account WHERE user_id = 16), (SELECT zip_post_code FROM account WHERE user_id = 16), 'USA', '6732498897094898119', 'American Express', '2019-10-11');
INSERT INTO lineitem VALUES(126, 1, 182, 1);
INSERT INTO orderstatus VALUES(126, 1, '2016-11-18', 'T');
INSERT INTO lineitem VALUES(126, 2, 185, 2);
INSERT INTO orderstatus VALUES(126, 2, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 126) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 126;

INSERT INTO orders VALUES(127, 69, '2016-11-17', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 69), (SELECT middle_name FROM account WHERE user_id = 69), (SELECT last_name FROM account WHERE user_id = 69), (SELECT address FROM account WHERE user_id = 69), (SELECT city FROM account WHERE user_id = 69), (SELECT state_province FROM account WHERE user_id = 69), (SELECT zip_post_code FROM account WHERE user_id = 69), 'USA', '9791709348769786049', 'Visa', '2020-03-14');
INSERT INTO lineitem VALUES(127, 1, 171, 2);
INSERT INTO orderstatus VALUES(127, 1, '2016-11-17', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 127) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 127;

INSERT INTO orders VALUES(128, 23, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 23), (SELECT middle_name FROM account WHERE user_id = 23), (SELECT last_name FROM account WHERE user_id = 23), (SELECT address FROM account WHERE user_id = 23), (SELECT city FROM account WHERE user_id = 23), (SELECT state_province FROM account WHERE user_id = 23), (SELECT zip_post_code FROM account WHERE user_id = 23), 'USA', '9626161372152396482', 'Visa', '2018-11-22');
INSERT INTO lineitem VALUES(128, 1, 113, 2);
INSERT INTO orderstatus VALUES(128, 1, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 128) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 128;

INSERT INTO orders VALUES(129, 61, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 61), (SELECT middle_name FROM account WHERE user_id = 61), (SELECT last_name FROM account WHERE user_id = 61), (SELECT address FROM account WHERE user_id = 61), (SELECT city FROM account WHERE user_id = 61), (SELECT state_province FROM account WHERE user_id = 61), (SELECT zip_post_code FROM account WHERE user_id = 61), 'USA', '2804765152633586547', 'MasterCard', '2017-04-20');
INSERT INTO lineitem VALUES(129, 1, 79, 1);
INSERT INTO orderstatus VALUES(129, 1, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 129) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 129;

INSERT INTO orders VALUES(130, 99, '2016-11-17', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 99), (SELECT middle_name FROM account WHERE user_id = 99), (SELECT last_name FROM account WHERE user_id = 99), (SELECT address FROM account WHERE user_id = 99), (SELECT city FROM account WHERE user_id = 99), (SELECT state_province FROM account WHERE user_id = 99), (SELECT zip_post_code FROM account WHERE user_id = 99), 'USA', '1165944270719250301', 'Visa', '2019-01-23');
INSERT INTO lineitem VALUES(130, 1, 68, 2);
INSERT INTO orderstatus VALUES(130, 1, '2016-11-17', 'T');
INSERT INTO lineitem VALUES(130, 2, 144, 2);
INSERT INTO orderstatus VALUES(130, 2, '2016-11-17', 'T');
INSERT INTO lineitem VALUES(130, 3, 45, 1);
INSERT INTO orderstatus VALUES(130, 3, '2016-11-17', 'T');
INSERT INTO lineitem VALUES(130, 4, 147, 2);
INSERT INTO orderstatus VALUES(130, 4, '2016-11-17', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 130) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 130;

INSERT INTO orders VALUES(131, 83, '2016-11-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 83), (SELECT middle_name FROM account WHERE user_id = 83), (SELECT last_name FROM account WHERE user_id = 83), (SELECT address FROM account WHERE user_id = 83), (SELECT city FROM account WHERE user_id = 83), (SELECT state_province FROM account WHERE user_id = 83), (SELECT zip_post_code FROM account WHERE user_id = 83), 'USA', '1547232013416969937', 'MasterCard', '2018-02-12');
INSERT INTO lineitem VALUES(131, 1, 29, 1);
INSERT INTO orderstatus VALUES(131, 1, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(131, 2, 152, 1);
INSERT INTO orderstatus VALUES(131, 2, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(131, 3, 141, 1);
INSERT INTO orderstatus VALUES(131, 3, '2016-11-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 131) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 131;

INSERT INTO orders VALUES(132, 24, '2016-11-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 24), (SELECT middle_name FROM account WHERE user_id = 24), (SELECT last_name FROM account WHERE user_id = 24), (SELECT address FROM account WHERE user_id = 24), (SELECT city FROM account WHERE user_id = 24), (SELECT state_province FROM account WHERE user_id = 24), (SELECT zip_post_code FROM account WHERE user_id = 24), 'USA', '3043025311627105227', 'Visa', '2011-12-12');
INSERT INTO lineitem VALUES(132, 1, 40, 2);
INSERT INTO orderstatus VALUES(132, 1, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(132, 2, 89, 1);
INSERT INTO orderstatus VALUES(132, 2, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(132, 3, 171, 1);
INSERT INTO orderstatus VALUES(132, 3, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(132, 4, 90, 1);
INSERT INTO orderstatus VALUES(132, 4, '2016-11-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 132) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 132;

INSERT INTO orders VALUES(133, 91, '2016-11-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 91), (SELECT middle_name FROM account WHERE user_id = 91), (SELECT last_name FROM account WHERE user_id = 91), (SELECT address FROM account WHERE user_id = 91), (SELECT city FROM account WHERE user_id = 91), (SELECT state_province FROM account WHERE user_id = 91), (SELECT zip_post_code FROM account WHERE user_id = 91), 'USA', '1030403986208070878', 'Visa', '2018-10-25');
INSERT INTO lineitem VALUES(133, 1, 109, 1);
INSERT INTO orderstatus VALUES(133, 1, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(133, 2, 100, 1);
INSERT INTO orderstatus VALUES(133, 2, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(133, 3, 81, 2);
INSERT INTO orderstatus VALUES(133, 3, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(133, 4, 91, 1);
INSERT INTO orderstatus VALUES(133, 4, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(133, 5, 133, 1);
INSERT INTO orderstatus VALUES(133, 5, '2016-11-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 133) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 133;

INSERT INTO orders VALUES(134, 78, '2016-11-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 78), (SELECT middle_name FROM account WHERE user_id = 78), (SELECT last_name FROM account WHERE user_id = 78), (SELECT address FROM account WHERE user_id = 78), (SELECT city FROM account WHERE user_id = 78), (SELECT state_province FROM account WHERE user_id = 78), (SELECT zip_post_code FROM account WHERE user_id = 78), 'USA', '9552040729553443732', 'American Express', '2018-07-31');
INSERT INTO lineitem VALUES(134, 1, 173, 1);
INSERT INTO orderstatus VALUES(134, 1, '2016-11-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 134) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 134;

INSERT INTO orders VALUES(135, 86, '2016-11-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 86), (SELECT middle_name FROM account WHERE user_id = 86), (SELECT last_name FROM account WHERE user_id = 86), (SELECT address FROM account WHERE user_id = 86), (SELECT city FROM account WHERE user_id = 86), (SELECT state_province FROM account WHERE user_id = 86), (SELECT zip_post_code FROM account WHERE user_id = 86), 'USA', '9693838426957299706', 'Visa', '2019-04-02');
INSERT INTO lineitem VALUES(135, 1, 129, 2);
INSERT INTO orderstatus VALUES(135, 1, '2016-11-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 135) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 135;

INSERT INTO orders VALUES(136, 27, '2016-11-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 27), (SELECT middle_name FROM account WHERE user_id = 27), (SELECT last_name FROM account WHERE user_id = 27), (SELECT address FROM account WHERE user_id = 27), (SELECT city FROM account WHERE user_id = 27), (SELECT state_province FROM account WHERE user_id = 27), (SELECT zip_post_code FROM account WHERE user_id = 27), 'USA', '6943636442147081570', 'Visa', '2019-10-11');
INSERT INTO lineitem VALUES(136, 1, 145, 1);
INSERT INTO orderstatus VALUES(136, 1, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(136, 2, 182, 2);
INSERT INTO orderstatus VALUES(136, 2, '2016-11-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 136) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 136;

INSERT INTO orders VALUES(137, 53, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 53), (SELECT middle_name FROM account WHERE user_id = 53), (SELECT last_name FROM account WHERE user_id = 53), (SELECT address FROM account WHERE user_id = 53), (SELECT city FROM account WHERE user_id = 53), (SELECT state_province FROM account WHERE user_id = 53), (SELECT zip_post_code FROM account WHERE user_id = 53), 'USA', '4402440492867988888', 'MasterCard', '2018-10-14');
INSERT INTO lineitem VALUES(137, 1, 34, 1);
INSERT INTO orderstatus VALUES(137, 1, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 137) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 137;

INSERT INTO orders VALUES(138, 62, '2016-11-16', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 62), (SELECT middle_name FROM account WHERE user_id = 62), (SELECT last_name FROM account WHERE user_id = 62), (SELECT address FROM account WHERE user_id = 62), (SELECT city FROM account WHERE user_id = 62), (SELECT state_province FROM account WHERE user_id = 62), (SELECT zip_post_code FROM account WHERE user_id = 62), 'USA', '8583263080333923521', 'Visa', '2019-05-05');
INSERT INTO lineitem VALUES(138, 1, 196, 2);
INSERT INTO orderstatus VALUES(138, 1, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(138, 2, 3, 1);
INSERT INTO orderstatus VALUES(138, 2, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(138, 3, 61, 1);
INSERT INTO orderstatus VALUES(138, 3, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(138, 4, 78, 1);
INSERT INTO orderstatus VALUES(138, 4, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(138, 5, 170, 1);
INSERT INTO orderstatus VALUES(138, 5, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(138, 6, 111, 2);
INSERT INTO orderstatus VALUES(138, 6, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(138, 7, 140, 1);
INSERT INTO orderstatus VALUES(138, 7, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(138, 8, 12, 2);
INSERT INTO orderstatus VALUES(138, 8, '2016-11-16', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 138) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 138;

INSERT INTO orders VALUES(139, 45, '2016-11-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 45), (SELECT middle_name FROM account WHERE user_id = 45), (SELECT last_name FROM account WHERE user_id = 45), (SELECT address FROM account WHERE user_id = 45), (SELECT city FROM account WHERE user_id = 45), (SELECT state_province FROM account WHERE user_id = 45), (SELECT zip_post_code FROM account WHERE user_id = 45), 'USA', '8869665247276388021', 'Visa', '2018-10-26');
INSERT INTO lineitem VALUES(139, 1, 134, 1);
INSERT INTO orderstatus VALUES(139, 1, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(139, 2, 161, 2);
INSERT INTO orderstatus VALUES(139, 2, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(139, 3, 111, 2);
INSERT INTO orderstatus VALUES(139, 3, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(139, 4, 33, 2);
INSERT INTO orderstatus VALUES(139, 4, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(139, 5, 116, 2);
INSERT INTO orderstatus VALUES(139, 5, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(139, 6, 22, 1);
INSERT INTO orderstatus VALUES(139, 6, '2016-11-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 139) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 139;

INSERT INTO orders VALUES(140, 80, '2016-11-16', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 80), (SELECT middle_name FROM account WHERE user_id = 80), (SELECT last_name FROM account WHERE user_id = 80), (SELECT address FROM account WHERE user_id = 80), (SELECT city FROM account WHERE user_id = 80), (SELECT state_province FROM account WHERE user_id = 80), (SELECT zip_post_code FROM account WHERE user_id = 80), 'USA', '1058372953024643275', 'MasterCard', '2018-09-03');
INSERT INTO lineitem VALUES(140, 1, 193, 2);
INSERT INTO orderstatus VALUES(140, 1, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 2, 137, 2);
INSERT INTO orderstatus VALUES(140, 2, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 3, 84, 1);
INSERT INTO orderstatus VALUES(140, 3, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 4, 21, 1);
INSERT INTO orderstatus VALUES(140, 4, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 5, 37, 2);
INSERT INTO orderstatus VALUES(140, 5, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 6, 191, 1);
INSERT INTO orderstatus VALUES(140, 6, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 7, 86, 2);
INSERT INTO orderstatus VALUES(140, 7, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 8, 76, 1);
INSERT INTO orderstatus VALUES(140, 8, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 9, 43, 2);
INSERT INTO orderstatus VALUES(140, 9, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(140, 10, 23, 2);
INSERT INTO orderstatus VALUES(140, 10, '2016-11-16', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 140) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 140;

INSERT INTO orders VALUES(141, 44, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 44), (SELECT middle_name FROM account WHERE user_id = 44), (SELECT last_name FROM account WHERE user_id = 44), (SELECT address FROM account WHERE user_id = 44), (SELECT city FROM account WHERE user_id = 44), (SELECT state_province FROM account WHERE user_id = 44), (SELECT zip_post_code FROM account WHERE user_id = 44), 'USA', '5610337365944621531', 'MasterCard', '2017-01-05');
INSERT INTO lineitem VALUES(141, 1, 49, 2);
INSERT INTO orderstatus VALUES(141, 1, '2016-11-18', 'T');
INSERT INTO lineitem VALUES(141, 2, 187, 1);
INSERT INTO orderstatus VALUES(141, 2, '2016-11-18', 'T');
INSERT INTO lineitem VALUES(141, 3, 73, 2);
INSERT INTO orderstatus VALUES(141, 3, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 141) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 141;

INSERT INTO orders VALUES(142, 63, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 63), (SELECT middle_name FROM account WHERE user_id = 63), (SELECT last_name FROM account WHERE user_id = 63), (SELECT address FROM account WHERE user_id = 63), (SELECT city FROM account WHERE user_id = 63), (SELECT state_province FROM account WHERE user_id = 63), (SELECT zip_post_code FROM account WHERE user_id = 63), 'USA', '1423915081679005627', 'MasterCard', '2017-05-09');
INSERT INTO lineitem VALUES(142, 1, 94, 1);
INSERT INTO orderstatus VALUES(142, 1, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 142) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 142;

INSERT INTO orders VALUES(143, 78, '2016-11-18', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 78), (SELECT middle_name FROM account WHERE user_id = 78), (SELECT last_name FROM account WHERE user_id = 78), (SELECT address FROM account WHERE user_id = 78), (SELECT city FROM account WHERE user_id = 78), (SELECT state_province FROM account WHERE user_id = 78), (SELECT zip_post_code FROM account WHERE user_id = 78), 'USA', '7409614182047244526', 'American Express', '2018-06-12');
INSERT INTO lineitem VALUES(143, 1, 191, 1);
INSERT INTO orderstatus VALUES(143, 1, '2016-11-18', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 143) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 143;

INSERT INTO orders VALUES(144, 68, '2016-11-17', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 68), (SELECT middle_name FROM account WHERE user_id = 68), (SELECT last_name FROM account WHERE user_id = 68), (SELECT address FROM account WHERE user_id = 68), (SELECT city FROM account WHERE user_id = 68), (SELECT state_province FROM account WHERE user_id = 68), (SELECT zip_post_code FROM account WHERE user_id = 68), 'USA', '8758989583139263061', 'Visa', '2020-06-11');
INSERT INTO lineitem VALUES(144, 1, 91, 1);
INSERT INTO orderstatus VALUES(144, 1, '2016-11-17', 'T');
INSERT INTO lineitem VALUES(144, 2, 196, 2);
INSERT INTO orderstatus VALUES(144, 2, '2016-11-17', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 144) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 144;

INSERT INTO orders VALUES(145, 83, '2016-11-16', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'UPS', (SELECT first_name FROM account WHERE user_id = 83), (SELECT middle_name FROM account WHERE user_id = 83), (SELECT last_name FROM account WHERE user_id = 83), (SELECT address FROM account WHERE user_id = 83), (SELECT city FROM account WHERE user_id = 83), (SELECT state_province FROM account WHERE user_id = 83), (SELECT zip_post_code FROM account WHERE user_id = 83), 'USA', '1232678526447437874', 'American Express', '2019-07-27');
INSERT INTO lineitem VALUES(145, 1, 186, 1);
INSERT INTO orderstatus VALUES(145, 1, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(145, 2, 87, 1);
INSERT INTO orderstatus VALUES(145, 2, '2016-11-16', 'T');
INSERT INTO lineitem VALUES(145, 3, 199, 2);
INSERT INTO orderstatus VALUES(145, 3, '2016-11-16', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 145) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 145;

INSERT INTO orders VALUES(146, 77, '2016-11-19', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 77), (SELECT middle_name FROM account WHERE user_id = 77), (SELECT last_name FROM account WHERE user_id = 77), (SELECT address FROM account WHERE user_id = 77), (SELECT city FROM account WHERE user_id = 77), (SELECT state_province FROM account WHERE user_id = 77), (SELECT zip_post_code FROM account WHERE user_id = 77), 'USA', '7073078716965633609', 'MasterCard', '2018-11-21');
INSERT INTO lineitem VALUES(146, 1, 65, 1);
INSERT INTO orderstatus VALUES(146, 1, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(146, 2, 142, 2);
INSERT INTO orderstatus VALUES(146, 2, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(146, 3, 114, 1);
INSERT INTO orderstatus VALUES(146, 3, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(146, 4, 70, 2);
INSERT INTO orderstatus VALUES(146, 4, '2016-11-19', 'T');
INSERT INTO lineitem VALUES(146, 5, 18, 2);
INSERT INTO orderstatus VALUES(146, 5, '2016-11-19', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 146) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 146;

INSERT INTO orders VALUES(147, 86, '2016-11-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FedEx', (SELECT first_name FROM account WHERE user_id = 86), (SELECT middle_name FROM account WHERE user_id = 86), (SELECT last_name FROM account WHERE user_id = 86), (SELECT address FROM account WHERE user_id = 86), (SELECT city FROM account WHERE user_id = 86), (SELECT state_province FROM account WHERE user_id = 86), (SELECT zip_post_code FROM account WHERE user_id = 86), 'USA', '2448535449989381189', 'MasterCard', '2019-10-21');
INSERT INTO lineitem VALUES(147, 1, 53, 2);
INSERT INTO orderstatus VALUES(147, 1, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(147, 2, 115, 2);
INSERT INTO orderstatus VALUES(147, 2, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(147, 3, 157, 2);
INSERT INTO orderstatus VALUES(147, 3, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(147, 4, 159, 2);
INSERT INTO orderstatus VALUES(147, 4, '2016-11-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 147) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 147;

INSERT INTO orders VALUES(148, 45, '2016-11-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 45), (SELECT middle_name FROM account WHERE user_id = 45), (SELECT last_name FROM account WHERE user_id = 45), (SELECT address FROM account WHERE user_id = 45), (SELECT city FROM account WHERE user_id = 45), (SELECT state_province FROM account WHERE user_id = 45), (SELECT zip_post_code FROM account WHERE user_id = 45), 'USA', '2332942181276343058', 'American Express', '2018-03-18');
INSERT INTO lineitem VALUES(148, 1, 137, 1);
INSERT INTO orderstatus VALUES(148, 1, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(148, 2, 175, 1);
INSERT INTO orderstatus VALUES(148, 2, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(148, 3, 119, 2);
INSERT INTO orderstatus VALUES(148, 3, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(148, 4, 149, 2);
INSERT INTO orderstatus VALUES(148, 4, '2016-11-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 148) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 148;

INSERT INTO orders VALUES(149, 14, '2016-11-16', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 14), (SELECT middle_name FROM account WHERE user_id = 14), (SELECT last_name FROM account WHERE user_id = 14), (SELECT address FROM account WHERE user_id = 14), (SELECT city FROM account WHERE user_id = 14), (SELECT state_province FROM account WHERE user_id = 14), (SELECT zip_post_code FROM account WHERE user_id = 14), 'USA', '3865871099654146492', 'American Express', '2018-06-20');
INSERT INTO lineitem VALUES(149, 1, 32, 2);
INSERT INTO orderstatus VALUES(149, 1, '2016-11-16', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 149) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 149;

INSERT INTO orders VALUES(150, 9, '2016-11-15', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'USPS', (SELECT first_name FROM account WHERE user_id = 9), (SELECT middle_name FROM account WHERE user_id = 9), (SELECT last_name FROM account WHERE user_id = 9), (SELECT address FROM account WHERE user_id = 9), (SELECT city FROM account WHERE user_id = 9), (SELECT state_province FROM account WHERE user_id = 9), (SELECT zip_post_code FROM account WHERE user_id = 9), 'USA', '1089232000654096004', 'American Express', '2019-11-08');
INSERT INTO lineitem VALUES(150, 1, 89, 2);
INSERT INTO orderstatus VALUES(150, 1, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(150, 2, 110, 2);
INSERT INTO orderstatus VALUES(150, 2, '2016-11-15', 'T');
INSERT INTO lineitem VALUES(150, 3, 38, 1);
INSERT INTO orderstatus VALUES(150, 3, '2016-11-15', 'T');
UPDATE TEMP SET temp = (SELECT SUM(I.unitprice) FROM orders O JOIN lineitem L USING(order_id) JOIN item I USING(item_id) WHERE O.order_id = 150) WHERE temp_id = 1;
UPDATE orders SET total_price = (SELECT temp FROM TEMP WHERE temp_id = 1) WHERE order_id = 150;

--
-- DROP TEMPORARY TABLE
--
DROP TABLE IF EXISTS TEMP;

--
-- INVENTORY
--



INSERT INTO inventory VALUES( 1, 91);
INSERT INTO inventory VALUES( 2, 58);
INSERT INTO inventory VALUES( 3, 69);
INSERT INTO inventory VALUES( 4, 64);
INSERT INTO inventory VALUES( 5, 69);
INSERT INTO inventory VALUES( 6, 89);
INSERT INTO inventory VALUES( 7, 55);
INSERT INTO inventory VALUES( 8, 80);
INSERT INTO inventory VALUES( 9, 29);
INSERT INTO inventory VALUES(10, 91);
INSERT INTO inventory VALUES(11, 75);
INSERT INTO inventory VALUES(12, 0);
INSERT INTO inventory VALUES(13, 53);
INSERT INTO inventory VALUES(14, 0);
INSERT INTO inventory VALUES(15, 0);
INSERT INTO inventory VALUES(16, 0);
INSERT INTO inventory VALUES(17, 27);
INSERT INTO inventory VALUES(18, 49);
INSERT INTO inventory VALUES(19, 53);
INSERT INTO inventory VALUES(20, 68);
INSERT INTO inventory VALUES(21, 0);
INSERT INTO inventory VALUES(22, 49);
INSERT INTO inventory VALUES(23, 76);
INSERT INTO inventory VALUES(24, 56);
INSERT INTO inventory VALUES(25, 95);
INSERT INTO inventory VALUES(26, 60);
INSERT INTO inventory VALUES(27, 96);
INSERT INTO inventory VALUES(28, 61);
INSERT INTO inventory VALUES(29, 46);
INSERT INTO inventory VALUES(30, 24);
INSERT INTO inventory VALUES(31, 52);
INSERT INTO inventory VALUES(32, 26);
INSERT INTO inventory VALUES(33, 46);
INSERT INTO inventory VALUES(34, 35);
INSERT INTO inventory VALUES(35, 78);
INSERT INTO inventory VALUES(36, 67);
INSERT INTO inventory VALUES(37, 100);
INSERT INTO inventory VALUES(38, 33);
INSERT INTO inventory VALUES(39, 27);
INSERT INTO inventory VALUES(40, 55);
INSERT INTO inventory VALUES(41, 0);
INSERT INTO inventory VALUES(42, 60);
INSERT INTO inventory VALUES(43, 49);
INSERT INTO inventory VALUES(44, 26);
INSERT INTO inventory VALUES(45, 87);
INSERT INTO inventory VALUES(46, 78);
INSERT INTO inventory VALUES(47, 47);
INSERT INTO inventory VALUES(48, 97);
INSERT INTO inventory VALUES(49, 51);
INSERT INTO inventory VALUES(50, 41);
INSERT INTO inventory VALUES(51, 34);
INSERT INTO inventory VALUES(52, 95);
INSERT INTO inventory VALUES(53, 60);
INSERT INTO inventory VALUES(54, 66);
INSERT INTO inventory VALUES(55, 95);
INSERT INTO inventory VALUES(56, 74);
INSERT INTO inventory VALUES(57, 36);
INSERT INTO inventory VALUES(58, 48);
INSERT INTO inventory VALUES(59, 0);
INSERT INTO inventory VALUES(60, 0);
INSERT INTO inventory VALUES(61, 60);
INSERT INTO inventory VALUES(62, 0);
INSERT INTO inventory VALUES(63, 0);
INSERT INTO inventory VALUES(64, 0);
INSERT INTO inventory VALUES(65, 0);
INSERT INTO inventory VALUES(66, 0);
INSERT INTO inventory VALUES(67, 0);
INSERT INTO inventory VALUES(68, 83);
INSERT INTO inventory VALUES(69, 96);
INSERT INTO inventory VALUES(70, 54);
INSERT INTO inventory VALUES(71, 35);
INSERT INTO inventory VALUES(72, 59);
INSERT INTO inventory VALUES(73, 55);
INSERT INTO inventory VALUES(74, 80);
INSERT INTO inventory VALUES(75, 21);
INSERT INTO inventory VALUES(76, 84);
INSERT INTO inventory VALUES(77, 82);
INSERT INTO inventory VALUES(78, 87);
INSERT INTO inventory VALUES(79, 54);
INSERT INTO inventory VALUES(80, 97);
INSERT INTO inventory VALUES(81, 34);
INSERT INTO inventory VALUES(82, 45);
INSERT INTO inventory VALUES(83, 36);
INSERT INTO inventory VALUES(84, 26);
INSERT INTO inventory VALUES(85, 50);
INSERT INTO inventory VALUES(86, 29);
INSERT INTO inventory VALUES(87, 77);
INSERT INTO inventory VALUES(88, 97);
INSERT INTO inventory VALUES(89, 51);
INSERT INTO inventory VALUES(90, 68);
INSERT INTO inventory VALUES(91, 45);
INSERT INTO inventory VALUES(92, 68);
INSERT INTO inventory VALUES(93, 46);
INSERT INTO inventory VALUES(94, 62);
INSERT INTO inventory VALUES(95, 87);
INSERT INTO inventory VALUES(96, 97);
INSERT INTO inventory VALUES(97, 92);
INSERT INTO inventory VALUES(98, 88);
INSERT INTO inventory VALUES(99, 95);
INSERT INTO inventory VALUES(100, 68);
INSERT INTO inventory VALUES(101, 50);
INSERT INTO inventory VALUES(102, 34);
INSERT INTO inventory VALUES(103, 0);
INSERT INTO inventory VALUES(104, 83);
INSERT INTO inventory VALUES(105, 97);
INSERT INTO inventory VALUES(106, 77);
INSERT INTO inventory VALUES(107, 96);
INSERT INTO inventory VALUES(108, 69);
INSERT INTO inventory VALUES(109, 0);
INSERT INTO inventory VALUES(110, 0);
INSERT INTO inventory VALUES(111, 0);
INSERT INTO inventory VALUES(112, 0);
INSERT INTO inventory VALUES(113, 0);
INSERT INTO inventory VALUES(114, 0);
INSERT INTO inventory VALUES(115, 47);
INSERT INTO inventory VALUES(116, 97);
INSERT INTO inventory VALUES(117, 30);
INSERT INTO inventory VALUES(118, 28);
INSERT INTO inventory VALUES(119, 68);
INSERT INTO inventory VALUES(120, 0);
INSERT INTO inventory VALUES(121, 0);
INSERT INTO inventory VALUES(122, 26);
INSERT INTO inventory VALUES(123, 32);
INSERT INTO inventory VALUES(124, 55);
INSERT INTO inventory VALUES(125, 68);
INSERT INTO inventory VALUES(126, 29);
INSERT INTO inventory VALUES(127, 34);
INSERT INTO inventory VALUES(128, 75);
INSERT INTO inventory VALUES(129, 34);
INSERT INTO inventory VALUES(130, 28);
INSERT INTO inventory VALUES(131, 50);
INSERT INTO inventory VALUES(132, 89);
INSERT INTO inventory VALUES(133, 27);
INSERT INTO inventory VALUES(134, 97);
INSERT INTO inventory VALUES(135, 88);
INSERT INTO inventory VALUES(136, 20);
INSERT INTO inventory VALUES(137, 71);
INSERT INTO inventory VALUES(138, 90);
INSERT INTO inventory VALUES(139, 74);
INSERT INTO inventory VALUES(140, 92);
INSERT INTO inventory VALUES(141, 90);
INSERT INTO inventory VALUES(142, 20);
INSERT INTO inventory VALUES(143, 76);
INSERT INTO inventory VALUES(144, 54);
INSERT INTO inventory VALUES(145, 78);
INSERT INTO inventory VALUES(146, 87);
INSERT INTO inventory VALUES(147, 48);
INSERT INTO inventory VALUES(148, 99);
INSERT INTO inventory VALUES(149, 20);
INSERT INTO inventory VALUES(150, 75);
INSERT INTO inventory VALUES(151, 32);
INSERT INTO inventory VALUES(152, 40);
INSERT INTO inventory VALUES(153, 98);
INSERT INTO inventory VALUES(154, 99);
INSERT INTO inventory VALUES(155, 21);
INSERT INTO inventory VALUES(156, 49);
INSERT INTO inventory VALUES(157, 30);
INSERT INTO inventory VALUES(158, 33);
INSERT INTO inventory VALUES(159, 35);
INSERT INTO inventory VALUES(160, 81);
INSERT INTO inventory VALUES(161, 48);
INSERT INTO inventory VALUES(162, 60);
INSERT INTO inventory VALUES(163, 0);
INSERT INTO inventory VALUES(164, 73);
INSERT INTO inventory VALUES(165, 53);
INSERT INTO inventory VALUES(166, 60);
INSERT INTO inventory VALUES(167, 25);
INSERT INTO inventory VALUES(168, 32);
INSERT INTO inventory VALUES(169, 83);
INSERT INTO inventory VALUES(170, 32);
INSERT INTO inventory VALUES(171, 37);
INSERT INTO inventory VALUES(172, 62);
INSERT INTO inventory VALUES(173, 22);
INSERT INTO inventory VALUES(174, 47);
INSERT INTO inventory VALUES(175, 83);
INSERT INTO inventory VALUES(176, 23);
INSERT INTO inventory VALUES(177, 78);
INSERT INTO inventory VALUES(178, 43);
INSERT INTO inventory VALUES(179, 45);
INSERT INTO inventory VALUES(180, 34);
INSERT INTO inventory VALUES(181, 42);
INSERT INTO inventory VALUES(182, 78);
INSERT INTO inventory VALUES(183, 72);
INSERT INTO inventory VALUES(184, 77);
INSERT INTO inventory VALUES(185, 84);
INSERT INTO inventory VALUES(186, 54);
INSERT INTO inventory VALUES(187, 79);
INSERT INTO inventory VALUES(188, 96);
INSERT INTO inventory VALUES(189, 22);
INSERT INTO inventory VALUES(190, 71);
INSERT INTO inventory VALUES(191, 89);
INSERT INTO inventory VALUES(192, 42);
INSERT INTO inventory VALUES(193, 87);
INSERT INTO inventory VALUES(194, 32);
INSERT INTO inventory VALUES(195, 46);
INSERT INTO inventory VALUES(196, 89);
INSERT INTO inventory VALUES(197, 64);
INSERT INTO inventory VALUES(198, 84);
INSERT INTO inventory VALUES(199, 0);
INSERT INTO inventory VALUES(200, 94);

--
-- WISHLIST
--
INSERT INTO wishlist VALUES(5, 94, 1);
INSERT INTO wishlist VALUES(5, 157, 1);
INSERT INTO wishlist VALUES(5, 83, 1);
INSERT INTO wishlist VALUES(5, 24, 1);
INSERT INTO wishlist VALUES(5, 40, 1);
INSERT INTO wishlist VALUES(9, 21, 1);
INSERT INTO wishlist VALUES(9, 3, 1);
INSERT INTO wishlist VALUES(9, 144, 1);
INSERT INTO wishlist VALUES(9, 125, 1);
INSERT INTO wishlist VALUES(9, 26, 1);
INSERT INTO wishlist VALUES(13, 143, 1);
INSERT INTO wishlist VALUES(13, 16, 1);
INSERT INTO wishlist VALUES(13, 168, 1);
INSERT INTO wishlist VALUES(13, 13, 1);
INSERT INTO wishlist VALUES(13, 90, 1);
INSERT INTO wishlist VALUES(13, 80, 1);
INSERT INTO wishlist VALUES(19, 42, 2);
INSERT INTO wishlist VALUES(19, 103, 1);
INSERT INTO wishlist VALUES(19, 200, 1);
INSERT INTO wishlist VALUES(19, 112, 1);
INSERT INTO wishlist VALUES(68, 193, 1);
INSERT INTO wishlist VALUES(68, 106, 1);
INSERT INTO wishlist VALUES(68, 34, 3);
INSERT INTO wishlist VALUES(68, 65, 1);
INSERT INTO wishlist VALUES(68, 53, 1);
INSERT INTO wishlist VALUES(68, 128, 1);
INSERT INTO wishlist VALUES(69, 113, 3);
INSERT INTO wishlist VALUES(69, 9, 1);
INSERT INTO wishlist VALUES(69, 80, 1);
INSERT INTO wishlist VALUES(80, 156, 1);
INSERT INTO wishlist VALUES(80, 57, 1);

SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES=1;

-- 28/03/2016
SHOW TABLES;
-- Q.1
select * from orders;

SELECT order_id AS 'Order Id', order_date AS 'Order Date' FROM Orders ORDER BY order_date DESC;

-- Q.2
select * from account;
select last_name,first_name from account;
SELECT CONCAT(first_name, ' ',  last_name) AS 'Customer' FROM Account;

SELECT DATE_FORMAT(birthday, %Y) FROM Account;
SELECT YEAR(DATEDIFF('2016-03-28', birthday)) from account;
SELECT YEAR(BIRTHDAY) FROM ACCOUNT;
select date_format(birthday,%W %M %Y) from account;
SELECT DATE_FORMAT(birthday, '%d/%m/%Y') FROM account;
select date_format(datediff(curdate(),birthday),'%Y') from account;
select datediff(curdate(),birthday) from account;


SELECT TIMESTAMPDIFF(YEAR, birthday, CURDATE()) AS age from account;

SELECT CONCAT(first_name, ' ',  last_name) AS 'Customer', 
TIMESTAMPDIFF(YEAR, birthday, CURDATE()) AS Age FROM account
ORDER BY Customer;

-- Q.3
select * from account;
select * from account where email like ('%gmail.com') or email like ('%yahoo.com');

select RIGHT(email,10) as 'Email Domain' from account WHERE EMAIL LIKE ('%yahoo.com');
select Right(email,9) as 'Email Domain' from account where email like ('%gmail.com');

SELECT email AS 'Email Domain' FROM ACCOUNT WHERE email IN
(select RIGHT(email,10) as 'Email Domain' from account WHERE EMAIL LIKE ('%yahoo.com')) 
OR 
(select Right(email,9) as 'Email Domain' from account where email like ('%gmail.com'));

select email from account where email = (select email from account);

select email from account group by email having email = (select email from account);


select right(email,9) as 'Email Domain' 
from account where email like ('%gmail.com') 
or email like ('%yahoo.com') order by 'email domain' asc;

select CONCAT(first_name, ' ',  last_name) AS 'Customer',right(email,9) AS 'Email Domain' from account WHERE EMAIL LIKE ('%yahoo.com');



SELECT CONCAT(first_name, ' ',  last_name) AS Customer, 
RIGHT(email,9) AS 'Email Domain' 
FROM account WHERE EMAIL LIKE ('%yahoo.com') 
OR email LIKE ('%gmail.com') ORDER BY right(email,9) DESC;

SELECT CONCAT(first_name, ' ',  last_name) AS Customer, 
RIGHT(email,9) AS Email_Domain 
FROM account WHERE EMAIL LIKE ('%yahoo.com') 
OR email LIKE ('%gmail.com') ORDER BY Email_Domain DESC;

SELECT CONCAT(first_name, ' ',  last_name) AS Customer, 
RIGHT(email,9) AS 'Email Domain' 
FROM account WHERE EMAIL LIKE ('%yahoo.com') 
OR email LIKE ('%gmail.com') 'Email Domain' DESC;

-- Q.4
select * from account;
select count(gender) from account where gender like('M'); -- 57

select count(gender) from account where gender like('F'); -- 43

SELECT COUNT(*) FROM ACCOUNT WHERE gender = 'M';
SELECT COUNT(*) FROM ACCOUNT WHERE gender = 'F';
SELECT gender AS Gender, COUNT(*) AS '% Account Holders' FROM ACCOUNT WHERE gender = 'M' OR gender = 'F' GROUP BY GENDER;

SELECT (SELECT COUNT(*) FROM Account WHERE gender = 'M' OR gender = 'F') / 
(SELECT COUNT(*) FROM Account) * 100;

SELECT (SELECT COUNT(*) FROM Account WHERE gender = 'M' OR gender = 'F') / 
(SELECT COUNT(*) FROM Account) * 100;

select (select count(*) from account) / (select count(*) from account) * 100;

select gender,100 * 
(select count(gender) from account) /
(select count(*) from account) 
from account where gender like 'M' or gender like 'F' group by gender;


select gender,100 * (select count(*) from account where gender )/
(select count(*) from account) from account group by gender;


SELECT gender AS Gender, 
FORMAT(COUNT(*) / (SELECT COUNT(*) FROM account) * 100,0) 
AS '% Account Holders' 
FROM ACCOUNT WHERE gender = 'M' OR gender = 'F' GROUP BY GENDER;

-- Q.5
select * from orders;

select count(*) from orders where date_format(order_date,'%m') = 03;
select count(date_format(order_date, '%M')) from orders group by DATE_FORMAT(order_date, '%m');

SELECT DISTINCT DATE_FORMAT(order_date, '%m') FROM orders group by order_date ORDER BY DATE_FORMAT(order_date, '%m');

SELECT DATE_FORMAT(order_date, '%m') FROM orders group by DATE_FORMAT(order_date, '%m') ORDER BY DATE_FORMAT(order_date, '%m');

SELECT DATE_FORMAT(order_date, '%m') AS 'Month',
COUNT(*) AS 'No. Orders Placed' 
FROM orders GROUP BY DATE_FORMAT(order_date, '%m') 
ORDER BY DATE_FORMAT(order_date, '%m');

-- Q.6
SHOW TABLES;

SELECT * FROM account;
SELECT * FROM category;
SELECT * FROM genre;
SELECT * FROM inventory;
SELECT * FROM item;
SELECT * FROM lineitem;
SELECT * FROM orders;
SELECT * FROM orderstatus;
SELECT * FROM product;
SELECT * FROM series;
SELECT * FROM supplier;
SELECT * FROM xrefseriesgenre;
SELECT * FROM wishlist;

SELECT order_id,COUNT(item_id) from lineitem group by order_id;
select sum(item_id) from lineitem;
select * from lineitem;
select count(distinct order_id) from lineitem;
select * from orders;
select count(item_id) from lineitem;

select * from lineitem;
select count(item_id) from lineitem group by order_id;
select sum(quantity) from lineitem;
select * from lineitem;

SELECT (SELECT SUM(quantity) FROM lineitem) / 
(SELECT COUNT(DISTINCT order_id) FROM lineitem) 
AS 'Average Qty Ordered Per Order';

-- Q.7
select cc_type, count(cc_type) from orders group by cc_type;
select cc_type, count(cc_type) from orders group by cc_type order by count(cc_type) desc;

SELECT cc_type AS 'Most Popular Credit Card' FROM orders 
GROUP BY cc_type ORDER BY COUNT(cc_type) DESC LIMIT 1;

-- Q.8
select * from orders;
select * from product; 	-- product_id
select * from item; 	-- product_id
select * from account;
select * from lineitem; -- order_id

select series from product where series like 'Fate/Stay Night';
select product_id,series from product where series like 'Fate/Stay Night';
use toystore;

SELECT CONCAT(first_name, " ", last_name) AS 'Account Holder',
o.order_id AS OrderNo, order_date AS 'Order Date',
p.product_id AS 'Product ID'
FROM account a
JOIN orders o ON a.user_id = o.user_id
JOIN lineitem l ON l.order_id = o.order_id
JOIN item i ON i.item_id = l.item_id
JOIN product p ON p.product_id = i.product_id
WHERE series LIKE 'Fate/Stay Night' group by p.product_id;

SELECT CONCAT(first_name, " ", last_name),order_id, order_date FROM orders o
JOIN account a ON a.user_id = o.user_id
where order_id IN (SELECT order_id FROM lineitem WHERE item_id IN 
(SELECT item_id FROM item WHERE product_id IN 
(SELECT product_id FROM product WHERE series LIKE 'Fate/Stay Night')));

-- Q.9

CREATE VIEW titleVw AS
SELECT * FROM product;

select * from product;
select * from genre;
select * from xrefseriesgenre;
select series from product where series in (select series from xrefseriesgenre);

select genre,name from product p
join xrefseriesgenre x on x.series = p.series;

CREATE VIEW genre_product_view AS
SELECT genre AS 'Genre', name AS 'Product Name' FROM product p
JOIN xrefseriesgenre x on p.series = x.series ORDER BY genre;

SELECT * FROM genre_product_view;

-- Q.10
select * from account;
select * from orders;
select state_province AS State from account;
select user_id from account where state_province = 'AK';
select sum(total_price) from orders where user_id = 48;

SELECT state_province AS State, 
SUM(total_price) AS 'Total Price of Orders within State'
FROM account a
JOIN orders o ON a.user_id = o.user_id 
GROUP BY state_province;


SELECT state_province AS State, 
ROUND(SUM(total_price),0) 
AS 'Total Price of Orders within State'
FROM account a
JOIN orders o ON a.user_id = o.user_id 
GROUP BY state_province;

SELECT state_province AS State,
SUM(total_price) AS 'Total Price of Orders within State'
FROM account WHERE user_id in (select user_id from orders);

select sum(total_price) from orders where user_id in 
(select user_id from account where state_province = 'AK');

-- Q.11
use toystore;
select * from product;
select * from item;

SELECT product_id AS 'Product ID', 
listprice AS 'List Price', unitprice AS 'Unit Price',
FORMAT(100 * (listprice - unitprice) / unitprice,0) AS 'Mark-up %'
FROM item GROUP BY 'Mark-up %' HAVING 'Mark-up %' > avg(100 * (listprice - unitprice) / unitprice);

SELECT product_id AS 'Product ID', 
listprice AS 'List Price', unitprice AS 'Unit Price',
FORMAT(100 * (listprice - unitprice) / unitprice,0) AS 'Mark-up %', AVG('Mark-up %')
FROM item;

SELECT product_id AS 'Product ID', 
listprice AS 'List Price', unitprice AS 'Unit Price',
ROUND(100 * (listprice - unitprice) / unitprice) AS 'Mark-up %'
FROM item group by 'Mark-up %' HAVING 'Mark-up %' > AVG('Mark-up %');

SELECT product_id AS 'Product ID', 
listprice AS 'List Price', unitprice AS 'Unit Price',
ROUND(100 * (listprice - unitprice) / unitprice) AS 'Mark-up %'
FROM item group by 'Mark-up %' HAVING 'Mark-up %' > (select avg(100 * (listprice - unitprice) / unitprice from item));

select avg(100 * (listprice - unitprice) / unitprice) from item;

select listprice from item having unitprice >  (select avg(100 *  (listprice - unitprice) / unitprice from item));

SELECT product_id AS 'Product ID', 
listprice AS 'List Price', unitprice AS 'Unit Price',
FORMAT(100 * (listprice - unitprice) / unitprice,0) AS 'Mark-up %'
FROM item group by 'Mark-up %';

select FORMAT(100 * (listprice - unitprice) / unitprice,0) from item;	-- mark-up
select avg(100 * (listprice - unitprice) / unitprice) from item;		-- average

SELECT product_id AS 'Product ID', listprice AS 'List Price', unitprice AS 'Unit Price',
FORMAT(100 * (listprice - unitprice) / unitprice,0) AS 'Mark-up %' FROM item
WHERE (100 * (listprice - unitprice) / unitprice) >= 
(SELECT AVG(100 * (listprice - unitprice) / unitprice) FROM item);

SELECT product_id AS 'Product ID', 
listprice AS 'List Price', unitprice AS 'Unit Price',
ROUND(100 * (listprice - unitprice) / unitprice) AS 'Mark-up %' FROM item 
WHERE (100 * (listprice - unitprice) / unitprice) >= 
(SELECT AVG(100 * (listprice - unitprice) / unitprice) FROM item);


-- Q.12
select * from orders;

SELECT order_id AS 'Order No', order_date AS 'Order Date'
FROM orders;
select date_add(order_date, interval 3 day) from orders;

SELECT order_id AS 'Order No', order_date AS 'Order Date', 
DATE_ADD(order_date, INTERVAL 3 DAY) AS 'Expected Delivery Date'
FROM orders;

select order_date, date_add(order_date, interval 7 day) from orders;


-- 4

SELECT gender AS Gender, 
ROUND(COUNT(*) / (SELECT COUNT(*) FROM account) * 100,0) 
AS '% Account Holders' 
FROM ACCOUNT WHERE gender IN ('M','F') GROUP BY GENDER;

SELECT gender AS Gender, 
ROUND(COUNT(gender) / (SELECT COUNT(*) FROM account) * 100,0) 
AS '% Account Holders' 
FROM ACCOUNT WHERE gender IN ('M','F') GROUP BY GENDER;


