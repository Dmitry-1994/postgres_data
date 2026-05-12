-- Какова общая сумма всех завершённых заказов?
select sum(order_items.quantity * order_items.unit_price)	-- вычисление суммы всех заказов, где каждый из которых = количество товаров * на стоимость товара)
from orders													-- из таблицы orders													
join order_items on orders.order_id = order_items.order_id	-- объединение таблицы orders c таблицей order_items по полю order_id
where orders.status = 'completed';							-- отфильтровывание заказов, только со статусом completed

-- Какие клиенты сделали более одного заказа? Выведите их имя и количество заказов.
select first_name, count(orders.order_id)					-- получение имени клиента и количества его заказов
from customers												-- из таблицы customers
join orders on customers.customer_id = orders.customer_id	-- объединение таблицы customers c таблицей orders по полю customer_id
group by customers.customer_id								-- группировака по id клиента
having count(orders.order_id) > 1;							-- отфильтровывание клиентов, только с количеством заказов > 1

-- Какие товары имеют остаток на складе меньше 5 единиц?
select product_name, stock_quantity							-- получение названий товаров и их доступное количество на складе
from products												-- из таблицы products
where stock_quantity < 5;									-- отфильтровываем по количеству остатка на скалде (меньше 5 штук)

-- Найдите самый популярный товар по количеству проданных единиц.
select products.product_id, products.product_name, sum(order_items.quantity)					-- вывод id товара, наименования товара и суммарного количества
from order_items																				-- начинаем выборку опираясь на таблицу order_item
join orders on order_items.order_id = orders.order_id											-- объединение таблиц order_items и orders по полю order_id
join products on order_items.product_id = products.product_id									-- объединение таблиц order_items и products по полю product_id
where orders.status = 'completed'																-- отфильтровывание строк со статусом заказа completed
group by products.product_id, products.product_name												-- группировка по id и имени товара
order by sum(order_items.quantity) desc															-- сортировка строк таблицы order_items по убываю по полю quantity
limit 1;																						-- ограничиваем выборку одной записью

-- Выведите список клиентов, зарегистрировавшихся в последний месяц.
select *																	-- вывод всех строк
from customers																-- из таблицы customers
where registration_date >= current_date - interval '1 month'; 					-- в которой дата регистрации была не раньше чем месяц назад 

-- Напишите запрос, который выводит все заказы с общей стоимостью свыше 10 000 рублей.
select order_id, sum(quantity * unit_price)									-- получение общей суммы по каждому из id заказа
from order_items															-- из таблицы order_items
group by order_id															-- группируем строки по order_id, при повторах складывается сумма заказа каждого из них
having sum(quantity * unit_price) > 10000;									-- отфильтровываем по общей сумме заказов (больше 10000), уже по группированным уникальным order_id

-- Какие категории товаров приносят наибольшую выручку?
select products.category, sum(quantity * unit_price)						-- вывод категории товаров с полученной суммой от продаж каждой из них
from order_items															-- начинаем выборку опираясь на таблицу order_item
join orders on order_items.order_id = orders.order_id						-- объединение таблиц order_items и orders по полю order_id
join products on order_items.product_id = products.product_id				-- объединение таблиц order_items и products по полю product_id
where orders.status = 'completed'											-- отфильтровывание строк со статусом заказа completed
group by products.category													-- группируем строки по категории товаров, при повторах складывается сумма заказа каждого из них													
order by sum(quantity * unit_price) desc;									-- сортировка строк таблицы по убыванию по суммарной сумме каждой из категорий товаров