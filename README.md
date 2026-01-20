# Police Violence Database: LA & Orange County

![Status](https://img.shields.io/badge/Status-Completed-success)
![Language](https://img.shields.io/badge/Language-SQL-blue)
![Focus](https://img.shields.io/badge/Focus-Data%20Engineering-red)

## 📌 Project Overview
This repository contains the schema design and analytical queries for a relational database documenting police violence incidents in **Los Angeles (LA)** and **Orange County (OC)**.

The project was designed to enable data-driven inquiries into law enforcement accountability. It structures unstructured incident reports into a normalized relational format to answer critical questions regarding:
1.  **Racial Disparities:** Comparing force types used against Black victims vs. other demographics.
2.  **Accountability:** Correlating "Severe/Fatal" injury outcomes with officer disciplinary rates.
3.  **Geospatial Trends:** Identifying high-frequency incident zones across urban (LA) vs. suburban (OC) settings.

## 📂 Database Schema
The database utilizes a **Relational Schema** centered on a primary fact table (`Incidents`) linked to dimensional tables for victims, officers, and force types.

* **`Incidents` (Parent Table):** The core fact table containing temporal and geospatial data (Date, City, County, Address).
* **`Victims` (Child Table):** Demographic data (Race/Ethnicity) and health outcomes (Injury Status).
* **`Officers` (Child Table):** Law enforcement data, including badge numbers and disciplinary actions taken (Y/N).
* **`Force_Types` (Lookup Table):** Standardized dictionary of force categories (e.g., Taser, Firearm, Control Hold).

### Entity Relationship Diagram
You can view the full schema design here: [View EER Diagram](diagrams/entity_relationship_diagram.pdf)

## 💻 SQL Skills Demonstrated
The `src/police_violence_schema.sql` script demonstrates advanced querying and data manipulation capabilities:

* **Complex Joins:** Linking `Victims`, `Officers`, and `Force_Types` to reconstruct full incident narratives.
* **Conditional Logic:** Identifying "Accountability Gaps" (e.g., queries isolating incidents where *Injury = Fatal* AND *Disciplinary Action = None*).
* **Aggregations & Subqueries:**
    * Calculating incident counts by specific cities.
    * Comparing specific demographic incident rates against the **average across all races**.
* **Data Integrity:** Implementation of Foreign Keys to enforce relationships between the Incident parent table and Officer/Victim child tables.

## 🔍 Sample Analysis Questions
This database was built to answer queries such as:
* *"What is the most common force type used against Black and African American victims?"*
* *"Among victims with severe or fatal injuries, how many officers received NO disciplinary action?"*
* *"Which cities in Orange County have the highest density of police violence incidents?"*
