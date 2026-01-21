
#################
# FINAL PROJECT #
#################

# By Sanne Glastra


-- PROJECT SETUP --------------------------------------------------------------------------------

-- create schema;
DROP SCHEMA violence;
CREATE SCHEMA violence;
USE violence;

# PARENT TABLE: INCIDENTS ##########################################################################

-- create parent table;
CREATE TABLE incidents (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE,
    time TIME,
    street_address VARCHAR(100),
    city VARCHAR(50), 
    county VARCHAR(50), 
    zip_code VARCHAR(5),
    force_id INT NOT NULL
);

-- create index on county;
CREATE INDEX idx_county
	ON incidents(county);
    
-- create index on force id;
CREATE INDEX idx_force_id
	ON incidents(force_id);
    
-- add trigger to parent table
DELIMITER //

CREATE TRIGGER incidents_trigger
	BEFORE INSERT ON incidents
    FOR EACH ROW
BEGIN
	# Add rule for date here
	IF NEW.date > CURDATE() THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Incident date must be on or before the current day';
	END IF;
    
    # Add rule for staisfaction scores here
    IF LENGTH(NEW.zip_code) != 5 THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Zip code must be exactly 5 digits';
	END IF;   

END //


# CHILD TABLE: OFFICERS ##########################################################################

-- officers child table
CREATE TABLE officers (
	PRIMARY KEY(officer_id, incident_id),
    officer_id INT NOT NULL,
    incident_id INT NOT NULL,
    badge_number VARCHAR(5),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    officer_rank VARCHAR(50),
    action_taken VARCHAR(50),
    disciplinary_action VARCHAR(3),
    FOREIGN KEY (incident_id)
        REFERENCES incidents (incident_id)
);

-- indexes
CREATE INDEX idx_action_taken
	ON officers(action_taken);
    
CREATE INDEX idx_disciplinary_action
	ON officers(disciplinary_action);

-- triggers    
DELIMITER //

CREATE TRIGGER officers_trigger
	BEFORE INSERT ON officers
    FOR EACH ROW
BEGIN
	IF LENGTH(NEW.badge_number) NOT IN (3, 4, 5) THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Badge number can only be 3, 4, or 5 digits';
	END IF;
    
     IF NEW.action_taken IS NOT NULL AND NEW.action_taken NOT IN ('force', 'arrest') THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Action taken must be either "force", "arrest", or NULL';
	END IF;
    
     IF NEW.disciplinary_action NOT IN ('Yes', 'No') THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Disciplinary action taken must be either Yes or No';
	END IF;
    
END //


# CHILD TABLE: VICTIMS ##########################################################################


-- victims child table
CREATE TABLE victims (
	PRIMARY KEY(victim_id, incident_id),
    victim_id INT NOT NULL,
    incident_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    race_ethnicity VARCHAR(50),
    injury_status VARCHAR(6),
    FOREIGN KEY (incident_id)
        REFERENCES incidents (incident_id)
);

-- indexes
CREATE INDEX idx_race_ethnicity
	ON victims(race_ethnicity);
    
CREATE INDEX idx_injury_status
	ON victims(injury_status);

-- triggers
DELIMITER //

CREATE TRIGGER victims_trigger
	BEFORE INSERT ON victims
    FOR EACH ROW
BEGIN
	  IF NEW.race_ethnicity IS NOT NULL AND NEW.race_ethnicity NOT IN (
        'American Indian or Alaska Native',
        'Asian',
        'Black or African American',
        'Hispanic or Latino',
        'Native Hawaiian or Pacific Islander',
        'White',
        'Two or More Races'
    ) THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Invalid race_ethnicity: must be one of the predefined categories.';
	END IF;
    
      IF NEW.injury_status IS NOT NULL AND NEW.injury_status NOT IN ('None', 'Minor', 'Severe', 'Fatal') THEN
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Invalid injury_status: must be None, Minor, Severe, or Fatal';
	END IF;
    
