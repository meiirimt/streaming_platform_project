-- 1
SELECT *
FROM users
WHERE country = 'Kazakhstan';

-- 2
SELECT *
FROM users
WHERE age > 30;

-- 3
SELECT *
FROM subscriptions
WHERE status = 'Active';

-- 4
SELECT *
FROM content
WHERE rating > 8.0;

-- 5
SELECT *
FROM views
WHERE watch_minutes > 120;

-- 6
SELECT country, COUNT(*) AS users_count
FROM users
GROUP BY country
HAVING COUNT(*) > 50;

-- 7
SELECT status, COUNT(*)
FROM subscriptions
GROUP BY status
HAVING COUNT(*) > 100;

-- 8
SELECT content_id, COUNT(*) AS total_views
FROM views
GROUP BY content_id
HAVING COUNT(*) > 20;

-- 9
SELECT genre_id, AVG(rating)
FROM content
GROUP BY genre_id
HAVING AVG(rating) > 7.0;

-- 10
SELECT user_id, SUM(watch_minutes)
FROM views
GROUP BY user_id
HAVING SUM(watch_minutes) > 500;

-- 11
SELECT u.full_name, s.plan_type
FROM users u
JOIN subscriptions s
ON u.user_id = s.user_id;

-- 12
SELECT u.full_name, s.status
FROM users u
JOIN subscriptions s
ON u.user_id = s.user_id;

-- 13
SELECT c.title, g.genre_name
FROM content c
JOIN genres g
ON c.genre_id = g.genre_id;

-- 14
SELECT u.full_name, c.title
FROM users u
JOIN views v
ON u.user_id = v.user_id
JOIN content c
ON v.content_id = c.content_id;

-- 15
SELECT c.title, COUNT(*) AS views_count
FROM content c
JOIN views v
ON c.content_id = v.content_id
GROUP BY c.title;

-- 16
SELECT g.genre_name, COUNT(*) AS total_views
FROM genres g
JOIN content c
ON g.genre_id = c.genre_id
JOIN views v
ON c.content_id = v.content_id
GROUP BY g.genre_name;

-- 17
SELECT s.plan_type, COUNT(*) AS subscribers
FROM subscriptions s
GROUP BY s.plan_type;

-- 18
SELECT u.country, COUNT(*) AS views_count
FROM users u
JOIN views v
ON u.user_id = v.user_id
GROUP BY u.country;

-- 19
SELECT c.title, SUM(v.watch_minutes) AS total_watch_time
FROM content c
JOIN views v
ON c.content_id = v.content_id
GROUP BY c.title;

-- 20
SELECT g.genre_name, AVG(c.rating) AS avg_rating
FROM genres g
JOIN content c
ON g.genre_id = c.genre_id
GROUP BY g.genre_name;

-- 21
SELECT
title,
rating,
RANK() OVER(ORDER BY rating DESC) AS rating_rank
FROM content;

-- 22
SELECT
title,
rating,
DENSE_RANK() OVER(ORDER BY rating DESC) AS dense_rank
FROM content;

-- 23
SELECT
user_id,
watch_minutes,
SUM(watch_minutes)
OVER(PARTITION BY user_id) AS total_watch_time
FROM views;

-- 24
SELECT
genre_id,
title,
rating,
AVG(rating)
OVER(PARTITION BY genre_id) AS genre_avg_rating
FROM content;

-- 25
SELECT
user_id,
watch_date,
COUNT(*)
OVER(PARTITION BY user_id) AS total_views
FROM views;

-- 26
SELECT *
FROM content
WHERE rating >
(
    SELECT AVG(rating)
    FROM content
);

-- 27
SELECT *
FROM users
WHERE user_id IN
(
    SELECT user_id
    FROM subscriptions
    WHERE status = 'Active'
);

-- 28
WITH user_stats AS
(
    SELECT
    user_id,
    COUNT(*) AS views_count
    FROM views
    GROUP BY user_id
)
SELECT *
FROM user_stats
WHERE views_count > 10;

-- 29
WITH genre_views AS
(
    SELECT
    g.genre_name,
    COUNT(*) AS total_views
    FROM genres g
    JOIN content c
        ON g.genre_id = c.genre_id
    JOIN views v
        ON c.content_id = v.content_id
    GROUP BY g.genre_name
)
SELECT *
FROM genre_views;

-- 30
WITH active_users AS
(
    SELECT DISTINCT user_id
    FROM views
)
SELECT
COUNT(*) AS active_users_count
FROM active_users;
