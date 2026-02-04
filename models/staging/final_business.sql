{{config(materialized='ephemeral')}}
with customers as(
    select
     id as customer_id,
     first_name,
     last_name
     from{{source('datafeed_shared_schema','raw_customers_data')}}
),
orders as(
    select 
     id as order_id,
     user_id as customer_id,
     order_date,
     status
     from{{ ref('emphral') }}
     ),
customer_order as(
    select
      customer_id,
      min(order_date)as first_orde_date,
      max(order_date)as most_recent_order_date,
      count(order_id)as number_of_orders
      from orders
      group by 1
),
final as(
    select 
      customers.customer_id,
      customers.first_name,
      customers.last_name,
      customers_orders.first_orde_date,
      customers_orders.most_recent_order_date,
      coalesec(customers_orders.number_of_orders,'0') as number_of_orders
      from
      left join customers_orders using(customer_id)
)
select * from final limit 10

 
