# RaceDay_Part1
# RaceDay API

A RESTful Web API for managing running, walking, and cycling events.

RaceDay allows users to register and authenticate, manage their profiles, view and manage events, enrol in events, and record race results.

---

## 📌 Project Overview

RaceDay is an ASP.NET Core Web API application designed to manage community sporting events.

The system supports three main user roles:

- **Admin** – manages users and system information.
- **Organiser** – creates and manages events, categories, enrolments, and results.
- **Participant** – manages their profile, views events, enrols in events, and views personal results.

The project uses a relational SQL Server database and follows a RESTful API architecture.

---

## 🎯 Project Objectives

The main objectives of the RaceDay API are to:

- Provide secure user registration and login.
- Manage user profiles.
- Create and manage sporting events.
- Organise events into categories.
- Allow participants to enrol in events.
- Record and retrieve race results.
- Provide RESTful API endpoints.
- Use a relational SQL Server database.
- Use primary and foreign key relationships.
- Support role-based access control.

---

## 🏗️ System Architecture

The project follows a layered API architecture:

```text
Client
  │
  ▼
ASP.NET Core Web API
  │
  ├── Controllers
  │
  ├── Models
  │
  ├── Services
  │
  └── Data Access
          │
          ▼
      SQL Server
```

---

# 🗄️ Database Design

The RaceDay database contains exactly **six entities/tables**:

1. `Users`
2. `Profiles`
3. `Categories`
4. `Events`
5. `EventEnrolments`
6. `Results`

### Entity Relationships

```text
Users
  │
  ├────────────── 1 : 1 ────────────── Profiles
  │
  └────────────── 1 : M ────────────── Events
                                          │
                                          │
Categories ───────── 1 : M ──────────────┘
                                          │
                                          ▼
                                  EventEnrolments
                                    ▲        │
                                    │        │
                                    │        ▼
                                  Users     Results
```

### Relationships

| Relationship | Description |
|---|---|
| Users → Profiles | One user has one profile |
| Users → Events | One organiser can create many events |
| Categories → Events | One category can contain many events |
| Users → EventEnrolments | One participant can have many enrolments |
| Events → EventEnrolments | One event can have many participants |
| EventEnrolments → Results | An enrolment can have zero or one result |

---

# 📊 Database Tables

## Users

Stores account and authentication information.

| Column | Type | Description |
|---|---|---|
| `user_id` | INT | Primary key |
| `email` | VARCHAR(255) | Unique user email |
| `password_hash` | VARCHAR(255) | Hashed password |
| `role` | VARCHAR(20) | Admin, Organiser or Participant |
| `created_at` | DATETIME | Account creation date |

---

## Profiles

Stores additional information about users.

| Column | Type | Description |
|---|---|---|
| `profile_id` | INT | Primary key |
| `user_id` | INT | Foreign key to Users |
| `first_name` | VARCHAR(100) | First name |
| `last_name` | VARCHAR(100) | Last name |
| `phone` | VARCHAR(30) | Contact number |
| `location` | VARCHAR(255) | User location |

---

## Categories

Stores the different types of sporting events.

Example categories:

- Running
- Walking
- Cycling

| Column | Type | Description |
|---|---|---|
| `category_id` | INT | Primary key |
| `name` | VARCHAR(100) | Category name |
| `description` | VARCHAR(500) | Category description |

---

## Events

Stores RaceDay sporting events.

| Column | Type | Description |
|---|---|---|
| `event_id` | INT | Primary key |
| `organizer_id` | INT | Foreign key to Users |
| `category_id` | INT | Foreign key to Categories |
| `name` | VARCHAR(200) | Event name |
| `description` | VARCHAR(MAX) | Event description |
| `event_type` | VARCHAR(50) | Type of event |
| `event_date` | DATETIME | Date and time of event |
| `location` | VARCHAR(255) | Event location |
| `entry_fee` | DECIMAL(10,2) | Entry fee |
| `status` | VARCHAR(30) | Event status |

---

## EventEnrolments

