select column_name, data_type
from rfm_segmentation.INFORMATION_SCHEMA.COLUMNS;

# Setiap baris  data mewakili apa
select 
    count (*) as jumlah_baris,
    count (distinct Invoice) as jumlah_invoice,
    count (distinct `Customer ID`) as jumlah_customer,
    min (InvoiceDate) as awal_periode,
    max (InvoiceDate) as akhir_periode
from `rfm_segmentation.raw_data`;

# Cek duplicate
select count (*)
from (
  select distinct *
  from `rfm_segmentation.raw_data`
);

select 
    *,
    count (*) as jumlah_dup
from `rfm_segmentation.raw_data`
group by all
having count (*) > 1;

# Cek null
select 
    countif (Invoice is null) as null_Invoice,
    countif (StockCode is null) as null_StockCode,
    countif (Description is null) as null_Description,
    countif (Quantity is null) as null_Quantity,
    countif (InvoiceDate is null) as null_InvoiceDate,
    countif (Price is null) as null_Price,
    countif (`Customer ID` is null) as null_CustomerID,
    countif (Country is null) as null_Country
from `rfm_segmentation.raw_data`;

# Identifikasi null customer id
select
    countif (baris_null = 0) as semua_punyaID,
    countif (baris_null = jumlah_baris) as semua_tidakpunyaID,
    countif (baris_null > 0 and baris_null < jumlah_baris)
from (
    select Invoice,
          count(*) as jumlah_baris,
          countif (`Customer ID` is null) as baris_null
    from `rfm_segmentation.raw_data`
    group by Invoice
);

# Cek format Customer ID
select
    countif (`Customer ID` - floor(`Customer ID`) != 0),
    min (`Customer ID`) as min_data,
    max (`Customer ID`) as max_data
from `rfm_segmentation.raw_data`;

# Cek format invoice
select
    left (Invoice, 1) as awalan,
    length (Invoice) as panjang,
    count (*) as jumlah_baris
from `rfm_segmentation.raw_data`
where not regexp_contains (Invoice, r'^[0-9]{6}$')
group by awalan, panjang
order by jumlah_baris desc;

select
    count (*) as jumlah_baris,
from `rfm_segmentation.raw_data`
where not regexp_contains (Invoice, r'^[0-9]{6}')
      and not regexp_contains (Invoice, r'^[CA][0-9]{6}');

# cek format invoice 'A%'
select *
from `rfm_segmentation.raw_data`
where starts_with (Invoice, 'A');

select countif (StockCode = 'B'),
countif (Description = 'Adjust bad debt')
from `rfm_segmentation.raw_data`;

# cek format invoice 'C%'
select *
from `rfm_segmentation.raw_data`
where starts_with (Invoice, 'C')
limit 20;

# Cek quantity dan price
select 
    countif (Quantity < 0) as quantity_negatif,
    countif (Quantity = 0) as quantity_nol,
    min (Quantity) as min_quantity,
    max (Quantity) as max_quantity,
    countif (Price < 0) as Price_negatif,
    countif (Price = 0) as Price_nol,
    min (Price) as min_Price,
    max (Price) as max_Price
from `rfm_segmentation.raw_data`;

# Hubungan invoice, quantity, dan price
select
    starts_with (Invoice, 'C') as invoice_batal,
    starts_with (Invoice, 'A') as invoice_debt,
    Quantity < 0 as qty_negatif,
    Price = 0 as price_nol,
    Price < 0 as price_negatif,
    count (*) as jumlah_baris
from `rfm_segmentation.raw_data`
group by invoice_batal, qty_negatif, price_nol,invoice_debt, price_negatif
order by invoice_batal;

# Cek baris anomali
select
    Description,
    count (*) as jumlah_baris,
    countif (`Customer ID` is null) as tanpa_id
from `rfm_segmentation.raw_data`
where
    regexp_contains (Invoice, r'^[0-9]{6}$')
    and Quantity < 0
    and Price = 0
group by Description;

select
    Quantity > 0 as qty_positif,
    `Customer ID` is null as tanpa_id,
    count (*) as jumlah_baris
from `rfm_segmentation.raw_data`
where regexp_contains (Invoice, r'^[0-9]{6}$')
      and Price = 0
group by qty_positif, tanpa_id;

select
    Description,
    count (*) as jumlah_baris,
    count (distinct `Customer ID`) as jumlah_customer,
    min (Quantity) as min_qty,
    max (Quantity) as max_qty,
from `rfm_segmentation.raw_data`
where regexp_contains (Invoice, r'^[0-9]{6}$')
      and Quantity > 0
      and Price = 0
      and `Customer ID` is not null
group by Description;

select 
    starts_with(Invoice, 'C') as invoice_batal,
    count (*) as jumlah_baris,
    count (distinct Invoice) as jumlah_invoice,
    count (distinct `Customer ID`) as jumlah_customer,
    round (sum (Quantity * Price), 2) as total
from `rfm_segmentation.raw_data`
where `Customer ID` is not null
group by invoice_batal;

select
    count (*) AS jumlah_invoice,
    countif (jumlah_baris = jumlah_price0) AS solo,
    countif (jumlah_baris > jumlah_price0) AS mix,
    sum (jumlah_price0) AS total_baris_nol
from (
    select
        Invoice,
        count (*) as jumlah_baris,
        countif (Price = 0) as jumlah_price0
    from `rfm_segmentation.raw_data`
    where `Customer ID` is not null
    group by Invoice
)
where jumlah_price0 > 0;