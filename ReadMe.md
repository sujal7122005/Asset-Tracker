# 🏦 WealthTrack — Asset Management & Portfolio Tracking System

A full-stack web-based **Asset Management & Portfolio Tracking System** built using Java technologies as part of the **Advanced Java Programming** course group project. WealthTrack enables users to manage, monitor, and analyze their financial assets — including Equities, ETFs, Crypto, Real Estate, Cash, and Liabilities — all from a unified dashboard.

---

## 📸 Screenshots

| Login Page | Dashboard |
|:---:|:---:|
| Clean centered login card with social auth | Net worth overview, category cards, charts |

| Portfolio Holdings | Asset Detail |
|:---:|:---:|
| Searchable asset table with P&L tracking | Performance chart, statistics, transactions |

| Add New Asset | Settings |
|:---:|:---:|
| 3-step wizard (Type → Details → Confirm) | Profile, password, and account management |

---

## ✨ Features

### 🔐 Authentication
- User Registration & Login with BCrypt password hashing
- Forgot Password flow
- "Remember this device" session persistence
- Client-side & server-side input validation
- Session-based authentication with auto-logout on timeout

### 📊 Dashboard
- Total Net Worth headline display
- Asset category summary cards (Cash, Equities, Real Estate, Crypto)
- Portfolio Performance chart (Chart.js) with period filters (1M, 6M, 1Y, ALL)
- Recent Activity feed (Dividends, Transfers, Purchases, Sales)
- Quick "Add Asset" button

### 💼 Portfolio Holdings
- Summary cards: Net Worth, Investments, Liquid Cash, Liabilities
- Tab-based filtering: All Assets, Investments, Liabilities, Cash
- Sortable data table with Asset Name, Category, Invested, Current Value, P&L, Allocation
- Real-time search/filter functionality
- Pagination support
- Color-coded category badges and allocation progress bars

### ➕ Add New Asset (Multi-Step Wizard)
- **Step 1** — Select asset category (Stocks, Crypto, Real Estate, Cash, Bonds, ETF)
- **Step 2** — Enter details (Ticker, Name, Quantity, Cost Basis, Date, Commission)
- **Step 3** — Review & confirm before submission

