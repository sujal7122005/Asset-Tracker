# Experiment 10 Project (JSF CRUD + JSF vs Spring Analysis)

This folder contains a complete standalone Java web project for Experiment No. 10.

## What this project demonstrates

1. MVC architecture with JSF.
2. JSF replacing JSTL/custom-tag style view logic using Facelets and JSF components.
3. CRUD operations using JSF managed bean + JDBC DAO.
4. Comparative analysis between JSF and Spring framework.

## Stack

- Java 17 (JDK 1.8+ compatible objective, implemented with a modern JDK)
- Maven
- Jakarta Faces (JSF) 4.x
- CDI (Weld)
- PostgreSQL
- Apache Tomcat 10+

## Folder structure

- src/main/java/com/experiment10/model - model classes
- src/main/java/com/experiment10/dao - DAO for CRUD
- src/main/java/com/experiment10/bean - JSF managed bean
- src/main/java/com/experiment10/util - database utility
- src/main/webapp - Facelets pages
- src/main/webapp/WEB-INF - web.xml, faces-config.xml, beans.xml
- sql - schema and seed files

## Database setup

1. Create database:
   CREATE DATABASE wealthtrack_exp10;
2. Run schema:
   psql -U postgres -d wealthtrack_exp10 -f sql/schema.sql
3. Optional seed data:
   psql -U postgres -d wealthtrack_exp10 -f sql/seed-data.sql

## Configure DB connection

Edit src/main/java/com/experiment10/util/DBConnection.java if needed.
Defaults:
- URL: jdbc:postgresql://localhost:5432/wealthtrack_exp10
- USER: postgres
- PASSWORD: admin

## Build

mvn clean package

WAR output:
- target/jsf-crud-experiment10.war

## Run

Deploy the generated WAR on Tomcat 10+.
Open:
- /jsf-crud-experiment10/
- /jsf-crud-experiment10/categories.xhtml

## Report

The experiment write-up and JSF vs Spring comparison is in:
- Experiment_No_10_Report.md
