/*----------------------------------------- Left Join -----------------------------------------------------------*/
SELECT
    p.ProductKey,
    p.EnglishProductName,
    ps.EnglishProductSubcategoryName,
    pc.EnglishProductCategoryName
FROM DimProduct p
LEFT JOIN DimProductSubCategory ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN DimProductCategory pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey;
    
    
/*------------------------------------------- Union -------------------------------------------------------------------*/
create table Sales as
select *
FROM FactInternetSales
UNION ALL
SELECT *
FROM Fact_Internet_Sales_New;

SELECT COUNT(*) AS TotalSalesRows
FROM SALES;

/*---------------------------------------------------Q.1 -----------------------------------------------------------*/
SELECT
    SALES.ProductKey,
    DimProduct.EnglishProductName
FROM SALES
LEFT JOIN DimProduct
    ON SALES.ProductKey = DimProduct.ProductKey;
    
/*----------------------------------------------------- Q.2 -----------------------------------------------------------------*/    
SELECT
    SALES.CustomerKey,
    CONCAT(DimCustomer.FirstName, ' ',dimcustomer.MiddleName,' ', DimCustomer.LastName) AS CustomerFullName,
    SALES.ProductKey,
    DimProduct.`Unit price` AS UnitPrice
FROM SALES
LEFT JOIN DimCustomer
    ON SALES.CustomerKey = DimCustomer.CustomerKey
LEFT JOIN DimProduct
    ON SALES.ProductKey = DimProduct.ProductKey;

/*-------------------------------------------------------- Q.3 -------------------------------------------------------------------*/
SELECT
    SALES.OrderDateKey,
    DimDate.FullDateAlternateKey,
    DimDate.CalendarYear,
    DimDate.MonthNumberOfYear,
    DimDate.EnglishMonthName,
    DimDate.CalendarQuarter,
    DimDate.EnglishDayNameOfWeek,
    DimDate.DayNumberOfWeek
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey;
    
    
SELECT
    SALES.OrderDateKey,
    DimDate.CalendarYear AS Year,
    DimDate.MonthNumberOfYear AS MonthNo,
    DimDate.EnglishMonthName AS MonthFullName,
    CONCAT('Q', DimDate.CalendarQuarter) AS Quarter,
    CONCAT(
        DimDate.CalendarYear,
        '-',
        LPAD(DimDate.MonthNumberOfYear, 2, '0')
    ) AS YearMonth,
    DimDate.DayNumberOfWeek AS WeekdayNo,
    DimDate.EnglishDayNameOfWeek AS WeekdayName
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey;
    
SELECT
    SALES.OrderDateKey,
    DimDate.CalendarYear AS Year,
    DimDate.MonthNumberOfYear AS MonthNo,
    DimDate.EnglishMonthName AS MonthFullName,
    CONCAT('Q', DimDate.CalendarQuarter) AS Quarter,
    CONCAT(
        DimDate.CalendarYear,
        '-',
        LPAD(DimDate.MonthNumberOfYear, 2, '0')
    ) AS YearMonth,
    DimDate.DayNumberOfWeek AS WeekdayNo,
    DimDate.EnglishDayNameOfWeek AS WeekdayName,

    CASE
        WHEN DimDate.MonthNumberOfYear >= 7
            THEN DimDate.MonthNumberOfYear - 6
        ELSE DimDate.MonthNumberOfYear + 6
    END AS FinancialMonth,

    CASE
        WHEN DimDate.MonthNumberOfYear BETWEEN 7 AND 9 THEN 'FQ1'
        WHEN DimDate.MonthNumberOfYear BETWEEN 10 AND 12 THEN 'FQ2'
        WHEN DimDate.MonthNumberOfYear BETWEEN 1 AND 3 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter

FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey;
    
/*----------------------------------------------------------- Q.4 ------------------------------------------------*/
SELECT
    SALES.ProductKey,
    SALES.OrderQuantity,
    SALES.UnitPrice,
    SALES.UnitPriceDiscountPct,
    SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct) AS SalesAmount
FROM SALES;

/*--------------------------------------------------- Q.5 ------------------------------------------------------*/
SELECT
    SALES.ProductKey,
    SALES.OrderQuantity,
    SALES.ProductStandardCost,
    SALES.ProductStandardCost
        * SALES.OrderQuantity AS ProductionCost
FROM SALES;

/*---------------------------- Q.6 ---------------------------------------------------*/
SELECT
    SALES.ProductKey,
    SALES.OrderQuantity,

    SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct) AS SalesAmount,

    SALES.ProductStandardCost
        * SALES.OrderQuantity AS ProductionCost,

    (
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    )
    -
    (
        SALES.ProductStandardCost
        * SALES.OrderQuantity
    ) AS Profit

