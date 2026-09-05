CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    department_id INTEGER REFERENCES departments(id),
    designation VARCHAR(150),
    salary NUMERIC(12,2),
    joining_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO departments (name, description)
VALUES
    ('IT', 'Information Technology'),
    ('HR', 'Human Resources'),
    ('Finance', 'Finance and Accounting'),
    ('Operations', 'Business Operations')
ON CONFLICT (name) DO NOTHING;

INSERT INTO employees
    (first_name, last_name, email, department_id, designation, salary, joining_date)
VALUES
    (
        'Rahul',
        'Sharma',
        'rahul.sharma@example.com',
        1,
        'DevOps Engineer',
        850000,
        '2024-01-15'
    ),
    (
        'Priya',
        'Verma',
        'priya.verma@example.com',
        2,
        'HR Manager',
        950000,
        '2023-08-10'
    ),
    (
        'Amit',
        'Kumar',
        'amit.kumar@example.com',
        3,
        'Financial Analyst',
        750000,
        '2024-03-20'
    )
ON CONFLICT (email) DO NOTHING;
