# 🛒 Olist Customer Intelligence & Revenue Analytics Platform
## 🛠 Tech Stack

Database: PostgreSQL 18, pgAdmin 4

Programming: Python, SQL

Libraries: Pandas, NumPy, Matplotlib, Seaborn, Scikit-Learn, SQLAlchemy

Business Intelligence: Power BI

Tools: Git, GitHub, Jupyter Lab, Anaconda

End-to-end analytics pipeline — from raw e-commerce CSVs to predictive ML models and interactive Power BI dashboards — built to surface customer behaviour patterns, delivery performance issues, and revenue growth opportunities across 100K+ orders.

🔄 Project Architecture

Raw CSV Files (9 Datasets)

⬇

PostgreSQL Data Warehouse

⬇

SQL Analytics (Revenue, RFM, Cohort, CLV, Churn)

⬇

Python Data Processing & EDA

⬇

Machine Learning Models

⬇

Power BI Dashboards

⬇

Business Insights & Recommendations


📈 Business Metrics
Metric	Value
Total Orders	99,441
Unique Customers	96,096
Total Revenue	R$ 13.6M+
Average Order Value	R$ 137
Delivered Orders	~97%
Average Review Score	4.09 / 5
Repeat Customer Rate	2.97%
Total Sellers	3,095
Total Products	32,951

🗂️ Dataset

Source: Olist Brazilian E-Commerce — Kaggle

9 CSV files covering orders, customers, sellers, products, payments, reviews, and geolocation data from 2016 to 2018.


🏗️ Database Schema (ERD)

Designed and built a 9-table relational schema in PostgreSQL with proper primary keys, foreign key constraints, and composite keys where required.

<img width="2464" height="1309" alt="erd_diagram_of_olist pgerd" src="https://github.com/user-attachments/assets/9e1eb0d5-b9fc-405b-85ef-56e4d15c3b12" />



All 9 tables with primary keys (🔑), foreign key relationships, and column data types. geolocation stands alone — no FK by design since zip codes repeat with different lat/lng coordinates.

🔍 SQL Analytics 13 Business Areas

Performed advanced business analysis using PostgreSQL:

Area	            Analysis
Revenue Analytics	Monthly revenue, AOV, growth trends
Delivery Analytics	Delays, SLA performance, state-level analysis
Customer Analytics	Repeat customers, retention metrics
Seller Analytics	Seller tier classification
Product Analytics	Category performance
Payment Analytics	Payment method trends
Review Analytics	Satisfaction analysis
RFM Analysis	Customer segmentation
Cohort Analysis	Retention tracking
CLV Analysis	Customer lifetime value
Churn Analysis	Risk categorization
Techniques Used
Window Functions (LAG, RANK, DENSE_RANK)
Common Table Expressions (CTEs)
Subqueries & Joins
Conditional Aggregations
Composite Primary Keys
Foreign Key Constraints

🐍 Python Notebooks

Notebook 1 — Data Extraction & Validation
Connected to PostgreSQL via SQLAlchemy + psycopg2. Loaded all 9 tables, fixed timestamps, and engineered features: delivery_delay_days, actual_delivery_days, is_late, purchase_hour, purchase_dow.

Notebook 2 — EDA & Visualisations (10 Charts)
Order status distribution · monthly revenue trend · top 10 categories · payment breakdown · review scores · orders-by-hour heatmap · delay vs review boxplot · top states by revenue · repeat vs one-time customers · monthly order volume.

Notebook 3 — RFM Analysis
Recency, Frequency, Monetary scored 1–4 via quartile ranking per customer. Assigned 7 segments: Champions · Loyal Customers · Potential Loyalists · New Customers · At Risk · Need Attention · Lost Customers. Visualised segment counts, average revenue, R/F/M distributions, and recency vs monetary scatter.

Notebook 4 — Machine Learning
See ML Models section below.


🤖 Machine Learning Models

Model 1 — Random Forest Classifier · Late Delivery Prediction

TargetBinary — will this order arrive late?FeaturesItem count · total price · avg freight · customer state · actual delivery daysAccuracy96.44%Weighted F10.963Late recall67% · On-time precision 0.98 · Late precision 0.77OutputConfusion matrix · feature importance chart

Model 2 — K-Means Clustering · Customer Segmentation

InputRFM values scaled with StandardScalerK selectionElbow MethodVisualisationPCA (2 components)ResultClearly separated clusters — avg monetary R$141.62 in Mid Value segmentOutputPCA scatter plot · cluster revenue bar chart

Model 3 — Linear Regression · Review Score Prediction

TargetReview score (1–5 scale)FeaturesDelivery days · delay days · is_late · total price · item countMAE0.886R²0.193Key findingdelivery_delay_days is the strongest negative predictor — confirms the SQL C8 findingOutputActual vs predicted scatter · coefficient impact chart


📊 Power BI Dashboards

Three interactive dashboards built in Power BI Desktop, each targeting a distinct business area. Data is sourced directly from the PostgreSQL analytical layer and RFM outputs.

Dashboard 1 — Revenue Analysis
<img width="765" height="429" alt="image" src="https://github.com/user-attachments/assets/ee61ac6e-d6c2-4698-8d4b-af01130b6be3" />


Provides a comprehensive view of revenue performance, customer spending behavior, and category-level sales trends.

Key Features

Revenue, Orders, and Average Order Value (AOV) KPIs
Monthly Revenue Trend Analysis
Top Revenue-Generating Product Categories
Payment Method Distribution
Revenue Analysis by State and Time Period

Business Insight

Revenue peaks significantly during November (Black Friday season), highlighting the importance of inventory planning and marketing investments before peak demand periods. Health & Beauty emerged as the highest revenue-generating category.


Dashboard 2 — Customer Intelligence
<img width="759" height="425" alt="image" src="https://github.com/user-attachments/assets/304d098d-06ce-417e-bd06-53fbd5c41518" />


Combines RFM segmentation, Customer Lifetime Value (CLV), and K-Means clustering to provide a 360° customer view

Key Features

Customer Base & CLV KPIs
Recency, Frequency, and Monetary Performance Metrics
Customer Segment Distribution
Revenue Contribution by Customer Segment
Customer Cluster Analysis
Top Revenue-Contributing Customers

Business Insight

Champion and Loyal customers represent a relatively small percentage of the customer base but contribute a disproportionately large share of total revenue, making them the highest-priority segment for retention initiatives.

Dashboard 3 — Delivery & Operations Analytics
<img width="761" height="434" alt="image" src="https://github.com/user-attachments/assets/62839c29-4a04-41f9-926f-0b42f0bc09f1" />

Monitors operational efficiency, delivery performance, and their impact on customer satisfaction.

Key Features

Delivery Performance KPIs
Average Delay & Delivery Time Analysis
Order Status Distribution
Monthly Delivery Performance Trends
State-wise Delivery Time Analysis
Freight Cost Analysis by Region

Business Insight

Northern and Northeastern regions consistently experience longer delivery times and higher freight costs. These operational challenges directly correlate with lower customer review scores, indicating clear opportunities for logistics optimization.


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
