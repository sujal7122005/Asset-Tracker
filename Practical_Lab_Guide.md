# 🧪 Practical-wise Lab Guide
## WealthTrack — Asset Tracker (CRUD Operations)
### Advanced Java Programming — Lab Manual

---

> **Project:** Asset Tracker — A CRUD-based Asset Management System  
> **Database:** PostgreSQL  
> **Each practical builds on the previous one, eventually creating the full website.**  
> **📸 Take code screenshots at each step for your lab manual.**

---

## Practical 1 — Console-Based Java + PostgreSQL CRUD

**Objective:** Create databases related to your project and query them from console-based Java applications.

### What You'll Build
A console (terminal) Java application that connects to PostgreSQL and performs CRUD operations on the `assets` table.

### Step-by-Step

**Step 1.1 — Create PostgreSQL Database & Tables**

```sql
-- Connect to PostgreSQL and run:
CREATE DATABASE wealthtrack_db;

\c wealthtrack_db;

-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Asset Categories lookup
CREATE TABLE asset_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

INSERT INTO asset_categories (category_name) VALUES
('Equities'), ('ETF'), ('Crypto'), ('Real Estate'), ('Cash'), ('Bonds');

-- Assets table
CREATE TABLE assets (
    asset_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    asset_name VARCHAR(100) NOT NULL,
    ticker_symbol VARCHAR(20),
    category_id INT REFERENCES asset_categories(category_id),
    invested_amount DECIMAL(15,2) DEFAULT 0,
    current_value DECIMAL(15,2) DEFAULT 0,
    purchase_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table
CREATE TABLE transactions (
    txn_id SERIAL PRIMARY KEY,
    asset_id INT REFERENCES assets(asset_id) ON DELETE CASCADE,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    txn_type VARCHAR(20) NOT NULL,  -- Buy, Sell, Dividend
    quantity DECIMAL(15,4),
    price_per_unit DECIMAL(15,2),
    total_amount DECIMAL(15,2),
    commission DECIMAL(10,2) DEFAULT 0,
    txn_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'Completed'
);
```
📸 **Screenshot:** Database tables created in pgAdmin/psql terminal

**Step 1.2 — Java Project Setup (Maven)**

```xml
<!-- pom.xml dependencies -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.7.1</version>
</dependency>
```

**Step 1.3 — DBConnection.java (Utility Class)**

```java
package com.wealthtrack.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/wealthtrack_db";
    private static final String USER = "postgres";
    private static final String PASSWORD = "your_password";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```
📸 **Screenshot:** DBConnection.java code

**Step 1.4 — Asset.java (Model/Bean Class)**

```java
package com.wealthtrack.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Asset {
    private int assetId;
    private int userId;
    private String assetName;
    private String tickerSymbol;
    private int categoryId;
    private BigDecimal investedAmount;
    private BigDecimal currentValue;
    private Date purchaseDate;

    // Default constructor
    public Asset() {}

    // Parameterized constructor
    public Asset(int userId, String assetName, String tickerSymbol,
                 int categoryId, BigDecimal investedAmount,
                 BigDecimal currentValue, Date purchaseDate) {
        this.userId = userId;
        this.assetName = assetName;
        this.tickerSymbol = tickerSymbol;
        this.categoryId = categoryId;
        this.investedAmount = investedAmount;
        this.currentValue = currentValue;
        this.purchaseDate = purchaseDate;
    }

    // Getters and Setters for all fields...
    public int getAssetId() { return assetId; }
    public void setAssetId(int assetId) { this.assetId = assetId; }
    public String getAssetName() { return assetName; }
    public void setAssetName(String assetName) { this.assetName = assetName; }
    // ... (all other getters/setters)
}
```
📸 **Screenshot:** Asset model class

**Step 1.5 — AssetDAO.java (CRUD Operations)**

