select
  approx_quantiles(recency, 5) as batas_recency,
  approx_quantiles(frequency, 5) as batas_frequency,
  approx_quantiles(monetary, 5) as batas_monetary,
from `rfm_segmentation.rfm_base`;

# RFM Score
create or replace table `rfm_segmentation.rfm_score` as
select
    customer_id,
    recency,
    frequency,
    monetary,
    ntile(5) over (order by recency desc, customer_id) as r_score,
    case
        when frequency = 1 then 1
        when frequency = 2 then 2
        when frequency between 3 and 5 then 3
        when frequency between 6 and 10 then 4
        else 5
    end as f_score,
    ntile(5) over (order by monetary asc, customer_id) as m_score
from `rfm_segmentation.rfm_base`;