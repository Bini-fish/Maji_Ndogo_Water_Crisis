# Data-Driven Solutions for a Water Crisis: An SQL Analysis

## Project Overview

This project focuses on a complete data analysis workflow, from raw data to actionable insights, to solve a real-world water crisis in the fictional Maji Ndogo region. Using advanced SQL, I transformed a massive, messy dataset of over 60,000 records into a clear, prioritized project plan to help engineers improve water access for communities in need.

## Problem Statement

The Maji Ndogo local government needed to identify and address critical water supply issues—specifically, contaminated sources, broken infrastructure, and long queue times at shared taps. The goal was to provide a data-driven strategy to guide engineering teams, ensuring resources are allocated to the areas with the greatest need.

## Methodology

The analysis was performed using SQL, following a structured, step-by-step process:

1.  **Data Cleaning & Exploration:** Initial queries were used to inspect the database, identify inconsistencies in data collection, and correct data quality issues.
2.  **Integrated Analysis:** I used `JOIN`s, `CASE` statements, and `GROUP BY` to analyze key areas, including:
    * Identifying corrupt data entries and employee performance issues.
    * Analyzing queue times at shared taps to determine where new taps are needed.
    * Assessing well pollution and water quality across the region.
3.  **Creating a Final Project Plan:** The final stage involved creating a professional `Project_progress` table, which serves as a prioritized backlog for engineers. This table includes specific improvement suggestions for each location.

All SQL queries used in this analysis can be found in the **[maji_ndogo_analysis.sql](https://github.com/Bini-fish/Maji_Ndogo_Water_Crisis/blob/main/SQL_Scripts/maji_ndogo_analysis.sql)** file.

## How to Replicate This Project

To run this project on your own machine, you can use the provided database schema.

1.  Clone this repository to your local machine.
2.  Import the schema by running the `maji_ndogo_schema.sql` script in your MySQL client. This will create the database and tables.
3.  Once the tables are created, you can execute the queries in `maji_ndogo_analysis.sql` to see the full analysis and results.

## Key Insights & Results

Through this analysis, I delivered a comprehensive project plan that directly addresses the water crisis. The key deliverables included:

* **A Final, Actionable Table:** A cleaned and validated dataset of over **25,000 records**, ready for implementation by the engineering teams. A snapshot can be seen in the [final_project_snapshot.csv](https://github.com/Bini-fish/Maji_Ndogo_Water_Crisis/blob/main/Data/final_project_snapshot.csv) file.
* **Targeted Improvements:** The plan specifically identified locations that needed improvements, such as drilling new wells for river-dependent communities, installing new taps at high-traffic shared sources, and implementing water purification systems (UV/RO filters) for contaminated wells.
* **Operational Efficiency:** The analysis also identified operational issues, such as poor-performing field surveyors and corrupt data entries, which provided a holistic view of the problem.

Screenshots of key queries and the final output can be seen in the **[Screenshots](https://github.com/Bini-fish/Maji_Ndogo_Water_Crisis/tree/main/Screenshots)** folder.

## Skills & Tools

* **SQL (MySQL):** Used for all data cleaning, transformation, and analysis.
* **Data Cleaning:** Handling inconsistent data, correcting values, and ensuring data integrity.
* **Data Modeling:** Creating a new table (`Project_progress`) to structure and present the final deliverables.
* **Data Analysis:** Using queries to answer complex business questions and uncover hidden patterns.
