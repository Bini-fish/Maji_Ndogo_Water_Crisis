-- This script creates the database schema for the md_water_services project.
-- It's intended to allow anyone to recreate the database environment from scratch.

-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS md_water_services;
USE md_water_services;

-- CREATE TABLES

-- Table: `employee`
CREATE TABLE `employee` (
    `assigned_employee_id` INT NOT NULL PRIMARY KEY,
    `employee_name` VARCHAR(255),
    `phone_number` VARCHAR(15),
    `email` VARCHAR(255),
    `address` VARCHAR(255),
    `province_name` VARCHAR(255),
    `town_name` VARCHAR(255),
    `position` VARCHAR(255)
);

-- Table: `location`
CREATE TABLE `location` (
    `location_id` VARCHAR(255) NOT NULL PRIMARY KEY,
    `address` VARCHAR(255),
    `province_name` VARCHAR(255),
    `town_name` VARCHAR(255),
    `location_type` VARCHAR(255)
);

-- Table: `water_source`
CREATE TABLE `water_source` (
    `source_id` VARCHAR(510) NOT NULL PRIMARY KEY,
    `type_of_water_source` VARCHAR(255),
    `number_of_people_served` INT,
    `location_id` VARCHAR(255),
    CONSTRAINT `fk_source_location` FOREIGN KEY (`location_id`) REFERENCES `location`(`location_id`)
);

-- Table: `visits`
CREATE TABLE `visits` (
    `record_id` INT NOT NULL PRIMARY KEY,
    `location_id` VARCHAR(255),
    `source_id` VARCHAR(510),
    `time_of_record` DATETIME,
    `visit_count` INT,
    `time_in_queue` INT,
    `assigned_employee_id` INT,
    CONSTRAINT `fk_visits_location` FOREIGN KEY (`location_id`) REFERENCES `location`(`location_id`),
    CONSTRAINT `fk_visits_source` FOREIGN KEY (`source_id`) REFERENCES `water_source`(`source_id`),
    CONSTRAINT `fk_visits_employee` FOREIGN KEY (`assigned_employee_id`) REFERENCES `employee`(`assigned_employee_id`)
);

-- Table: `water_quality`
CREATE TABLE `water_quality` (
    `record_id` INT NOT NULL PRIMARY KEY,
    `subjective_quality_score` INT,
    `visit_count` INT,
    CONSTRAINT `fk_quality_visits` FOREIGN KEY (`record_id`) REFERENCES `visits`(`record_id`)
);

-- Table: `well_pollution`
CREATE TABLE `well_pollution` (
    `source_id` VARCHAR(258) NOT NULL PRIMARY KEY,
    `date` DATETIME,
    `description` VARCHAR(255),
    `pollutant_ppm` FLOAT,
    `biological` FLOAT,
    `results` VARCHAR(255),
    CONSTRAINT `fk_well_pollution_source` FOREIGN KEY (`source_id`) REFERENCES `water_source`(`source_id`)
);

-- Table: `project_progress`
CREATE TABLE `project_progress` (
    `Project_id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `source_id` VARCHAR(20),
    `Address` VARCHAR(20),
    `Town` VARCHAR(30),
    `Province` VARCHAR(30),
    `Source_type` VARCHAR(50),
    `Improvement` VARCHAR(50),
    `Source_status` VARCHAR(50),
    `Date_of_completion` DATE
);

-- Table: `data_dictionary`
CREATE TABLE `data_dictionary` (
    `table_name` VARCHAR(255) NOT NULL,
    `column_name` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `datatype` VARCHAR(50),
    `related_to` VARCHAR(255)
);

-- Table: `global_water_access`
CREATE TABLE `global_water_access` (
    `name` VARCHAR(255),
    `region` VARCHAR(255),
    `year` INT,
    `pop_n` FLOAT,
    `pop_u` FLOAT,
    `wat_bas_n` FLOAT,
    `wat_lim_n` FLOAT,
    `wat_unimp_n` FLOAT,
    `wat_sur_n` FLOAT,
    `wat_bas_r` FLOAT,
    `wat_lim_r` FLOAT,
    `wat_unimp_r` FLOAT,
    `wat_sur_r` FLOAT,
    `wat_bas_u` FLOAT,
    `wat_lim_u` FLOAT,
    `wat_unimp_u` FLOAT,
    `wat_sur_u` FLOAT
);

-- Table: `auditor_report`
CREATE TABLE `auditor_report` (
    `location_id` VARCHAR(32),
    `type_of_water_source` VARCHAR(64),
    `true_water_source_score` INT,
    `statements` VARCHAR(255)
);

-- Table: `combined_analysis_table`
CREATE TABLE `combined_analysis_table` (
    `source_type` VARCHAR(255),
    `town_name` VARCHAR(255),
    `province_name` VARCHAR(255),
    `location_type` VARCHAR(255),
    `people_served` INT,
    `time_in_queue` INT,
    `results` VARCHAR(255)
);

-- Table: `incorrect_records`
CREATE TABLE `incorrect_records` (
    `location_id` VARCHAR(32),
    `record_id` INT,
    `employee_name` VARCHAR(255),
    `auditor_score` INT,
    `surveyor_score` INT,
    `statements` VARCHAR(255)
);