```java
package com.wealthtrack.dao;

import com.wealthtrack.model.Asset;
import com.wealthtrack.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssetDAO {

    // CREATE
    public boolean addAsset(Asset asset) {
        String sql = "INSERT INTO assets (user_id, asset_name, ticker_symbol, category_id, invested_amount, current_value, purchase_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, asset.getUserId());
            ps.setString(2, asset.getAssetName());
            ps.setString(3, asset.getTickerSymbol());
            ps.setInt(4, asset.getCategoryId());
            ps.setBigDecimal(5, asset.getInvestedAmount());
            ps.setBigDecimal(6, asset.getCurrentValue());
            ps.setDate(7, asset.getPurchaseDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // READ ALL
    public List<Asset> getAllAssets() {
        List<Asset> assets = new ArrayList<>();
        String sql = "SELECT * FROM assets";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Asset a = new Asset();
                a.setAssetId(rs.getInt("asset_id"));
                a.setAssetName(rs.getString("asset_name"));
                a.setTickerSymbol(rs.getString("ticker_symbol"));
                a.setInvestedAmount(rs.getBigDecimal("invested_amount"));
                a.setCurrentValue(rs.getBigDecimal("current_value"));
                assets.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return assets;
    }

    // READ by ID
    public Asset getAssetById(int id) {
        String sql = "SELECT * FROM assets WHERE asset_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Asset a = new Asset();
                a.setAssetId(rs.getInt("asset_id"));
                a.setAssetName(rs.getString("asset_name"));
                a.setTickerSymbol(rs.getString("ticker_symbol"));
                a.setInvestedAmount(rs.getBigDecimal("invested_amount"));
                a.setCurrentValue(rs.getBigDecimal("current_value"));
                return a;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // UPDATE
    public boolean updateAsset(Asset asset) {
        String sql = "UPDATE assets SET asset_name=?, ticker_symbol=?, invested_amount=?, current_value=? WHERE asset_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, asset.getAssetName());
            ps.setString(2, asset.getTickerSymbol());
            ps.setBigDecimal(3, asset.getInvestedAmount());
            ps.setBigDecimal(4, asset.getCurrentValue());
            ps.setInt(5, asset.getAssetId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // DELETE
    public boolean deleteAsset(int id) {
        String sql = "DELETE FROM assets WHERE asset_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // SEARCH by name
    public List<Asset> searchAssets(String keyword) {
        List<Asset> results = new ArrayList<>();
        String sql = "SELECT * FROM assets WHERE asset_name ILIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Asset a = new Asset();
                a.setAssetId(rs.getInt("asset_id"));
                a.setAssetName(rs.getString("asset_name"));
                a.setTickerSymbol(rs.getString("ticker_symbol"));
                results.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return results;
    }
}
```
📸 **Screenshot:** AssetDAO with all CRUD methods

**Step 1.6 — ConsoleApp.java (Main Class)**

```java
package com.wealthtrack;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.model.Asset;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Scanner;

public class ConsoleApp {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        AssetDAO dao = new AssetDAO();
        while (true) {
            System.out.println("\n=== WealthTrack Asset Tracker ===");
            System.out.println("1. Add Asset");
            System.out.println("2. View All Assets");
            System.out.println("3. Search Asset");
            System.out.println("4. Update Asset");
            System.out.println("5. Delete Asset");
            System.out.println("6. Exit");
            System.out.print("Choose: ");
            int choice = sc.nextInt(); sc.nextLine();

            switch (choice) {
                case 1: // Add
                    System.out.print("Asset Name: "); String name = sc.nextLine();
                    System.out.print("Ticker: "); String ticker = sc.nextLine();
                    System.out.print("Invested Amount: "); BigDecimal inv = sc.nextBigDecimal();
                    System.out.print("Current Value: "); BigDecimal cur = sc.nextBigDecimal();
                    Asset a = new Asset(1, name, ticker, 1, inv, cur, new Date(System.currentTimeMillis()));
                    System.out.println(dao.addAsset(a) ? "✅ Added!" : "❌ Failed");
                    break;
                case 2: // View All
                    dao.getAllAssets().forEach(asset ->
                        System.out.printf("ID:%d | %s (%s) | Invested: ₹%s | Current: ₹%s%n",
                            asset.getAssetId(), asset.getAssetName(), asset.getTickerSymbol(),
                            asset.getInvestedAmount(), asset.getCurrentValue()));
                    break;
                case 3: // Search
                    System.out.print("Search keyword: "); String kw = sc.nextLine();
                    dao.searchAssets(kw).forEach(asset ->
                        System.out.printf("ID:%d | %s (%s)%n", asset.getAssetId(), asset.getAssetName(), asset.getTickerSymbol()));
                    break;
                case 4: // Update
                    System.out.print("Asset ID to update: "); int uid = sc.nextInt(); sc.nextLine();
                    Asset existing = dao.getAssetById(uid);
                    if (existing != null) {
                        System.out.print("New Name [" + existing.getAssetName() + "]: "); String nn = sc.nextLine();
                        if (!nn.isEmpty()) existing.setAssetName(nn);
                        System.out.println(dao.updateAsset(existing) ? "✅ Updated!" : "❌ Failed");
                    } else System.out.println("Asset not found.");
                    break;
                case 5: // Delete
                    System.out.print("Asset ID to delete: "); int did = sc.nextInt();
                    System.out.println(dao.deleteAsset(did) ? "✅ Deleted!" : "❌ Failed");
                    break;
                case 6: System.exit(0);
            }
        }
    }
}
```
📸 **Screenshot:** Console app running with menu + sample output

