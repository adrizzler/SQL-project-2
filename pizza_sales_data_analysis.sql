-- create database pizzaria;
/*create TABLE orders (
order_id INT not NULL,
order_date date not null,
order_time time not null,
primary key(order_id) )*/
/*select 
round(sum(pizzas.price * order_details.quantity),2) as Total_Revenue
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;*/
-- most expensive piza
/*select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc ;*/
-- Most common quanity ordered
/*select quantity, count(order_details_id)
from order_details group by quantity;*/

-- most common ordered pizza size
/*SELECT 
    pizzas.size, COUNT(order_details.order_details_id)
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size;*/

-- list the top 5 pizza types along with their quantity 
/*select pizza_types.name,
sum(order_details.quantity) as quantity 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5; */

-- Join the necessary tables to find the total quantity of each pizza category ordered.
/* select pizza_types.category,
sum(order_details.quantity) as quantity 
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc; */

-- Determine the distribution of orders by hour of the day.

/* select hour(time) as hour , count(order_id) as order_count from orders
group by hour(time) ; */ 

-- Join relevant tables to find the category-wise distribution of pizzas.

/* select category, count(name) from pizza_types
group by category; */

-- Group the orders by date and calculate the average number of pizzas ordered per day.
/* Select round( avg (quantity), 2) from
(select orders.date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by  orders.date) as order_quantity; */

-- Determine the top 3 most ordered pizza types based on revenue.

/* select pizza_types.name, 
sum(order_details.quantity * pizzas.price) as Revenue 
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by Revenue desc limit 3; */

-- Calculate the percentage contribution of each pizza type to total revenue.

/* select pizza_types.category,
round(sum(order_details.quantity * pizzas.price) / (select round(sum(order_details.quantity * pizzas.price), 2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id) * 100, 2) as revenue
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc; */

-- Analyze the cumulative revenue generated over time.

/* select date,
sum(Revenue) over(order by date) as cummulative_revenue
from (select orders.date,
sum(order_details.quantity * pizzas.price) as Revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.date) as sales; */

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue 
 from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn<=3;
