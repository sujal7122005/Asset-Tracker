# 🗺️ Development Roadmap
## WealthTrack — Asset Tracker System
### Step-by-Step Build Plan (Advanced Java Programming Course)

---

## Phase Overview

```
Phase 1: Database Schema Design (PostgreSQL)
    ↓
Phase 2: JDBC — Data Access Layer
    ↓
Phase 3: Servlets — Web-based Controller
    ↓
Phase 4: JSP — Frontend Views
    ↓
Phase 5: JSF Framework
    ↓
Phase 6: Custom Tags + Hibernate ORM
    ↓
Phase 7: Spring MVC — Multi-tier Architecture
    ↓
Phase 8: Integration, Testing & Final Polish
```

---

## 📌 Phase 1 — Database Schema Design (PostgreSQL)
**Duration:** ~2–3 days  
**Goal:** Design and create the complete PostgreSQL database schema.

### Tasks
- [ ] Install and configure PostgreSQL Server
- [ ] Create the database: `wealthtrack_db`
- [ ] Create the following tables:

| Table | Purpose |
|-------|---------|
| `users` | Store registered user details (user_id SERIAL, name, email, phone, password_hash, created_at) |
| `asset_categories` | Lookup table for asset types (Equities, ETF, Crypto, Real Estate, Cash, Bonds) |
| `assets` | Store individual assets per user (id, user_id FK, name, ticker_symbol, category_id FK, current_price, added_date) |
| `transactions` | Record buy/sell/dividend transactions (id, asset_id FK, user_id FK, type, quantity, price_per_unit, total_amount, commission, transaction_date, status) |
| `portfolio_summary` | Cached summary data per user (total_net_worth, total_investments, liquid_cash, liabilities) |
| `documents` | File metadata for uploaded documents (id, asset_id FK, user_id FK, file_name, file_path, file_size, upload_date) |
| `activity_log` | Audit trail of user actions (id, user_id FK, action_type, description, timestamp) |

- [ ] Define Primary Keys, Foreign Keys, Indexes, and Constraints
- [ ] Insert sample/seed data for testing
- [ ] Write and test core SQL queries (SELECT, INSERT, UPDATE, DELETE, JOINs)

### Deliverables
✅ Complete `.sql` schema file  
✅ ER Diagram  
✅ Sample data inserts  
✅ Tested queries document

---

## 📌 Phase 2 — JDBC (Data Access Layer)
**Duration:** ~3–4 days  
**Goal:** Build Java classes to interact with MySQL using JDBC.

### Tasks
- [ ] Set up Java project structure (Maven-based)
- [ ] Add PostgreSQL JDBC driver dependency (`postgresql`)
- [ ] Create `DBConnection.java` — Database connection utility class using `DriverManager` / Connection Pooling
- [ ] Create **Model/Bean classes** (POJOs):
  - `User.java`
  - `Asset.java`
  - `Transaction.java`
  - `Document.java`
  - `PortfolioSummary.java`
  - `ActivityLog.java`
- [ ] Create **DAO (Data Access Object) classes**:
  - `UserDAO.java` — register, login, getById, updateProfile, deleteUser
  - `AssetDAO.java` — addAsset, getAssetsByUser, getAssetById, updateAsset, deleteAsset
  - `TransactionDAO.java` — addTransaction, getTransactionsByAsset, getTransactionsByUser
  - `DocumentDAO.java` — uploadDoc, getDocsByAsset, deleteDoc
  - `PortfolioDAO.java` — getSummary, updateSummary, calculateNetWorth
  - `ActivityLogDAO.java` — logActivity, getRecentActivity
- [ ] Use **PreparedStatements** everywhere (SQL injection prevention)
- [ ] Write a simple test class to verify all CRUD operations

### Deliverables
✅ `DBConnection.java` utility  
✅ All Model/Bean classes  
✅ All DAO classes with CRUD methods  
✅ Tested JDBC operations via console output

---

## 📌 Phase 3 — JSP (Frontend Views)
**Duration:** ~4–5 days  
**Goal:** Build all the UI pages using JSP, HTML, CSS, and JavaScript.

### Tasks
- [ ] Set up `webapp/` directory structure:
  ```
  webapp/
  ├── WEB-INF/
  │   └── web.xml
  ├── css/
  │   └── style.css
  ├── js/
  │   └── app.js
  ├── images/
  ├── login.jsp
  ├── register.jsp
  ├── forgot-password.jsp
  ├── dashboard.jsp
  ├── portfolio.jsp
  ├── add-asset.jsp
  ├── asset-detail.jsp
  ├── transactions.jsp
  ├── documents.jsp
  ├── settings.jsp
  ├── header.jsp (reusable)
  ├── sidebar.jsp (reusable)
  └── footer.jsp (reusable)
  ```

