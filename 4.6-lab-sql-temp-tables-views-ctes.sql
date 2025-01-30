### 4.6-lab-sql-temp-tables-views-ctes ### 
# Content intro
# (cte extracts columns from the joining of view and table? cte is basically like a VERY temporary table) 
# Comaprison between the 3 types: view as permanent column, table lives only in sql file, cte only lives within the single query 

use sakila; 

##### Challenge: Creating a Customer Summary Report
### In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
# including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

    ### Step 1: Create a View
# First, create a view that summarizes rental information for each customer. 
# The view should include the customer's ID, name, email address, and total number of rentals (rental_count). Need: customer + rental tables 
create view rental_summary as  
select customer_id, concat(first_name," " ,last_name) as customer_name, email, count(rental_id) as rental_count # writing frist and last name in one column and renaming it
from customer
inner join rental
using (customer_id)
group by customer_id;

select * from rental_summary; # "calling" the table

    ### Step 2: Create a Temporary Table
# Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
# The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
DROP TABLE total_paid;

create temporary table total_paid
select customer_name, sum(amount) as total_amount
from rental_summary 
inner join payment
using (customer_id)
group by customer_id
order by total_amount desc;

select * from total_paid;

    ### Step 3: Create a CTE and the Customer Summary Report
# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
# The CTE should include the customer's name, email address, rental count, and total amount paid.
with cte_join as(
    select customer_name, email, rental_count, total_amount
    from rental_summary
    inner join total_paid
    using (customer_name)
)
select *, (total_amount/rental_count) as average_payment_per_rental 
from cte_join; # the call for the cte with additional column needs to be added within task 3, because the cte does not exist outside this query!!!

# Final Step: Next, using the CTE, create the query to generate the final customer summary report, which should include: 
# customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

