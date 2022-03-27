DROP DATABASE IF EXISTS vk;

CREATE DATABASE IF NOT EXISTS vk;

-- использовать БД vk  
USE vk;

-- использовать все таблицы
SHOW TABLES;

CREATE TABLE users(
   id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
   first_name VARCHAR(150) NOT NULL, 
   last_name VARCHAR(150) NOT NULL,   
   email VARCHAR(150) UNIQUE NOT NULL,   
   phone CHAR(11) UNIQUE NOT NULL,   
   password_hash CHAR(65) DEFAULT NULL,   
   created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,   
   INDEX (last_name)
);

SELECT * FROM users;

-- Заполнение таблицы Коля и Леша
INSERT INTO users VALUES (1, 'Kolya', 'Ivanov', 'kolya@mail.com', '12345678912', 
'12345', DEFAULT); 
INSERT INTO users VALUES (DEFAULT, 'Lesha', 'Petrov', 'Lesha@mail.ru', '98765432112',
NULL, DEFAULT);

-- создание профеля пользователя
CREATE TABLE profiles(
     user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
     gende ENUM('f', 'm', 'x') NOT NULL,
     birthday DATE NOT NULL,
     photo_id BIGINT UNSIGNED,
     city VARCHAR(130),
     country VARCHAR (130),
     FOREIGN KEY (user_id) REFERENCES users(id)   
);

-- профиль для Коли
INSERT INTO profiles VALUES (1, 'm', '1997-11-02', 1, 'SPb', 'Russia');

-- профиль для Леши
INSERT INTO profiles VALUES (2, 'm', '1997-08-02', 6, 'SPb', 'Russia');

SELECT * FROM profiles;

-- общение между пользователями
CREATE TABLE messages(
	id SERIAL PRIMARY KEY, -- SERIAL (сокращенная команда от) BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	txt TEXT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	id_delivered BOOLEAN DEFAULT FALSE,
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id) 
);

-- Добавим два сообщения от Коли к Леше, сообщение от Леши к Коле
-- Сообщение от Коли к Леше №1
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Привет! Как дела?', DEFAULT, DEFAULT, DEFAULT);

SELECT * FROM messages; 

-- Сообщение от Коли к Леше №2
INSERT INTO messages VALUES (DEFAULT, 1, 2, 'Ты дома?', DEFAULT, DEFAULT, DEFAULT);

-- Сообщение от Леши к Коле №1
INSERT INTO messages VALUES (DEFAULT, 2, 1, 'Привет, я дома!', DEFAULT, DEFAULT, DEFAULT);


-- Создаем таблицу добавления в друзья
CREATE TABLE friend_request(
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	acceptet BOOL DEFAULT FALSE,
	PRIMARY KEY (from_user_id, to_user_id),
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

-- Запрос на дружбу от Коли к Леше
INSERT INTO friend_request VALUES (1, 2, DEFAULT);

SELECT * FROM friend_request;

-- Таблица Сообщество
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150) NOT NULL,
	description VARCHAR(250),
	admin_id BIGINT UNSIGNED NOT NULL,
	INDEX (name),
	FOREIGN KEY (admin_id) REFERENCES users(id) 
);

-- Добавляем в сообщество Колю
INSERT INTO communities VALUES (DEFAULT, 'Учение-свет', 'Изучение СУБД', 1);

SELECT * FROM communities;

-- Создание таблицы ЧЛЕНОВ сообществ
CREATE TABLE communities_users(
	community_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (community_id, user_id),
	FOREIGN KEY (community_id) REFERENCES communities(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);
 
-- Добавляем Лешу в сообщество "Учение - свет", через страничку Коли
INSERT INTO communities_users VALUES (1, 2);

SELECT * FROM communities_users;

-- Созание справочника типов файлов, для загрузки пользователемя
CREATE TABLE media_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) UNIQUE NOT NULL 
);

-- Добавляем в справочник типы файлов
INSERT INTO media_types VALUES (DEFAULT, 'изображения');
INSERT INTO media_types VALUES (DEFAULT, 'музыка');
INSERT INTO media_types VALUES (DEFAULT, 'документы');

-- Таблица с данными о файле(серия №, имя и т. п.)
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_types_id INT UNSIGNED NOT NULL,
	file_name VARCHAR(255),
	file_size BIGINT UNSIGNED,
	criated_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_types_id) REFERENCES media_types(id)  
); 


-- Заполняем таблицу
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im.jpg', 100, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 1, 1, 'im1.png', 78, DEFAULT);
INSERT INTO media VALUES (DEFAULT, 2, 3, 'doc.docx', 1024, DEFAULT);

SELECT * FROM media;




