END //


# LOOKUP TABLE: FORCE TYPES ##########################################################################

-- create lookup table;
CREATE TABLE force_types (
    force_id INT PRIMARY KEY,
    force_type VARCHAR(100)
);


-- ADD DATA TO TABLES --------------------------------------------------------------------------------

# PARENT TABLE: INCIDENTS ##########################################################################
INSERT INTO incidents (incident_id, date, time, street_address, city, county, zip_code, force_id) 
VALUES
	(1, '2024-02-14', '14:25:00', '1234 Sunset Blvd', 'Los Angeles', 'Los Angeles County', '90026', 5),
	(2, '2024-01-05', '10:10:00', '500 N Main St', 'Santa Ana', 'Orange County', '92701', 1),
	(3, '2023-11-20', '22:30:00', '789 Beach Ave', 'Huntington Beach', 'Orange County', '92648', 10),
	(4, '2023-10-03', '18:45:00', '135 Hollywood Way', 'Burbank', 'Los Angeles County', '91505', 4),
	(5, '2023-08-12', '02:15:00', '760 Ocean Blvd', 'Long Beach', 'Los Angeles County', '90802', 9),
	(6, '2023-06-30', '11:50:00', '300 Civic Center Dr', 'Irvine', 'Orange County', '92606', 2),
	(7, '2024-03-01', '13:15:00', '876 Hill St', 'Anaheim', 'Orange County', '92805', 13),
	(8, '2023-09-10', '23:00:00', '44 Pacific Coast Hwy', 'Malibu', 'Los Angeles County', '90265', 6),
	(9, '2023-05-22', '17:40:00', '2101 E 7th St', 'Los Angeles', 'Los Angeles County', '90023', 3),
	(10, '2024-04-10', '08:30:00', '1020 Harbor Blvd', 'Fullerton', 'Orange County', '92832', 14),
	(11, '2024-01-18', '20:20:00', '555 S Flower St', 'Los Angeles', 'Los Angeles County', '90071', 11),
	(12, '2023-12-25', '04:50:00', '3901 Katella Ave', 'Los Alamitos', 'Orange County', '90720', 15),
	(13, '2023-07-08', '12:00:00', '888 Main St', 'Garden Grove', 'Orange County', '92840', 7),
	(14, '2023-11-11', '09:45:00', '1000 S Figueroa St', 'Los Angeles', 'Los Angeles County', '90015', 12),
	(15, '2024-02-01', '06:05:00', '650 N Tustin Ave', 'Orange', 'Orange County', '92867', 1),
	(16, '2023-10-19', '15:10:00', '1200 Lincoln Blvd', 'Santa Monica', 'Los Angeles County', '90401', 5),
	(17, '2023-08-05', '21:55:00', '1400 Chapman Ave', 'Fullerton', 'Orange County', '92831', 8),
	(18, '2023-06-01', '07:35:00', '7777 Valley View St', 'Cypress', 'Orange County', '90630', 10),
	(19, '2023-09-20', '16:25:00', '1600 Vine St', 'Los Angeles', 'Los Angeles County', '90028', 4),
	(20, '2023-03-03', '19:45:00', '1340 S Sanderson Ave', 'Los Angeles', 'Los Angeles County', '90003', 6),
	(21, '2023-04-28', '10:00:00', '2222 Katella Ave', 'Anaheim', 'Orange County', '92806', 9),
	(22, '2023-05-14', '22:30:00', '1800 Bellflower Blvd', 'Long Beach', 'Los Angeles County', '90815', 13),
	(23, '2023-07-30', '12:20:00', '2601 E Chapman Ave', 'Orange', 'Orange County', '92869', 15),
	(24, '2023-11-04', '14:10:00', '9000 Sunset Blvd', 'West Hollywood', 'Los Angeles County', '90069', 7),
	(25, '2024-03-21', '05:45:00', '4800 Irvine Blvd', 'Irvine', 'Orange County', '92620', 3);



