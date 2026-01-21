# Incident Reporting Database (SQL)

![Language](https://img.shields.io/badge/Language-SQL-blue)
![Database](https://img.shields.io/badge/Database-PostgreSQL-blue)
![Focus](https://img.shields.io/badge/Focus-Relational%20Design-orange)

## Project Overview
This project establishes a relational database to structure and analyze incident reporting data from Los Angeles and Orange County. The goal was to transform flat, unstructured logs into a **connected, relational system** that reflects the real-world complexity of these events.

By moving away from a single "flat file" spreadsheet, this design allows for efficient querying of complex scenarios, such as incidents involving multiple officers or diverse force types.

## Database Architecture & Relationships
The core strength of this project is the **Relational Schema**, which organizes data into four logical entities connected by strict relationships.



### 1. The Parent-Child Structure
* **`Incidents` (Parent Table):** This is the central anchor of the database. It stores the unique "Event" data (Date, Location, City).
* **`Officers` & `Victims` (Child Tables):** These contain the detailed personnel data. They are linked back to the `Incidents` table via the `incident_id` Foreign Key.

### 2. One-to-Many Relationships
I designed the schema to handle **One-to-Many** relationships rather than simple One-to-One matches:
* **One Incident $\rightarrow$ Many Officers:** A single incident often involves multiple responding officers. By separating these into two tables, the database can record unique disciplinary outcomes for *each* officer involved in the same event without duplicating the incident data.
* **One Incident $\rightarrow$ Many Victims:** Similarly, this structure allows multiple subjects to be associated with a single event ID, preserving the integrity of the event data.

### 3. Lookup Tables (Standardization)
* **`Force_Types`:** To prevent data inconsistency (e.g., "Taser" vs. "Tased"), I implemented a Lookup Table linked via `force_id`. This ensures every incident references a standardized definition of force.

## Technical Skills Demonstrated

### Advanced SQL Querying
The `src/police_violence_schema.sql` script demonstrates the ability to leverage these relationships for analysis:

* **Multi-Table Joins:** utilized `INNER JOIN` and `LEFT JOIN` commands to reconnect the `Incidents`, `Victims`, and `Officers` tables. This allows for queries that span across relationships (e.g., *"Find the City (from Incidents) where the Officer (from Officers) had no disciplinary action"*).
* **Subqueries & Aggregation:** Wrote nested queries to calculate baseline averages across the entire dataset, then compared specific demographic subsets against those baselines.
* **Complex Filtering:** Applied `GROUP BY` and `HAVING` clauses to identify high-density clusters (e.g., cities with above-average incident rates).

### Data Integrity
* **Constraints:** Implemented **Primary Keys** to ensure every record is unique and **Foreign Keys** to enforce referential integrity (preventing an officer from being added to a non-existent incident).

## How to Run
This project is built for **PostgreSQL**.

1.  **Build the Schema:** Run the `CREATE TABLE` commands in `src/police_violence_schema.sql` to set up the relationships.
2.  **Load Data:** Import the `force_lookup_data.csv` to populate the lookup table.
3.  **Run Analysis:** Execute the query block at the bottom of the SQL file to generate reports.
