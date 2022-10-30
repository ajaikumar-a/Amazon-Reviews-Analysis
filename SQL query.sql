-- creating a product categories table

CREATE TABLE categories AS
(
	SELECT DISTINCT product_id, 'Appliances' AS category
	FROM appliances

	UNION ALL

	SELECT DISTINCT product_id, 'Cell phones and accessories' AS category
	FROM cell_phones_accessories

	UNION ALL

	SELECT DISTINCT product_id, 'Cosmetics' AS category
	FROM cosmetics

	UNION ALL

	SELECT DISTINCT product_id, 'Digital music' AS category
	FROM digital_music

	UNION ALL

	SELECT DISTINCT product_id, 'Fashion' AS category
	FROM fashion

	UNION ALL

	SELECT DISTINCT product_id, 'Gift cards' AS category
	FROM gift_cards

	UNION ALL

	SELECT DISTINCT product_id, 'Grocery and gourmet food' AS category
	FROM grocery_gourmet_food

	UNION ALL

	SELECT DISTINCT product_id, 'Industrial and scientific' AS category
	FROM industrial_scientific

	UNION ALL

	SELECT DISTINCT product_id, 'Magazine subscriptions' AS category
	FROM magazine_subscriptions

	UNION ALL

	SELECT DISTINCT product_id, 'Musical instruments' AS category
	FROM musical_instruments

	UNION ALL

	SELECT DISTINCT product_id, 'Office products' AS category
	FROM office_products

	UNION ALL

	SELECT DISTINCT product_id, 'Software' AS category
	FROM software

	UNION ALL

	SELECT DISTINCT product_id, 'Sports and outdoors' AS category
	FROM sports_outdoors

	UNION ALL

	SELECT DISTINCT product_id, 'Toys and games' AS category
	FROM toys_games

	UNION ALL

	SELECT DISTINCT product_id, 'Video games' AS category
	FROM video_games
);


-- combining all the data tables into a single table

CREATE TABLE reviews AS 
(
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM appliances
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM cell_phones_accessories
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM cosmetics
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM digital_music
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM fashion
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM gift_cards
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM grocery_gourmet_food
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM industrial_scientific
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM magazine_subscriptions
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM musical_instruments
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM office_products
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM software
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM sports_outdoors
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM toys_games
	
	UNION ALL
	
	SELECT reviewer_id, product_id, date, rating, verified, vote
	FROM video_games
);



/* Data Cleaning */

-- Changing the data type of the column 'vote' from text into integer

UPDATE 
	reviews
SET 
	vote = REPLACE(vote, ',', '') -- removing the commas in the values

ALTER TABLE 
	reviews
	ALTER COLUMN 
		vote 
			TYPE integer USING vote::integer;

-- Changing the data type of the column 'date' from integer to date

ALTER TABLE 
	reviews
	ALTER COLUMN 
		date 
			SET DATA TYPE date USING TO_TIMESTAMP(date)::DATE;
			
			


-- Removing the records which are before the year 2007

DELETE FROM
	reviews
WHERE 
	EXTRACT(YEAR FROM date) < 2007;
	




/* Exploratory Data Analysis */


-- No.of reviews across the years 

SELECT 
	EXTRACT(YEAR FROM date) AS year,
	COUNT(*) no_of_reviews
FROM
	reviews
GROUP BY
	EXTRACT(YEAR FROM date)

	
-- No.of reviews and Average rating based on categories

SELECT
	c.category,
	COUNT(r.reviewer_id) no_of_reviews,
	ROUND(AVG(r.rating), 1) avg_rating
FROM	
	reviews r
	JOIN categories c
	  ON r.product_id = c.product_id
GROUP BY
	c.category
ORDER BY
	COUNT(r.reviewer_id) DESC,
	ROUND(AVG(r.rating), 1) DESC



-- Initial and latest no.of reviews

SELECT
	EXTRACT(YEAR FROM date) AS year,
	c.category,
	COUNT(*) no_of_reviews
FROM	
	reviews r
	JOIN categories c
	  ON r.product_id = c.product_id
GROUP BY
	EXTRACT(YEAR FROM date),
	c.category
ORDER BY
	year DESC;
	
	
-- Frequency of best rating across the years

SELECT
	EXTRACT(YEAR FROM date) AS year,
	COUNT(*) rating_frequency
FROM
	reviews
WHERE
	rating = 5
GROUP BY
	EXTRACT(YEAR FROM date)
	

-- Frequency of worst rating across the years

SELECT 
	EXTRACT(YEAR FROM date) AS year,
	COUNT(*) rating_frequency
FROM
	reviews
WHERE
	rating = 1
GROUP BY
	EXTRACT(YEAR FROM date)
	
	
-- Average rating across the years

SELECT
	EXTRACT(YEAR FROM date) AS year,
	ROUND(AVG(rating), 1) avg_rating
FROM
	reviews r
	JOIN categories c
	  ON r.product_id = c.product_id
GROUP BY
	EXTRACT(YEAR FROM date),
	c.category
	
	
	
-- Verified and Unverified reviews

SELECT
	year,
	COUNT(verified_review_score) total_reviews,
	SUM(verified_review_score) verfied_reviews,
	COUNT(verified_review_score) - SUM(verified_review_score) unverified_reviews,
	ROUND(1.0 * (COUNT(verified_review_score) - SUM(verified_review_score)) / COUNT(verified_review_score) * 100, 2) unverified_reviews_perc
FROM
  (
	SELECT
	  	EXTRACT(YEAR FROM date) AS year,
		CASE WHEN verified = 'TRUE' THEN 1 ELSE 0 END AS verified_review_score
	FROM
		reviews
  ) v
GROUP BY
	year	
	

-- No.of votes for verified reviews based on categories

SELECT
	category,
	COUNT(*) total_votes,
	SUM(score) verified_review_votes,
	ROUND(1.0 * SUM(score) / COUNT(*) * 100, 2) verified_review_votes_perc
FROM
(
SELECT
	c.category,
	r.vote,
	CASE WHEN verified = 'TRUE' THEN 1 ELSE 0 END AS score
FROM
	reviews r
	JOIN categories c 
	  ON r.product_id = c.product_id) s
GROUP BY
	category

	

	

	


	
	