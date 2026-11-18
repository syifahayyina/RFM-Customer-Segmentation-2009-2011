# Jumlah cust masing2 score
select
  r_score,
  min(recency) as min_recency,
  max(recency) as max_recency,
  count(*) as jumlah
from `rfm_segmentation.rfm_score`
group by r_score
order by r_score;

select
  f_score,
  min(frequency) as min_frequency,
  max(frequency) as max_frequency,
  count(*) as jumlah
from `rfm_segmentation.rfm_score`
group by f_score
order by f_score;

select
  m_score,
  min(monetary) as min_monetary,
  max(monetary) as max_monetary,
  count(*) as jumlah
from `rfm_segmentation.rfm_score`
group by m_score
order by m_score;

# RFM segment
create or replace table `rfm_segmentation.rfm_segment` as
select *,
    case
        when r_score >= 4 and f_score >= 4 then 'Champion'
        when r_score >= 3 and f_score >= 3 then 'Loyal'
        when r_score >= 4 and f_score <= 2 then 'New'
        when r_score <= 2 and f_score >= 3 then 'At Risk'
        when r_score <= 2 and f_score <= 2 then 'Lost'
        else 'Needs Attention'
    end as segment
from `rfm_segmentation.rfm_score`;


# Cek lagi
select
    segment,
    count (*) as jumlah_cust,
    min (r_score) as min_rscore,
    max (r_score) as max_rscore,
    min (f_score) as min_fscore,
    max (f_score) as max_fscore,
from `rfm_segmentation.rfm_segment`
group by segment;

# Kontribusi revenue per segment
select
    segment,
    count (*) as jumlah_cust,
    round (100 * count (*) / sum(count(*)) over(), 1) as persen_cust,
    round (sum (monetary), 0) as total_monetary,
    round (100 * sum (monetary) / sum(sum(monetary)) over(), 1) as persen_monetary
from `rfm_segmentation.rfm_segment`
group by segment;

# Profil perilaku masing2 segment
select
    segment,
    count (*) as jumlah_cust,
    round (avg(recency), 0) as avg_recency,
    round (avg(frequency), 1) as avg_frequency,
    round (approx_quantiles(monetary, 2)[offset(1)], 0) as median_monetary,
    round (sum(monetary) / sum(frequency), 0) as avg_per_invoice
from `rfm_segmentation.rfm_segment`
group by segment;

# Tabel Transaksi
create or replace table  rfm_segmentation.rfm_transaction as
select
    c.*,
    s.segment
from `rfm_segmentation.clean_data` C
inner join `rfm_segmentation.rfm_segment` S
      on c.customer_id = s.customer_id;

# Cek tabel transaksi
select
count (distinct customer_id) as cust,
sum (quantity * price) as monetary
from `rfm_segmentation.rfm_transaction`