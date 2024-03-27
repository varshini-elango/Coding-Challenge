create database codingchallenge

use codingchallenge;

CREATE TABLE Vehicle (
carID varchar(3) NOT NULL PRIMARY KEY,
make varchar(15) NOT NULL,
model varchar(15),
year int,
dailyRate decimal(10,2),
available int,
passengerCapacity int,
engineCapacity int);

INSERT INTO Vehicle (carID, make, model, Year, dailyRate, available, passengerCapacity, engineCapacity) 
VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10,'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

select * from vehicle;

use codingchallenge;

CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(20)
);

INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber)
VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

select * from customer;

use codingchallenge;

Create TABLE Lease (
    leaseID INT PRIMARY KEY,
    carID varchar(3) FOREIGN KEY REFERENCES Vehicle(carID), 
    customerID INT FOREIGN KEY REFERENCES Customer(customerID),
    startDate DATE,
    endDate DATE,
    type VARCHAR(20),
);

INSERT INTO Lease (leaseID, carID, customerID, startDate, endDate, type)
VALUES 
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');

select * from Lease;

use codingchallenge;

create table Payment(
paymentID varchar(3) NOT NULL PRIMARY KEY,
leaseID INT FOREIGN KEY REFERENCES Lease(leaseID),
paymentDate date NOT NULL,
amount int);

insert into Payment values(1, 1, '2023-01-25', 200);
insert into Payment values(2, 2, '2023-02-25', 1000);
insert into Payment values(3, 3, '2023-03-25', 75);
insert into Payment values(4, 4, '2023-04-25', 900);
insert into Payment values(5, 5, '2023-05-07', 60);
insert into Payment values(6, 6, '2023-06-18', 1200);
insert into Payment values(7, 7, '2023-07-03', 40);
insert into Payment values(8, 8, '2023-08-14', 1100);
insert into Payment values(9, 9, '2023-09-09', 80);
insert into Payment values(10, 10, '2023-10-25', 1500);

select  * from  Payment;

/*1. Update the daily rate for a Mercedes car to 68.*/
UPDATE Vehicle  
SET dailyRate = '68.00'  
WHERE make = 'Mercedes'
select * from Vehicle;

/*2.Delete a specific customer and all associated leases and payments*/

select * from customer;
select * from Lease;
select  * from  Payment;

use codingchallenge;
DELETE FROM Payment
WHERE leaseID IN (
    SELECT l.leaseID
    FROM Lease l
    WHERE l.customerID = 10	
);
DELETE FROM Lease
WHERE customerID = 10;
DELETE FROM Customer
WHERE customerID =10;


/*3.Rename the "paymentDate" column in the Payment table to "transactionDate".*/
EXEC sp_RENAME 'Payment.paymentDate' , 'transactionDate', 'COLUMN'
select  * from  Payment;

/*4. Find a specific customer by email.*/
SELECT customerID, firstName, lastName, email, phoneNumber
FROM Customer
WHERE email LIKE 'robert@example.com'

/*5.Get active leases for a specific customer*/
SELECT l.*
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
WHERE l.customerID = 1
AND l.endDate >= GETDATE();

/*6. Find all payments made by a customer with a specific phone number*/
select amount from payment 
where leaseId=(select leaseId from Lease 
where customerID=(select customerID from Customer 
where phoneNumber='555-555-5555'));

/*7. Calculate the average daily rate of all available cars*/
SELECT AVG(dailyRate)
FROM Vehicle;

/*8. Find the car with the highest daily rate*/
select * from Vehicle where dailyRate=(select Max(dailyRate) from Vehicle);

/*9. Retrieve all cars leased by a specific customer.*/
select concat(make,model) from Vehicle
where carId in (select carID from Lease 
where customerID=3);

/*10. Find the details of the most recent lease.*/
SELECT *
FROM Lease
WHERE endDate = (
    SELECT MAX(endDate)
    FROM Lease
);

/*11. List all payments made in the year 2023.*/
SELECT *
FROM Payment
WHERE YEAR(transactionDate) = 2023;

/*12. Retrieve customers who have not made any payments.*/
use codingchallenge;
SELECT c.*
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
WHERE l.customerID IS NULL;

/*13. Retrieve Car Details and Their Total Payments.*/
SELECT v.carID,v.make,v.model,
SUM(p.amount) AS totalPayments
FROM Vehicle v
LEFT JOIN Lease l ON v.carID = l.carID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.carID,v.make,v.model;

/*14. Calculate Total Payments for Each Customer.*/
SELECT c.customerID,c.firstName,c.lastName,
SUM(p.amount) AS totalPayments
FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID,c.firstName,c.lastName;

/*15. List Car Details for Each Lease.*/
SELECT l.leaseID,v.carID,v.make,v.model,v.year,v.dailyRate,v.available,v.passengerCapacity,v.engineCapacity
FROM Lease l
JOIN Vehicle v ON l.carID = v.carID;

/*16. Retrieve Details of Active Leases with Customer and Car Information.*/
SELECT l.leaseID,l.startDate,l.endDate,l.type AS leaseType,c.customerID,c.firstName,c.lastName,c.email,c.phoneNumber,
v.carID,v.make,v.model,v.year,v.dailyRate,v.available
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
JOIN Vehicle v ON l.carID = v.carID
WHERE l.endDate >= GETDATE();

UPDATE Lease
SET endDate = '2024-03-10' 
WHERE leaseID = 1;

/*17. Find the Customer Who Has Spent the Most on Leases.*/
SELECT TOP 1
c.customerID,c.firstName,c.lastName,
SUM(p.amount) AS totalSpentOnLeases
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID,c.firstName,c.lastName
ORDER BY totalSpentOnLeases DESC;

/*18. List All Cars with Their Current Lease Information*/
SELECT V.*, L.* FROM Vehicle V
JOIN Lease L ON L.carID = V.carID