--TABLOLARI OLUŞTURMA
CREATE TABLE IF NOT EXISTS users (user_id SERIAL PRIMARY KEY,
				   username VARCHAR UNIQUE NOT NULL,
				   email VARCHAR UNIQUE NOT NULL,
				   creation_date TIMESTAMP DEFAULT NOW(),
				   is_active BOOLEAN);
				   
CREATE TABLE IF NOT EXISTS categories (category_id SERIAL PRIMARY KEY,
									  name VARCHAR UNIQUE NOT NULL,
									  creation_date TIMESTAMP DEFAULT NOW());
								
CREATE TABLE IF NOT EXISTS
posts (post_id SERIAL PRIMARY KEY,
		user_id INTEGER NOT NULL,
		category_id INTEGER NOT NULL,
		title VARCHAR(50) NOT NULL,
		content VARCHAR NOT NULL,
		view_count INTEGER DEFAULT 0,
		creation_date TIMESTAMP DEFAULT NOW(),
		is_published BOOLEAN,
		FOREIGN KEY (user_id) REFERENCES users(user_id),
	   FOREIGN KEY (category_id) REFERENCES categories(category_id) 
	  );
	  
CREATE TABLE IF NOT EXISTS 
	comments(comment_id SERIAL PRIMARY KEY,
			 post_id INTEGER NOT NULL,
			 user_id INTEGER,
			 comment VARCHAR NOT NULL,
			 creation_date TIMESTAMP DEFAULT NOW(),
			 is_confirmed BOOLEAN,
			 FOREIGN KEY (post_id) REFERENCES posts(post_id),
			 FOREIGN KEY (user_id) REFERENCES users(user_id)
			);