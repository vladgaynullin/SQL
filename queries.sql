SELECT
  name, city, date_first, 
  (
    DATEDIFF(date_last, date_first)+ 1
  )* per_diem AS Сумма 
FROM
  trip 
WHERE
  MONTH(date_first) IN (2, 3) 
  AND YEAR(date_first) = 2020 
ORDER BY
  name, Сумма DESC;

--

UPDATE 
  fine f, payment p 
SET 
  f.date_payment = IF(f.date_payment IS NULL, p.date_payment, f.date_payment), 
  f.sum_fine = IF(p.date_payment - f.date_violation <= 20, f.sum_fine / 2, f.sum_fine) 
WHERE 
  (f.name, f.number_plate, f.violation) = (p.name, p.number_plate, p.violation);
SELECT 
  * 
FROM 
  fine;

--

UPDATE
    fine f, (
SELECT
    f.name, f.number_plate, f.violation
FROM
    fine f
GROUP BY
    f.name, f.number_plate, f.violation
HAVING
    COUNT(violation) >= 2
) temp
SET f.sum_fine = f.sum_fine * 2
WHERE
    f.date_payment IS NULL AND
    f.name = temp.name AND
    f.number_plate = temp.number_plate AND
    f.violation = temp.violation; 
    
SELECT * FROM fine;

--

SELECT name_author
FROM
    author
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON genre.genre_id = book.genre_id
GROUP BY name_author
HAVING COUNT(DISTINCT name_genre) = 1
ORDER BY name_author;

--

CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
);

DESCRIBE book;

--

SELECT title, name_author, name_genre, price, amount
FROM
    genre
    INNER JOIN book ON genre.genre_id = book.genre_id
    INNER JOIN author ON author.author_id = book.author_id
WHERE genre.genre_id IN
    (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM 
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN 
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount = query_in_2.sum_amount
         )
ORDER BY title;

--

SELECT name_author, name_genre, COUNT(title) AS Количество
FROM
    author AS a
    CROSS JOIN
    genre AS g
    LEFT JOIN
    book AS b
    ON b.author_id = a.author_id AND
    b.genre_id = g.genre_id
GROUP BY a.author_id, name_genre
ORDER BY name_author, Количество DESC;

--

UPDATE book
SET genre_id = (
    SELECT genre_id
    FROM genre
    WHERE name_genre = 'Поэзия'
)
WHERE title LIKE 'Стихотворения и поэмы' AND
    author_id = (
        SELECT author_id
        FROM author
        WHERE name_author LIKE '%Лермонтов%'
    );

UPDATE book
SET genre_id = (
    SELECT genre_id
    FROM genre
    WHERE name_genre = 'Приключения'
)
WHERE title LIKE 'Остров сокровищ' AND
    author_id = (
        SELECT author_id
        FROM author
        WHERE name_author LIKE '%Стивенсон%'
    );

SELECT * FROM book;

--

INSERT INTO author (name_author)
SELECT supply.author
FROM 
author
RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS Null;

INSERT INTO book(title,author_id,price,amount)
SELECT supply.title, author_id, price, amount
FROM
 supply 
    INNER JOIN author ON author.name_author = supply.author AND title NOT IN(SELECT title FROM book);
    
UPDATE book
SET genre_id = 1
WHERE title IN('Доктор Живаго');

UPDATE book
SET genre_id = 3
WHERE title IN('Остров сокровищ');
            
UPDATE book INNER JOIN (SELECT genre_id, AVG(price) AS newprice
                            FROM book
                            GROUP BY genre_id
                        ) AS q USING(genre_id)
SET book.price = q.newprice;
    
SELECT*FROM author;
SELECT*FROM book;

--

SELECT
    buy.buy_id,
    DATEDIFF(date_step_end, date_step_beg) AS Количество_дней,
    if(days_delivery >= DATEDIFF(date_step_end, date_step_beg), 0, DATEDIFF(date_step_end, date_step_beg) -days_delivery) AS Опоздание
FROM city
JOIN client USING(city_id)
JOIN buy USING(client_id)
JOIN buy_step USING(buy_id)
JOIN step USING(step_id)
WHERE step_id = 3 AND date_step_end IS NOT NULL

--

SELECT name_genre, sum(buy_book.amount) AS Количество
FROM genre
JOIN book USING(genre_id)
JOIN buy_book USING(book_id)
GROUP BY name_genre

HAVING SUM(buy_book.amount) =
     (/* вычисляем максимальное из общего количества книг каждого автора */
      SELECT MAX(sum_amount) AS max_sum_amount
      FROM 
          (/* считаем количество книг каждого автора */
            SELECT SUM(buy_book.amount) AS sum_amount 
            FROM buy_book
            JOIN book USING(book_id)
            GROUP BY genre_id
          ) query_in
      );
      
      
SELECT SUM(buy_book.amount) AS sum_amount 
FROM buy_book
JOIN book USING(book_id)
GROUP BY genre_id

--

SELECT title, sum(Количество) AS Количество, sum(Сумма) AS Сумма
FROM
(SELECT title, SUM(buy_archive.amount) AS Количество, SUM(buy_archive.price*buy_archive.amount) AS Сумма
FROM buy_archive
JOIN book USING(book_id)
GROUP BY 1
UNION ALL

SELECT book.title, SUM(buy_book.amount) AS Количество, SUM(price*buy_book.amount) AS Сумма
FROM book
JOIN buy_book USING(book_id)
JOIN buy USING(buy_id)
JOIN buy_step USING(buy_id)
WHERE buy_step.date_step_end IS NOT NULL AND step_id = 1
GROUP BY 1
) query_in
GROUP BY query_in.title
ORDER BY 3 DESC
