#universidad #grado
![[Pasted image 20260112184650.png]]
---
# SQL/OLAP

Las operaciones SQL/OLAP extienden el SQL estándar para facilitar el análisis de datos multidimensionales, solucionando la ineficiencia de realizar múltiples `GROUP BY` unidos con `UNION` o el problema de perder el detalle de las filas al agregar.

---

## 1. Extensiones de GROUP BY

Estas operaciones permiten calcular múltiples niveles de agregación en una sola consulta.

### 🔹 ROLLUP

Calcula subtotales jerárquicos basados en el orden de la lista de atributos. Genera $N+1$ agrupaciones. **Debemos usarla cuando hay jerarquías implícitas en los datos**. Si agrupas por `(Pais, Ciudad)`, ROLLUP asume que la Ciudad pertenece al País. Por tanto, te dará el total por País, pero **nunca** te dará el total por Ciudad independientemente del País (porque no tendría sentido sumar ciudades de países distintos si fuera una jerarquía estricta).

- **Uso:** Ideal para jerarquías (ej. País -> Provincia -> Ciudad).
- **Ejemplo:** Calcula ventas por Producto y Cliente, subtotales por Producto, y el gran total.

```SQL
SELECT ProductKey, CustomerKey, SUM(SalesAmount)
FROM Sales
GROUP BY ROLLUP(ProductKey, CustomerKey)
```

### 🔹 CUBE

Calcula **todas** las combinaciones posibles de subtotales para las dimensiones dadas. Genera $2^N$ agrupaciones.

- **Uso:** Cuando se necesitan cruces de todas las dimensiones sin importar la jerarquía (análisis simétrico).
- **Ejemplo:** Calcula ventas por Producto-Cliente, solo por Producto, solo por Cliente y el gran total.

```SQL
SELECT ProductKey, CustomerKey, SUM(SalesAmount)
FROM Sales
GROUP BY CUBE(ProductKey, CustomerKey)
```

### 🔹 GROUPING SETS

Es el operador general. Permite especificar explícitamente qué grupos de columnas exactos se desean agregar. `ROLLUP` y `CUBE` son abreviaturas de este operador.

- **Ejemplo:** Equivalente a las agrupaciones generadas por el ROLLUP anterior.

```SQL
SELECT ProductKey, CustomerKey, SUM(SalesAmount)
FROM Sales
GROUP BY GROUPING SETS((ProductKey, CustomerKey), (ProductKey), ())
```

---

## 2. Funciones de Ventana (Window Functions)

Permiten realizar cálculos agregados sobre un conjunto de filas relacionadas (ventana) **sin colapsar** las filas individuales. Se definen mediante la cláusula `OVER`.

### 🪟 Window Partitioning (Particionamiento)

Divide el resultado en particiones para aplicar la función de agregación, manteniendo el detalle de la fila original.

- **Objetivo:** Comparar datos detallados con valores agregados (ej. cuota de mercado, comparativa con máximos).
- **Ejemplo:** Muestra cada venta individual junto con la venta _máxima_ de ese producto específico.

```SQL
SELECT ProductKey, CustomerKey, SalesAmount,
       MAX(SalesAmount) OVER (PARTITION BY ProductKey) AS MaxAmount
FROM Sales
```

**En el examen, si piden generar un ranking, hay que pensar automáticamente en esta función**. 
#### Ranking
```SQL
ROW_NUMBER() OVER (
    PARTITION BY <COLUMNAS_GRUPO> 
    ORDER BY <MEDIDA_A_COMPARAR> DESC
) AS Ranking
```

Cómo rellenar los huecos en el examen:

1. **<COLUMNAS_GRUPO>** **(El Reinicio):** Pregúntate: _"¿Cuándo debe volver a empezar el ranking desde el número 1?"_.
    ◦ Si el enunciado dice: "Ranking de productos **por Año** y **por País**".
    ◦ Entonces: `PARTITION BY Year, Country`.

2. **<MEDIDA_A_COMPARAR>** **(El Criterio):** Pregúntate: _"¿Qué determina quién gana?"_.
    ◦ Si el enunciado dice: "Los **más vendidos**" o "Mayor importe".
    ◦ Entonces: `ORDER BY SUM(SalesAmount) DESC`. (Usa `DESC` para que el mayor sea el 1º).

#### Ejemplo
-- ranking de los productos vendidos por año, para cada empleado de estados unidos
```SQL
SELECT P.ProductName, T.Year, CONCAT(E.FirstName,' ',E.LastName) as
Empleado, SUM(S.SalesAmount) as TotalVentas,

ROW_NUMBER() over (
partition by CONCAT(E.FirstName,' ',E.LastName), T.Year 
order by SUM(S.SalesAmount) desc) as rowno

FROM Sales S, Product P, Time T, Employee E
WHERE S.ProductKey = P.ProductKey AND S.OrderDateKey = T.TimeKey
AND E.EmployeeKey = S.EmployeeKey AND E.Country = 'USA'
GROUP BY P.ProductName, T.Year,CONCAT(E.FirstName,' ',E.LastName)
ORDER BY CONCAT(E.FirstName,' ',E.LastName),T.Year,rowno
```
En este caso, *queremos reiniciar el ranking cuando cambiemos de empleado, y, por empleado, cuando cambiemos de año*. Es por esto que realizamos el partition by primero por empleado, y luego por año. 
### 🔢 Window Ordering (Ordenación)

