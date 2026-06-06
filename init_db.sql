1-кезен 
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    age INTEGER,
    country VARCHAR(50),
    registration_date DATE
);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL
);

CREATE TABLE content (
    content_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    genre_id INTEGER REFERENCES genres(genre_id),
    release_year INTEGER,
    rating NUMERIC(3,1)
);

CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    plan_type VARCHAR(30),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);
CREATE TABLE views (
    view_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    content_id INTEGER REFERENCES content(content_id),
    watch_date DATE,
    watch_minutes INTEGER
);

2-кезен 
INSERT INTO genres (genre_name)
VALUES
('Action'),
('Drama'),
('Comedy'),
('Horror'),
('Fantasy'),
('Romance'),
('Documentary'),
('Thriller');

DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..200 LOOP
        INSERT INTO content (
            title,
            genre_id,
            release_year,
            rating
        )
        VALUES (
            'Movie_' || i,
            floor(random() * 8 + 1)::int,
            floor(random() * 17 + 2010)::int,
            round((random() * 4.9 + 5.0)::numeric, 1)
        );
    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..1000 LOOP

        INSERT INTO subscriptions (
            user_id,
            plan_type,
            start_date,
            end_date,
            status
        )
        VALUES (
            i,
            (ARRAY['Basic','Standard','Premium'])[floor(random()*3+1)],
            DATE '2024-01-01' + floor(random()*365)::int,
            DATE '2025-01-01' + floor(random()*365)::int,
            (ARRAY['Active','Cancelled','Expired'])[floor(random()*3+1)]
        );

    END LOOP;
END $$;

DO $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..5000 LOOP

        INSERT INTO views (
            user_id,
            content_id,
            watch_date,
            watch_minutes
        )
        VALUES (
            floor(random() * 1000 + 1)::int,
            floor(random() * 200 + 1)::int,
            DATE '2024-01-01' + floor(random() * 730)::int,
            floor(random() * 170 + 10)::int
        );

    END LOOP;
END $$;

SELECT COUNT(*) FROM users;

SELECT COUNT(*) FROM content;

SELECT COUNT(*) FROM subscriptions;

SELECT COUNT(*) FROM views;



