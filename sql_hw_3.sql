CREATE TABLE users(
  user_id integer GENERATED ALWAYS AS IDENTITY, --т.к. primary key, то тип int
  birth_date date,
  sex varchar(1), --одна буква - "М" или "Ж"
  age NUMERIC(2),
  primary key(user_id)
);

CREATE TABLE orders(
  item_id integer GENERATED ALWAYS AS IDENTITY,
  description varchar(100), --допустим, описание товара - текст длиной 100 символов
  price decimal(13, 2), --цена с точностью до копеек
  category varchar(50), --название категории - текст длиной 50 символов
  primary key(item_id)
);

CREATE TABLE ratings(
  /*
 если оставить в таблице только внешние ключи user_id и item_id, то как дать юзеру 
 возможность написать два ревью на один товар? как отличать эти два ревью друг от друга?
 (например, сразу после покупки и по прошествии нескольких лет использования) 
 для этого можем завести для таблицы ratings свой pk - rewiew_id
  */
  review_id integer GENERATED ALWAYS AS IDENTITY, 
  item_id integer not NULL, --foreign key, not null, иначе непонятно на что был этот отзыв
  user_id integer not NULL, --foreign key, not null, чтобы юзеру могли дать обратную связь по его отзыву
  review varchar(100), --текст ревью на 100 символов
  rating numeric(2), --рейтинг от 1 до 10
  primary key(review_id),
  CONSTRAINT fk_user foreign key(user_id) REFERENCES users(user_id),
  CONSTRAINT fk_item FOREIGN key(item_id) REFERENCES orders(item_id)
);


--заполнение таблицы users
insert into users (birth_date, sex, age)
select
date('2007-01-01') - (random() * (interval '70 years')) as birth_date,
unnest(array['М', 'Ж']) as sex,
0 as age
from generate_series(1, 20);

update users
set age = DATE_PART('YEAR', AGE(birth_date));

select * from users;

--заполнение таблицы orders
insert into orders (description, price, category)
select
md5(random()::text) as description,
round(cast(random() * 1000 as numeric), 2) as price,
unnest(array['toys', 'beauty', 'sport', 'swimsuit']) as category
from generate_series(1, 20);

select * from orders;

--заполнение таблицы ratings
insert into ratings (item_id, user_id, review, rating)
select
floor(random() * 20 + 1)::int as item_id,
floor(random() * 20 + 1)::int as user_id,
md5(random()::text) as review,
floor(random() * 10)::int as rating
from generate_series(1, 20);

select * from ratings;