Ordena las filas _dentro_ de una partición específica. Es esencial para funciones de ranking.

- **Objetivo:** Calcular rankings, top N, o asignar números de fila secuenciales.
- **Ejemplo:** Asigna un número de ranking a cada venta de un cliente, ordenadas de mayor a menor importe.

```SQL
SELECT ProductKey, CustomerKey, SalesAmount,
       ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY SalesAmount DESC) AS RowNo
FROM Sales
```

#### Nota:
Hay que tener en cuenta que muchas veces el OVER se utiliza para poder tomar datos más agregados que la granularidad que queremos. Por ejemplo:
```SQL
SELECT 
    P.ProductName, 
    CONCAT(E.FirstName, ' ', E.LastName) as Empleado, 
    -- 1. La venta de ESTE empleado
    SUM(S.SalesAmount) as TotalVentas,
    
    -- 2. La venta MÁXIMA lograda por CUALQUIER empleado para este producto
    MAX(SUM(S.SalesAmount)) OVER (PARTITION BY P.ProductName) as MaximaVenta,
    
    -- 3. La DIFERENCIA 
    SUM(S.SalesAmount) - MAX(SUM(S.SalesAmount)) OVER (PARTITION BY P.ProductName) as Diff

FROM Sales S
JOIN Employee E on S.EmployeeKey = E.EmployeeKey
JOIN Product P on S.ProductKey = P.ProductKey 
WHERE E.Country = 'USA' 
GROUP BY P.ProductName, CONCAT(E.FirstName, ' ', E.LastName)
ORDER BY P.ProductName;
```

Empezamos con ProductName - Empleado - SUM(S.SalesAmount), al llegar hasta aquí, ya sabemos que GROUP BY debería de darnos las ventas totales por producto, para cada empleado. Sin embargo, **queremos comparar con la venta máxima de un producto, independientemente del empleado**. Para ello, hacemos un OVER PARTITION de P.ProductName, y desagregamos un nivel.

### 🖼️ Window Framing (Encuadre)

Define el tamaño exacto de la ventana (subconjunto de filas) dentro de la partición relativa a la fila actual. Se usa para cálculos de series temporales.

#### A. Media Móvil (Moving Average)

Define una ventana deslizante de tamaño fijo.

- **Ejemplo:** Calcula el promedio de ventas del mes actual y los 2 meses anteriores.

```SQL
SELECT ProductKey, Year, Month, SalesAmount,
       AVG(SalesAmount) OVER (PARTITION BY ProductKey
                              ORDER BY Year, Month
                              ROWS 2 PRECEDING) AS MovAvg
FROM Sales
```

#### B. Acumulado (Year-To-Date / Running Total)

Define una ventana que crece desde el inicio de la partición hasta la fila actual.

- **Ejemplo:** Suma acumulada de ventas desde el inicio del año hasta el mes actual.

```SQL
SELECT ProductKey, Year, Month, SalesAmount,
       SUM(SalesAmount) OVER (PARTITION BY ProductKey, Year
                              ORDER BY Month
                              ROWS UNBOUNDED PRECEDING) AS YTD
FROM Sales
```

## 3. Otras consultas para practicar

1. **Ranking de contribución trimestral por empleado:** Calcular las ventas totales de cada empleado por trimestre y año. Luego, mostrar solo aquellos empleados que hayan contribuido con más del 10% del total de ventas de la empresa en ese trimestre específico.

2. **Análisis de Pareto de Clientes (Acumulado 80/20):** Listar los clientes ordenados de mayor a menor venta, mostrando el porcentaje acumulado de ingresos que representan. Esto sirve para identificar el 20% de clientes que generan el 80% de los beneficios (principio de Pareto).

3. **Comparativa de ventas con el mes anterior (Crecimiento mensual):** Para cada producto, mostrar las ventas del mes actual y las ventas del mes inmediatamente anterior, calculando la diferencia (crecimiento o decrecimiento).

4. **Categorías "Dominantes" por País:** Identificar aquellos Países donde una sola Categoría de productos representa más del 50% de las ventas totales de dicho país.

5. **Gap con el líder:** Para cada ciudad de Estados Unidos, mostrar sus ventas anuales y cuánto le falta para alcanzar a la ciudad con mayores ventas de ese mismo año (Diferencia respecto al máximo).