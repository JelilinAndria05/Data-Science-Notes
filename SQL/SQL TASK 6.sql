-- TASK 6

-- > Frame 5 problem statements using window functions.

-- 1. Rank products by MSRP within each product line

SELECT productCode, productName, productLine, MSRP,
       RANK() OVER (PARTITION BY productLine ORDER BY MSRP DESC) AS price_rank
FROM products;

-- 2. Give products a dense rank by MSRP

SELECT productCode, productName, MSRP,
       DENSE_RANK() OVER (ORDER BY MSRP DESC) AS price_rank
FROM products;

-- 3. Calculate a running sales amount within each order

SELECT orderNumber, orderLineNumber, quantityOrdered, priceEach,
       SUM(quantityOrdered * priceEach)
       OVER (PARTITION BY orderNumber ORDER BY orderLineNumber) AS running_amount
FROM orderdetails;

-- 4. Show each product and its product line’s average MSRP

SELECT productCode, productName, productLine, MSRP,
       ROUND(AVG(MSRP) OVER (PARTITION BY productLine), 2) AS average_line_MSRP
FROM products;

-- 5. Show each order and the number of orders with the same status

SELECT orderNumber, status,
       COUNT(*) OVER (PARTITION BY status) AS orders_with_same_status
FROM orders;

-- > Create 3 stored procedures.

DELIMITER $$

-- 1. Procedure without parameters
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT productCode, productName, productLine, quantityInStock
    FROM products;
END $$

-- Run the procedures
CALL GetAllProducts();

-- 2. Procedure with an input parameter
DELIMITER $$

CREATE PROCEDURE GetProductsByProductLine(IN p_productLine VARCHAR(50))
BEGIN
    SELECT productCode, productName, productLine, quantityInStock
    FROM products
    WHERE productLine = p_productLine;
END $$

-- Run the procedures
CALL GetProductsByProductLine('Classic Cars');


-- 3. Procedure with input and output parameters
DELIMITER $$

CREATE PROCEDURE GetCustomerOrderCount(
    IN p_customerNumber INT,
    OUT p_orderCount INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_orderCount
    FROM orders
    WHERE customerNumber = p_customerNumber;
END $$

DELIMITER ;

-- Run the procedures
CALL GetCustomerOrderCount(103, @orderCount);
SELECT @orderCount AS 'Number of Orders';