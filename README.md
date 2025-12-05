# Maji Ndogo Water Crisis: End-to-End Data Analysis and Public Reporting

This repository documents a comprehensive data analysis project aimed at addressing the severe water access crisis in the fictional region of **Maji Ndogo**.  

The workflow spans from advanced **SQL data transformation and prioritization** to building a robust **Power BI multi-star data model** and deploying **transparent, interactive dashboards** for government executives, provincial leaders, and the public.

The project's central goal was to deliver a **data-driven strategy** to President **Aziza Naledi** and provincial leaders, outlining precise **costs, locations, and actions** required to restore basic water access for Maji Ndogo's citizens.

---

## Project Phases and Deliverables

### **Phase 1: Data Wrangling and Project Prioritization (SQL)**

The foundational phase involved processing a massive dataset (over **60,000 records**) to identify crucial issues—contaminated sources, broken infrastructure, and long queue times—and generating an actionable list of improvements.

#### **Activities & Deliverables**

| Activity | Description |
|-----------|-------------|
| **Cleaning & Transformation** | Used advanced SQL (MySQL) to inspect, clean, and correct data inconsistencies, including corrupt entries and low-performing field surveyor records. |
| **Integrated Analysis** | Analyzed queue times, assessed well pollution, and determined optimal locations for intervention based on need. |
| **Deliverable** | Creation of a prioritized `Project_progress` table, serving as the official improvement backlog for engineering teams (**over 25,000 records**). |

#### **File Paths (SQL)**

| File/Folder | Description |
|--------------|-------------|
| `SQL_Scripts/maji_ndogo_schema.sql` | SQL script used to create the initial database structure and tables. |
| `SQL_Scripts/maji_ndogo_analysis.sql` | Contains all cleaning, transformation, and final prioritization SQL queries. |
| `Data/final_project_snapshot.csv` | A snapshot of the final, cleaned, and prioritized action table. |

---

### **Phase 2: Exploratory Data Analysis (EDA) and Core Insights**

This phase utilized **Power BI** to visually expose the human and operational impacts of the water crisis—focusing particularly on **queue dynamics, gender disparity, and associated safety risks**.

** Published Dashboard Link:**  
[View Initial EDA Dashboard](https://app.powerbi.com/view?r=eyJrIjoiMDBiZTA2ZmMtZWQ2ZS00NTUwLTliMmUtNzhkZGYzYzljMzU0IiwidCI6ImE0NGQ1YWZhLTJmMDUtNGRmYi05ODJjLTUwZWRkMDM5YTdhMSJ9)

#### **Key Insights**

| Insight Category | Key Findings |
|------------------|--------------|
| **Water Access & Queues** | 43% of the population uses shared taps. Average queue times exceed **120 minutes**. Queues are longest on **Saturdays and Sundays**. |
| **Queue Timing** | Queues peak during **early mornings (before 9:00)** and **evenings (past 18:00)** during weekdays. |
| **Gender Disparity** | Females dominate the queue composition nationally. Male participation doubles on weekends (from ~21% on weekdays to 40% on weekends). |
| **Safety Crisis** | 64% of crime victims are female. The top three crimes are **harassment**, **theft**, and **sexual assault**, concentrated during peak queuing hours. |

---

### **Phase 3: Public Reporting and Financial Tracking**

This final phase established the **National Public Dashboard**, incorporating advanced **Power BI features** (Multi-Star Schema, DAX) to monitor project progress, budget status, and improvements in basic water access.

**Published Dashboard Link (Public Dashboard):**  
[View National Water Survey Dashboard](https://app.powerbi.com/view?r=eyJrIjoiZGFlZDQzNjMtYTk1Yi00MzRkLWE2N2MtMGZmOTY1MjkxYmFjIiwidCI6ImE0NGQ1YWZhLTJmMDUtNGRmYi05ODJjLTUwZWRkMDM5YTdhMSJ9&embedImagePlaceholder=true)

#### **Metrics and Features**

| Metric / Feature | Description |
|------------------|-------------|
| **Total Budget** | Displays the overall cost required to complete all planned water infrastructure upgrades. |
| **Basic Water Access** | DAX measure classifying sources as "Basic" if they meet UN standards (e.g., wells must be clean; public taps must have queue times < 30 minutes). |
| **Budget Tracking (KPI)** | Measures actual spending (`cumulative_cost`) against projected budget (`cumulative_budget`), revealing a project running **~10% over budget** nationally after one year. |
| **Cost Allocation** | Outlines the number of improvements in each province and the financial budget allocation per water source. |
| **Efficiency Insight** | Vendor performance analysis showed cost efficiency was driven by travel logistics; local vendors (e.g., *Entebbe RO Installers - ERI893*) completed more projects efficiently. |

---

##  Technical Skills & Tools

| Category | Tools / Skills | Context in Project |
|-----------|----------------|--------------------|
| **Data Engineering** | SQL (MySQL), Data Cleaning, ETL | Used for initial data integration, cleaning, and creating the core `Project_progress` backlog. |
| **Business Intelligence** | Power BI Desktop, Power BI Service | Dashboard creation, visual design, and report publishing. |
| **Data Modeling** | Multi-Star Schema, Relationship Management | Designed a flexible model with multiple fact tables (e.g., visits and water_source_related_crime). |
| **Advanced Calculation** | DAX (Data Analysis Expressions) | Implemented measures for calculating `Basic_water_access`, cumulative tracking, and completion rates. |
| **Visualization** | Custom Maps (JSON), KPI Visuals | Created custom shape maps (`MD_Provinces.json`, `MD_Full_map.json`) and KPI visuals for financial monitoring. |

---


