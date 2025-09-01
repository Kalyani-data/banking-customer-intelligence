# END-TO-END BANKING CUSTOMER INTELLIGENCE & RISK ANALYSIS USING SQL & POWER BI

This repository contains a complete workflow for analyzing banking customer data using SQL and Power BI, focusing on customer insights, transaction behaviors, loan performance, and CRM feedback.

## 📌 Business Problem
The bank aims to improve customer understanding, monitor product performance, and detect potential risks across personal loans, CRM, and customer satisfaction.  
Currently, customer, account, loan, and complaint data is siloed. The goal is to build a 360° view of customers and operations.

## 📂 Repository Structure
- **data/** – Raw CSV files (core banking and CRM data)  
- **python/** – Python scripts for loading large datasets into MySQL  
- **sql/** – SQL scripts for table creation, data cleaning, queries, and SQL views for Power BI  
- **power_BI/** – Power BI dashboard files  
- **images/** – Screenshots of dashboards  
- **document/** – Detailed project report in PDF  

## 🛠 Project Workflow
1. **Data Preparation** – Study datasets, identify key entities (clients, accounts, loans, transactions, CRM interactions).  
2. **SQL Query Development** – Clean and transform data; extract features like balances, loan payments, and customer demographics.  
3. **SQL Views** – Combine queries into reusable views for each business area to simplify Power BI integration.  
4. **Power BI Dashboards** – Build 4 dashboards:

### Dashboard 1: Customer Demographics & Segmentation  
![Dashboard 1](images/dashboard1.png)  
*Visualizes customer distribution by age, gender, region, and product adoption to identify growth opportunities and high-value segments.*

### Dashboard 2: Account & Transaction Behaviors  
![Dashboard 2](images/dashboard2.png)  
*Shows account activity, dormancy patterns, transaction volumes, and regional financial trends for operational insights.*

### Dashboard 3: Loan Performance & Financial Risk  
![Dashboard 3](images/dashboard3.png)  
*Highlights loan portfolio performance, default rates, high-risk loans, and repayment behaviors for risk assessment.*

### Dashboard 4: CRM & Customer Satisfaction  
![Dashboard 4](images/dashboard4.png)  
*Displays complaints, call center activity, and customer reviews to monitor service quality and resolution effectiveness.*

## 📊 Key Insights
- Customer base is balanced by gender; younger clients show strong card adoption.  
- Northeast region dominates in clients, balances, and transactions but also shows high loan charge-offs and complaints.  
- Loans are high-risk, with >59% charged-off or defaulted.  
- CRM insights align with financial patterns; resolution disputes need improvement.  

## ⚡️ Usage
1. Load large datasets using the Python scripts in `python/`.  
2. Execute SQL scripts in `sql/` to create tables and views in MySQL.  
3. Open Power BI files in `power_BI/` to view dashboards and interact with data.  

## 📌 Notes
- The data is sourced from [Retail Banking Demo Data](https://data.world/lpetrocelli/retail-banking-demo-data).  
- Eagle National Bank is a fictional institution for demo purposes.  
- Full project report with detailed analysis and insights is in `document/`.

