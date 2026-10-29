# Foundation Quiz Application

A full-stack, secure quiz application built with Vanilla HTML5, CSS3, and JavaScript on the frontend and Spring Boot 3.5 with Spring Security and Spring Data JPA on the backend.

The platform is designed with an emphasis on server-side evaluation, zero client-side answer leakage, and an enterprise-grade authentication lifecycle.

---

## Table of Contents

- [Overview](#overview)
- [Architecture and Tech Stack](#architecture-and-tech-stack)
- [Core Features](#core-features)
- [Security Architecture](#security-architecture)
- [API Specification](#api-specification)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Database Configuration](#database-configuration)
  - [Application Configuration](#application-configuration)
  - [Building and Running the Backend](#building-and-running-the-backend)
  - [Deploying the Frontend](#deploying-the-frontend)
- [License and Attribution](#license-and-attribution)

---

## Overview

The Foundation Quiz Application provides an assessment environment for developers across multiple programming languages, including Java, Python, JavaScript, and C. 

In contrast to client-evaluated quiz systems that expose answer keys in HTTP payloads, this architecture enforces strict server-side grading. Questions delivered to the client are stripped of answer keys, submissions are validated against server records, and candidate attempts are persisted to historical records.

---

## Architecture and Tech Stack

### Frontend
- **Interface Layer**: Vanilla HTML5 and CSS3 (no external UI framework dependencies).
- **Application Logic**: Vanilla JavaScript (ES6+) utilizing standard asynchronous Fetch APIs and custom request interceptors.
- **State Management**: Client-side storage for session token management with automated cache invalidation upon session expiry.

### Backend
- **Core Framework**: Spring Boot 3.5 on Java 21 LTS.
- **Security Framework**: Spring Security 6 configured for stateless session management.
- **Persistence Layer**: Spring Data JPA with Hibernate 6 and MySQL 8 Dialect.
- **Token Management**: JJWT (Java JWT 0.12.6) employing HMAC-SHA256 signature verification.
- **Validation**: Jakarta Bean Validation API.

### Database
- **Relational Storage**: MySQL Server 8.0+.
- **Schema Management**: Relational mapping covering users, quiz categories, multiple-choice option sets, and historical score entries.

---

## Core Features

- **Dual-Token Lifecycle**: Short-lived Access Tokens (15-minute validity) paired with long-lived Refresh Tokens (7-day validity) featuring automatic rotation.
- **Multi-Category Quiz Engine**: Dedicated pools for Java, Python, JavaScript, and C with server-driven randomized question sequencing.
- **Synchronized Assessment Timer**: 15-minute examination countdown timer with automated test submission upon expiry.
- **Server-Side Grading**: Prevention of answer sniffing; answer validation is conducted strictly within backend transactional contexts.
- **Historical Reporting**: Persistent tracking of user scores, completion timestamps, and subject categories.
- **Detailed Solution Breakdown**: Post-submission evaluation displaying candidate selections against verified correct answers.

---

## Security Architecture

The application implements defense-in-depth measures against common web application vulnerabilities and abuse patterns:

| Vulnerability Vector | Defense Mechanism | Implementation Strategy |
| :--- | :--- | :--- |
| **Token Type Confusion** | Explicit Claim Validation | Access and refresh tokens enforce a typed claim (`access` vs `refresh`). The security filter chain unconditionally rejects refresh tokens on protected resource endpoints. |
| **Refresh Token Replay** | Token Rotation | Each invocation of the refresh endpoint invalidates the incoming refresh token and issues a new access/refresh key pair. |
| **Brute-Force and Credential Stuffing** | Sliding-Window Rate Limiting | An in-memory rate-limiting engine enforces request thresholds on authentication endpoints: login (max 20 requests/minute per IP; max 5 attempts/minute per account) and signup (max 5 requests/minute per IP). |
| **Account Collision (Race Conditions)** | Database-Level Unique Constraints | `User.username` enforces a database-level unique constraint (`@Column(unique = true, nullable = false)`), catching concurrent race conditions through transactional rollback. |
| **Score Tampering** | Question Deduplication and Size Limits | Submissions deduplicate question IDs using hash set validation and restrict payload length to a maximum of 50 answers per test. |
| **Cross-Site Scripting (XSS)** | Safe DOM Rendering | Dynamic question text and solution review trees are rendered using `document.createTextNode` and `element.textContent`, preventing HTML/script injection vectors. |
| **SQL Injection** | Parameterized Execution | All database interactions rely on Spring Data JPA derived queries and parameterized native bindings. |
| **Information Leakage** | Exception Interception | A global `@RestControllerAdvice` sanitizes error payloads, ensuring internal stack traces and database schemas are not exposed to clients. |

---

## API Specification

All protected endpoints require an HTTP Authorization header containing a valid Bearer token:  
`Authorization: Bearer <access_token>`

### Authentication Endpoints

| Method | Endpoint | Access Level | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/signup` | Public | Registers a new user account with validated credentials. |
| `POST` | `/api/auth/login` | Public | Authenticates credentials and issues access and refresh tokens. |
| `POST` | `/api/auth/refresh` | Public | Rotates tokens and issues a new access token. |

### Assessment and Score Endpoints

| Method | Endpoint | Access Level | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/questions` | Authenticated | Retrieves the master question list without answer keys. |
| `GET` | `/api/questions/{category}` | Authenticated | Retrieves randomized questions for a category (accepts `count` parameter). |
| `POST` | `/api/questions/submit` | Authenticated | Grades candidate responses and records score history. |
| `GET` | `/api/scores` | Authenticated | Retrieves score history for the authenticated user account. |

---

## Directory Structure

```
Quiz-Application/
|-- java_problems.sql                      # Database schema and seed question bank
|-- README.md                              # Technical documentation
|
|-- quiz/                                  # Spring Boot Backend
|   |-- mvnw / mvnw.cmd                    # Maven wrapper scripts
|   |-- pom.xml                            # Dependency definitions and build plugin configuration
|   `-- src/main/
|       |-- java/com/quiz/quiz/
|       |   |-- QuizApplication.java       # Application entry point
|       |   |-- config/
|       |   |   |-- AppConfig.java         # Security and bean definitions (BCrypt)
|       |   |   |-- GlobalExceptionHandler.java # Centralized exception handling
|       |   |   `-- WebConfig.java         # Web context configuration
|       |   |-- controller/
|       |   |   |-- AuthController.java    # Authentication and session management
|       |   |   |-- LoginController.java   # Question distribution endpoints
|       |   |   `-- QuizSubmitController.java # Test submission and score tracking
|       |   |-- dto/                       # Data transfer objects
|       |   |-- entity/                    # JPA persistence entities (User, Question, Score)
|       |   |-- repo/                      # Spring Data JPA repositories
|       |   |-- security/
|       |   |   |-- JwtAuthenticationFilter.java # Per-request JWT authentication filter
|       |   |   |-- JwtUtil.java           # Token generation, parsing, and claim inspection
|       |   |   |-- RateLimiterService.java# Sliding-window rate limiter
|       |   |   `-- SecurityConfig.java    # Security filter chain and CORS policies
|       |   `-- service/                   # Business logic implementations
|       `-- resources/
|           |-- application.properties     # Application configuration
|           `-- application-local.properties.example # Local override template
|
`-- quiz-app/                              # Frontend Web Application
    |-- config.js                          # API gateway base URL
    |-- index.html                         # Home page and category catalog
    |-- login.html                         # User authentication interface
    |-- signup.html                        # User registration interface
    |-- quiz.html                          # Interactive test environment
    |-- quiz.js                            # Test logic, timing, and network layer
    |-- result.html                        # Assessment outcome display
    |-- solutions.html                     # Question-by-question review screen
    |-- style.css                          # Portal styling
    |-- quiz-style.css                     # Examination workspace styling
    |-- result.css                         # Outcome and solution styling
    `-- images/                            # Static visual assets
```

---

## Getting Started

### Prerequisites

- Java Development Kit (JDK) 21 or later
- Apache Maven 3.8+ (or use the packaged `./mvnw` wrapper)
- MySQL Server 8.0 or later
- Static HTTP file server (e.g., VS Code Live Server, Python `http.server`, Nginx)

---

### Database Configuration

1. Initialize the database schema and populate question sets using the provided SQL file:

```bash
mysql -u root -p < java_problems.sql
```

This provisions the `quiz` database, initializes the table structures, and seeds initial question banks.

---

### Application Configuration

The backend reads configuration values from environment variables with standard fallbacks:

| Property | Environment Variable | Default Value | Description |
| :--- | :--- | :--- | :--- |
| `spring.datasource.url` | `DB_URL` | `jdbc:mysql://localhost:3306/quiz` | JDBC Connection String |
| `spring.datasource.username` | `DB_USER` | `root` | Database user account |
| `spring.datasource.password` | `DB_PASS` | `root` | Database password |
| `jwt.secret` | `JWT_SECRET` | Configured default | 256-bit Base64-encoded secret key |

For local testing, create an uncommitted configuration file at `quiz/src/main/resources/application-local.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/quiz
spring.datasource.username=root
spring.datasource.password=your_database_password
jwt.secret=m+D4Qv8QkXkF5R1W8u3M6Vp8Ys2B5E8H+MbQeThWmZq=
```

---

### Building and Running the Backend

Execute the Spring Boot run task using the Maven wrapper:

**Unix/Linux/macOS:**
```bash
cd quiz
./mvnw spring-boot:run
```

**Windows (PowerShell):**
```powershell
cd quiz
.\mvnw.cmd spring-boot:run
```

The service will bind to port `8080` (`http://localhost:8080`).

---

### Deploying the Frontend

The client application consists of static HTML, CSS, and JavaScript. Serve the `quiz-app` directory from an HTTP host configured to match the CORS policy (`http://127.0.0.1:5500` or `http://localhost:5500`).

**Option 1: VS Code Live Server**
1. Open the project root in Visual Studio Code.
2. Ensure the Live Server extension is installed.
3. Right-click `quiz-app/index.html` and choose **Open with Live Server**.

**Option 2: Python HTTP Server**
```bash
cd quiz-app
python -m http.server 5500 --bind 127.0.0.1
```

Access the application in a modern web browser at `http://127.0.0.1:5500`.

---

## License and Attribution

- **Developer**: Ansh Kumar
- **Project**: Foundation Quiz Application
- **License**: MIT