Connects participants with events.

| Column | Type | Description |
|---|---|---|
| `enrolment_id` | INT | Primary key |
| `event_id` | INT | Foreign key to Events |
| `participant_id` | INT | Foreign key to Users |
| `status` | VARCHAR(30) | Enrolment status |
| `bib_number` | VARCHAR(30) | Participant bib number |
| `enrolled_at` | DATETIME | Enrolment date |

---

## Results

Stores participant race results.

| Column | Type | Description |
|---|---|---|
| `result_id` | INT | Primary key |
| `enrolment_id` | INT | Foreign key to EventEnrolments |
| `finish_time` | VARCHAR(20) | Participant finish time |
| `position` | INT | Finishing position |
| `pace` | VARCHAR(20) | Average pace |
| `recorded_at` | DATETIME | Date result was recorded |

---

# 🔌 API Endpoints

## Authentication

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/register` | Register a new user |
| POST | `/api/auth/login` | Login and receive an access token |

---

## Users

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/users` | Get all users |
| GET | `/api/users/{id}` | Get a specific user |
| PUT | `/api/users/{id}` | Update a user |
| DELETE | `/api/users/{id}` | Delete a user |

---

## Profiles

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/profiles/me` | Get logged-in user's profile |
| PUT | `/api/profiles/me` | Create or update logged-in user's profile |
| GET | `/api/profiles/{id}` | Get a specific profile |

---

## Categories

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/categories` | Get all categories |
| GET | `/api/categories/{id}` | Get a specific category |
| POST | `/api/categories` | Create a category |
| PUT | `/api/categories/{id}` | Update a category |
| DELETE | `/api/categories/{id}` | Delete a category |

---

## Events

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/events` | Get all upcoming events |
| GET | `/api/events/{id}` | Get a specific event |
| POST | `/api/events` | Create an event |
| PUT | `/api/events/{id}` | Update an event |
| DELETE | `/api/events/{id}` | Delete or cancel an event |

---

## Event Enrolments

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/events/{eventId}/enrolments` | Get event participants |
| POST | `/api/events/{eventId}/enrolments` | Enrol in an event |
| GET | `/api/enrolments/me` | Get logged-in participant's enrolments |
| GET | `/api/enrolments/{id}` | Get a specific enrolment |
| PUT | `/api/enrolments/{id}` | Update an enrolment |
| DELETE | `/api/enrolments/{id}` | Withdraw from an event |

---

