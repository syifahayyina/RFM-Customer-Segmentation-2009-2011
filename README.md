# RFM-Customer-Segmentation-2009-2011

## Project Overview
This project groups the customers of an online retailer using RFM analysis. It uses the Online Retail II dataset, with transactions from December 2009 to December 2011. The data is cleaned and analyzed in BigQuery with SQL, and the results are shown in a Looker Studio dashboard. The goal is to group customers by how recently they bought, how often they bought, and how much they spent, and to see which groups bring the most revenue.

## Dataset Description

This Online Retail II data set contains all the transactions occurring for a UK-based and registered, non-store online retail between 01/12/2009 and 09/12/2011.The company mainly sells unique all-occasion gift-ware. Many customers of the company are wholesalers. Each record represents one product in one invoice.

- Invoice : `Invoice`, `InvoiceDate`
- Product : `StockCode`, `Description`
- Sales : `Quantity`, `Price`
- Customer : `Customer ID`, `Country`

## Project Objectives
1. Track monthly revenue trends and identify seasonal peaks
2. Summarize overall metrics : total revenue, total transactions, and total customers
3. Identify segments
4. Analyze the number of customers and revenue contribution across each segment
5. Compare the buying behavior of each segment using average recency, frequency, and monetary metrics
6. Evaluate top geographic markets and high-value individual customers driving revenue

## RFM Segment
| Segment | Rule | Customers |
|---|---|---|
| Champion | R 4-5, F 4-5 | 1,228 |
| Loyal | R 3-5, F 3-5, not Champion | 1,350 |
| New | R 4-5, F 1-2 | 509 |
| At Risk | R 1-2, F 3-5 | 711 |
| Lost | R 1-2, F 1-2 | 1,631 |
| Needs Attention | R 3, F 1-2 | 423 |

## Visualizations Included
- KPI cards : Total Revenue, Total Customers, and Purchase Invoices
- Line chart : Monthly revenue trend
- Table : Segment profile (average recency, average frequency, and median monetary)
- Horizontal bar chart : Number of customers by segment
- Pie chart : Revenue contribution by segment
- Bar chart : Top 5 customers by revenue
- Bar chart : Top 5 countries by revenue
- Text box : Key insights

## Tools Used
- BigQuery (SQL) : Storing the raw data, Data Cleaning, and Calculating RFM
- Looker Studio : Visualization
- GitHub : Documentation

## Key Insight
- Champion customers are 21.0% of customers and 67.9% of revenue
- At Risk and Loyal customers both have 5.5 invoices on average. At Risk last bought 360 days ago, Loyal 70 days ago.
- November has the highest revenue in both 2010 and 2011
- The United Kingdom accounts for 83.5% of revenue
