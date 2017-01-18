SELECT DISTINCT
  b1.user_id
FROM books_users AS b1, books_users AS b2
WHERE b1.book_id = 1002 AND b2.book_id = 1003;

SELECT array_agg(DISTINCT b1.user_id)
FROM books_users AS b1, books_users AS b2
WHERE b1.book_id = 1002 AND b2.book_id = 1003;


# Jaccard similarity
SELECT
  (# (array_agg(DISTINCT b1.user_id) & array_agg(DISTINCT b2.user_id)))::numeric /
  (# (array_agg(DISTINCT b1.user_id) | array_agg(DISTINCT b2.user_id)))::numeric as similarity
FROM books_users AS b1, books_users AS b2
WHERE b1.book_id = 1002 AND b2.book_id = 1003;
