SELECT DISTINCT
  b1.user_id
FROM books_users AS b1, books_users AS b2
WHERE b1.book_id = 1002 AND b2.book_id = 1003;

SELECT array_agg(DISTINCT b1.user_id)
FROM books_users AS b1, books_users AS b2
WHERE b1.book_id = 1002 AND b2.book_id = 1003;


# for one book
SELECT
  b2.book_id,
  (# (array_agg(DISTINCT b1.user_id) & array_agg(DISTINCT b2.user_id)))::numeric /
  (# (array_agg(DISTINCT b1.user_id) | array_agg(DISTINCT b2.user_id)))::numeric as similarity
FROM books_users AS b1, books_users AS b2
WHERE b1.book_id = 1002 and b2.book_id != 1002
GROUP BY b2.book_id
ORDER BY similarity DESC
LIMIT 10;

# for all books (unnecessary, but possible -- could even materialize in postgres)
SELECT
  b2.book_id,
  (# (array_agg(DISTINCT b1.user_id) & array_agg(DISTINCT b2.user_id)))::numeric /
  (# (array_agg(DISTINCT b1.user_id) | array_agg(DISTINCT b2.user_id)))::numeric as similarity
FROM books_users AS b1, books_users AS b2
GROUP BY b1.book_id, b2.book_id
ORDER BY similarity DESC
LIMIT 10;


WITH similar_books AS (
  SELECT
    b2.book_id,
    (# (array_agg(DISTINCT b1.user_id) & array_agg(DISTINCT b2.user_id)))::numeric /
    (# (array_agg(DISTINCT b1.user_id) | array_agg(DISTINCT b2.user_id)))::numeric as similarity
  FROM books_users AS b1, books_users AS b2
  WHERE b1.book_id = 1002 and b2.book_id != 1002
  GROUP BY b2.book_id
  ORDER BY similarity DESC
  LIMIT 10
)
SELECT books.*, similarity
FROM similar_books
JOIN books ON books.id = similar_books.book_id;
