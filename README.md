# 🛒 Olist Customer Intelligence & Revenue Analytics Platform
## 🛠 Tech Stack

PostgreSQL • SQL • Python • Pandas • NumPy • Matplotlib • Seaborn • Scikit-Learn • Power BI • Git • GitHub

Engineered a production-style Customer Intelligence & Revenue Analytics Platform using PostgreSQL, Python, Machine Learning, and Power BI to analyze 100K+ e-commerce orders, perform customer segmentation, predict business outcomes, and create interactive dashboards for strategic decision-making.

🔄 Project Architecture

Raw CSV Files (9 datasets, 500K+ rows)
            ↓
PostgreSQL Database (9-table relational schema with PKs, FKs, composite keys)
            ↓
SQL Analysis (C1–C13: Revenue, Delivery, RFM, CLV, Churn, Cohort...)
            ↓
Python — pandas + NumPy (data extraction, cleaning, feature engineering)
            ↓
EDA & Visualisations (10 charts — matplotlib + seaborn)
            ↓
RFM Analysis (7 customer segments)
            ↓
Machine Learning Models (Classification · Clustering · Regression)
            ↓
Power BI Dashboards (3 interactive dashboards — Revenue · Customer · Delivery)
            ↓
Business Insights & Recommendations


📊 Business Headline Numbers

MetricValueTotal Orders99,441Total Unique Customers96,096Total RevenueR$ 13.6M+Average Order Value (AOV)R$ 137Delivered Successfully~97%Average Review Score4.09 / 5Repeat Customer Rate2.97%Total Sellers3,095Total Products32,951


🗂️ Dataset

Source: Olist Brazilian E-Commerce — Kaggle

9 CSV files covering orders, customers, sellers, products, payments, reviews, and geolocation data from 2016 to 2018.


🏗️ Database Schema (ERD)

Designed and built a 9-table relational schema in PostgreSQL with proper primary keys, foreign key constraints, and composite keys where required.

<img width="2464" height="1309" alt="erd_diagram_of_olist pgerd" src="https://github.com/user-attachments/assets/9e1eb0d5-b9fc-405b-85ef-56e4d15c3b12" />



All 9 tables with primary keys (🔑), foreign key relationships, and column data types. geolocation stands alone — no FK by design since zip codes repeat with different lat/lng coordinates.



Table Creation Order (parent before child):

#TableDepends On1customers—2sellers—3product_category_name_translation—4productscategory_translation5geolocation—6orderscustomers7order_paymentsorders8order_reviewsorders9order_itemsorders + products + sellers


🔍 SQL Analysis — 13 Business Areas

All analysis performed in PostgreSQL. Key techniques used:


Window functions — LAG(), RANK(), DENSE_RANK(), SUM() OVER()
CTEs (Common Table Expressions) for multi-step logic
Composite primary keys and FK constraint management
CASE WHEN pattern for conditional aggregations
Subqueries and anti-joins for data quality checks


SectionAnalysisC1Revenue Analysis — monthly trends, AOV, peak hours, quarterly breakdownC2Delivery Analysis — on-time %, delay days, performance by stateC3Customer Analysis — repeat rate, unique vs total customersC4Seller Analysis — Bronze / Silver / Gold / Platinum tiersC5Product & Category Analysis — top categories, null handlingC6Payment Analysis — method breakdown, installment distributionC7Review & Satisfaction Analysis — score distribution, comment rateC8Delay vs Review Score — correlation between lateness and satisfactionC9RFM Analysis — Recency, Frequency, Monetary segmentationC10Cohort Analysis — monthly retention snapshotC11Month-over-Month Revenue Growth using LAG()C12Customer Lifetime Value (CLV) — tiers and averagesC13Churn Risk Analysis — Lost / High Risk / Medium Risk / Active


🐍 Python Notebooks

Notebook 1 — Data Extraction & Validation


Connected Python to PostgreSQL using SQLAlchemy + psycopg2
Loaded all 9 tables into pandas DataFrames
Fixed timestamp columns and performed feature engineering
Created: delivery_delay_days, actual_delivery_days, is_late, purchase_hour, purchase_dow


Notebook 2 — EDA & Visualisations (10 Charts)


Order status distribution
Monthly revenue trend (line chart with fill)
Top 10 categories by revenue
Payment type breakdown (pie + bar)
Review score distribution
Orders by hour heatmap (day of week × hour)
Delivery delay vs review score (boxplot)
Top 10 states by revenue
Repeat vs one-time customers
Monthly order volume + month-over-month category trend


Notebook 3 — RFM Analysis


Calculated Recency, Frequency, Monetary per unique customer
Scored each dimension 1–4 using quartile ranking
Assigned 7 customer segments: Champions, Loyal Customers, Potential Loyalists, New Customers, At Risk, Lost Customers, Need Attention
Visualised: segment count, average revenue per segment, R/F/M distributions, recency vs monetary scatter


Notebook 4 — Machine Learning (3 Models)

Model 1 — Random Forest Classifier (Late Delivery Prediction)


