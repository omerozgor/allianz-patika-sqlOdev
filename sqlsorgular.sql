-- 1. Tüm blog yazılarını başlıkları, yazarları ve kategorileriyle birlikte getirin.
SELECT title, username, name AS category FROM posts
JOIN users ON posts.user_id = users.user_id
JOIN categories ON posts.category_id = categories.category_id;

-- 2. En son yayınlanan 5 blog yazısını başlıkları, yazarları ve yayın tarihleriyle birlikte alın.
SELECT title, username, posts.creation_date fROM posts
JOIN users ON posts.user_id = users.user_id
ORDER BY posts.creation_date DESC
LIMIT 5;

-- 3. Her blog yazısı için yorum sayısını gösterin.
SELECT title, COUNT(comment) AS comment_count FROM comments
FULL JOIN posts ON comments.post_id = posts.post_id
GROUP BY title
ORDER BY COUNT(comment);

-- 4. Tüm kayıtlı kullanıcıların kullanıcı adlarını ve e-posta adreslerini gösterin.
SELECT username, email FROM users;

-- 5. En son 10 yorumu, ilgili gönderi başlıklarıyla birlikte alın.
SELECT comment, title FROM comments
JOIN posts ON posts.post_id = comments.post_id
ORDER BY comments.creation_date DESC
LIMIT 10;

-- 6. Belirli bir kullanıcı tarafından yazılan tüm blog yazılarını bulun.
SELECT * FROM posts
WHERE user_id = 15;

-- 7. Her kullanıcının yazdığı toplam gönderi sayısını alın.
SELECT username,COUNT(*) AS post_count FROM posts
JOIN users ON posts.user_id = users.user_id
GROUP BY username;

-- 8. Her kategoriyi, kategorideki gönderi sayısıyla birlikte gösterin.
SELECT categories.name AS category_name, COUNT(*) AS post_count FROM posts
JOIN categories ON posts.category_id = categories.category_id
GROUP BY categories.name;

-- 9. Gönderi sayısına göre en popüler kategoriyi bulun.
SELECT categories.name AS category_name FROM posts
JOIN categories ON posts.category_id = categories.category_id
GROUP BY categories.name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 10. Gönderilerindeki toplam görüntülenme sayısına göre en popüler kategoriyi bulun.
SELECT categories.name ,SUM(view_count) FROM posts
JOIN categories ON posts.category_id = categories.category_id
GROUP BY name
ORDER BY SUM(view_count) DESC
LIMIT 1;

-- 11. En fazla yoruma sahip gönderiyi alın.
SELECT title, COUNT(comment) AS comment_count FROM comments
JOIN posts ON posts.post_id = comments.post_id
GROUP BY title
ORDER BY COUNT(comment) DESC
LIMIT 1;

-- 12. Belirli bir gönderinin yazarının kullanıcı adını ve e-posta adresini gösterin.
SELECT title AS post_title ,username, email FROM posts
JOIN users ON posts.user_id = users.user_id
WHERE post_id = 13;

-- 13.  Başlık veya içeriklerinde belirli bir anahtar kelime bulunan tüm gönderileri bulun.
SELECT * FROM posts
WHERE title ILIKE '%money%' OR content ILIKE '%money%';

-- 14. Belirli bir kullanıcının en son yorumunu gösterin.
SELECT * FROM comments
WHERE comments.user_id = 12
ORDER BY comments.creation_date DESC
LIMIT 1;

-- 15. Gönderi başına ortalama yorum sayısını bulun.
SELECT AVG(co) FROM (SELECT COUNT(comment) co FROM comments
GROUP BY post_id) as x;

-- 16. Son 30 günde yayınlanan gönderileri gösterin.
SELECT * FROM posts
WHERE creation_date > CURRENT_DATE - INTERVAL '30 days';

-- 17. Belirli bir kullanıcının yaptığı yorumları alın.
SELECT * FROM comments
WHERE user_id = 18;

-- 18. Belirli bir kategoriye ait tüm gönderileri bulun.
SELECT * FROM posts
WHERE category_id = 2;

-- 19. 5'ten az yazıya sahip kategorileri bulun.
SELECT categories.name, COUNT(*) FROM posts
JOIN categories ON posts.category_id = categories.category_id
GROUP BY categories.name 
HAVING COUNT(*) < 5;

-- 20. Hem bir yazı hem de bir yoruma sahip olan kullanıcıları gösterin.
SELECT username FROM comments
JOIN users on users.user_id = comments.user_id
GROUP BY username
HAVING COUNT(comment) = 1
INTERSECT
SELECT username FROM posts
JOIN users on users.user_id = posts.user_id
GROUP BY username
HAVING COUNT(*) = 1;

--21.  En az 2 farklı yazıya yorum yapmış kullanıcıları alın.
SELECT username
FROM (
  SELECT user_id, COUNT(DISTINCT post_id) AS num_posts
  FROM comments
  GROUP BY user_id
) AS x
JOIN users ON users.user_id = x.user_id
WHERE num_posts >= 2 AND x.user_id IS NOT NULL;

-- 22. En az 3 yazıya sahip kategorileri görüntüleyin.
SELECT name FROM posts
JOIN categories ON posts.category_id = categories.category_id
GROUP BY name
HAVING COUNT(*) >= 3;

-- 23.  5'ten fazla blog yazısı yazan yazarları bulun.
SELECT username
FROM (
  SELECT user_id, COUNT(*) AS num_posts
  FROM posts
  GROUP BY user_id
) AS x
JOIN users ON users.user_id = x.user_id
WHERE num_posts >= 5;

-- 24. Bir blog yazısı yazmış veya bir yorum yapmış kullanıcıların e-posta adreslerini görüntüleyin. (UNION kullanarak)
SELECT DISTINCT email FROM posts
JOIN users ON users.user_id = posts.user_id
UNION
SELECT DISTINCT email FROM comments
JOIN users ON users.user_id = comments.user_id;

-- 25. Bir blog yazısı yazmış ancak hiç yorum yapmamış yazarları bulun.
SELECT username FROM posts
JOIN users ON users.user_id = posts.user_id
GROUP BY username
HAVING COUNT(*) = 1
INTERSECT
(SELECT username FROM users
 EXCEPT
SELECT DISTINCT username FROM comments
LEFT JOIN users ON users.user_id = comments.user_id);