# CHILD TABLE: OFFICERS ##########################################################################
INSERT INTO officers (officer_id, incident_id, badge_number, first_name, last_name, officer_rank, action_taken, disciplinary_action) 
VALUES
	(101, 1, '12345', 'James', 'Reynolds', 'Sergeant', 'arrest', 'No'),
	(101, 5, '12345', 'James', 'Reynolds', 'Sergeant', 'force', 'Yes'),
	(101, 9, '12345', 'James', 'Reynolds', 'Sergeant', NULL, 'No'),
	(102, 2, '23456', 'Maria', 'Lopez', 'Officer', 'force', 'Yes'),
	(102, 6, '23456', 'Maria', 'Lopez', 'Officer', NULL, 'No'),
	(103, 3, '34567', 'Daniel', 'Kim', 'Lieutenant', 'force', 'No'),
	(103, 7, '34567', 'Daniel', 'Kim', 'Lieutenant', NULL, 'No'),
	(103, 10, '34567', 'Daniel', 'Kim', 'Lieutenant', 'arrest', 'No'),
	(104, 4, '45678', 'Rebecca', 'Nguyen', 'Officer', NULL, 'No'),
	(104, 11, '45678', 'Rebecca', 'Nguyen', 'Officer', 'arrest', 'Yes'),
	(104, 14, '45678', 'Rebecca', 'Nguyen', 'Officer', 'force', 'Yes'),
	(105, 5, '56789', 'Joseph', 'Allen', 'Officer', 'arrest', 'Yes'),
	(105, 12, '56789', 'Joseph', 'Allen', 'Officer', 'force', 'No'),
	(105, 13, '56789', 'Joseph', 'Allen', 'Officer', NULL, 'No'),
	(106, 6, '67890', 'Karen', 'Johnson', 'Captain', NULL, 'No'),
	(106, 10, '67890', 'Karen', 'Johnson', 'Captain', 'arrest', 'No'),
	(106, 15, '67890', 'Karen', 'Johnson', 'Captain', 'arrest', 'No'),
	(107, 7, '78901', 'Mark', 'Peterson', 'Officer', 'force', 'No'),
	(107, 16, '78901', 'Mark', 'Peterson', 'Officer', NULL, 'Yes'),
	(108, 8, '89012', 'Emily', 'Clark', 'Sergeant', 'arrest', 'No'),
	(108, 17, '89012', 'Emily', 'Clark', 'Sergeant', 'force', 'Yes'),
	(109, 9, '90123', 'Liam', 'White', 'Lieutenant', NULL, 'No'),
	(109, 18, '90123', 'Liam', 'White', 'Lieutenant', 'arrest', 'No'),
	(110, 10, '01234', 'Sophia', 'Green', 'Officer', 'arrest', 'Yes'),
	(110, 19, '01234', 'Sophia', 'Green', 'Officer', NULL, 'No');


