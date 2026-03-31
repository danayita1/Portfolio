SELECT * FROM ischool.people;



#2

USE ap;
SELECT vendor_name,
COUNT(invoice_total) AS invoice_total_count,
CONCAT("$ ", SUM(invoice_total)) AS invoice_total_sum,
CONCAT("$ ", format(AVG(invoice_total), 2)) AS invoice_total_avarage

FROM vendors JOIN invoices on vendors.vendor_id = invoices.vendor_id
GROUP BY vendors.vendor_id
ORDER BY invoice_total_count DESC; 

#3
USE ischool;
SELECT COUNT(*) AS total_number_of_people
FROM people; 

SELECT COUNT(title) as people_titled
FROM people;



#4
SELECT section_id, delivery_id
FROM course_sections
WHERE section_id > 120; 

SELECT count (section_id) as total_sections, delivery_id
FROM course_sections
GROUP BY delivery_id
HAVING COUNT(section_id) > 120;


## Lab 8

#Q2 

USE my_guitar_shop; 
SELECT DISTINCT CONCAT(last_name, ', ', first_name) AS customer_name
    FROM customers
        JOIN orders USING(customer_id)
    ORDER BY customer_name;

#updated using a subquery in the WHERE clause 
SELECT DISTINCT CONCAT(last_name, ', ', first_name) AS customer_name
    FROM customers
    WHERE customer_id IN (
    
							SELECT DISTINCT customer_id FROM orders
                            )
	ORDER BY customer_name;
    
    
    # Q3 
    
    
SELECT email_address, order_id, 
SUM (( item_price - discount_amount)*quantity) AS order_total
FROM customers JOIN orders USING(customer_id)
JOIN order_items USING (order_id) 
GROUP BY order_id );




SELECT email_address, max(order_id) max_order_total 
FROM (SELECT email_address, 
order_id, 
	SUM (( item_price - discount_amount)*quantity) AS order_total
    
   FROM customers JOIN orders USING(customer_id)
   JOIN order_items USING (order_id) 
   GROUP BY order_id )sum_orders
   GROUP BY email_address
   ORDER BY max_order_total DESC;
   
   
   #Q4
   
   SELECT avg(list_price) AS avg_guitar_price
   FROM products
   WHERE category_id = 1;
   
   SELECT DISTINCT customers.*
   FROM customers JOIN orders USING (customer_id)
   JOIN order_items USING (order_id)
   WHERE item_price > (SELECT AVG(list_price) AS avg_guitar_price
   FROM products
   WHERE category_id = 1);
   
   
   #Q5 CTE 
   
   #WITH name of cte AS (cte)#
				#SELECT#
                
                
   
   WITH sum_orders AS( SELECT email_address, 
					order_id, 
					SUM (( item_price - discount_amount)*quantity) AS order_total

					FROM customers JOIN orders USING(customer_id)
					JOIN order_items USING (order_id) 
					GROUP BY order_id 
					)
                    SELECT  email_address, MAX(order_total) AS max_order_total
                    FROM sum_orders
                    GROUP BY email_address
                    ORDER BY max_order_total;
   
   
   
   