- [ ] **Login Page (`login.jsp`)**: Centered login card, email/phone + password fields, "Forgot Password?" link, "Secure Login" button, "Sign up" link
- [ ] **Registration Page (`register.jsp`)**: Registration form with name, email, phone, password, confirm password
- [ ] **Dashboard (`dashboard.jsp`)**: Sidebar nav, Total Net Worth display, 4 category summary cards, portfolio performance chart area, recent activity list
- [ ] **Portfolio Holdings (`portfolio.jsp`)**: Summary cards row, tab-based filtering (All Assets / Investments / Liabilities / Cash), asset table with pagination
- [ ] **Add Asset Wizard (`add-asset.jsp`)**: Multi-step form (Step 1: Type, Step 2: Details, Step 3: Confirm) with JavaScript step navigation
- [ ] **Asset Detail (`asset-detail.jsp`)**: Asset header with price, performance chart, key statistics panel, position card, transaction history table, document vault
- [ ] **Documents (`documents.jsp`)**: List of uploaded documents with download links
- [ ] **Settings (`settings.jsp`)**: Profile edit form, change password section
- [ ] **Reusable Components**: `header.jsp`, `sidebar.jsp`, `footer.jsp` — included via `<%@ include %>`
- [ ] **CSS Stylesheet (`style.css`)**: Complete styling — layout, cards, tables, buttons, forms, color-coded badges, responsiveness
- [ ] **JavaScript (`app.js`)**: Step wizard logic, chart initialization (Chart.js), search/filter functionality, form validation

### Deliverables
✅ All JSP pages built and styled  
✅ Responsive CSS stylesheet  
✅ JavaScript for interactivity  
✅ Reusable header/sidebar/footer components

---

## 📌 Phase 4 — Servlets (Controller & Business Logic)
**Duration:** ~4–5 days  
**Goal:** Connect the JSP views to the JDBC backend using Servlets as controllers.

### Tasks
- [ ] Configure `web.xml` with servlet mappings
- [ ] Create **Servlet classes**:

| Servlet | URL Pattern | Methods | Purpose |
|---------|-------------|---------|---------|
| `LoginServlet` | `/login` | GET, POST | Show login page, authenticate user |
| `RegisterServlet` | `/register` | GET, POST | Show registration page, register new user |
| `LogoutServlet` | `/logout` | GET | Invalidate session, redirect to login |
| `DashboardServlet` | `/dashboard` | GET | Fetch summary data, render dashboard |
| `PortfolioServlet` | `/portfolio` | GET | Fetch all assets, render portfolio page |
| `AddAssetServlet` | `/asset/add` | GET, POST | Show add-asset form, save new asset |
| `AssetDetailServlet` | `/asset/detail` | GET | Fetch single asset data, render detail page |
| `TransactionServlet` | `/transactions` | GET, POST | List transactions, add new transaction |
| `DocumentServlet` | `/documents` | GET, POST | List documents, upload new document |
| `SettingsServlet` | `/settings` | GET, POST | Show settings, update profile/password |

- [ ] Implement **Authentication Filter** (`AuthFilter.java`): Check session for logged-in user, redirect to login if not authenticated
- [ ] Implement **Session Management**: Store user object in `HttpSession` after login
- [ ] Implement **Request Forwarding**: Servlets process data → forward to JSP views with attributes
- [ ] Implement **File Upload**: Handle document uploads using `Part` API (Servlet 3.0)
- [ ] Implement **Error Handling**: Custom error pages for 404, 500; try-catch in all servlets
- [ ] Connect DAO methods to Servlet logic
- [ ] Test complete flow: Login → Dashboard → Portfolio → Add Asset → View Asset → Logout

### Deliverables
✅ All Servlet controllers  
✅ Authentication filter  
✅ `web.xml` with all mappings  
✅ End-to-end working application (Servlet + JSP + JDBC)

---

## 📌 Phase 5 — Spring Framework (Refactoring to Spring MVC)
**Duration:** ~5–6 days  
**Goal:** Refactor the Servlet-based application to use Spring MVC framework.

### Tasks
- [ ] Add Spring dependencies to `pom.xml`:
  - `spring-core`
  - `spring-context`
  - `spring-webmvc`
  - `spring-jdbc`
- [ ] Create Spring configuration:
  - `applicationContext.xml` or `@Configuration` class
  - `dispatcher-servlet.xml` — DispatcherServlet config
  - Configure `ViewResolver` for JSP pages
- [ ] **Refactor Servlets → Spring Controllers**:

| Old Servlet | New Spring Controller | Annotations |
|-------------|----------------------|-------------|
| `LoginServlet` | `AuthController.java` | `@Controller`, `@RequestMapping` |
| `DashboardServlet` | `DashboardController.java` | `@Controller`, `@GetMapping` |
| `PortfolioServlet` | `PortfolioController.java` | `@Controller`, `@GetMapping` |
| `AddAssetServlet` | `AssetController.java` | `@Controller`, `@GetMapping`, `@PostMapping` |
| `AssetDetailServlet` | `AssetController.java` | `@Controller`, `@GetMapping` |
| `TransactionServlet` | `TransactionController.java` | `@Controller` |
| `DocumentServlet` | `DocumentController.java` | `@Controller` |
| `SettingsServlet` | `SettingsController.java` | `@Controller` |