# CHILD TABLE: VICTIMS ##########################################################################
INSERT INTO victims (victim_id, incident_id, first_name, last_name, race_ethnicity, injury_status)
VALUES
    (201, 1, 'Alex', 'Smith', 'White', 'Minor'),
    (201, 8, 'Alex', 'Smith', 'White', 'None'),
    (202, 2, 'Linda', 'Martinez', 'Hispanic or Latino', 'Severe'),
    (202, 11, 'Linda', 'Martinez', 'Hispanic or Latino', 'Minor'),
    (203, 3, 'David', 'Lee', 'Asian', 'None'),
    (203, 4, 'David', 'Lee', 'Asian', 'Fatal'),
    (204, 4, 'Fatima', 'Ali', 'Black or African American', 'Minor'),
    (204, 9, 'Fatima', 'Ali', 'Black or African American', 'Severe'),
    (205, 5, 'John', 'Doe', 'White', 'None'),
    (205, 14, 'John', 'Doe', 'White', 'Minor'),
    (206, 6, 'Mei', 'Chen', 'Asian', 'None'),
    (206, 15, 'Mei', 'Chen', 'Asian', 'Severe'),
    (207, 7, 'Carlos', 'Ramirez', 'Hispanic or Latino', 'Severe'),
    (207, 10, 'Carlos', 'Ramirez', 'Hispanic or Latino', 'None'),
    (208, 8, 'Grace', 'Johnson', 'Black or African American', 'Minor'),
    (208, 16, 'Grace', 'Johnson', 'Black or African American', 'Minor'),
    (209, 9, 'Mohammed', 'Yusuf', 'American Indian or Alaska Native', 'Severe'),
    (209, 12, 'Mohammed', 'Yusuf', 'American Indian or Alaska Native', 'Minor'),
    (210, 10, 'Natalie', 'Parker', 'White', 'None'),
    (210, 17, 'Natalie', 'Parker', 'White', 'Minor'),
    (211, 11, 'Sean', 'Brown', 'Black or African American', 'Fatal'),
    (212, 12, 'Emily', 'Nguyen', 'Asian', 'Severe'),
    (213, 13, 'Andre', 'Williams', 'Black or African American', 'None'),
    (214, 14, 'Olivia', 'Davis', 'White', 'Minor'),
    (215, 15, 'Ethan', 'Clark', 'Hispanic or Latino', 'Severe');



# LOOKUP TABLE: FORCE TYPES ##########################################################################
-- add data to lookup table;
INSERT INTO force_types (force_id, force_type) 
VALUES
	(1, 'Control Hold'),
	(2, 'Pain Compliance'),
	(3, 'OC Spray'),
	(4, 'Takedown'),
	(5, 'Firearm Discharge'),
	(6, 'Impact Weapon Head Strike'),
	(7, 'Kick to the Head'),
	(8, 'Hospitalization-Level Force'),
	(9, 'Canine Bite'),
	(10, 'Taser Deployment'),
	(11, '40mm Less-Lethal Launcher'),
	(12, 'Neck Restraint'),
	(13, 'Hand Strike'),
	(14, 'Kick'),
	(15, 'Hobble Restraint');



-- RUN 10 DIFFERENT QUERIES --------------------------------------------------------------------------------

# QUESTION 1: Create a view of incidents and corresponding victims in Orange County. What cities in Orange County have the highest 
# amount of incidents? Provide the cities in all upper case.

CREATE VIEW oc_incidents AS
	SELECT *
    FROM incidents AS i
		LEFT JOIN victims AS v
        USING (incident_id)
	WHERE county = 'Orange County';
    
SELECT UPPER(city) AS upper_city, COUNT(incident_id) AS incident_count
FROM oc_incidents
GROUP BY city
ORDER BY incident_count DESC;

# the cities with the highest amount of incidents are Fullerton and Orange. 
# We decided to create this view since orange county may have a different profile of incidents compared to LA county, which is a 
# more urban setting. 

# QUESTION 2: What is the most common force type among Black and African American victims?

CREATE TEMPORARY TABLE incidents_black_victims AS
(
	SELECT *
    FROM incidents AS i
		LEFT JOIN victims AS v
        USING (incident_id)
	WHERE race_ethnicity = 'Black or African American'

);

SELECT injury_status, COUNT(*) AS injury_count
FROM incidents_black_victims
GROUP BY injury_status;

# The most common injury type is minor. We would want to look at this in a real dataset because we understand from previous literature that Black Americans experience disproportionately severe injuries during interactions with police officers. T
# This fabricated data does not indicate this, but it would be important to look at this at a larger scale in sprawling places like Los Angeles and Orange County.

# QUESTION 3: List the first name and last name of officers in one column and their corresponding number of incidents.

WITH officer_incidents AS
(
SELECT *, CONCAT(first_name, ' ', last_name) AS full_name 
FROM incidents AS i
	LEFT JOIN officers AS o
    USING(incident_id)
)