### 📸 Screenshots to Capture for Practical 1
1. PostgreSQL database & tables in pgAdmin
2. `DBConnection.java` code
3. `Asset.java` model class
4. `AssetDAO.java` CRUD methods
5. `ConsoleApp.java` main class
6. Console output — Add, View, Search, Update, Delete operations

---

## Practical 2 — Client-Server Socket Application with Search

**Objective:** Create a client application that connects to Practical 1's app, sends a search "string", and gets matching results from the database.

### What You'll Build
A **TCP Socket-based client-server** application. The server connects to PostgreSQL, the client sends a search string, server queries DB and returns results.

### Step-by-Step

**Step 2.1 — AssetServer.java**

```java
package com.wealthtrack.network;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.model.Asset;
import java.io.*;
import java.net.*;
import java.util.List;

public class AssetServer {
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(5000);
        System.out.println("🟢 Asset Server started on port 5000...");

        while (true) {
            Socket clientSocket = serverSocket.accept();
            System.out.println("Client connected: " + clientSocket.getInetAddress());

            BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);

            String searchQuery = in.readLine();
            System.out.println("Search query received: " + searchQuery);

            AssetDAO dao = new AssetDAO();
            List<Asset> results = dao.searchAssets(searchQuery);

            if (results.isEmpty()) {
                out.println("No assets found matching: " + searchQuery);
            } else {
                StringBuilder sb = new StringBuilder();
                for (Asset a : results) {
                    sb.append(String.format("ID:%d | %s (%s) | Invested: ₹%s | Current: ₹%s",
                        a.getAssetId(), a.getAssetName(), a.getTickerSymbol(),
                        a.getInvestedAmount(), a.getCurrentValue()));
                    sb.append("\n");
                }
                out.println(sb.toString());
            }
            out.println("END");
            clientSocket.close();
        }
    }
}
```

**Step 2.2 — AssetClient.java**

```java
package com.wealthtrack.network;

import java.io.*;
import java.net.*;
import java.util.Scanner;

public class AssetClient {
    public static void main(String[] args) throws IOException {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter search keyword: ");
        String keyword = sc.nextLine();

        Socket socket = new Socket("localhost", 5000);
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        out.println(keyword);

        System.out.println("\n=== Search Results from Server ===");
        String line;
        while ((line = in.readLine()) != null) {
            if (line.equals("END")) break;
            System.out.println(line);
        }
        socket.close();
    }
}
```
📸 **Screenshot:** Server terminal + Client terminal side by side showing search results

### 📸 Screenshots to Capture for Practical 2
1. `AssetServer.java` code
2. `AssetClient.java` code
3. Server console — showing "Server started" and "Client connected"
4. Client console — showing search input and results received

---

## Practical 3 — Servlet-based Web UI (Replaces Console)

**Objective:** Modify Practical 1 by replacing the console-based UI with a web-based UI using Servlets.

### What You'll Build
A web application running on Tomcat that uses **Servlets** to handle HTTP requests and render HTML for CRUD operations.

### Step-by-Step

**Step 3.1 — Configure `web.xml`**

```xml
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0">
    <servlet>
        <servlet-name>AssetServlet</servlet-name>
        <servlet-class>com.wealthtrack.servlet.AssetServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>AssetServlet</servlet-name>
        <url-pattern>/assets</url-pattern>
    </servlet-mapping>
</web-app>
```

**Step 3.2 — AssetServlet.java**

```java
package com.wealthtrack.servlet;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.model.Asset;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.util.List;

public class AssetServlet extends HttpServlet {

    private AssetDAO dao = new AssetDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        String action = req.getParameter("action");

        out.println("<html><head><title>WealthTrack Assets</title></head><body>");
        out.println("<h1>WealthTrack - Asset Manager</h1>");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteAsset(id);
            out.println("<p style='color:green'>✅ Asset deleted!</p>");
        }

        // Search form
        out.println("<form method='GET' action='assets'>");
        out.println("<input type='hidden' name='action' value='search'>");
        out.println("Search: <input type='text' name='keyword'>");
        out.println("<button type='submit'>🔍 Search</button></form><hr>");

        // Display assets
        List<Asset> assets;
        if ("search".equals(action)) {
            assets = dao.searchAssets(req.getParameter("keyword"));
            out.println("<h3>Search Results:</h3>");
        } else {
            assets = dao.getAllAssets();
        }

        out.println("<table border='1' cellpadding='8'>");
        out.println("<tr><th>ID</th><th>Name</th><th>Ticker</th><th>Invested</th><th>Current Value</th><th>Actions</th></tr>");
        for (Asset a : assets) {
            out.printf("<tr><td>%d</td><td>%s</td><td>%s</td><td>₹%s</td><td>₹%s</td>",
                a.getAssetId(), a.getAssetName(), a.getTickerSymbol(),
                a.getInvestedAmount(), a.getCurrentValue());
            out.printf("<td><a href='assets?action=delete&id=%d'>Delete</a></td></tr>", a.getAssetId());
        }
        out.println("</table>");

        // Add Asset form
        out.println("<h3>Add New Asset</h3>");
        out.println("<form method='POST' action='assets'>");
        out.println("Name: <input name='name'><br>");
        out.println("Ticker: <input name='ticker'><br>");
        out.println("Invested: <input name='invested' type='number' step='0.01'><br>");
        out.println("Current Value: <input name='currentValue' type='number' step='0.01'><br>");
        out.println("<button type='submit'>Add Asset</button></form>");
        out.println("</body></html>");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Asset a = new Asset();
        a.setUserId(1);
        a.setAssetName(req.getParameter("name"));
        a.setTickerSymbol(req.getParameter("ticker"));
        a.setCategoryId(1);
        a.setInvestedAmount(new BigDecimal(req.getParameter("invested")));
        a.setCurrentValue(new BigDecimal(req.getParameter("currentValue")));
        a.setPurchaseDate(new java.sql.Date(System.currentTimeMillis()));
        dao.addAsset(a);
        resp.sendRedirect("assets");
    }
}
```
📸 **Screenshot:** Servlet code + browser showing asset list and add form

