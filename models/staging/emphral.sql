{{config(materialized='ephemeral')}}
 with tb1 as(
       select id,
       order_date,
       user_id,
       status
       from {{source('datafeed_shared_schema','raw_orders')}}
       select * from tb1
 )