Target: predict whether an order will arrive late (binary classification)
Features: item count, total price, avg freight, customer state, actual delivery days
Result: 96.44% accuracy · Weighted F1-score 0.963 · Late delivery recall 67%
On-time precision 0.98, Late delivery precision 0.77
Output: confusion matrix, feature importance chart


Model 2 — K-Means Clustering (Customer Segmentation)


Input: RFM values (recency, frequency, monetary) scaled with StandardScaler
Used Elbow Method to determine optimal K
Visualised clusters using PCA (2 components)
Result: Clusters clearly separated by spending behaviour — avg monetary R$141.62 in Mid Value segment
Output: PCA scatter plot, cluster revenue bar chart


Model 3 — Linear Regression (Review Score Prediction)


Target: predict customer review score (1–5 scale)
Features: actual delivery days, delivery delay, is_late flag, total price, item count
Result: MAE 0.886 · R² 0.193
Delivery delay has the strongest negative coefficient — confirming SQL finding that late orders tank scores
Output: actual vs predicted scatter, coefficient impact chart



📊 Power BI Dashboards

Three interactive dashboards built in Power BI Desktop, each targeting a distinct business area. Data is sourced directly from the PostgreSQL analytical layer and RFM outputs.

Dashboard 1 — Revenue Analysis
<img width="765" height="429" alt="image" src="https://github.com/user-attachments/assets/ee61ac6e-d6c2-4698-8d4b-af01130b6be3" />


Tracks overall business performance and revenue drivers.

VisualTypePurposeTotal RevenueKPI CardHeadline revenue figureTotal OrdersKPI CardOrder volume at a glanceAOV (Avg Order Value)KPI CardSpend efficiency metricMonthly Revenue TrendLine ChartSeasonality & growth over timeTop 10 Categories by RevenueBar ChartCategory performance rankingPayment Method DistributionDonut ChartCredit card vs Boleto vs othersRevenue by State / TimeColumn ChartGeographic & temporal breakdown

Key finding surfaced: November revenue spike (Black Friday) is clearly visible; Health & Beauty leads all categories.


Dashboard 2 — Customer Intelligence
<img width="759" height="425" alt="image" src="https://github.com/user-attachments/assets/304d098d-06ce-417e-bd06-53fbd5c41518" />


Combines RFM segmentation, CLV, and K-Means cluster outputs into a single customer view.

VisualTypePurposeTotal CustomersKPI CardPlatform customer base sizeAverage CLVKPI CardLifetime value per customerAvg RecencyKPI CardHow recently customers orderedAvg FrequencyKPI CardPurchase frequency metricAvg MonetaryKPI CardAverage spend per customerCustomer Segment DistributionBar ChartChampions vs At Risk vs Lost breakdownRevenue by Customer SegmentColumn ChartWhich segments drive the most revenueCustomer Cluster DistributionDonut ChartK-Means cluster proportionsTop 10 Customers by RevenueBar ChartHighest-value individual customers

Key finding surfaced: Champions and Loyal Customers are a small group but drive disproportionate revenue — direct input for retention strategy.


Dashboard 3 — Delivery & Operations Analytics
<img width="761" height="434" alt="image" src="https://github.com/user-attachments/assets/62839c29-4a04-41f9-926f-0b42f0bc09f1" />


Monitors logistics performance and its relationship with customer satisfaction.

VisualTypePurposeAvg Delay DaysKPI CardMean delay across all ordersAvg Delivery DaysKPI CardEnd-to-end fulfilment timeDelivered OrdersKPI CardTotal successfully deliveredAvg Review ScoreKPI CardPlatform-wide satisfactionOrder Status DistributionDonut ChartDelivered vs cancelled vs othersMonthly Delivery PerformanceLine ChartDelay trends over timeTop 5 States by Delivery TimeBar ChartSlowest-delivery geographiesTop 10 States by Freight CostBar ChartHighest freight cost regions

Key finding surfaced: Northern and northeastern states consistently show higher delay days and freight costs — directly correlating with the lower review scores seen in those regions.


⚠️ Challenges & Solutions

These are real problems encountered and solved during the project — not textbook scenarios.

1. Foreign Key Violation on Import
The products CSV contained categories pc_gamer and portateis_cozinha_e_preparadores_de_alimentos which were missing from the product_category_name_translation table. PostgreSQL blocked the import with an FK constraint error.


Temporarily dropped the FK constraint to allow import
Used a LEFT JOIN anti-pattern to identify all missing categories
Inserted the missing rows manually with correct English translations
Restored the FK constraint — referential integrity confirmed


2. Composite Key Design
Three tables required composite primary keys rather than single-column PKs:


order_items → (order_id, order_item_id) — one order can have multiple products
order_payments → (order_id, payment_sequential) — one order can use multiple payment methods
order_reviews → (review_id, order_id) — same review_id appears across multiple orders in the raw data (dataset quality issue)


Each case was verified by running a duplicate check query before deciding on the key strategy.