FROM SALES;

/*---------------------------------- Q.7 ----------------------------------*/
SELECT
    DimDate.CalendarYear AS Year,
    DimDate.MonthNumberOfYear AS MonthNo,
    DimDate.EnglishMonthName AS MonthName,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey
GROUP BY
    DimDate.CalendarYear,
    DimDate.MonthNumberOfYear,
    DimDate.EnglishMonthName
ORDER BY
    DimDate.CalendarYear,
    DimDate.MonthNumberOfYear;
    
SELECT
    DimDate.CalendarYear AS Year,
    DimDate.MonthNumberOfYear AS MonthNo,
    DimDate.EnglishMonthName AS MonthName,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey
WHERE DimDate.CalendarYear = 2010
GROUP BY
    DimDate.CalendarYear,
    DimDate.MonthNumberOfYear,
    DimDate.EnglishMonthName
ORDER BY
    DimDate.MonthNumberOfYear;

/*------------------------------------- Q.9 -------------------------------------- */
SELECT
    DimDate.CalendarYear AS Year,
    DimDate.MonthNumberOfYear AS MonthNo,
    DimDate.EnglishMonthName AS MonthName,
    COUNT(*) AS SalesRows,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey
GROUP BY
    DimDate.CalendarYear,
    DimDate.MonthNumberOfYear,
    DimDate.EnglishMonthName
ORDER BY
    DimDate.CalendarYear,
    DimDate.MonthNumberOfYear;
    
/*------------------------------------------ Q.8 ---------------------------------------------------------*/
SELECT
    DimDate.CalendarYear AS Year,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey
GROUP BY
    DimDate.CalendarYear
ORDER BY
    DimDate.CalendarYear;
 
/*------------------------------------------------------- Q.9 --------------------------------------------------*/
SELECT
    DimDate.MonthNumberOfYear AS MonthNo,
    DimDate.EnglishMonthName AS MonthName,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey
GROUP BY
    DimDate.MonthNumberOfYear,
    DimDate.EnglishMonthName
ORDER BY
    DimDate.MonthNumberOfYear;
    
/*---------------------------------------------------- Q.10 ------------------------------------------------*/
SELECT
    CONCAT('Q', DimDate.CalendarQuarter) AS Quarter,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey
GROUP BY
    DimDate.CalendarQuarter
ORDER BY
    DimDate.CalendarQuarter;
    
/*--------------------------------------- Q.11 ---------------------------------------------*/
SELECT
    DimDate.CalendarYear AS Year,

    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS SalesAmount,

    SUM(
        SALES.ProductStandardCost
        * SALES.OrderQuantity
    ) AS ProductionCost

FROM SALES
LEFT JOIN DimDate
    ON SALES.OrderDateKey = DimDate.DateKey

GROUP BY
    DimDate.CalendarYear

ORDER BY
    DimDate.CalendarYear;
    
/*------------------------------------------------- Q.12 ---------------------------------------------*/
SELECT
    COUNT(DISTINCT SALES.ProductKey) AS TotalProducts
FROM SALES;

SELECT
    COUNT(DISTINCT SALES.CustomerKey) AS TotalCustomers
FROM SALES;

SELECT
    COUNT(DISTINCT SALES.SalesTerritoryKey) AS TotalTerritories
FROM SALES;

SELECT
    DimSalesTerritory.SalesTerritoryRegion AS Region,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimSalesTerritory
    ON SALES.SalesTerritoryKey = DimSalesTerritory.SalesTerritoryKey
GROUP BY
    DimSalesTerritory.SalesTerritoryRegion
ORDER BY
    TotalSales DESC;
    
SELECT
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES;

SELECT
    DimProduct.EnglishProductName AS ProductName,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimProduct
    ON SALES.ProductKey = DimProduct.ProductKey
GROUP BY
    DimProduct.EnglishProductName
ORDER BY
    TotalSales DESC
LIMIT 10;

SELECT
    CONCAT(
        DimCustomer.FirstName,
        ' ',
        DimCustomer.LastName
    ) AS CustomerFullName,
    SUM(
        SALES.UnitPrice
        * SALES.OrderQuantity
        * (1 - SALES.UnitPriceDiscountPct)
    ) AS TotalSales
FROM SALES
LEFT JOIN DimCustomer
    ON SALES.CustomerKey = DimCustomer.CustomerKey
GROUP BY
    DimCustomer.CustomerKey,
    DimCustomer.FirstName,
    DimCustomer.LastName
ORDER BY
    TotalSales DESC
LIMIT 10;