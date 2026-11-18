# Menentukan tanggal acuan : 10 Desember 2011
select
min (InvoiceDate) as awal,
max (InvoiceDate) as akhir
from `rfm_segmentation.clean_data`
where customer_id is not null and not starts_with(Invoice, 'C');

# Tabel RFM
with rfm as (
select
    customer_id,
    date_diff(
          date '2011-12-10',
          date (max(if(not starts_with(Invoice, 'C'), InvoiceDate, null))),
          day
    ) as recency,
    count(distinct if(not starts_with(Invoice, 'C'), Invoice, null)) as frequency,
    round(sum(Quantity * Price), 1) as monetary
from `rfm_segmentation.clean_data`
where customer_id is not null
group by customer_id
)

select
    count (*) as jumlah_customer,
    countif (frequency = 0) as cust_tanpa_beli,
    min (recency) as min_recency,
    max (recency) as max_recency,
    min (frequency) as min_frequency,
    max (frequency) as max_frequency,
    countif (monetary < 0) as monetary_negatif,
    countif (monetary = 0) as monetary_nol
from rfm;

# Cek cust_id dengan monetary < 0
select
    customer_id,
    count(distinct if(not starts_with(Invoice, 'C'), Invoice, null)) as invoice_beli,
    count(distinct if(starts_with(Invoice, 'C'), Invoice, null)) as invoice_batal,
    min(date(InvoiceDate)) as tanggal_pertama,
    round(sum(Quantity * Price), 1) as monetary
from `rfm_segmentation.clean_data`
where customer_id is not null
group by customer_id
having sum (Quantity * Price) < 0;

# RFM Base
create or replace table `rfm_segmentation.rfm_base` as 
select
    customer_id,
    date_diff(
          date '2011-12-10',
          date (max(if(not starts_with(Invoice, 'C'), InvoiceDate, null))),
          day
    ) as recency,
    count(distinct if(not starts_with(Invoice, 'C'), Invoice, null)) as frequency,
    round(sum(Quantity * Price), 1) as monetary
from `rfm_segmentation.clean_data`
where customer_id is not null
group by customer_id
having frequency > 0;