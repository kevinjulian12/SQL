use GD2015C1;

--1. Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea
--mayor o igual a $ 1000 ordenado por código de cliente

select clie_codigo,clie_razon_social from Cliente
where clie_limite_credito>=1000 order by clie_codigo;

--2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados
--por cantidad vendida.

select /*prod_codigo,prod_detalle*/ * from Producto
inner join Item_Factura i 
on prod_codigo = i.item_producto
inner join Factura f
on i.item_numero=f.fact_numero
where DATEPART(year,fact_fecha)=2012
order by i.item_cantidad

--3. Realizar una consulta que muestre código de producto, nombre de producto y el
--stock total, sin importar en que deposito se encuentre, los datos deben ser ordenados
--por nombre del artículo de menor a mayor.

select prod_codigo, prod_detalle,s.stoc_cantidad from Producto
inner join STOCK s
on prod_codigo = s.stoc_producto
order by prod_detalle

--4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad
--de artículos que lo componen. Mostrar solo aquellos artículos para los cuales el
--stock promedio por depósito sea mayor a 100. 

select prod_codigo,prod_detalle,comp_cantidad from Producto
inner join Composicion C
on prod_codigo=C.comp_producto
inner join STOCK s
on prod_codigo = s.stoc_producto
where s.stoc_stock_maximo>100

--5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos
--de stock que se realizaron para ese artículo en el año 2012 (egresan los productos
--que fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el
--2011. 

select prod_codigo, prod_detalle,stoc_cantidad from Producto
inner join Item_Factura i
on prod_codigo = i.item_producto
inner join Factura f
on i.item_sucursal = f.fact_sucursal
inner join STOCK s
on prod_codigo=s.stoc_producto
where YEAR(f.fact_fecha)=2011 and YEAR(f.fact_fecha)=2012

select* from Item_Factura



select year(f.fact_fecha) año,

	   p.prod_familia FAMILIA_MAS_VENDIDA,

	   (select count(p2.prod_rubro) 
	    from Producto p2
	    where p2.prod_familia = p.prod_familia) CANTIDAD_RUBROS, 
	   
	   (select count(comp_componente)
	    from Composicion c
		join Producto p2 on c.comp_producto = p2.prod_codigo
	    where p2.prod_familia = p.prod_familia and
	          p2.prod_codigo = (select top 1 item_producto 
	  					        from Item_Factura 
	  					        group by item_producto 
						        order by sum(item_precio * item_cantidad) desc)) COMPONENTES,

	   count(distinct f.fact_tipo + f.fact_sucursal + f.fact_numero) FACTURAS,

	   (select top 1 f2.fact_cliente 
	    from factura f2
		join Item_Factura i2 on i2.item_tipo + i2.item_sucursal + i2.item_numero = f2.fact_tipo + f2.fact_sucursal + f2.fact_numero
	    join Producto p2 ON i2.item_producto = p2.prod_codigo
	    where p2.prod_familia = p.prod_familia
	    group by f2.fact_cliente
	    order by sum(i2.item_cantidad * i2.item_precio) desc) as CLIENTE,

	   (sum(i.item_cantidad * i.item_precio) / (select sum(i2.item_cantidad * i2.item_precio) 
												from Item_Factura i2
												join factura f2 on i2.item_tipo + i2.item_sucursal + i2.item_numero = f2.fact_tipo + f2.fact_sucursal + f2.fact_numero
												where year(f2.fact_fecha) = year(f.fact_fecha)) * 100)	PORCENTAJE,

		--PARA MI ES ASI:
	   (select sum(i2.item_precio * i2.item_cantidad)
		from Item_Factura i2
		join Producto p2 on p2.prod_codigo = i2.item_producto
		where p2.prod_familia = p.prod_familia) * 100 / (select sum(f2.fact_total)
													 from Factura f2
													 where year(f2.fact_fecha) = year(f.fact_fecha)) PORCENTAJE

from Factura f 
join Item_Factura i on f.fact_tipo + f.fact_sucursal + f.fact_numero = i.item_tipo + i.item_sucursal + i.item_numero
join Producto p on i.item_producto = p.prod_codigo
where p.prod_familia = (select top 1 p2.prod_familia
						from Factura f2
						join Item_Factura i2 on f2.fact_tipo + f2.fact_sucursal + f2.fact_numero = i2.item_tipo + i2.item_sucursal + i2.item_numero
						join Producto p2 on i2.item_producto = p2.prod_codigo				 
						group by p2.prod_familia, year(f2.fact_fecha)
						having year(f2.fact_fecha) = year(f.fact_fecha) --esto se puede poner en el where pero acá es menos costoso ponerlo ya que agrupa y va haciendo menos comparaciones
						order by sum(i2.item_precio * i2.item_cantidad) desc) 			 
group by year(f.fact_fecha), p.prod_familia
order by sum(i.item_cantidad * i.item_precio), p.prod_familia desc 