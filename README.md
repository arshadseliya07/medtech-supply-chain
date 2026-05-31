# 🏥 MedTech — Medicine Supply Chain Demand & Inventory Performance Analysis

## 📌 Project Overview
An end-to-end data analytics and machine learning project 
analyzing medicine demand, inventory health, wastage patterns 
and supplier performance across 19 Indian regions using 
26,708 records from 4 interconnected datasets.

---

## 🎯 Business Objectives
- Minimize medicine stockouts and wastage
- Enhance supply chain reliability
- Regional demand forecasting
- Procurement cost efficiency analysis
- Patient consumption modelling
- Stockout risk classification

---

## 🛠️ Tools & Technologies
| Tool | Usage |
|---|---|
| Python | EDA, Preprocessing, ML Models |
| MySQL | Database, Stored Procedures, Triggers |
| Power BI | Interactive Dashboards, DAX |
| Microsoft Excel | KPI Dashboard, Pivot Analysis |
| Pandas & NumPy | Data Manipulation |
| Scikit-learn | Machine Learning Models |
| Matplotlib & Seaborn | Data Visualization |

---

## 📁 Datasets
| Dataset | Records | Description |
|---|---|---|
| consumption_facility | 11,111 | Patient-level medicine consumption |
| demand_sales | 14,218 | Order tracking and financial data |
| inventory_stock | 841 | Stock levels, reorder and expiry |
| supplier_procurement | 538 | Supplier KPIs and delivery data |

---

## 🔍 Key Findings
- **Wastage 5x higher** than stockout probability (0.144 vs 0.028)
- **Parenteral medicines** — 92.3% expiry risk (critical finding)
- **Mumbai** — highest wastage region (533 units, 80 stockout days)
- **Coimbatore** — highest stockout probability (0.043)
- **Chennai** — highest poor supplier performance (24.2%)
- **Overstock (48.1%)** dominates inventory risk
- **27 medicines** below reorder level including critical cardiac drugs

---

## 🤖 Machine Learning Models

### Regression — Predicting Total Medicine Consumption
| Model | Features | R2 Score |
|---|---|---|
| Linear Regression | 3 features | 0.533 |
| Linear Regression | 8 features | 0.534 |
| KNN Regressor (K=3) | 3 features | 0.640 |
| KNN Regressor (K=5) | 5 features (random search) | **0.809** ⭐ |

### Classification — Predicting Stockout Risk
| Model | AUC Score | False Negatives |
|---|---|---|
| Logistic Regression | **0.9881** ⭐ | **0** ✅ |
| KNN Classifier (K=3) | - | - |

### Clustering — Supplier Segmentation
| Model | Clusters | Result |
|---|---|---|
| KMeans (K=3) | 3 | High / Moderate / Low Performance |

---

## 📈 Statistical Analysis
- **Probability Analysis** — P(Stockout), P(Wastage), 
  P(Expiry Risk), P(Poor Supplier Performance)
- **Hypothesis Testing** — Chi-Square & T-Test
  - H1: Region vs Stockout → P=0.3265 (Not significant)
  - H2: Wastage vs Stockout → P=0.0000 ✅ (Significant)
  - H3: Consumption vs Stockout → P=0.2795 (Not significant)
- **CLT Verification** — Normal distribution of sample means
- **Correlation Analysis** — Feature selection for ML

---

## 🗄️ MySQL Automation
- **Stored Procedure** — `reorder_medicines()` identifies 
  top 5 critical reorder candidates on demand
- **Trigger** — `low_stock_trigger` auto-flags Low Stock 
  status on every stock update (zero manual intervention)
- **Event Scheduler** — `auto_low_stock_check` runs 
  every minute refreshing stock status across all 841 medicines
- **5 Cross-Table JOIN Queries** — Demand + Inventory + 
  Supplier analysis

---

## 📊 Power BI Dashboard
5-page interactive dashboard covering:
- KPI Overview (Supply Chain, Inventory, Financial, Supplier)
- Demand & Inventory Analysis
- Supplier Performance & Delivery Analysis
- Key Drivers (Decomposition Tree)
- Regional Analysis

---

## 💡 Business Recommendations
1. Reclassify "Other" category — contains critical cardiac 
   and emergency medicines needing urgent monitoring
2. Deploy ML stockout classifier for real-time alerts
3. Replace poor performing suppliers (Chennai, Delhi, Mumbai)
4. Implement automated reorder triggers via MySQL
5. Reduce Parenteral overstock to prevent 92.3% expiry loss
6. Strengthen supply chains in smaller cities 
   (Coimbatore, Patna, Indore)

---

## 👨‍💻 Author
**Arshad Seliya**
- 🔗 LinkedIn: linkedin.com/in/arshad-seliya-a49706397
- 🔗 GitHub: github.com/arshadseliya07
- 🌐 Portfolio: analyst-services--arshadseliya88.replit.app

---

## 📄 License
MIT License — feel free to use and reference with attribution

