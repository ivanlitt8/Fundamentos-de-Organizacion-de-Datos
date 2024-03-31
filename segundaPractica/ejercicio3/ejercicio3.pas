{
	El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
	de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
	productos que comercializa. De cada producto se maneja la siguiente información: código de
	producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
	genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
	cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
	realizar un programa con opciones para:

	a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
		● Ambos archivos están ordenados por código de producto.
		● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
		archivo detalle.
		● El archivo detalle sólo contiene registros que están en el archivo maestro.

	b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
	stock actual esté por debajo del stock mínimo permitido
   
}

program ejercicio3;
const
	valorAlto = 9999;
type
	producto = record
		id: integer;
		nombre: string[15];
		precio: real;
		stockAct: integer;
		stockMin: integer;
	end;
	registro = record
		id: integer;
		cantidadVenta: integer;
	end;
	archivoProductos = file of producto;
	archivoDetalle = file of registro;
procedure leerMaestro (var arch: Text; var P: producto);
begin
	readln(arch,P.id,P.nombre,P.precio,P.stockAct,P.stockMin);
	writeln(P.id,' ',P.nombre,' ',P.precio:0:2,' ',P.stockAct,' ',P.stockMin);
end;
procedure leerDetalle (var arch: Text; var R: registro);
begin
	readln(arch,R.id,R.cantidadVenta);
	writeln(R.id,' ',R.cantidadVenta);
end;
procedure generarArchivoMaestro(var txtMaestro: Text ; var arch: archivoProductos);
var
	P: producto;
begin
	reset(txtMaestro);
	while not eof(txtMaestro) do begin
		leerMaestro(txtMaestro,P);
		write(arch,P);
	end;	
	close(arch);
	close(txtMaestro);
end;
procedure generarArchivoDetalle(var txtDetalle: Text ; var arch: archivoDetalle);
var
	R: registro;
begin
	reset(txtDetalle);
	while not eof(txtDetalle) do begin
		leerDetalle(txtDetalle,R);
		write(arch,R);
	end;	
	close(arch);
	close(txtDetalle);
end;
procedure leerDetalleDat ( var arch: archivoDetalle ; var R: registro);
begin
	if not eof (arch) then
		read(arch,R)
	else
		R.id:= valorAlto;
end;
procedure actualizarMaestro ( var maestro: archivoProductos; var detalle: archivoDetalle);
var
	R: registro;
	P: producto;
begin
	reset(maestro);
	reset(detalle);
	leerDetalleDat(detalle,R);
	while(R.id<>valorAlto) do begin
		read(maestro,P);
		while(R.id<>P.id) do begin
			read(maestro,P);
		end;
		while(R.id<>valorAlto)and(R.id=P.id) do begin
			P.stockAct:= P.stockAct - R.cantidadVenta;
			leerDetalleDat(detalle,R);
		end;
		seek(maestro, filepos(maestro)-1);
		write(maestro, P);
	end;
	close(maestro);
	close(detalle);
end;
procedure listarStockMinimo( var arch: archivoProductos);
var
	P: producto;
	listado: Text;
begin
	assign(listado,'stock_minimo.txt');
	rewrite(listado);
	reset(arch);
	while not eof(arch) do begin
		read(arch,P);
		if(P.stockAct<P.stockMin) then begin
			writeln(listado,P.id,' ',P.nombre,' ',P.precio:0:2,' ',P.stockAct,' ',P.stockMin);
			writeln('** El producto con id ',P.id,' tiene stock menor al minimo permitido.');
		end;
	end;
	close(arch);
	close(listado);
	writeln('Los productos con stock actual debajo del stock minimo se exportaron stock_minimo.txt.');
end;
procedure imprimirMaestro (var arch: archivoProductos);
var
	P: producto;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,P);
		writeln('Producto id: ',P.id,' - Nombre:',P.nombre);
		writeln('Precio: ',P.precio:0:2,' - Stock Actual: ',P.stockAct,' - Stock Minimo: ',P.stockMin);
		writeln();
	end;
	close(arch);
end;
var
	datDetalle: archivoDetalle;
	datMaestro: archivoProductos;
	txtMaestro: Text;
	txtDetalle: Text;
begin
	assign(txtMaestro,'productos.txt');
    assign(txtDetalle,'detalle.txt');
    assign(datMaestro,'alumnos.dat');
    assign(datDetalle,'detalle.dat');
    rewrite(datDetalle);
    rewrite(datMaestro);
    writeln('----- Archivo Maestro -----');
    writeln();
    generarArchivoMaestro(txtMaestro,datMaestro);
    writeln('---------------------------');
    writeln();
    writeln('----- Archivo Detalle -----');
    writeln();
    generarArchivoDetalle(txtDetalle,datDetalle);
	actualizarMaestro(datMaestro,datDetalle);
	writeln('---------------------------');
    writeln();
	writeln('Archivo Maestro actualizado: ');
    writeln();
	imprimirMaestro(datMaestro);
	listarStockMinimo(datMaestro);
end.