SELECT full_name, COUNT(incident_id) AS num_incidents
FROM officer_incidents
GROUP BY full_name
HAVING full_name IS NOT NULL;

# QUESTION 4: Pivot the incidents table by year to get a count of incidents per county for each year

SELECT county, 
COUNT(CASE WHEN YEAR(date) = 2023 THEN incident_id END) AS incidents_2023,
COUNT(CASE WHEN YEAR(date) = 2024 THEN incident_id END) AS incidents_2024
FROM incidents
GROUP BY county;

# We could see if there is a significant difference in incidents in 2023 versus 2024 or in LA County versus Orange County.

# QUESTION 5: Which officers had both a 'Yes' and 'No' disciplinary action? Provide officer IDs. 

SELECT DISTINCT a.officer_id
FROM officers AS a
	INNER JOIN officers AS b 
    USING(officer_id)
WHERE a.disciplinary_action = 'Yes' AND b.disciplinary_action = 'No';

# QUESTION 6: Use a subquery to list the victim_id's with the highest number of incidents, accounting for ties.

SELECT victim_id, COUNT(victim_id) AS num_incidents 
FROM victims 
GROUP BY victim_id
HAVING num_incidents=
	(SELECT COUNT(victim_id) AS num_incidents
    FROM victims
    GROUP BY victim_id
    ORDER BY num_incidents DESC
    LIMIT 1);
    
# QUESTION 7: Create a table that lists the first and last names of both the officers and victims involved in each incident, specifying whether the name of the person was a victim or an officer. We chose UNION because we don't have duplicates.

CREATE TEMPORARY TABLE victim_table AS
	SELECT incident_id, first_name, last_name, 'victim' AS status
    FROM victims;
    
CREATE TEMPORARY TABLE officer_table AS
	SELECT incident_id, first_name, last_name, 'officer' AS status
    FROM officers;
    
CREATE TABLE status_names AS
	SELECT * FROM victim_table
    UNION
    SELECT * FROM officer_table
    ORDER BY incident_id;

SELECT * FROM status_names;

# QUESTION 8: Count the number of incidents by race and then get the average number of incidents 
# across all races. Then use CASE WHEN() to compare the average number of incidents to the number of incidents by race. We used OVER() when we wanted to get the average
# number of incidents and we used OVER(PARTITION BY) when we wanted to get the number of incidents by race.

WITH race_avg AS
(
SELECT race_ethnicity, num_incidents_by_race, AVG(num_incidents_by_race) OVER() AS avg_incidents
FROM 
	(SELECT race_ethnicity, COUNT(incident_id) OVER(PARTITION BY race_ethnicity) AS num_incidents_by_race
    FROM victims) AS derived
)

SELECT *,
	CASE 
		WHEN num_incidents_by_race<avg_incidents THEN 'Below Average'
		WHEN num_incidents_by_race>avg_incidents THEN 'Above Average'
		ELSE 'Equal to average'
	END AS incident_category
FROM race_avg;

# QUESTION 9: DENSE RANK the number of incidents by race, in order of most incidents to least. We are using DENSE RANK to account for duplicates.
WITH incident_count AS
(
SELECT race_ethnicity, COUNT(incident_id) OVER(PARTITION BY race_ethnicity) AS num_incidents_by_race
FROM victims
)

SELECT *, DENSE_RANK() OVER(ORDER BY num_incidents_by_race DESC) AS incident_rank
FROM incident_count;

# QUESTION 10: Among victims where injury status is severe or fatal, how many officers did not receive disciplinary action?

WITH victims_injury_status AS
(
SELECT officer_id, injury_status, disciplinary_action
FROM officers as o
	LEFT JOIN victims as v
    USING (incident_id)
WHERE injury_status IN ('Severe', 'Fatal')
)

SELECT COUNT(officer_id) AS officer_count
FROM victims_injury_status
WHERE disciplinary_action = 'No';

# Answer to this question is 10. 



