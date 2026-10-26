-- TASK 3

-- 1. Which product line generates the highest sales revenue?

SELECT
    P.productLine,
    SUM(OD.quantityOrdered * OD.priceEach) AS totalSalesRevenue
FROM 
	orderdetails AS OD
JOIN products AS P
    ON OD.productCode = P.productCode
GROUP BY P.productLine
ORDER BY totalSalesRevenue DESC;

-- 2. Which office is associated with the highest sales revenue?

SELECT 
	O.officeCode,
    O.city,
    SUM(OD.quantityOrdered * OD.priceEach) AS total_revenue
FROM 
	offices O
JOIN employees E	
	ON O.officeCode = E.officeCode
JOIN customers C
	ON E.employeeNumber = C.salesRepEmployeeNumber
Join orders O2
	ON C.customerNumber = O2.customerNumber
JOIN orderdetails OD
	ON O2.orderNumber = OD.orderNumber
GROUP BY O.officeCode, O.city
ORDER BY total_revenue DESC;

-- 3. Which product is the top-selling product in each product line?
--    (Based on quantity sold)
SELECT
    productLine,
    productCode,
    productName,
    totalQuantitySold
FROM (
    SELECT
        P.productLine,
        P.productCode,
        P.productName,
        SUM(OD.quantityOrdered) AS totalQuantitySold,
        RANK() OVER (
            PARTITION BY P.productLine
            ORDER BY SUM(OD.quantityOrdered) DESC
        ) AS productRank
    FROM 
		products AS P
    JOIN orderdetails AS OD
        ON P.productCode = OD.productCode
    GROUP BY P.productLine, P.productCode, P.productName
) AS rankedProducts
WHERE productRank = 1
ORDER BY productLine;


-- 4. How many orders are currently in process?
SELECT
    COUNT(*) AS ordersInProcess
FROM 
	orders
WHERE status = 'In Process';


-- 5. Which employee is associated with the highest sales revenue?
SELECT
    E.employeeNumber,
    CONCAT(E.firstName, ' ', E.lastName) AS employeeName,
    SUM(OD.quantityOrdered * OD.priceEach) AS totalSalesRevenue
FROM 
	employees AS E
JOIN customers AS C
    ON E.employeeNumber = C.salesRepEmployeeNumber
JOIN orders AS O
    ON C.customerNumber = O.customerNumber
JOIN orderdetails AS OD
    ON O.orderNumber = OD.orderNumber
GROUP BY E.employeeNumber, E.firstName, E.lastName
ORDER BY totalSalesRevenue DESC;


-- 6. What are the minimum, maximum, and average MSRP values for products in each product line?

SELECT
    productLine,
    MIN(MSRP) AS minimumPrice,
    MAX(MSRP) AS maximumPrice,
    ROUND(AVG(MSRP), 2) AS averagePrice
FROM 
	products
GROUP BY productLine
ORDER BY productLine;


-- 7. Which products have low stock and may need restocking?
--    Low stock is defined here as fewer than 1,000 units.
SELECT
    productCode,
    productName,
    quantityInStock
FROM 
	products
WHERE quantityInStock < 1000
ORDER BY quantityInStock ASC;


-- 8. Which vendor's products generate the highest sales revenue?
SELECT
    P.productVendor,
    SUM(OD.quantityOrdered * OD.priceEach) AS totalSalesRevenue
FROM 
	products AS P
JOIN orderdetails AS OD
    ON P.productCode = OD.productCode
GROUP BY P.productVendor
ORDER BY totalSalesRevenue DESC;


-- 9. Which customers have made the highest total payments?
SELECT
    C.customerNumber,
    C.customerName,
    SUM(P.amount) AS totalPayments
FROM 
	customers AS C
JOIN payments AS P
    ON C.customerNumber = P.customerNumber
GROUP BY C.customerNumber, C.customerName
ORDER BY totalPayments DESC;


-- 10. How does sales revenue change month by month?
SELECT
    DATE_FORMAT(O.orderDate, '%Y-%m') AS salesMonth,
    SUM(OD.quantityOrdered * OD.priceEach) AS monthlySalesRevenue
FROM 
	orders AS O
JOIN orderdetails AS OD
    ON O.orderNumber = OD.orderNumber
GROUP BY DATE_FORMAT(O.orderDate, '%Y-%m')
ORDER BY salesMonth;