### 📈 Asset Detail Page
- Live price display with change indicators
- Interactive performance chart with period toggles (1D, 1W, 1M, YTD, 1Y, ALL)
- Key Statistics panel (Day's Range, 52-Week Range, Market Cap, P/E Ratio, Div Yield, Beta)
- Your Position card (Shares Owned, Avg Cost, Total Return)
- Transaction History table (Buy/Sell/Dividend with color-coded badges)
- Document Vault (attach/view trade confirmations, statements)

### 📁 Document Management
- Upload PDF/image files linked to specific assets
- View document list with file name, size, upload date
- Download documents

### ⚙️ Settings
- Profile management (name, email, phone, profile picture)
- Change password with current password verification
- Currency preference & notification settings
- Account deletion with confirmation

### 🛡️ Security
- BCrypt password hashing
- SQL injection prevention (PreparedStatements everywhere)
- Session-based authentication with AuthFilter on protected routes
- Custom error pages (404, 500)

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Java (JDK 8+) |
| **Database** | MySQL 8.0 |
| **Database Connectivity** | JDBC with PreparedStatements |
| **Frontend Views** | JSP (JavaServer Pages) + JSTL |
| **Styling** | CSS3 + JavaScript |
| **Charts** | Chart.js |
| **Icons** | Font Awesome 6 |
| **Typography** | Google Fonts (Inter) |
| **Backend Controllers** | Servlets (Annotation-based) |
| **Server** | Apache Tomcat 9+ |
| **Build Tool** | Maven |
| **Architecture** | MVC (Model-View-Controller) |

---

## 📂 Project Structure

```
Asset-Tracker/
├── pom.xml                                    # Maven configuration
├── sql/
│   ├── schema.sql                             # Database schema (7 tables)
│   └── seed-data.sql                          # Sample data for testing
├── src/
│   └── main/
│       ├── java/com/wealthtrack/
│       │   ├── model/                         # Java Bean / POJO classes
│       │   │   ├── User.java
│       │   │   ├── Asset.java
│       │   │   ├── Transaction.java
│       │   │   ├── Document.java
│       │   │   ├── PortfolioSummary.java
│       │   │   └── ActivityLog.java
│       │   ├── dao/                           # Data Access Objects (JDBC)
│       │   │   ├── UserDAO.java
│       │   │   ├── AssetDAO.java
│       │   │   ├── TransactionDAO.java
│       │   │   ├── DocumentDAO.java
│       │   │   ├── PortfolioDAO.java
│       │   │   └── ActivityLogDAO.java
│       │   ├── controller/                    # Servlet Controllers
│       │   │   ├── LoginServlet.java
│       │   │   ├── RegisterServlet.java
│       │   │   ├── LogoutServlet.java
│       │   │   ├── DashboardServlet.java
│       │   │   ├── PortfolioServlet.java
│       │   │   ├── AddAssetServlet.java
│       │   │   ├── AssetDetailServlet.java
│       │   │   ├── TransactionServlet.java
│       │   │   ├── DocumentServlet.java
│       │   │   └── SettingsServlet.java
│       │   ├── filter/
│       │   │   └── AuthFilter.java            # Authentication filter
│       │   └── util/
│       │       └── DBConnection.java          # DB connection utility
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml                    # Deployment descriptor
│           ├── css/
│           │   └── style.css                  # Complete CSS design system
│           ├── js/
│           │   └── app.js                     # Chart.js, validation, animations
│           ├── includes/
│           │   ├── sidebar.jsp                # Reusable sidebar navigation
│           │   └── header.jsp                 # Reusable top header bar
│           ├── login.jsp                      # Login page
│           ├── register.jsp                   # Registration page
│           ├── forgot-password.jsp            # Password reset page
│           ├── dashboard.jsp                  # Dashboard overview
│           ├── portfolio.jsp                  # Portfolio holdings table
│           ├── add-asset.jsp                  # Add asset wizard
│           ├── asset-detail.jsp               # Individual asset detail
│           ├── transactions.jsp               # Transaction history
│           ├── documents.jsp                  # Document management
│           ├── settings.jsp                   # Account settings
│           ├── error-404.jsp                  # Custom 404 page
│           └── error-500.jsp                  # Custom 500 page
├── Reference_Photos/                          # UI reference screenshots
├── Project_Requirement_Document.md
├── Development_Roadmap.md
└── ReadMe.md
```

---

## 🚀 How to Run the Project

### Prerequisites

Make sure you have the following installed on your system:

| Software | Version | Download Link |
|----------|---------|---------------|
| **JDK** | 8 or higher | [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://adoptium.net/) |
| **MySQL** | 8.0+ | [MySQL Downloads](https://dev.mysql.com/downloads/installer/) |
| **Apache Tomcat** | 9.0+ | [Tomcat Downloads](https://tomcat.apache.org/download-90.cgi) |
| **Maven** | 3.6+ | [Maven Downloads](https://maven.apache.org/download.cgi) |

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/Asset-Tracker.git
cd Asset-Tracker
```

### Step 2: Set Up the Database

1. Open MySQL command line or MySQL Workbench
2. Run the schema file to create the database and tables:

```sql
source sql/schema.sql;
```

3. Load the sample/seed data for testing:

```sql
source sql/seed-data.sql;
```

> This creates the `wealthtrack_db` database with 7 tables and populates it with a sample user and 14 assets.

### Step 3: Configure Database Connection

Open `src/main/java/com/wealthtrack/util/DBConnection.java` and update the connection details to match your MySQL setup:

```java
private static final String URL = "jdbc:mysql://localhost:3306/wealthtrack_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String USER = "root";         // ← Your MySQL username
private static final String PASSWORD = "root";      // ← Your MySQL password
```

### Step 4: Build the Project with Maven

```bash
mvn clean package
```

This will:
- Download all dependencies (Servlet API, JSTL, MySQL Connector, BCrypt, Chart.js, etc.)
- Compile the Java source files
- Package everything into `target/wealthtrack.war`

### Step 5: Deploy to Apache Tomcat

**Option A — Manual Deployment:**
1. Copy `target/wealthtrack.war` to Tomcat's `webapps/` directory
2. Start Tomcat:
   ```bash
   # Windows
   %CATALINA_HOME%\bin\startup.bat

   # Linux/Mac
   $CATALINA_HOME/bin/startup.sh
   ```

**Option B — Deploy via Tomcat Manager:**
1. Open `http://localhost:8080/manager/html`
2. Upload the `wealthtrack.war` file using the "WAR file to deploy" section

**Option C — Run from IDE (Eclipse/IntelliJ):**
1. Import as a Maven project
2. Configure Tomcat server in your IDE
3. Right-click project → Run on Server

### Step 6: Access the Application

Open your browser and navigate to:

```
http://localhost:8080/wealthtrack/login
```

### Step 7: Login with Test Credentials

| Field | Value |
|-------|-------|
| **Email** | `alex@wealthtrack.com` |
| **Password** | `Test@1234` |

> You can also create a new account using the **Sign up** link on the login page.

---

## 📋 URL Routes

| # | Page | URL Pattern |
|---|------|-------------|
| 1 | Login | `/login` |
| 2 | Registration | `/register` |
| 3 | Forgot Password | `/forgot-password.jsp` |
| 4 | Dashboard | `/dashboard` |
| 5 | Portfolio Holdings | `/portfolio` |
| 6 | Add New Asset | `/asset/add` |
| 7 | Asset Detail | `/asset/detail?id={id}` |
| 8 | Transactions | `/transactions` |
| 9 | Documents | `/documents` |
| 10 | Settings | `/settings` |
| 11 | Logout | `/logout` |

---

## 🗄️ Database Schema

The application uses **7 tables** in the `wealthtrack_db` database:

| Table | Purpose |
|-------|---------|
| `users` | Registered user details |
| `asset_categories` | Lookup table for asset types (Equities, ETF, Crypto, Real Estate, Cash, Bonds) |
| `assets` | Individual assets per user |
| `transactions` | Buy/Sell/Dividend transaction records |
| `portfolio_summary` | Cached summary data per user |
| `documents` | Uploaded file metadata |
| `activity_log` | Audit trail of user actions |

---

## 🧑‍💻 Team

| Name | Role |
|------|------|
| Sujal | Developer |

---

## 📝 Project Status

✅ **Phase 1** — Database Schema Design (MySQL) — Complete  
✅ **Phase 2** — JDBC Data Access Layer — Complete  
✅ **Phase 3** — JSP Frontend Views — Complete  
✅ **Phase 4** — Servlets (Controllers & Business Logic) — Complete  
🔲 **Phase 5** — Spring Framework Refactoring — Planned  
🔲 **Phase 6** — Integration Testing & Final Polish — Planned  

---

## 📄 License

This project is open source and available for educational purposes.

---

> **Note:** This project is built as part of an Advanced Java Programming course. Refer to [Project_Requirement_Document.md](Project_Requirement_Document.md) and [Development_Roadmap.md](Development_Roadmap.md) for detailed requirements and roadmap.
