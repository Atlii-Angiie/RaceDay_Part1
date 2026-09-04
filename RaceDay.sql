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
