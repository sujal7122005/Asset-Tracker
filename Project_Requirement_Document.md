# 📋 Project Requirement Document (PRD)
## WealthTrack — Asset Management / Asset Tracker System
### Advanced Java Programming — Group Project

---

## 1. Project Overview

**WealthTrack** is a full-stack web-based Asset Management & Portfolio Tracking System built using **Java technologies** (JDBC, JSP, Servlets, Spring Framework). It enables users to manage, monitor, and analyze their financial assets — including Equities, ETFs, Crypto, Real Estate, Cash, and Liabilities — all from a unified dashboard.

**Technology Stack:** Java (JDBC → JSP → Servlets → Spring Framework)  
**Database:** MySQL  
**Frontend:** JSP + HTML/CSS/JavaScript (with Chart.js for graphs)  
**Server:** Apache Tomcat

---

## 2. User Roles

| Role | Description |
|------|-------------|
| **Guest** | Can view the login/signup page only |
| **Registered User** | Full access to Dashboard, Portfolio, Asset Management, Documents, Settings |
| **Admin** *(optional)* | Can manage all users, view system-wide analytics |

---

## 3. Module-wise Feature Breakdown

### 3.1 🔐 Authentication Module (Login / Signup)

| Feature | Description |
|---------|-------------|
| **User Registration** | Sign up with Name, Email/Phone, Password |
| **User Login** | Login via Email/Phone and Password |
| **Forgot Password** | Password reset flow via email |
| **Remember Me** | "Remember this device" checkbox for session persistence |
| **Input Validation** | Client-side and server-side validation on all form fields |
| **Password Security** | Passwords stored as hashed values (SHA-256 / BCrypt) |
| **Session Management** | HttpSession-based login tracking, auto-logout on timeout |

> **UI Reference:** Clean centered login card with email, password fields, "Forgot Password?" link, "Secure Login" button, and "Sign up" link.

---

### 3.2 📊 Dashboard Module (Overview Page)

| Feature | Description |
|---------|-------------|
| **Total Net Worth** | Large headline showing sum of all assets minus liabilities |
| **Asset Category Cards** | Summary cards for Cash & Equivalents, Equities, Real Estate, Crypto & Gold — each showing value and % change |
| **Portfolio Performance Chart** | Line/area chart showing portfolio value over time with period filters (1M, 6M, 1Y, ALL) |
| **Recent Activity Feed** | List of latest transactions — Dividend Payouts, Asset Rebalancing, Wire Transfers, Purchases, Sales |
| **Sidebar Navigation** | Links to Dashboard, Portfolio, Documents, Settings |
| **Notification Bell** | Icon indicator for new alerts/events |
| **Quick Add Asset** | "+ Add Asset" button accessible from the dashboard |

---

### 3.3 💼 Portfolio Holdings Module

| Feature | Description |
|---------|-------------|
| **Summary Cards** | Total Net Worth, Total Investments, Liquid Cash, Liabilities — each with trend indicator |
| **Tab-based Filtering** | Tabs: All Assets, Investments, Liabilities, Cash — each showing count badge |
| **Asset Table** | Columns: Asset Name (with ticker + icon), Category (color-coded badge), Invested Amount, Current Value, P&L (profit/loss with %), % Allocation (with progress bar) |
| **Search** | "Search holdings…" search bar to filter assets by name/ticker |
| **Pagination** | Paginated results (e.g., Showing 1 to 5 of 14 results) |
| **Sort & Filter** | Sort by any column (Name, Category, Value, P&L, Allocation) |
| **Actions Menu** | Three-dot menu per asset row (Edit, Delete, View Details) |
| **Add Asset Button** | Navigate to the "Add New Asset" wizard |

---

### 3.4 ➕ Add New Asset Module (Multi-Step Wizard)

| Step | Feature | Description |
|------|---------|-------------|
| **Step 1 — Type** | Asset Category Selection | Choose from: Stocks & ETFs, Crypto, Real Estate, Cash, Bonds, etc. |
| **Step 2 — Details** | Asset Identification | Ticker Symbol / Asset Name search field with current price display |
| | Transaction Details | Quantity (Shares), Cost Basis (Per Share), Purchase Date (date picker), Commission / Fees |
| **Step 3 — Confirm** | Review & Submit | Review all entered details before final submission |
| | Navigation | Back / Continue buttons, step indicator (Step 1/2/3) |
| | Change Category | "Change" link to go back and reselect category |

---

### 3.5 📈 Asset Detail Page

