/*
****************************************
1. Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas
realizadas en enero 2020 sea superior a 1500.
****************************************
*/
SELECT
  c.customer_id,
  c.email,
  c.nombre,
  c.apellido
FROM
  Customer c
  INNER JOIN Invoice i ON c.customer_id = i.customer_id
WHERE
  MONTH(i.fecha) = 1
  AND YEAR(i.fecha) = 2020
  AND EXTRACT(
    MONTH
    FROM
      c.fecha_nacimiento
  ) = EXTRACT(
    MONTH
    FROM
      CURRENT_DATE
  )
  AND EXTRACT(
    DAY
    FROM
      c.fecha_nacimiento
  ) = EXTRACT(
    DAY
    FROM
      CURRENT_DATE
  )
GROUP BY
  c.customer_id,
  c.email,
  c.nombre,
  c.apellido
HAVING
  COUNT(i.invoice_id) > 1500;
  
  /*
  ****************************************
  2. Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la
  categoría Celulares. Se requiere el mes y año de análisis, nombre y apellido del
  vendedor, cantidad de ventas realizadas, cantidad de productos vendidos y el monto
  total transaccionado.
  ****************************************
  */
  WITH MonthlySales AS (
    SELECT
      YEAR(i.fecha) AS anio,
      MONTH(i.fecha) AS mes,
      c.customer_id AS customer_id,
      c.nombre,
      c.apellido,
      COUNT(i.invoice_id) AS cantidad_ventas,
      SUM(ii.cantidad) AS cantidad_productos_vendidos,
      SUM(ii.precio_unitario * ii.cantidad) AS monto_total_transaccionado,
      ROW_NUMBER() OVER (
        PARTITION BY YEAR(i.fecha),
        MONTH(i.fecha)
        ORDER BY
          SUM(ii.precio_unitario * ii.cantidad) DESC
      ) AS rn
    FROM
      Invoice i
      INNER JOIN Customer c ON i.customer_id = c.customer_id
      INNER JOIN InvoiceDetail ii ON i.invoice_id = ii.invoice_id
      INNER JOIN Item it ON ii.item_id = it.item_id
      INNER JOIN Category cat ON it.category_id = cat.category_id
    WHERE
      YEAR(i.fecha) = 2020
      AND cat.descripcion = 'Celulares'
    GROUP BY
      YEAR(i.fecha),
      MONTH(i.fecha),
      c.customer_id,
      c.nombre,
      c.apellido
  )
SELECT
  anio,
  mes,
  nombre,
  apellido,
  cantidad_ventas,
  cantidad_productos_vendidos,
  monto_total_transaccionado
FROM
  MonthlySales
WHERE
  rn <= 5
ORDER BY
  anio,
  mes,
  rn;