3. Password Special Character in Connection String
PostgreSQL password containing @ broke the standard SQLAlchemy connection string since @ is used to separate credentials from the host. Solved by using URL.create() with separate named parameters instead of an inline connection string.

4. bar_label Not Available
matplotlib 3.3.4 (Anaconda environment) does not support ax.bar_label() which was added in 3.4. Replaced with a manual ax.text() loop for all chart labels, adjusting position logic separately for vertical and horizontal bar charts.


💡 Key Business Insights

1. Late deliveries destroy satisfaction
Orders arriving 15+ days late receive an average review score below 2.0 out of 5, compared to 4.2+ for on-time deliveries. The Linear Regression model confirmed delivery_delay_days as the strongest negative predictor of review score (R² 0.193). The Delivery dashboard makes this pattern immediately visible to non-technical stakeholders.

2. Repeat customers are extremely rare
Only 2.97% of customers placed more than one order, indicating the platform is heavily dependent on customer acquisition rather than retention. This is a structural risk — retaining even 5% more customers could significantly improve LTV.

3. Credit card dominates payments
Credit card accounts for ~74% of all transactions. Boleto (Brazilian bank slip) is second at ~19%. Most customers choose 3–4 installments, suggesting price sensitivity in the market.

4. São Paulo drives disproportionate revenue
SP state contributes the largest share of revenue and has the fastest average delivery times. Northern and northeastern states face significantly longer delivery windows — directly correlating with lower review scores in those regions.

5. November–December is peak season
Monthly revenue spikes sharply in November (Black Friday effect). The trend is clearly visible in both the Python charts and the Revenue Analysis Power BI dashboard — marketing and logistics should be scaled up ahead of this period every year.

6. Top category: Health & Beauty
Health & Beauty leads by total revenue, followed by Watches & Gifts and Bed Bath Table. These three categories account for a disproportionate share of platform revenue and deserve priority in seller acquisition and advertising.


📋 Business Recommendations

Customer Retention


Introduce a loyalty rewards program targeting the "Potential Loyalists" RFM segment — customers who are recent and have moderate spend but have not returned
Send personalised re-engagement campaigns to the "At Risk" segment before they become "Lost"


Logistics & Delivery


Prioritise fulfilment improvements in states with the highest average delivery delays — the data shows a direct link between delay and negative reviews
Set internal delivery SLAs to keep delays under 3 days — orders in the 1–3 day delay bucket still score 3.8+ on average


Revenue Growth


Increase marketing and inventory spend in September–October ahead of the November Black Friday peak
Upsell within the Health & Beauty and Watches & Gifts categories — they have the highest revenue density


Seller Management


Create incentive programs for Platinum-tier sellers (top revenue contributors) to reduce churn
Identify Bronze-tier sellers with high review scores and fast delivery — they are growth candidates worth promoting



🛠️ Tools & Technologies

LayerToolsDatabasePostgreSQL 18SQL ClientpgAdmin 4LanguagePython 3.6Data Processingpandas, numpyVisualisationmatplotlib, seabornMachine Learningscikit-learnBI DashboardsPower BI DesktopEnvironmentAnaconda, Jupyter LabVersion ControlGit + GitHub


📁 Project Structure

Ecommerce-Analytics-Olist/
├── sql/
│    └── olist_data_modeling.sql     ← schema creation + complete SQL analysis (C1–C13)
├── notebooks/
│    ├── 01_data_extraction.ipynb
│    ├── 02_eda_visualisations.ipynb
│    ├── 03_rfm_analysis.ipynb
│    └── 04_machine_learning.ipynb
├── powerbi/
│    └── Revenue_Analysis_olist.pbix ← 3 dashboards: Revenue · Customer · Delivery
├── charts/                          ← all PNG charts (Python-generated)
│    ├── chart1_order_status.png
│    ├── chart2_monthly_revenue.png
│    ├── chart3_top_categories.png
│    ├── chart4_payment_types.png
│    ├── chart5_review_scores.png
│    ├── chart6_heatmap_orders.png
│    ├── chart7_delay_vs_review.png
│    ├── chart8_top_states.png
│    ├── chart9_repeat_customers.png
│    ├── chart10_monthly_orders.png
│    ├── rfm_chart1_segment_count.png
│    ├── rfm_chart2_avg_revenue.png
│    ├── ml_chart1_confusion_matrix.png
│    ├── ml_chart2_feature_importance.png
│    ├── ml_chart3_elbow.png
│    ├── ml_chart4_clusters_pca.png
│    └── ml_chart7_coefficients.png
├── archive/                         ← raw CSV files (not tracked in git)
└── README.md

👤 Author

Anuj Tripathi
Data Analyst | SQL · Python · Power BI · Machine Learning
📧 anujtripathi174@gmail.com
🔗 LinkedIn: https://www.linkedin.com/in/anuj-tripathi-a53a05198/ | 🔗 GitHub: https://github.com/ANUJTRIPATHI108


Dataset source: Olist Store — publicly available on Kaggle under CC BY-NC-SA 4.0 license
