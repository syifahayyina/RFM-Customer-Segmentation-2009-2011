create or replace table `rfm_segmentation.clean_data` as
select
    distinct * except (`Customer ID`, Description),
    cast(`Customer ID` as INT64) as customer_id,
    trim(Description) as Description
from `rfm_segmentation.raw_data`
where not (
    starts_with(Invoice, 'A')
    or (starts_with(Invoice, 'C') and Quantity > 0)
    or Price <= 0
    or StockCode in (
    'POST', 'DOT', 'C2', 'M', 'm', 'D', 'S',
    'BANK CHARGES', 'ADJUST', 'ADJUST2',
    'AMAZONFEE', 'CRUK', 'TEST001', 'TEST002',
    'gift_0001_10', 'gift_0001_20', 'gift_0001_30', 'gift_0001_40',
    'gift_0001_50', 'gift_0001_70', 'gift_0001_80'
    )
)