## Results

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/events/{eventId}/results` | Get results for an event |
| GET | `/api/results/me` | Get logged-in participant's results |
| GET | `/api/results/{id}` | Get a specific result |
| POST | `/api/events/{eventId}/results` | Record a result |
| PUT | `/api/results/{id}` | Update a result |
| DELETE | `/api/results/{id}` | Delete a result |

---

# 🔐 User Roles

## Admin

Administrators can:

- View users
- Update users
- Delete users
- View user profiles
- Manage system-level information

## Organiser

Organisers can:

- Create events
- Update events
- Cancel events
- Manage event categories
- View event participants
- Update enrolment information
- Record race results
- Correct race results

## Participant

Participants can:

- Register for an account
- Login
- Manage their profile
- View available events
- Enrol in events
- View their enrolments
- Withdraw from events
- View their personal race results

---

# 🧪 Example API Requests

## Register User

### Request

```http
POST /api/auth/register
Content-Type: application/json
```

```json
{
  "email": "john@gmail.com",
  "password": "Password123!",
  "role": "Participant"
}
```

### Response

```json
{
  "userId": 3,
  "email": "john@gmail.com",
  "role": "Participant"
}
```

---

## Login

### Request

```http
POST /api/auth/login
Content-Type: application/json
```

```json
{
  "email": "john@gmail.com",
  "password": "Password123!"
}
```

### Response

```json
{
  "token": "ACCESS_TOKEN",
  "userId": 3,
  "role": "Participant"
}
```

---

## Create Event

### Request

```http
POST /api/events
Content-Type: application/json
```

```json
{
  "organizerId": 2,
  "categoryId": 1,
  "name": "Cape Town 10K",
  "description": "Annual road running event in Cape Town.",
  "eventType": "Road Run",
  "eventDate": "2026-10-18T07:00:00",
  "location": "Cape Town",
  "entryFee": 250.00,
  "status": "Open"
}
```

### Response

```json
{
  "eventId": 1,
  "organizerId": 2,
  "categoryId": 1,
  "name": "Cape Town 10K",
  "eventType": "Road Run",
  "eventDate": "2026-10-18T07:00:00",
  "location": "Cape Town",
  "entryFee": 250.00,
  "status": "Open"
}
```

---

## Enrol in Event

### Request

```http
POST /api/events/1/enrolments
Content-Type: application/json
```

```json
{}
```

### Response

```json
{
  "enrolmentId": 1,
  "eventId": 1,
  "participantId": 3,
  "status": "Registered",
  "bibNumber": null
}
```

---

## Record Result

### Request

```http
POST /api/events/1/results
Content-Type: application/json
```

```json
{
  "enrolmentId": 1,
  "finishTime": "00:52:31",
  "position": 25,
  "pace": "05:15/km"
}
```

### Response

```json
{
  "resultId": 1,
  "enrolmentId": 1,
  "finishTime": "00:52:31",
  "position": 25,
  "pace": "05:15/km"
}
```

---

# 🗂️ Project Structure

```text
RaceDay/
│
├── README.md
│
├── docs/
│   ├── RaceDay_ERD.png
│   ├── RaceDay_API_Endpoint_Plan.md
│   └── RaceDay.sql
│
└── RaceDay.API/
    │
    ├── Controllers/
    │   ├── AuthController.cs
    │   ├── UsersController.cs
    │   ├── ProfilesController.cs
    │   ├── CategoriesController.cs
    │   ├── EventsController.cs
    │   ├── EventEnrolmentsController.cs
    │   └── ResultsController.cs
    │
    ├── Models/
    │   ├── User.cs
    │   ├── Profile.cs
    │   ├── Category.cs
    │   ├── Event.cs
    │   ├── EventEnrolment.cs
    │   └── Result.cs
    │
    ├── Data/
    │   └── RaceDayDbContext.cs
    │
    ├── Services/
    │
    ├── Program.cs
    └── appsettings.json
```

---

# 🛠️ Technologies

- C#
- ASP.NET Core Web API
- .NET
- Entity Framework Core
- Microsoft SQL Server
- Visual Studio 2022
- Swagger / OpenAPI
- Git
- GitHub
- REST API

---

# 🗃️ Database Setup

1. Open SQL Server Management Studio.

2. Open:

```text
docs/RaceDay.sql
```

3. Execute the SQL script.

4. The script creates the:

```text
RaceDay
```

database.

5. The following six tables are created:

```text
Users
Profiles
Categories
Events
EventEnrolments
Results
```

6. Sample data is included for testing.

---

# 🚀 Running the API

## Prerequisites

Make sure the following are installed:

- Visual Studio 2022
- .NET SDK
- SQL Server
- SQL Server Management Studio
- Git

## Steps

### 1. Clone the repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

### 2. Open the project

Open the `.sln` file in Visual Studio 2022.

### 3. Configure the database

Update the connection string in:

```text
appsettings.json
```

Example:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=RaceDay;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

### 4. Run the application

Press:

```text
F5
```

or:

```text
Ctrl + F5
```

---

# 📖 Swagger API Documentation

When the API is running, Swagger/OpenAPI can be used to test the endpoints.

Swagger provides an interactive interface for testing the RaceDay API.

The API contains the following endpoint groups:

```text
Authentication
Users
Profiles
Categories
Events
Event Enrolments
Results
```

---

# 🔒 Security

The API uses authentication and role-based authorisation for protected functionality.

Available roles are:

```text
Admin
Organiser
Participant
```

Passwords must never be stored as plain text.

The `password_hash` field is intended to store securely hashed passwords.

Authentication tokens should also be stored securely and should not be committed to GitHub.

---

# 🧪 Testing

API endpoints can be tested using:

- Swagger UI
- Postman
- Visual Studio
- Automated API tests

Example testing flow:

```text
Register
   ↓