### 📸 Screenshots to Capture for Practical 3
1. `web.xml` configuration
2. `AssetServlet.java` — doGet and doPost methods
3. Browser — Asset list table rendered
4. Browser — Add asset form + after submission

---

## Practical 4 — JSP replaces Servlet (View Layer)

**Objective:** Modify Practical 3 to use JSP instead of Servlet for rendering HTML.

### What You'll Build
Separate the **view (HTML)** into JSP files. The Servlet now only handles logic and forwards data to JSP.

### Step-by-Step

**Step 4.1 — Refactored AssetServlet.java (Controller only)**

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    String action = req.getParameter("action");

    if ("delete".equals(action)) {
        dao.deleteAsset(Integer.parseInt(req.getParameter("id")));
    }

    List<Asset> assets;
    if ("search".equals(action)) {
        assets = dao.searchAssets(req.getParameter("keyword"));
    } else {
        assets = dao.getAllAssets();
    }

    req.setAttribute("assets", assets);
    req.getRequestDispatcher("/assets.jsp").forward(req, resp);
}
```

**Step 4.2 — assets.jsp (View)**

```jsp
<%@ page import="java.util.List, com.wealthtrack.model.Asset" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>WealthTrack - Portfolio</title></head>
<body>
    <h1>WealthTrack - Asset Manager</h1>

    <form method="GET" action="assets">
        <input type="hidden" name="action" value="search">
        Search: <input type="text" name="keyword">
        <button type="submit">🔍 Search</button>
    </form>
    <hr>

    <table border="1" cellpadding="8">
        <tr><th>ID</th><th>Name</th><th>Ticker</th><th>Invested</th><th>Current</th><th>Actions</th></tr>
        <c:forEach var="asset" items="${assets}">
            <tr>
                <td>${asset.assetId}</td>
                <td>${asset.assetName}</td>
                <td>${asset.tickerSymbol}</td>
                <td>₹${asset.investedAmount}</td>
                <td>₹${asset.currentValue}</td>
                <td><a href="assets?action=delete&id=${asset.assetId}">Delete</a></td>
            </tr>
        </c:forEach>
    </table>

    <h3>Add New Asset</h3>
    <form method="POST" action="assets">
        Name: <input name="name"><br>
        Ticker: <input name="ticker"><br>
        Invested: <input name="invested" type="number" step="0.01"><br>
        Current Value: <input name="currentValue" type="number" step="0.01"><br>
        <button type="submit">Add Asset</button>
    </form>
</body>
</html>
```
📸 **Screenshot:** Refactored Servlet (no HTML) + JSP file + browser output

### 📸 Screenshots to Capture for Practical 4
1. Refactored `AssetServlet.java` — only logic, no HTML
2. `assets.jsp` using JSTL tags
3. Browser output — same look, now powered by JSP

---

## Practical 5 — JSF Framework (Replaces JSP)

**Objective:** Use JSF framework to replace JSP and calculate the reduction in programming.

### What You'll Build
Replace JSP pages with **JSF (JavaServer Faces)** using `xhtml` Facelets and Managed Beans.

### Step-by-Step

**Step 5.1 — Add JSF dependencies to `pom.xml`**

```xml
<dependency>
    <groupId>org.glassfish</groupId>
    <artifactId>javax.faces</artifactId>
    <version>2.3.9</version>
