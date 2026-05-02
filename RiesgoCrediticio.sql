
SELECT TOP 10 *
FROM dbo.credito_limpio
GO


-- =============================================
-- PROYECTO: RIESGO CREDITICIO BANCARIO
-- Dataset: Give Me Some Credit
-- =============================================

-- 1. DISTRIBUCION GENERAL DE MORA
SELECT 
    Mora_texto AS Estado,
    COUNT(*) AS Total_Clientes,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Porcentaje
FROM dbo.credito_limpio
GROUP BY Mora_texto
GO

-- 2. TASA DE MORA POR RANGO DE EDAD
SELECT 
    CASE 
        WHEN age BETWEEN 21 AND 30 THEN '21-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 60 THEN '51-60'
        WHEN age BETWEEN 61 AND 70 THEN '61-70'
        WHEN age BETWEEN 71 AND 80 THEN '71-80'
        ELSE '80+' 
    END AS Rango_Edad,
    COUNT(*) AS Total_Clientes,
    SUM(SeriousDlqin2yrs) AS Clientes_En_Mora,
    CAST(AVG(CAST(SeriousDlqin2yrs AS FLOAT)) * 100 AS DECIMAL(5,2)) AS Tasa_Mora_Pct
FROM dbo.credito_limpio
GROUP BY 
    CASE 
        WHEN age BETWEEN 21 AND 30 THEN '21-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 60 THEN '51-60'
        WHEN age BETWEEN 61 AND 70 THEN '61-70'
        WHEN age BETWEEN 71 AND 80 THEN '71-80'
        ELSE '80+' 
    END
ORDER BY Tasa_Mora_Pct DESC
GO


-- 3. TASA DE MORA POR NIVEL DE INGRESOS
SELECT 
    CASE 
        WHEN MonthlyIncome BETWEEN 500 AND 10500 THEN '500-10,500'
        WHEN MonthlyIncome BETWEEN 10501 AND 20500 THEN '10,501-20,500'
        WHEN MonthlyIncome BETWEEN 20501 AND 30500 THEN '20,501-30,500'
        WHEN MonthlyIncome BETWEEN 30501 AND 40500 THEN '30,501-40,500'
        WHEN MonthlyIncome BETWEEN 40501 AND 50500 THEN '40,501-50,500'
        ELSE 'Mayor a 50,500'
    END AS Rango_Ingreso,
    COUNT(*) AS Total_Clientes,
    SUM(SeriousDlqin2yrs) AS Clientes_En_Mora,
    CAST(AVG(CAST(SeriousDlqin2yrs AS FLOAT)) * 100 AS DECIMAL(5,2)) AS Tasa_Mora_Pct
FROM dbo.credito_limpio
GROUP BY 
    CASE 
        WHEN MonthlyIncome BETWEEN 500 AND 10500 THEN '500-10,500'
        WHEN MonthlyIncome BETWEEN 10501 AND 20500 THEN '10,501-20,500'
        WHEN MonthlyIncome BETWEEN 20501 AND 30500 THEN '20,501-30,500'
        WHEN MonthlyIncome BETWEEN 30501 AND 40500 THEN '30,501-40,500'
        WHEN MonthlyIncome BETWEEN 40501 AND 50500 THEN '40,501-50,500'
        ELSE 'Mayor a 50,500'
    END
ORDER BY Tasa_Mora_Pct DESC
GO


-- 4. TASA DE MORA POR NIVEL DE DEUDA (DebtRatio)
SELECT 
    CASE 
        WHEN DebtRatio BETWEEN 0 AND 0.2 THEN '0.0-0.2'
        WHEN DebtRatio BETWEEN 0.2 AND 0.4 THEN '0.2-0.4'
        WHEN DebtRatio BETWEEN 0.4 AND 0.6 THEN '0.4-0.6'
        WHEN DebtRatio BETWEEN 0.6 AND 0.8 THEN '0.6-0.8'
        WHEN DebtRatio BETWEEN 0.8 AND 1.0 THEN '0.8-1.0'
        ELSE 'Mayor a 1.0'
    END AS Rango_Deuda,
    COUNT(*) AS Total_Clientes,
    SUM(SeriousDlqin2yrs) AS Clientes_En_Mora,
    CAST(AVG(CAST(SeriousDlqin2yrs AS FLOAT)) * 100 AS DECIMAL(5,2)) AS Tasa_Mora_Pct
FROM dbo.credito_limpio
GROUP BY 
    CASE 
        WHEN DebtRatio BETWEEN 0 AND 0.2 THEN '0.0-0.2'
        WHEN DebtRatio BETWEEN 0.2 AND 0.4 THEN '0.2-0.4'
        WHEN DebtRatio BETWEEN 0.4 AND 0.6 THEN '0.4-0.6'
        WHEN DebtRatio BETWEEN 0.6 AND 0.8 THEN '0.6-0.8'
        WHEN DebtRatio BETWEEN 0.8 AND 1.0 THEN '0.8-1.0'
        ELSE 'Mayor a 1.0'
    END
ORDER BY Tasa_Mora_Pct DESC
GO

-- 5. PERFIL DEL CLIENTE EN MORA VS SIN MORA
SELECT 
    Mora_texto AS Estado,
    CAST(AVG(age) AS DECIMAL(5,1)) AS Edad_Promedio,
    CAST(AVG(MonthlyIncome) AS DECIMAL(10,2)) AS Ingreso_Promedio,
    CAST(AVG(DebtRatio) AS DECIMAL(5,2)) AS DebtRatio_Promedio,
    CAST(AVG(CAST(NumberOfOpenCreditLinesAndLoans AS FLOAT)) AS DECIMAL(5,1)) AS Creditos_Abiertos_Prom,
    CAST(AVG(CAST(NumberOfDependents AS FLOAT)) AS DECIMAL(5,1)) AS Dependientes_Prom
FROM dbo.credito_limpio
GROUP BY Mora_texto
GO