Login
   ↓
Receive Access Token
   ↓
Authorise in Swagger
   ↓
Create/View Profile
   ↓
View Events
   ↓
Enrol in Event
   ↓
Record Result
   ↓
View Results
```

---

# 📁 Documentation

Project documentation is stored in the `docs` folder.

```text
docs/
├── RaceDay_ERD.png
├── RaceDay_API_Endpoint_Plan.md
└── RaceDay.sql
```

### ERD

The ERD documents the database structure and relationships between the six entities.

### API Endpoint Plan

The API documentation describes the available REST endpoints, HTTP methods, roles, request bodies and expected responses.

### SQL Script

The SQL script creates the RaceDay database, tables, relationships and sample data.

---

# 📌 Sample Data

The database includes sample users, categories, events, enrolments and results.

## Sample Users

| ID | Email | Role |
|---:|---|---|
| 1 | admin@raceday.co.za | Admin |
| 2 | organiser@raceday.co.za | Organiser |
| 3 | john@gmail.com | Participant |
| 4 | sarah@gmail.com | Participant |

## Sample Categories

| ID | Category |
|---:|---|
| 1 | Running |
| 2 | Walking |
| 3 | Cycling |

## Sample Events

| ID | Event | Category | Location |
|---:|---|---|---|
| 1 | Cape Town 10K | Running | Cape Town |
| 2 | Durban Charity Walk | Walking | Durban |
| 3 | Johannesburg Cycle Challenge | Cycling | Johannesburg |

## Sample Enrolments

| ID | Participant | Event | Status | Bib Number |
|---:|---|---|---|---|
| 1 | John Mokoena | Cape Town 10K | Confirmed | A1025 |
| 2 | Sarah Dlamini | Cape Town 10K | Confirmed | A1026 |
| 3 | John Mokoena | Durban Charity Walk | Registered | B2015 |

## Sample Results

| ID | Participant | Event | Finish Time | Position | Pace |
|---:|---|---|---|---:|---|
| 1 | John Mokoena | Cape Town 10K | 00:52:31 | 25 | 05:15/km |
| 2 | Sarah Dlamini | Cape Town 10K | 00:48:20 | 12 | 04:50/km |

---

# 🔄 Development Workflow

The project is developed in the following order:

```text
ERD
 ↓
SQL Database
 ↓
C# Models
 ↓
Entity Framework Core
 ↓
Controllers
 ↓
Authentication & Authorisation
 ↓
REST API
 ↓
Swagger Testing
 ↓
Documentation
 ↓
GitHub
```

---

# 📈 Project Status

- [x] Database design
- [x] ERD design
- [x] Six database entities defined
- [x] SQL table structure
- [x] Foreign key relationships
- [x] Sample database data
- [x] API endpoint plan
- [x] GitHub README
- [ ] ASP.NET Core Web API implementation
- [ ] Entity Framework Core configuration
- [ ] Authentication
- [ ] Role-based authorisation
- [ ] Swagger testing
- [ ] API validation
- [ ] Final documentation
- [ ] Docker/containerisation

---
GITHUB LINK 

YOUTUBE LINK
# 🤖 Use of AI

Artificial Intelligence (AI) tools were used during the development of this project for **proofreading and improving the clarity of written content**.

AI was used to assist with:

- Proofreading and correcting grammar and spelling.
- Improving the clarity and readability of documentation.
- Reviewing the wording of the README and project documentation.
- Helping ensure that explanations and descriptions were clear and understandable.

The database design, project requirements, API structure, implementation decisions and final project work were reviewed and adapted by the student to meet the requirements of the assignment.

AI was used as a supporting proofreading and documentation tool and not as a replacement for the my own understanding and work.

# 📜 License

This project was created as part of an academic assignment.

All rights reserved.

