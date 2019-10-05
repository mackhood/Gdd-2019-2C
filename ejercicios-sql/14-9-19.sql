-----ej 6

select rubr_id, rubr_detalle, count(ISNULL(p.prod_codigo,0)), sum(ISNULL(s.stoc_cantidad,0)) from Rubro r
left join Producto p on r.rubr_id = p.prod_rubro
left join STOCK s on s.stoc_producto = p.prod_codigo
group by rubr_id, rubr_detalle
having sum(ISNULL(s.stoc_cantidad,0)) > (select sum(ISNULL(s2.stoc_cantidad,0)) from STOCK s2 
		where s2.stoc_deposito = '00' and s2.stoc_producto = '00000000')
order by rubr_id ASC;


SELECT 
	rubr_id AS 'Codigo', 
	rubr_detalle AS 'Rubro', 
	COUNT(DISTINCT prod_codigo) AS 'Articulos',
	SUM(stoc_cantidad) AS 'Stock total'
FROM Rubro
JOIN Producto ON rubr_id = prod_rubro
JOIN STOCK ON prod_codigo = stoc_producto
WHERE (SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = prod_codigo) >
(SELECT stoc_cantidad FROM STOCK WHERE stoc_producto = '00000000' AND stoc_deposito = '00')
GROUP BY rubr_id, rubr_detalle;
-----ej 7

--hecho por nosotros
select p.prod_codigo, p.prod_detalle
,max(it.item_precio),min(it.item_precio),((max(it.item_precio)-min(it.item_precio))/(min(it.item_precio)))*100
 from Producto p
join Item_Factura it on it.item_producto = p.prod_codigo 
join Stock s on s.stoc_producto = p.prod_codigo
group by p.prod_codigo,p.prod_detalle
having sum(s.stoc_cantidad) >0;


---el apunte magico

SELECT 
	prod_codigo AS 'Codigo',
	prod_detalle AS 'Producto', 
	MAX(item_precio) AS 'Precio maximo', 
	MIN(item_precio) AS 'Precio minimo',
	CAST(((MAX(item_precio) - MIN(item_precio)) / MIN(item_precio)) * 100 AS DECIMAL(10,2)) AS 'Diferencia'
FROM Producto
JOIN Item_Factura ON prod_codigo = item_producto
JOIN STOCK ON prod_codigo = stoc_producto
GROUP BY prod_codigo, prod_detalle
HAVING SUM(stoc_cantidad) > 0;


--ej 8

--hecho por nosotros(esta bien)
select p.prod_detalle, max(s.stoc_cantidad)
from Producto p join Stock s on p.prod_codigo = s.stoc_producto
group by stoc_producto, p.prod_detalle
having COUNT(DISTINCT stoc_deposito) = (select count(*) from DEPOSITO);



--ej 9


select  from Empleado empleado join Empleado



--ej 10





 --hecho por el profe bien
select prod_codigo,prod_detalle,(select top 1 fact_cliente from Factura join Item_Factura on fact_sucursal = item_sucursal and fact_tipo = item_tipo
where item_producto = prod_codigo 
group by fact_cliente
order by sum(item_precio*item_cantidad) desc)
from Producto
where prod_codigo in (select top 10 i2.item_producto   from Item_Factura i2 group by item_producto
order by sum(i2.item_precio *i2.item_cantidad) desc)
or
prod_codigo in (select top 10 i2.item_producto   from Item_Factura i2 group by item_producto
order by sum(i2.item_precio *i2.item_cantidad) asc);




--ej 15

select p1.prod_codigo,p1.prod_detalle,p2.prod_codigo,p2.prod_detalle,count(*) as total_vend
from Producto p1 join Item_Factura it1 on p1.prod_codigo = it1.item_producto
join Factura f1 on it1.item_tipo = f1.fact_tipo and it1.item_sucursal = f1.fact_sucursal 
and f1.fact_numero = it1.item_numero
join Item_Factura it2 ON it2.item_tipo = f1.fact_tipo  and it2.item_sucursal = f1.fact_sucursal 
and f1.fact_numero = it2.item_numero
join Producto p2 on p2.prod_codigo = it2.item_producto 
where p1.prod_codigo > p2.prod_codigo
group by p1.prod_codigo,p1.prod_detalle,p2.prod_codigo,p2.prod_detalle
having count(*) > 500;

--ejercicio dado por el profe
--mostrar todos los productos pero si no es compuesto muestre sin composicion
--combo 1,gaseosa,1
--combo1 ,hamb,1

use GD2015C1

select p.prod_detalle, isnull(p2.prod_detalle,'Sin Componentes'), isnull(comp.comp_cantidad,0) 
from Producto p left join Composicion comp on comp.comp_producto= p.prod_codigo left
join Producto p2 on (comp.comp_componente = p2.prod_codigo)
order by 2 desc


--Producto, les generemos un valor autonumerico

select   prod_codigo , (cast(prod_codigo as numeric) - (select count(*) from Producto)) from Producto
where prod_codigo NOT LIKE '%[^0-9.-]%'
order by 1 asc


--hecho por el profe

select (select count(*) from Producto p2 where p2.prod_codigo <=p1.prod_codigo) as ordinal,*
from Producto p1
order by prod_codigo asc







