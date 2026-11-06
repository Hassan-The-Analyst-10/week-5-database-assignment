# Database Indexing and Optimization

## Project Overview

This assignment focuses on database indexing, user account management, access control, and database security using MySQL.

The SQL queries demonstrate how to remove an index, create a database user, grant specific privileges, and change a user's password.

## Learning Objectives

1. Learn how to drop an index from a database table.
2. Create a MySQL user account restricted to localhost.
3. Grant specific database privileges to a user.
4. Change a user's password to improve database security.

## Technologies Used

- **Database:** MySQL
- **Language:** SQL
- **Editor:** MySQL Workbench or Visual Studio Code

## Project Structure

```text
database-indexing-optimization/
├── answers.sql
└── README.md
```

## Assignment Questions and Solutions

### Question 1: Drop an Index

Remove the index named `IdxPhone` from the `customers` table.

**SQL command:**

```sql
DROP INDEX IdxPhone ON customers;
```

### Question 2: Create a Database User

Create a MySQL user named `bob` whose account is restricted to connections from `localhost`.

**SQL command:**

```sql
CREATE USER 'bob'@'localhost'
IDENTIFIED BY '_S$cu3r3!';
```

### Question 3: Grant INSERT Privilege

Grant the user `bob` permission to insert records into tables within the `salesDB` database.

**SQL command:**

```sql
GRANT INSERT ON salesDB.*
TO 'bob'@'localhost';
```

### Question 4: Change the User Password

Change the password for the MySQL user `bob`.

**SQL command:**

```sql
ALTER USER 'bob'@'localhost'
IDENTIFIED BY '_P$55!23';
```

## How to Run the Queries

1. Open MySQL Workbench or another MySQL-compatible SQL editor.
2. Connect using an account with sufficient administrative privileges.
3. Open the `answers.sql` file.
4. Execute each query individually.
5. Check the results and confirm that the commands execute successfully.

**Note:** The `customers` table and `IdxPhone` index must exist before Question 1 can succeed. The `salesDB` database must exist before granting privileges in Question 3.

## Expected Outcomes

After completing this assignment, you should be able to:

- Manage database indexes.
- Create and manage MySQL user accounts.
- Apply database-level access control.
- Update user credentials.
- Understand the importance of database security and least-privilege access.

## Security Considerations

- Use strong, unique passwords for database accounts.
- Grant only the privileges required by each user.
- Restrict accounts to trusted connection sources.
- Avoid sharing database passwords publicly or committing real credentials to GitHub.

## Author

**Name:** [Your Name]

## Conclusion

This assignment provides practical experience in MySQL database administration, indexing, user management, and access control. These skills help maintain database performance and protect data from unauthorized access.
