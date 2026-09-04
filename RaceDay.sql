CREATE DATABASE EventManagementDB;


USE EventManagementDB;


CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL
);


CREATE TABLE EventType (
    id INT IDENTITY(1,1) PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    description TEXT
);


CREATE TABLE Category (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);
GO

CREATE TABLE Event (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    start_time TIME,
    location VARCHAR(255) NOT NULL,
    distance DECIMAL(6,2),
    event_type_id INT NOT NULL,
    category_id INT NOT NULL,
    organizer_id INT NOT NULL,
    registration_deadline DATE,
    max_participants INT,
    status VARCHAR(30) NOT NULL,

    CONSTRAINT FK_Event_EventType
        FOREIGN KEY (event_type_id)
        REFERENCES EventType(id),

    CONSTRAINT FK_Event_Category
        FOREIGN KEY (category_id)
        REFERENCES Category(id),

    CONSTRAINT FK_Event_Organizer
        FOREIGN KEY (organizer_id)
        REFERENCES Users(id)
);


CREATE TABLE Enrollment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    registration_date DATETIME2 DEFAULT GETDATE(),
    race_number VARCHAR(20),
    status VARCHAR(30) NOT NULL,

    CONSTRAINT FK_Enrollment_Event
        FOREIGN KEY (event_id)
        REFERENCES Event(id),

    CONSTRAINT FK_Enrollment_User
        FOREIGN KEY (user_id)
        REFERENCES Users(id)
);


CREATE TABLE Results (
    id INT IDENTITY(1,1) PRIMARY KEY,
    enrollment_id INT NOT NULL UNIQUE,
    finish_time TIME,
    position INT,
    pace DECIMAL(6,2),
    status VARCHAR(30),

    CONSTRAINT FK_Results_Enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES Enrollment(id)
);
/* =========================================================
   SEED DATA
   ========================================================= */

-- =========================================================
-- 1. USERS
-- 2 Organizers + 2 Participants
-- =========================================================

INSERT INTO Users (name, surname, email, password, role)
VALUES
('Thabo', 'Mokoena', 'thabo.mokoena@example.com', 'Password123', 'Organizer'),
('Lerato', 'Nkosi', 'lerato.nkosi@example.com', 'Password123', 'Organizer'),
('Sipho', 'Dlamini', 'sipho.dlamini@example.com', 'Password123', 'Participant'),
('Nomsa', 'Khumalo', 'nomsa.khumalo@example.com', 'Password123', 'Participant');

-- =========================================================
-- 2. EVENT TYPES
-- =========================================================

INSERT INTO EventType (event_name, description)
VALUES
('Road Race', 'A running event held on public roads and paved routes.'),
('Trail Run', 'A running event conducted on natural trails and off-road terrain.'),
('Charity Run', 'A running event organised to raise funds and awareness for a charitable cause.');

-- =========================================================
-- 3. CATEGORIES
-- =========================================================

INSERT INTO Category (name, description)
VALUES
('10 KM Run', 'A 10-kilometre running event suitable for recreational and competitive runners.'),
('21 KM Trail Run', 'A half-marathon distance trail running event for experienced runners.'),
('5 KM Fun Run', 'A short recreational run suitable for families and participants of different fitness levels.');

-- =========================================================
-- 4. EVENTS
-- Organizer IDs:
-- 1 = Thabo Mokoena
-- 2 = Lerato Nkosi
--
-- EventType IDs:
-- 1 = Road Race
-- 2 = Trail Run
-- 3 = Charity Run
--
-- Category IDs:
-- 1 = 10 KM Run
-- 2 = 21 KM Trail Run
-- 3 = 5 KM Fun Run
-

    INSERT INTO Event
(
    name,
    description,
    event_date,
    start_time,
    location,
    distance,
    event_type_id,
    category_id,
    organizer_id,
    registration_deadline,
    max_participants,
    status
)
VALUES
(
    'Johannesburg City 10K',
    'A fast-paced 10 kilometre road race through central Johannesburg.',
    '2026-10-18',
    '07:00:00',
    'Zoo Lake, Johannesburg',
    10.00,
    1,
    1,
    1,
    '2026-10-10',
    500,
    'Open'
),
(
    'Magaliesberg Mountain Trail',
    'A challenging 21 kilometre trail run through the scenic Magaliesberg mountains.',
    '2026-11-08',
    '06:30:00',
    'Magaliesberg Nature Area',
    21.00,
    2,
    2,
    2,
    '2026-10-31',
    250,
    'Open'
),

(
    'Run for Hope Charity 5K',
    'A family-friendly 5 kilometre charity run supporting local community projects.',
    '2026-12-05',
    '08:00:00',
    'Delta Park, Johannesburg',
    5.00,
    3,
    3,
    1,
    '2026-11-28',
    1000,
    'Open'
);

-- =========================================================
-- 5. ENROLLMENTS
-- Participant IDs:
-- 3 = Sipho Dlamini
-- 4 = Nomsa Khumalo
--
-- Event IDs:
-- 1 = Johannesburg City 10K
-- 2 = Magaliesberg Mountain Trail
-- 3 = Run for Hope Charity 5K
-- =========================================================
INSERT INTO Enrollment
(
    event_id,
    user_id,
    registration_date,
    race_number,
    status
)
VALUES
(
    1,
    3,
    '2026-09-01 09:15:00',
    'JHB001',
    'Registered'
),
(
    1,
    4,
    '2026-09-02 14:30:00',
    'JHB002',
    'Registered'
),
(
    2,
    3,
    '2026-09-03 10:00:00',
    'MAG001',
    'Registered'
),
(
    3,
    4,
    '2026-09-03 16:45:00',
    'HOP001',
    'Registered'
);
-- =========================================================
-- 6. SAMPLE RESULTS
-- Results should normally only exist for completed events.
-- These are included as sample data for testing.
-- =========================================================

-- If you want results to correspond to completed events,
-- you can update an event's status to 'Completed' first.

INSERT INTO Results
(
    enrollment_id,
    finish_time,
    position,
    pace,
    status
)
VALUES
(
    1,
    '00:52:35',
    18,
    5.26,
    'Finished'
),
(
    2,
    '01:04:20',
    42,
    6.43,
    'Finished'
),