</dependency>
```

**Step 5.2 — Configure `faces-config.xml`**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<faces-config xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="2.3">
    <managed-bean>
        <managed-bean-name>assetBean</managed-bean-name>
        <managed-bean-class>com.wealthtrack.bean.AssetBean</managed-bean-class>
        <managed-bean-scope>session</managed-bean-scope>
    </managed-bean>
</faces-config>
```

**Step 5.3 — AssetBean.java (Managed Bean)**

```java
package com.wealthtrack.bean;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.model.Asset;
import javax.faces.bean.*;
import java.util.List;

@ManagedBean(name = "assetBean")
@SessionScoped
public class AssetBean {
    private Asset asset = new Asset();
    private String searchKeyword;
    private AssetDAO dao = new AssetDAO();

    public List<Asset> getAssets() { return dao.getAllAssets(); }

    public String addAsset() {
        asset.setUserId(1); asset.setCategoryId(1);
        asset.setPurchaseDate(new java.sql.Date(System.currentTimeMillis()));
        dao.addAsset(asset);
        asset = new Asset();
        return "assets?faces-redirect=true";
    }

    public String deleteAsset(int id) {
        dao.deleteAsset(id);
        return "assets?faces-redirect=true";
    }

    // Getters/Setters
    public Asset getAsset() { return asset; }
    public void setAsset(Asset asset) { this.asset = asset; }
    public String getSearchKeyword() { return searchKeyword; }
    public void setSearchKeyword(String k) { this.searchKeyword = k; }
}
```

**Step 5.4 — assets.xhtml (JSF Facelet)**

```xml
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="http://xmlns.jcp.org/jsf/html"
      xmlns:ui="http://xmlns.jcp.org/jsf/facelets"
      xmlns:f="http://xmlns.jcp.org/jsf/core">
<h:head><title>WealthTrack - JSF</title></h:head>
<h:body>
    <h1>Asset Manager (JSF)</h1>
    <h:dataTable value="#{assetBean.assets}" var="a" border="1">
        <h:column><f:facet name="header">Name</f:facet>#{a.assetName}</h:column>
        <h:column><f:facet name="header">Ticker</f:facet>#{a.tickerSymbol}</h:column>
        <h:column><f:facet name="header">Invested</f:facet>₹#{a.investedAmount}</h:column>
        <h:column><f:facet name="header">Current</f:facet>₹#{a.currentValue}</h:column>
        <h:column>
            <h:commandButton value="Delete" action="#{assetBean.deleteAsset(a.assetId)}" />
        </h:column>
    </h:dataTable>

    <h3>Add Asset</h3>
    <h:form>
        Name: <h:inputText value="#{assetBean.asset.assetName}" /><br/>
        Ticker: <h:inputText value="#{assetBean.asset.tickerSymbol}" /><br/>
        <h:commandButton value="Add" action="#{assetBean.addAsset}" />
    </h:form>
</h:body>
</html>
```

**Step 5.5 — Reduction Analysis**

| Metric | Servlet+JSP | JSF | Reduction |
|--------|-----------|-----|-----------|
| Lines of Code (View) | ~60 lines | ~30 lines | ~50% |
| Lines of Code (Controller) | ~80 lines | ~40 lines | ~50% |
| No. of Files | 3 (Servlet, JSP, web.xml) | 3 (Bean, XHTML, faces-config) | Same |
| HTML in Java Code | Yes (Servlet) | No | Eliminated |
| Form Binding | Manual (getParameter) | Automatic (EL) | Simplified |

📸 **Screenshot:** Code comparison + reduction table

### 📸 Screenshots to Capture for Practical 5
1. `faces-config.xml`
2. `AssetBean.java` managed bean
3. `assets.xhtml` JSF page
4. Browser output
5. Reduction comparison table

---

## Practical 6 — Custom JSP Tag for CRUD

**Objective:** Make a custom tag for a component that can add/view/delete/modify records.

### What You'll Build
A **custom JSP tag library** that provides `<wt:assetTable>` and `<wt:assetForm>` tags.

### Step-by-Step

**Step 6.1 — AssetTableTag.java (Tag Handler)**

```java
package com.wealthtrack.tags;

import com.wealthtrack.dao.AssetDAO;
import com.wealthtrack.model.Asset;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.util.List;

public class AssetTableTag extends SimpleTagSupport {
    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        AssetDAO dao = new AssetDAO();
        List<Asset> assets = dao.getAllAssets();

        out.println("<table border='1' cellpadding='8'>");
        out.println("<tr><th>ID</th><th>Name</th><th>Ticker</th><th>Invested</th><th>Current</th><th>Actions</th></tr>");
        for (Asset a : assets) {
            out.printf("<tr><td>%d</td><td>%s</td><td>%s</td><td>₹%s</td><td>₹%s</td>",
                a.getAssetId(), a.getAssetName(), a.getTickerSymbol(),
                a.getInvestedAmount(), a.getCurrentValue());
            out.printf("<td><a href='assets?action=delete&id=%d'>Delete</a> | ", a.getAssetId());
            out.printf("<a href='assets?action=edit&id=%d'>Edit</a></td></tr>", a.getAssetId());
        }
        out.println("</table>");
    }
}
```

