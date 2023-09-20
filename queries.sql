/* Write an SQL query to solve the given problem statement. */

# 1. List all regions along with the number of users assigned to each region.
select region_name,
    (select count(distinct(u.consumer_id)) from user_nodes u
    join world_regions w
    using(region_id)
    where w.region_id = w1.region_id) 
from world_regions w1
order by region_name;


# 2. Find the user who made the largest deposit amount and the transaction type for that deposit.
select consumer_id,transaction_type,max(transaction_amount) as largest_deposit from user_transaction;

# 3. Calculate the total amount deposited for each user in the "Europe" region.
select un.consumer_id,sum(ut.transaction_amount) as total_deposit_amount
from user_nodes un
left join user_transaction ut 
    on un.consumer_id = ut.consumer_id  
left join world_regions w 
    on un.region_id = w.region_id
where w.region_name = 'Europe' 
    and ut.transaction_type = 'deposit'
group by un.consumer_id;

# 4. Calculate the total number of transactions made by each user in the "United States" region.
select un.consumer_id,count(ut.transaction_amount) as total_deposit_amount
from user_nodes un
left join user_transaction ut 
    on un.consumer_id = ut.consumer_id  
left join world_regions w 
    on un.region_id = w.region_id
where w.region_name = 'United States' 
group by un.consumer_id;

# 5. Calculate the total number of users who made more than 5 transactions.
select consumer_id, count(consumer_id) as num_transactions
from user_transaction
group by consumer_id
having count(transaction_amount) > 5;

# 6. Find the regions with the highest number of nodes assigned to them.
select w.region_name,count(node_id) as num_nodes 
from user_nodes u
join world_regions w
	on u.region_id = w.region_id
group by u.region_id
order by num_nodes;

# 7. Find the user who made the largest deposit amount in the "Australia" region.
select u.consumer_id, max(transaction_amount) as largest_deposit
from user_nodes u
join user_transaction ut
on u.consumer_id = ut.consumer_id
where u.consumer_id in (select un.consumer_id from user_nodes un
						join world_regions w
						on un.region_id = w.region_id
						where w.region_name = 'Australia')
	and ut.transaction_type = 'deposit'
limit 1;

# 8. Calculate the total amount deposited by each user in each region.
select w.region_name,count(ut.transaction_amount) as total_transactions
from user_nodes un
join user_transaction ut 
    on un.consumer_id = ut.consumer_id  
join world_regions w 
    on un.region_id = w.region_id
group by w.region_name;

# 9. Retrieve the total number of transactions for each region
select w.region_name,count(ut.transaction_amount) as total_transactions
from user_nodes un
join user_transaction ut 
    on un.consumer_id = ut.consumer_id  
join world_regions w 
    on un.region_id = w.region_id
group by w.region_name;

# 10. Write a query to find the total deposit amount for each region (region_name) in the user_transaction table. Consider only those transactions where the consumer_id is associated with a valid region in the user_nodes table.
select w.region_name,sum(ut.transaction_amount) as total_deposit_amount
from user_nodes un
join user_transaction ut 
    on un.consumer_id = ut.consumer_id  
join world_regions w 
    on un.region_id = w.region_id
where ut.transaction_type = 'deposit'
	and un.region_id in (1,2,3,4,5,6,7)
group by w.region_name;

# 11. Write a query to find the top 5 consumers who have made the highest total transaction amount (sum of all their deposit transactions) in the user_transaction table.
select consumer_id, sum(transaction_amount) as total_transaction_amount
from user_transaction
where transaction_type = 'deposit'
group by consumer_id
order by total_transaction_amount desc
limit 5;

# 12. How many consumers are allocated to each region?
select w.region_id, w.region_name, count(distinct u.consumer_id) as num_of_customers
from user_nodes u
join world_regions w
	on u.region_id = w.region_id
group by w.region_id
order by w.region_id;

# 13. What is the unique count and total amount for each transaction type?
select transaction_type as txn_type,count(distinct(consumer_id)) as unique_count, sum(transaction_amount) as total_amount
from user_transaction
group by transaction_type;

# 14. What are the average deposit counts and amounts for each transaction type ('deposit') across all customers, grouped by transaction type?
select transaction_type as txn_type, round(avg(count)) as avg_deposit_count, round(avg(amount)) as avg_deposit_amount
from (select transaction_type, consumer_id, count(*) as count, sum(transaction_amount) as amount
    from user_transaction
    where transaction_type = 'deposit'
    group by transaction_type, consumer_id
	) as subquery
group by transaction_type;


# 15. How many transactions were made by consumers from each region?
select w.region_name, count(un.consumer_id)
from user_nodes un
left join user_transaction ut 
    on un.consumer_id = ut.consumer_id  
left join world_regions w 
    on un.region_id = w.region_id
group by w.region_name;