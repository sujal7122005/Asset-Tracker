# Experiment No: 10

## Title
Compare and analyze JSF with the Spring framework. Use JSF for creating a CRUD operation.

## Date
April 19, 2026

## Competency and Practical Skills
Programming and database commands.

## Relevant CO
CO5

## Objectives
(a) To understand MVC architecture.
(b) To understand and use JSF to replace JSTL and custom tags for a JSP file.
(c) To assess the impact of using a framework instead of a pure JSP file for development and maintenance and compare JSF with Spring.

## Equipment/Instruments
- Personal Computer
- JDK 1.8 or above 
- NetBeans or Eclipse
- JSF framework
- JDBC or Hibernate-compatible database setup
- Apache Tomcat 10+

## Theory: JavaServer Faces
JavaServer Faces (JSF) is a server-side component-based UI framework used to build Java web applications. JSF provides a structured programming model with APIs and tag libraries. In JSF 2 and later, Facelets is the default templating engine.

Key capabilities:
- UI component model (inputText, commandButton, dataTable, messages)
- Stateful server-side views
- Validation and conversion
- Navigation handling
- Internationalization support
- Reusable composite component design

## Benefits of JSF
1. Clean separation between behavior and presentation.
2. Layered on top of the Servlet API, enabling flexible use cases.
3. Facelets improves templating, composition, and maintainability.

## Safety and Precautions
- Ensure database server is running.
- Ensure JSF/CDI/JDBC libraries are available on classpath.
- Ensure web server is running.
- Handle compile-time and runtime exceptions.

## Procedure Followed in This Implementation
1. Created a standalone Maven web application in the project folder.
2. Added JSF, CDI, Servlet, and PostgreSQL dependencies.
3. Configured FacesServlet in web.xml.
4. Created JSF pages using Facelets:
   - index.xhtml
   - categories.xhtml
5. Created managed bean:
   - AssetCategoryBean.java
6. Created model and DAO classes:
   - AssetCategory.java
   - AssetCategoryDAO.java
7. Configured DB utility and schema scripts.
8. Performed CRUD operations for asset categories:
   - Create category
   - Read category list
   - Update category
   - Delete category

## CRUD Mapping in JSF App
- Create: form submit with Save button
- Read: h:dataTable category listing
- Update: Edit action loading selected row in form
- Delete: Delete action with confirmation prompt

## JSF vs Spring Framework Comparison

| Parameter | JSF | Spring (Spring MVC / Boot) |
|---|---|---|
| Primary focus | Component-based server-side UI framework | Full ecosystem for enterprise app development |
| MVC role | Mostly View + Controller in web layer | Complete MVC + DI + data + security + cloud |
| Learning curve | Moderate for JSF lifecycle and component state | Moderate to high due to broad ecosystem |
| UI model | Stateful component tree, event-driven | Stateless request model, template/REST oriented |
| Best use cases | Server-rendered form-heavy enterprise portals | Microservices, REST APIs, modern full-stack apps |
| Templating | Facelets with JSF tags | Thymeleaf/JSP/Freemarker or frontend frameworks |
| Validation | Built-in component validators/converters | Bean Validation, custom validators |
| Dependency Injection | CDI integration | Core feature (IoC container) |
| Community trend | Stable but niche in modern projects | Very large ecosystem and industry adoption |
| Productivity | Fast for component-rich server-side pages | High overall productivity for diverse architectures |

## Analysis
- JSF provides rapid development for form-centric interfaces because binding and validation are tightly integrated.
- Spring provides stronger modular architecture and larger ecosystem support for modern distributed systems.
- For this experiment (single web CRUD module), JSF implementation is concise and demonstrates MVC clearly.
- For long-term scalability and service-oriented architecture, Spring usually offers better flexibility.

## Result
A working JSF CRUD module was implemented for the asset_categories table. The system demonstrates MVC architecture and JSF component-based development with form handling, validation, state management, and database CRUD operations.

## Conclusion
JSF is effective for server-side UI-focused enterprise modules and quickly replaces JSP/JSTL-heavy pages with structured component-based pages. Spring is broader and typically preferred for large modern applications requiring microservices, security, and REST-first design. The selection depends on project architecture, team skills, and maintenance goals.
