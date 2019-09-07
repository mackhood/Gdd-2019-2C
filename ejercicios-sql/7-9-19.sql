use GD2015C1;

-----GUIA SQL
-----ej.1:
--Hecho por nosotros
select clie_razon_social as Razon_Social_Cliente  from Cliente 
where clie_limite_credito >= 1000
order by clie_codigo;





--Hecho por el profe
select clie_codigo, clie_razon_social from Cliente
where clie_limite_credito >= 1000
order by clie_codigo ASC

-----ej.2:
--hecho por nosotros
select prod_codigo as Producto_Codigo, prod_detalle as Producto_Detalle  
from Producto p join Item_Factura item_f on p.prod_codigo = item_f.item_producto
join Factura F on item_f.item_numero = f.fact_numero and item_f.item_sucursal = f.fact_sucursal
and item_f.item_tipo = f.fact_tipo 
where year(f.fact_fecha)= 2012
group by prod_codigo,prod_detalle
order by sum(item_f.item_cantidad) desc;



--por el profe 
select prod_codigo, prod_detalle from Factura f join Item_Factura ifact
on f.fact_sucursal = ifact.item_sucursal and f.fact_tipo = ifact.item_tipo
and f.fact_numero = ifact.item_numero join Producto p on p.prod_codigo = ifact.item_producto
where year(f.fact_fecha) = 2012
group by prod_codigo,prod_detalle
order by sum(ifact.item_cantidad) desc;


--ej3.

use GD2015C1;
GO
select 1 from Producto;
--hecho por nosotros

select p.prod_codigo , p.prod_detalle    from Producto p
join STOCK s on p.prod_codigo = s.stoc_producto
group by p.prod_codigo,p.prod_detalle
order by p.prod_detalle  ASC


--hecho por el profe

select pr.prod_codigo,pr.prod_detalle,  sum(ISNULL(st.stoc_cantidad,0))
from Producto pr
left join Stock st on pr.prod_codigo = st.stoc_producto
group by pr.prod_codigo,pr.prod_detalle
order by pr.prod_detalle ASC

---
--ej.4

select p1.prod_codigo , p1.prod_detalle,(select sum(c.comp_cantidad) from Composicion c 
where c.comp_producto = p1.prod_codigo)
from Producto p1 join STOCK s on p1.prod_codigo = s.stoc_producto
group by p1.prod_codigo,p1.prod_detalle
having avg(s.stoc_cantidad) >100
order by 3 desc;


---hecho por otro
--funca y esta bien
select p.prod_codigo, p.prod_detalle,(select sum (c.comp_cantidad) from Composicion c
	where c.comp_producto = p.prod_codigo) as Cantidad_Componentes
from Producto p, Stock s
where s.stoc_producto = p.prod_codigo
group by p.prod_codigo,p.prod_detalle
having avg(s.stoc_cantidad)>100
order by 3 DESC;


-----

--ej5

--hecho por nosotros
select p1.prod_codigo,p1.prod_detalle,ISNULL((select sum(ifact.item_cantidad) from Item_Factura ifact join Factura f on
f.fact_tipo = ifact.item_tipo and f.fact_numero = ifact.item_numero and f.fact_sucursal = ifact.item_sucursal
where  ifact.item_producto = p1.prod_codigo and year(f.fact_fecha)=2012),0) as Cantidad
from Producto p1 
 
where  ISNULL((select  sum(ifact.item_cantidad) from Item_Factura ifact join Factura f on
f.fact_tipo = ifact.item_tipo and f.fact_numero = ifact.item_numero and f.fact_sucursal = ifact.item_sucursal
where  ifact.item_producto = p1.prod_codigo and year(f.fact_fecha)=2012),0) > ISNULL((select count(*) from Item_Factura ifact join Factura f on
f.fact_tipo = ifact.item_tipo and f.fact_numero = ifact.item_numero and f.fact_sucursal = ifact.item_sucursal
where  ifact.item_producto = p1.prod_codigo and year(f.fact_fecha)=2011),0)
 

select top 1 * from cliente;







 









