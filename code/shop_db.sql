# create database shopdb;
use shopdb;
select database(); 

# Мы хотим чтобы наш скрипт можно было бы запускать многократно.
drop table if exists purchase;
drop table if exists product;
drop table if exists producer;


create table producer (
	id int auto_increment primary key,
	name varchar(30)
);

create table product (
	id int auto_increment primary key,
	name varchar(30),
	producer_id int,
	price decimal(14,2) check (price > 0),
	amount int not null check (amount >= 0), 
	FOREIGN KEY (producer_id) REFERENCES producer (id)
);


create table purchase (
	product_id int,
	price decimal(14,2) check (price > 0),
	amount int not null check (amount > 0), 
	FOREIGN KEY (product_id) REFERENCES product (id)
);


insert producer (name) values ('Samsung'),
('Aplle'), ('Huawei'), ('HP'), ('Bosch');

select * from producer;
select * from purchase;

insert product (name, producer_id, price, amount) values 
('Кухонный комбайн', (select id from producer where name='Samsung' ), 5350, 6),
('Видеокарта', (select id from producer where name='HP' ), 480, 12), 
('Ноутбук', (select id from producer where name='Huawei' ), 15950, 3), 
('Фен',(select id from producer where name='Bosch' ), 1230, 9),
('Кофеварка', (select id from producer where name='Samsung' ), 999, 1),
('Пылесос', (select id from producer where name='Samsung' ), 89120, 7),
('Телефон сотовый', (select id from producer where name='Aplle' ), 53505, 4)
;


insert purchase (product_id, price, amount) values
((select id from product where name='Кофеварка' ), 999, 1),
((select id from product where name='Видеокарта' ), 480, 3),
((select id from product where name='Фен'), 1230, 2),
((select id from product where name='Кухонный комбайн' ), 5350, 4),
((select id from product where name='Пылесос'), 89120, 2)
;


# Проверяем ограничения
# insert product (name, producer_id, price, amount) values ('Кухонный комбайн', null, 0, 6);
# SQL Error [3819] [HY000]: Check constraint 'product_chk_1' is violated.
# insert product (name, producer_id, price, amount) values ('Кухонный комбайн', null, 1,-1);
# SQL Error [3819] [HY000]: Check constraint 'product_chk_2' is violated.

select * from  product;

select product.name as product_name
	  ,producer.name as producer_name
	  ,purchase.amount
      ,purchase.price
      ,purchase.amount * purchase.price as cost
from purchase 
inner join product on product.id = purchase.product_id
inner join producer on producer.id = product.producer_id
order by purchase.price desc 
;



