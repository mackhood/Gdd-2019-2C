
Alter trigger tr_ejemplo on Factura after insert
as 
begin transaction
declare @clie char(6)
declare @monto decimal(12,2)
declare ins_curs cursor for
				select fact_cliente,sum(fact_total) from inserted
				group by fact_cliente
	open ins_curs 
	fetch ins_curs into @clie,@monto
	while @@FETCH_STATUS = 0
	begin
		update Cliente set clie_limite_credito = clie_limite_credito + @monto where clie_codigo = @clie
		fetch ins_curs into @clie,@monto
	end
close ins_curs
deallocate ins_curs
commit transaction



insert into Factura (fact_tipo,fact_sucursal,fact_numero,fact_cliente,fact_total) values ('B','003','01100051','01634',1000)

select * from Cliente where clie_codigo = 01634;

GO

Alter trigger tr_ejemplo on Factura after insert,update,delete
as 
begin transaction
declare @clie char(6)
declare @monto decimal(12,2)
declare ins_curs cursor for
				select fact_cliente,sum(fact_total) from inserted
				group by fact_cliente
	union 
	select fact_cliente,-1*sum(fact_total) from deleted 
	group by fact_cliente
	open ins_curs 
	fetch ins_curs into @clie,@monto
	while @@FETCH_STATUS = 0
	begin
		update Cliente set clie_limite_credito = clie_limite_credito + @monto where clie_codigo = @clie
		fetch ins_curs into @clie,@monto
	end
close ins_curs
deallocate ins_curs
commit transaction

delete from Factura where fact_cliente = 01634;
select * from Cliente where clie_codigo = 01634;

select * from Factura where fact_cliente = 01634;

update Factura 
set fact_total = -105
where fact_cliente =01634;

select * from Inserted


GO
create trigger tr_2 on cliente
instead of delete
as 
begin transaction
declare @clie char(6)
declare del_curs cursor for 
		select clie_codigo from deleted
	open del_curs
	fetch del_curs into @clie
	while @@FETCH_STATUS = 0
	begin
		delete Item_Factura where exists ( select 1 from Factura where fact_cliente = @clie and fact_sucursal = item_sucursal
		and fact_numero = item_numero and fact_tipo = item_tipo)
		delete Factura where fact_cliente = @clie
		delete Cliente where clie_codigo = @clie
		fetch del_curs into @clie
	end
close del_curs
deallocate del_curs
commit




--implemente el /los objetos necesarios para que cada vez que se guarde en una factura un producto compuesto en
--la misma queden guardados sus componentes

--hecho por nosotros

create trigger tr_3 on Item_factura
instead of insert
as 
begin transaction
declare @item_tipo char(1)
declare @item_sucursal char(4)
declare @item_numero char(8)
declare @item_producto char(8)
declare @item_cantidad decimal(12,2)
declare @item_precio decimal(12,2)
declare new_curs cursor for 
		select item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio from inserted
	open new_curs
	fetch new_curs into @item_tipo,@item_sucursal,@item_numero,@item_producto, @item_cantidad,@item_precio
	while @@FETCH_STATUS = 0
	begin
			
		if not exists (
			 select 1 from Composicion where comp_producto = @item_producto )
			 begin
				insert into Item_Factura (item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio) values( @item_tipo, @item_sucursal,
		 @item_numero, @item_producto, @item_cantidad,@item_precio)
			end
		 else 
		 begin
			 insert into Item_Factura (item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio) 
		 (select @item_tipo,@item_sucursal,@item_numero,p.prod_codigo,p.prod_precio*(c.comp_cantidad*@item_cantidad) ,c.comp_cantidad *@item_cantidad from Producto p join Composicion c on p.prod_codigo = c.comp_componente
		  where c.comp_producto = @item_producto)
		  end
		fetch new_curs into @item_tipo,@item_sucursal,@item_numero,@item_producto, @item_cantidad,@item_precio
	end
close del_curs
deallocate del_curs
commit

--esta bien hecho
----------------------------------------------

--hecho por el profe


create trigger tr_4 on Item_Factura instead of insert
as 
begin transaction
	insert into Item_Factura (item_tipo,item_sucursal,item_numero,item_producto,item_cantidad,item_precio)
	select item_tipo,item_sucural,item_numero,isnull(comp_componente,item_produco),item_cantidad* isnull(comp_cantidad,1)
	,dbo.calc_precio(comp_componente,item_producto)
	from inserted join producto on item_producto = prod_codigo
	left join Composicion on prod_codigo = comp_producto

commit

--falla xq si trata de meter un cmbo con hamburguesa , y una hambuerguesa separado rompe por la pk
	









