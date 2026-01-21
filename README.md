# Incident Reporting Database (SQL)

![Language](https://img.shields.io/badge/Language-SQL-blue)
![Database](https://img.shields.io/badge/Database-PostgreSQL-blue)
![Focus](https://img.shields.io/badge/Focus-Data%20Modeling-orange)

## Project Overview
This project establishes a relational database to structure and analyze incident reporting data from Los Angeles and Orange County. The goal was to take raw, unstructured incident logs and convert them into a clean, normalized schema that supports complex querying.

The database handles one-to-many relationships (e.g., multiple officers per incident) and enforces data integrity through strict primary and foreign key constraints.

## Technical Implementation

### 1. Database Schema
I designed a **Star-Schema** architecture to separate the central event data from the descriptive attributes. This reduces redundancy and improves query performance.

* **`Incidents` (Fact Table):** Central table containing the "when" and "where" (Date, Location, City).
* **`Victims` & `Officers` (Dimension Tables):** Stores demographic and personnel data. Linked to Incidents via Foreign Keys.
* **`Force_Types` (Lookup Table):** A standardized dictionary for force categories (e.g., Taser, Control Hold) to ensure data consistency.

### 2. SQL Logic
The `src/police_violence_schema.sql` script handles the full ETL (Extract, Transform, Load) process:

* **Table Creation:** Defines tables with specific data types and constraints to prevent bad data entry (e.g., orphan records).
* **Complex Joins:** Connects four distinct tables to reconstruct complete incident narratives from fragmented data.
* **Analytical Queries:**
    * **Subqueries:** Calculates baseline averages (e.g., average incidents across all demographics) to compare against specific groups.
    * **Aggregations:** Groups data by multiple dimensions (City + Injury Status) to find high-density clusters.
    * **Filtering:** Uses `HAVING` clauses to filter grouped data based on aggregate thresholds.

[Image of Database Schema Diagram]

## How to Run
This project is built for **PostgreSQL**.

1.  **Build the Schema:** Run the `CREATE TABLE` commands in `src/police_violence_schema.sql`.
2.  **Load Data:** Import the `force_lookup_data.csv` to populate the lookup table.
3.  **Run Queries:** Execute the analysis scripts at the bottom of the SQL file to generate reports.
## 🚀 Usage
This project uses **PostgreSQL** syntax.
1.  **Schema Build:** Run the `CREATE TABLE` statements in `src/` to initialize the architecture.
2.  **Data Loading:** Use the provided `COPY` commands to seed the `Force_Types` lookup table from CSV.
3.  **Analysis:** Execute the stored queries to generate report metrics.
