use Car;
Select * from users;
Select * from city;
Select * from cars;
Select * from bids;
select * from advertisements;
LOAD DATA LOCAL INFILE 'C:/Users/Muhammad Ilham/Documents/GitHub/Used-Car-Website-Database/city.csv'
INTO TABLE city
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
select * from advertisements;
select * from users;
select * from cars;
select * from advertisements;
select * from cars;
ALTER TABLE `car`.`advertisements` 
ADD CONSTRAINT `fk_cars`
  FOREIGN KEY(car_id)
  REFERENCES `car`.`cars` (car_id)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT,
ADD CONSTRAINT `fk_user`
  FOREIGN KEY (`user_id`)
  REFERENCES `car`.`users` (`user_id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  ALTER TABLE `car`.`bids` 
ADD INDEX `fk_users_idx` (`user_id` ASC) VISIBLE;
;
ALTER TABLE `car`.`bids` 
ADD CONSTRAINT `fk_ads`
  FOREIGN KEY (ads_id)
  REFERENCES `car`.`advertisements` (ads_id)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT,
ADD CONSTRAINT `fk_users`
  FOREIGN KEY (`user_id`)
  REFERENCES `car`.`users` (`user_id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
#Comparing car price with average price on each city
SELECT 
	ads_id,
	city,
	car_brand,
	car_model,
	year_built,
	price,
	AVG(price) OVER(PARTITION BY city) AS avg_price
FROM advertisements as ads
LEFT JOIN users
ON users.user_id = ads.user_id
LEFT JOIN city
ON users.city_id = city.city_id
LEFT JOIN cars
ON ads.car_id = cars.car_id
ORDER BY ads_id ASC;

#Find car that were built beyond 2015
SELECT 
	year_built,
	car_brand,
	car_model,
	price
FROM advertisements AS ads
LEFT JOIN cars
ON ads.car_id = cars.car_id
WHERE year_built >= 2015;

#Checking the newest advertisements post from an account
SELECT
	first_name,
	last_name,
	car_brand,
	car_model,
	posting_date,
	price
FROM advertisements AS ads
LEFT JOIN users
ON ads.user_id = users.user_id
LEFT JOIN cars
ON ads.car_id = cars.car_id
WHERE 
	first_name LIKE 'Vicky' AND
	last_name LIKE 'Riyanti'
ORDER BY posting_date DESC;

#Finding the cheapest car
SELECT
	ads_id,
	car_brand,
	car_model,
	year_built,
	posting_date,
	price
FROM advertisements AS ads
LEFT JOIN cars
ON ads.car_id = cars.car_id
ORDER BY price ASC;

#Comparing last bid date & price with next entry bid, for the same user & same car
SELECT *
FROM(
	SELECT
		car_model,
		bids.user_id,
		bid_date,
		bid_price,
		LEAD(bid_date) OVER(PARTITION BY car_model, bids.user_id ORDER BY bid_date ASC) AS next_bid_date,
		LEAD(bid_price) OVER(PARTITION BY car_model, bids.user_id ORDER BY bid_date ASC) AS next_bid_price
	FROM bids
	LEFT JOIN advertisements AS ads
	ON ads.ads_id = bids.ads_id
	LEFT JOIN cars
	ON ads.car_id = cars.car_id
) AS compare
WHERE next_bid_date IS NOT NULL;