| Feature | Description |
|---------|-------------|
| **Asset Header** | Asset name (e.g., Apple Inc.), exchange/ticker (NASDAQ: AAPL), asset type (Equity) |
| **Live Price Display** | Current price, absolute change, % change, last updated timestamp, "Refresh Value" button |
| **Performance Chart** | Interactive line chart with period toggles: 1D, 1W, 1M, YTD, 1Y, ALL |
| **Key Statistics Panel** | Day's Range (with slider), 52 Week Range (with slider), Market Cap, P/E Ratio, Dividend Yield, Beta |
| **Your Position Card** | Shares Owned, Avg Cost, Total Return (absolute + %) |
| **Transaction History Table** | Columns: Date, Type (Buy/Sell/Dividend — color-coded badges), Qty, Price, Net Amount, Status (✅ icon) |
| **Document Vault** | Attach/view related documents (Trade Confirmations, Dividend Statements) with file name, size, date, and download button |
| **View All** | Links to see full transaction history and all documents |

---

### 3.6 📁 Document Management Module

| Feature | Description |
|---------|-------------|
| **Upload Documents** | Upload PDF/image files linked to specific assets |
| **Document List** | Display file name, size (KB), upload date |
| **Download** | Download button per document |
| **View All Documents** | Dedicated page for browsing all uploaded documents |

---

### 3.7 ⚙️ Settings Module

| Feature | Description |
|---------|-------------|
| **Profile Management** | Update name, email, phone number, profile picture |
| **Change Password** | Old password + new password + confirm password |
| **Account Preferences** | Currency preference, notification settings |
| **Delete Account** | Option to permanently delete account with confirmation |

---

## 4. Non-Functional Requirements

| Requirement | Description |
|-------------|-------------|
| **Responsive Design** | Website should work on desktop and tablet screens |
| **Security** | Password hashing, SQL injection prevention (PreparedStatements), XSS protection |
| **Performance** | Queries should execute < 2 seconds; use connection pooling |
| **Code Architecture** | MVC pattern — Model (Java Beans), View (JSP), Controller (Servlets/Spring Controllers) |
| **Database** | MySQL with normalized schema (3NF minimum) |
| **Session Handling** | Server-side session management with timeout |
| **Error Handling** | Custom error pages (404, 500), user-friendly error messages |
| **Logging** | Server-side logging for debugging (using `java.util.logging` or Log4j) |

---

## 5. Database Entities (High-Level)

| Entity | Key Fields |
|--------|------------|
| **User** | user_id, name, email, phone, password_hash, created_at |
| **Asset** | asset_id, user_id (FK), name, ticker_symbol, category, current_price |
| **Transaction** | txn_id, asset_id (FK), user_id (FK), type (Buy/Sell/Dividend), qty, price, date, commission, status |
| **Portfolio Summary** | user_id, total_net_worth, total_investments, liquid_cash, liabilities |
| **Document** | doc_id, asset_id (FK), user_id (FK), file_name, file_path, file_size, upload_date |
| **Activity Log** | log_id, user_id (FK), action_type, description, timestamp |

---

## 6. Pages / Screens Summary

| # | Page | URL Pattern |
|---|------|-------------|
| 1 | Login Page | `/login` |
| 2 | Registration Page | `/register` |
| 3 | Forgot Password | `/forgot-password` |
| 4 | Dashboard (Overview) | `/dashboard` |
| 5 | Portfolio Holdings | `/portfolio` |
| 6 | Add New Asset (Wizard) | `/asset/add` |
| 7 | Asset Detail Page | `/asset/{id}` |
| 8 | Transaction History | `/transactions` |
| 9 | Documents Page | `/documents` |
| 10 | Settings / Profile | `/settings` |

---

## 7. Technology Summary

| Layer | Technology |
|-------|-----------|
| **Language** | Java (JDK 8+) |
| **Database** | MySQL 8.0 |
| **Database Connectivity** | JDBC (initially) → Spring JDBC Template (later phase) |
| **Frontend Views** | JSP (JavaServer Pages) + JSTL |
| **Styling** | CSS3 + JavaScript (Chart.js for graphs) |
| **Backend Controllers** | Servlets (initially) → Spring MVC Controllers (later phase) |
| **Server** | Apache Tomcat 9+ |
| **Build Tool** | Maven |
| **Architecture** | MVC (Model-View-Controller) |

---

> **Note:** This document is a living document. Features may be added, modified, or removed based on team discussion and course requirements.