**Step 6.2 — wealthtrack.tld (Tag Library Descriptor)**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<taglib xmlns="http://java.sun.com/xml/ns/javaee" version="2.1">
    <tlib-version>1.0</tlib-version>
    <short-name>wt</short-name>
    <uri>http://wealthtrack.com/tags</uri>

    <tag>
        <name>assetTable</name>
        <tag-class>com.wealthtrack.tags.AssetTableTag</tag-class>
        <body-content>empty</body-content>
    </tag>
</taglib>
```

**Step 6.3 — Using the Custom Tag in JSP**

```jsp
<%@ taglib prefix="wt" uri="http://wealthtrack.com/tags" %>
<html>
<body>
    <h1>WealthTrack - Custom Tag Demo</h1>
    <wt:assetTable />   <!-- One line renders entire CRUD table! -->
</body>
</html>
```

### 📸 Screenshots to Capture for Practical 6
1. `AssetTableTag.java` tag handler
2. `wealthtrack.tld` descriptor
3. JSP using `<wt:assetTable />` custom tag
4. Browser output showing rendered table

---

## Practical 7 — Hibernate ORM for 1 Table

**Objective:** Use Object Relational Mapping with Hibernate for 1 table, replace SQL with HQL.

### What You'll Build
Map the `assets` table using Hibernate annotations + XML mapping file. Replace raw SQL with HQL queries.

### Step-by-Step

**Step 7.1 — Add Hibernate dependencies**

```xml
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>5.6.15.Final</version>
</dependency>
```

**Step 7.2 — hibernate.cfg.xml**

```xml
<hibernate-configuration>
  <session-factory>
    <property name="hibernate.connection.driver_class">org.postgresql.Driver</property>
    <property name="hibernate.connection.url">jdbc:postgresql://localhost:5432/wealthtrack_db</property>
    <property name="hibernate.connection.username">postgres</property>
    <property name="hibernate.connection.password">your_password</property>
    <property name="hibernate.dialect">org.hibernate.dialect.PostgreSQLDialect</property>
    <property name="hibernate.show_sql">true</property>
    <property name="hibernate.hbm2ddl.auto">update</property>
    <mapping class="com.wealthtrack.model.Asset"/>
  </session-factory>
</hibernate-configuration>
```

**Step 7.3 — Asset.java with Hibernate Annotations**

```java
package com.wealthtrack.model;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Date;

@Entity
@Table(name = "assets")
public class Asset {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "asset_id")
    private int assetId;

    @Column(name = "asset_name")
    private String assetName;

    @Column(name = "ticker_symbol")
    private String tickerSymbol;

    @Column(name = "invested_amount")
    private BigDecimal investedAmount;

    @Column(name = "current_value")
    private BigDecimal currentValue;

    // ... getters/setters
}
```

**Step 7.4 — AssetHibernateDAO.java (HQL instead of SQL)**

```java
package com.wealthtrack.dao;

import com.wealthtrack.model.Asset;
import org.hibernate.*;
import org.hibernate.cfg.Configuration;
import java.util.List;

public class AssetHibernateDAO {
    private SessionFactory factory = new Configuration().configure().buildSessionFactory();

    public List<Asset> getAllAssets() {
        Session session = factory.openSession();
        List<Asset> list = session.createQuery("FROM Asset", Asset.class).list();
        session.close();
        return list;
    }

    public void addAsset(Asset asset) {
        Session session = factory.openSession();
        Transaction tx = session.beginTransaction();
        session.save(asset);
        tx.commit();
        session.close();
    }

    public Asset getById(int id) {
        Session session = factory.openSession();
        Asset a = session.get(Asset.class, id);
        session.close();
        return a;
    }

    public void updateAsset(Asset asset) {
        Session session = factory.openSession();
        Transaction tx = session.beginTransaction();
        session.update(asset);
        tx.commit();
        session.close();
    }

    public void deleteAsset(int id) {
        Session session = factory.openSession();
        Transaction tx = session.beginTransaction();
        session.createQuery("DELETE FROM Asset WHERE assetId = :id")
               .setParameter("id", id).executeUpdate();
        tx.commit();
        session.close();
    }

