SELECT 
id_product,
name,
category,
name_store
FROM
products_data_all;

--

SELECT
*
FROM
products_data_all;

--

SELECT
name,
author
FROM
books
WHERE
author != 'Эрих Мария Ремарк';

--

SELECT
    name,
    author,
    price
FROM
    books
WHERE
    price > 200;

--

SELECT
    name,
    author,
    date_pub,
    price
FROM
    books
WHERE
    date_pub > '1990-12-31' AND
    date_pub < '2001-01-01';

--

SELECT
    name.
    author,
    date_pub,
    price
FROM
    books
WHERE
    date_pub BETWEEN '1991-01-01' AND '2000-12-31';

--

SELECT
    name,
    pub_name
FROM
    books
WHERE
    pub_name = 'АСТ' OR 'ЛитРес' OR 'Росмэн';

--

SELECT
    name,
    pub_name
FROM    
    books
WHERE
    pub_name IN ('АСТ','ЛитРес','Росмэн');

--

SELECT
    name,
    price,
    name_store,
    date_upd
FROM
    products_data_all
WHERE
    category = 'молоко и сливки' AND
    date_upd = '2019-06-01';

--

SELECT
    name,
    price,
    name_store,
    date_upd
FROM
    products_data_all
WHERE
    category = 'молоко и сливки' AND
    date_upd IN ('2019-06-08', '2019-06-15', '2019-06-22');

--

SELECT
    *
FROM
    transactions
WHERE
    date >= '2019-06-01' AND
    date < '2019-06-02' AND
    id_product IN ( 0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 28, 29, 30, 31,
32, 34, 35, 36, 37, 38, 39, 40, 42, 43, 44, 45, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
61, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,76, 77, 78, 80, 81, 82, 83, 84, 86, 88, 89, 90,
91, 92, 93, 95, 96, 97, 98, 99, 100, 102, 103, 104, 105,106, 107, 108, 109, 110, 111, 112, 113, 114,
115, 116, 118, 119, 5, 14, 27, 33, 41, 46, 62, 79, 85, 87, 94, 101, 117 );

--

SELECT
    COUNT(price) AS price_cnt,
    COUNT(DISTINCT price) AS price_uniq_cnt
FROM
    books;

--

SELECT
    SUM(price) AS price_sum
FROM
    books;

--

SELECT
    AVG(price) AS price_avg
FROM
    books;

--

SELECT
    COUNT(*) AS cnt
FROM
    products_data_all;

--

SELECT
    COUNT(*) AS cnt,
    COUNT(name) AS name_cnt,
    COUNT(DISTINCT name) AS name_uniq_cnt
FROM
    products_data_all;

--

SELECT
    AVG(price) AS price_avg
FROM
    products_data_all;

--

SELECT
    AVG (price) AS price_avg
FROM
    products_data_all,
WHERE
    name = 'Молоко пастеризованное Домик в деревне 2,5%, 930 мл' AND
    name_store = 'Семерочка';

SELECT
    SUM(price) AS price_sum
FROM
    products_data_all,
WHERE
    name_store = 'Молочные вкусности';


--

SELECT
    MAX(price) AS max_price
FROM
    products_data_all;

--

SELECT
    MAX(price) - MIN(price) AS max_min_diff
FROM
    products_data_all,
WHERE
    name = 'Масло топленое Ecotavush 99%, 500 г' AND
    name_store = 'ВкусМилк';

--

SELECT
    weight :: integer
FROM
    products_data_all;

--

SELECT
    AVG(weight :: real)
FROM
    products_data_all,
WHERE
    units = 'г';

--

SELECT
    MAX(CAST(weight AS real)) AS max_weight
FROM   
    products_data_all,
WHERE
    category = 'молоко и сливки';

--
SELECT
    author,
    COUNT(name) AS cnt
FROM
    books,
GROUP BY
    author;

--
SELECT
    author,
    rating,
    COUNT(name) AS cnt
FROM
    books,
GROUP BY
    author,
    rating;

--

SELECT
    author,
    MAX(pages :: integer) AS max_pages,
    AVG(pages :: integer) AS avg_pages
FROM  
    books,
GROUP BY
    author;

--

SELECT
    name_store,
    COUNT(name) AS name_cnt,
    COUNT(DISTINCT name) AS name_uniq_cnt
FROM
    products_data_all,
GROUP BY
    name_store;

--

SELECT
    category,
    MAX(weight :: real) AS max_weight,
FROM
    products_data_all
GROUP BY
    category;

--

SELECT
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price
FROM
    products_data_all
GROUP BY
    name_store;

--
SELECT
    name,
    MAX(price) - MIN(price) AS max_min_diff 
FROM
    products_data_all
WHERE
    category = 'масло сливочное и маргарин' AND
    date_upd :: date = '2019-06-10'
GROUP BY
    name;

--

SELECT
    author,
    COUNT(name) AS name_cnt
FROM
    books
GROUP BY
    author
ORDER BY
    name_cnt ASC,
LIMIT
    3;

--

SELECT 
    COUNT(name) AS name_cnt
FROM
    products_data_all
WHERE
    date_upd :: date AS update_date = '2019-06-05'
GROUP BY
    category,
    update_date
ORDER BY
    name_cnt;

--

SELECT
    COUNT(DISTINCT name) AS name_uniq_cnt
FROM
    products_data_all
WHERE
    name_store = 'Lentro' AND
    date_upd :: date AS update_date = '2019-06-30'
GROUP BY
    category,
    name_store,
    update_date
ORDER BY
    name_uniq_cnt DESC;

--

SELECT
    name,
    MAX(price) AS max_price
FROM    
    products_data_all
GROUP BY
    name
ORDER BY
    max_price DESC
LIMIT
    5;