- [ ] **Refactor DAO Layer → Spring JDBC Template**:
  - Replace raw JDBC code with `JdbcTemplate` / `NamedParameterJdbcTemplate`
  - Use `RowMapper` for object mapping
  - Configure `DataSource` bean
- [ ] **Create Service Layer** (new layer between Controller & DAO):
  - `UserService.java`
  - `AssetService.java`
  - `TransactionService.java`
  - `DocumentService.java`
  - `PortfolioService.java`
- [ ] **Apply Dependency Injection**:
  - Use `@Autowired` for injecting Services into Controllers
  - Use `@Autowired` for injecting DAOs into Services
  - Use `@Component`, `@Service`, `@Repository` annotations
- [ ] **Use Spring Form Tags** in JSPs:
  - `<form:form>`, `<form:input>`, `<form:errors>`
  - Add `@ModelAttribute` in controllers
- [ ] **Implement Spring Interceptor** (replaces Servlet Filter):
  - `AuthInterceptor.java` — replaces `AuthFilter`
  - Configure in Spring MVC config
- [ ] **Add Validation**:
  - Use `@Valid` + `BindingResult` for form validation
  - Create validation annotations on model classes
- [ ] Update `web.xml` to use Spring's `DispatcherServlet`

### Deliverables
✅ Spring MVC-based application  
✅ Spring JDBC Template for database access  
✅ Service layer with business logic  
✅ Dependency Injection throughout  
✅ Spring Interceptor for authentication  
✅ Form validation using Spring

---

## 📌 Phase 6 — Integration, Testing & Final Polish
**Duration:** ~3–4 days  
**Goal:** Final integration, testing, bug fixes, and documentation.

### Tasks
- [ ] **Integration Testing**: Test all modules working together end-to-end
- [ ] **Bug Fixes**: Fix any UI/backend issues discovered during testing
- [ ] **UI Polish**: Ensure consistent styling, fix responsive layout issues
- [ ] **Chart Integration**: Finalize Chart.js charts with real data from backend
- [ ] **Security Review**: Verify password hashing, SQL injection prevention, session security
- [ ] **Code Cleanup**: Remove unused code, add comments, organize packages
- [ ] **Documentation**: Finalize README, add setup instructions, add screenshots
- [ ] **Presentation Prep**: Prepare demo flow and talking points

### Deliverables
✅ Fully working, tested application  
✅ Clean, documented codebase  
✅ README with setup instructions  
✅ Project presentation ready

---

## 📋 Overall Timeline Summary

| Phase | Focus | Est. Duration |
|-------|-------|---------------|
| Phase 1 | Database Schema (MySQL) | 2–3 days |
| Phase 2 | JDBC (Data Access Layer) | 3–4 days |
| Phase 3 | JSP (Frontend Views) | 4–5 days |
| Phase 4 | Servlets (Controllers) | 4–5 days |
| Phase 5 | Spring Framework (MVC Refactor) | 5–6 days |
| Phase 6 | Integration, Testing & Polish | 3–4 days |
| **Total** | | **~21–27 days** |

---

## 📂 Final Project Structure

```
Asset-Tracker/
├── pom.xml
├── src/
│   └── main/
│       ├── java/
│       │   └── com/wealthtrack/
│       │       ├── config/             ← Spring Configuration
│       │       ├── controller/         ← Spring MVC Controllers
│       │       ├── service/            ← Business Logic Layer
│       │       ├── dao/                ← Data Access Objects
│       │       ├── model/              ← Java Bean / POJO classes
│       │       ├── interceptor/        ← Auth Interceptor
│       │       └── util/               ← Utility classes (DB Connection, etc.)
│       ├── resources/
│       │   └── applicationContext.xml
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml
│           │   ├── dispatcher-servlet.xml
│           │   └── views/              ← JSP Pages
│           ├── css/
│           ├── js/
│           └── images/
├── sql/
│   ├── schema.sql
│   └── seed-data.sql
├── Project_Requirement_Document.md
├── Development_Roadmap.md
└── README.md
```

---

## 🔑 Key Java Concepts Covered (Course Topics)

| Concept | Where Used |
|---------|-----------|
| **JDBC** | Phase 2 — DAO classes, PreparedStatements, Connection management |
| **JSP & JSTL** | Phase 3 — All frontend views, EL expressions, tag libraries |
| **Servlets** | Phase 4 — Request handling, session management, filters |
| **Spring Core** | Phase 5 — IoC Container, Dependency Injection, Beans |
| **Spring MVC** | Phase 5 — Controllers, ViewResolver, RequestMapping |
| **Spring JDBC** | Phase 5 — JdbcTemplate, DataSource, RowMapper |

---

> **Note:** This roadmap follows the course curriculum progression (JDBC → JSP → Servlets → Spring). Each phase builds on the previous one, so the application evolves incrementally.