    public List<Asset> searchAssets(String keyword) {
        Session session = factory.openSession();
        List<Asset> list = session.createQuery(
            "FROM Asset WHERE assetName LIKE :kw", Asset.class)
            .setParameter("kw", "%" + keyword + "%").list();
        session.close();
        return list;
    }
}
```

**Step 7.5 — Comparison: SQL vs HQL**

| Aspect | JDBC (SQL) | Hibernate (HQL) |
|--------|-----------|-----------------|
| Query Language | Raw SQL (`SELECT * FROM assets`) | HQL (`FROM Asset`) |
| Result Mapping | Manual `ResultSet` → Java Object | Automatic via annotations |
| Connection Mgmt | Manual open/close | Session managed |
| Code Lines (DAO) | ~120 lines | ~60 lines |

### 📸 Screenshots to Capture for Practical 7
1. `hibernate.cfg.xml`
2. `Asset.java` with `@Entity` annotations
3. `AssetHibernateDAO.java` with HQL queries
4. Console SQL output (`show_sql=true`)
5. SQL vs HQL comparison table

---

## Practical 8 — Hibernate for Entire Application

**Objective:** Use Hibernate framework to replace all JDBC calls and calculate reduction.

### What You'll Build
Replace ALL DAO classes (User, Asset, Transaction, Document) with Hibernate-based DAOs.

### Step-by-Step

**Step 8.1 — Add Hibernate annotations to ALL model classes** (User, Transaction, Document — same pattern as Asset in Practical 7)

**Step 8.2 — Create `HibernateUtil.java` (Session Factory Singleton)**

```java
package com.wealthtrack.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    private static final SessionFactory sessionFactory;
    static {
        sessionFactory = new Configuration().configure().buildSessionFactory();
    }
    public static SessionFactory getSessionFactory() { return sessionFactory; }
}
```

**Step 8.3 — Replace ALL DAOs with Hibernate versions** — UserHibernateDAO, TransactionHibernateDAO, etc.

**Step 8.4 — Reduction Analysis**

| Metric | JDBC (All DAOs) | Hibernate (All DAOs) | Reduction |
|--------|----------------|---------------------|-----------|
| Total DAO Lines | ~500 lines | ~200 lines | ~60% |
| SQL Queries Written | ~25 queries | 0 (HQL only) | 100% |
| ResultSet Mapping Code | ~100 lines | 0 (auto-mapped) | 100% |
| Connection Management | Manual everywhere | SessionFactory | Centralized |

### 📸 Screenshots to Capture for Practical 8
1. `HibernateUtil.java`
2. All annotated model classes
3. All Hibernate DAO classes
4. Working application with Hibernate
5. Reduction comparison table

---

## Practical 9 — Spring MVC Architecture

**Objective:** Use Spring MVC architecture and implement multi-tier architecture.

### What You'll Build
Refactor the entire app to use **Spring MVC** with proper layers: Controller → Service → DAO (Repository).

### Step-by-Step

**Step 9.1 — Add Spring dependencies**

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.3.30</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-orm</artifactId>
    <version>5.3.30</version>
</dependency>
```

**Step 9.2 — Spring Configuration (`dispatcher-servlet.xml`)**

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc">

    <context:component-scan base-package="com.wealthtrack"/>
    <mvc:annotation-driven/>

    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/views/"/>
        <property name="suffix" value=".jsp"/>
    </bean>

    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="org.postgresql.Driver"/>
        <property name="url" value="jdbc:postgresql://localhost:5432/wealthtrack_db"/>
        <property name="username" value="postgres"/>
        <property name="password" value="your_password"/>
    </bean>

    <bean id="sessionFactory" class="org.springframework.orm.hibernate5.LocalSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        <property name="packagesToScan" value="com.wealthtrack.model"/>
    </bean>
</beans>
```

**Step 9.3 — Multi-Tier Architecture**

```
┌─────────────────────────────────────────────────┐
│  Presentation Tier (JSP Views)                   │
├─────────────────────────────────────────────────┤
│  Controller Tier (@Controller - Spring MVC)      │
├─────────────────────────────────────────────────┤
│  Service Tier (@Service - Business Logic)        │
├─────────────────────────────────────────────────┤
│  DAO/Repository Tier (@Repository - Hibernate)   │
├─────────────────────────────────────────────────┤
│  Database Tier (PostgreSQL)                      │
└─────────────────────────────────────────────────┘
```

**Step 9.4 — AssetController.java**

```java
@Controller
@RequestMapping("/assets")
public class AssetController {
    @Autowired
    private AssetService assetService;

    @GetMapping
    public String listAssets(Model model) {
        model.addAttribute("assets", assetService.getAllAssets());
        return "assets";
    }

    @PostMapping("/add")
    public String addAsset(@ModelAttribute Asset asset) {
        assetService.addAsset(asset);
        return "redirect:/assets";
    }

    @GetMapping("/delete/{id}")
    public String deleteAsset(@PathVariable int id) {
        assetService.deleteAsset(id);
        return "redirect:/assets";
    }
}
```

**Step 9.5 — AssetService.java**

```java
@Service
public class AssetService {
    @Autowired
    private AssetDAO assetDAO;

    public List<Asset> getAllAssets() { return assetDAO.getAllAssets(); }
    public void addAsset(Asset a) { assetDAO.addAsset(a); }
    public void deleteAsset(int id) { assetDAO.deleteAsset(id); }
}
```

**Step 9.6 — AssetDAO.java (Repository)**

```java
@Repository
public class AssetDAO {
    @Autowired
    private SessionFactory sessionFactory;

    public List<Asset> getAllAssets() {
        return sessionFactory.getCurrentSession()
            .createQuery("FROM Asset", Asset.class).list();
    }
    // ... other CRUD methods using Hibernate
}
```

### 📸 Screenshots to Capture for Practical 9
1. Spring configuration XML
2. `AssetController.java` with `@Controller`
3. `AssetService.java` with `@Service`
4. `AssetDAO.java` with `@Repository`
5. Multi-tier architecture diagram
6. Working application in browser

---

## Practical 10 — JSF vs Spring Comparison

**Objective:** Compare and analyze JSF with the Spring framework.

### What You'll Build
A **comparison analysis document** with side-by-side code examples and metrics.

### Comparison Table

| Criteria | JSF | Spring MVC |
|----------|-----|------------|
| **Architecture** | Component-based MVC | Request-based MVC |
| **View Technology** | Facelets (XHTML) | JSP / Thymeleaf |
| **Controller** | Managed Beans (`@ManagedBean`) | Controllers (`@Controller`) |
| **Data Binding** | EL expressions `#{bean.prop}` | Model attributes `${attr}` |
| **Navigation** | `faces-config.xml` rules | `@RequestMapping` annotations |
| **Form Handling** | `<h:form>`, `<h:inputText>` | `<form:form>`, `<form:input>` |
| **CRUD Code Lines** | ~100 lines (Bean + XHTML) | ~120 lines (Controller + Service + JSP) |
| **Learning Curve** | Moderate | Steeper but more flexible |
| **Scalability** | Limited | Highly scalable |
| **Industry Usage** | Declining | Dominant (Spring Boot) |
| **Dependency Injection** | CDI (`@Inject`) | Spring DI (`@Autowired`) |
| **Testability** | Harder to unit test | Easy (Mockito, JUnit) |
| **REST API Support** | Limited | Native (`@RestController`) |
| **Community** | Smaller | Very large & active |

### Code Comparison

```
JSF Bean:                           Spring Controller:
@ManagedBean                        @Controller
@SessionScoped                      @RequestMapping("/assets")
public class AssetBean {            public class AssetController {
  private AssetDAO dao;               @Autowired AssetService service;
  public List<Asset> getAssets()      @GetMapping
    { return dao.getAll(); }          public String list(Model m)
  public String add()                   { m.addAttribute("assets",
    { dao.add(asset);                       service.getAll());
      return "assets"; }                return "assets"; }
}                                   }
```

### Conclusion

| Winner By Category | Framework |
|-------------------|-----------|
| Ease of Use (Small Apps) | JSF ✅ |
| Flexibility & Control | Spring ✅ |
| Enterprise / Large Apps | Spring ✅ |
| REST API Development | Spring ✅ |
| Industry Demand | Spring ✅ |
| Overall Recommendation | **Spring MVC** ✅ |

### 📸 Screenshots to Capture for Practical 10
1. JSF code (Bean + XHTML) side by side
2. Spring code (Controller + Service + JSP) side by side
3. Comparison tables
4. Both apps running in browser (side-by-side screenshots)

---

## 📋 Complete Practical Summary

| Practical | Topic | What Gets Built | Builds On |
|-----------|-------|-----------------|-----------|
| 1 | JDBC + PostgreSQL | Console CRUD app | — |
| 2 | Client-Server Sockets | Network search feature | Practical 1 |
| 3 | Servlets | Web-based CRUD | Practical 1 |
| 4 | JSP | Separate View layer | Practical 3 |
| 5 | JSF | Component-based UI | Practical 4 |
| 6 | Custom Tags | Reusable CRUD tag | Practical 4 |
| 7 | Hibernate (1 table) | ORM for Assets table | Practical 1 |
| 8 | Hibernate (full app) | ORM for all tables | Practical 7 |
| 9 | Spring MVC | Multi-tier architecture | Practical 8 |
| 10 | JSF vs Spring | Comparison analysis | Practical 5+9 |

> **End Result:** A fully working **WealthTrack Asset Tracker** CRUD website built with Spring MVC + Hibernate + PostgreSQL, with documented evolution from console app to enterprise architecture.
