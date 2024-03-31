{
	
	Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
	De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
	stock mínimo y precio del producto.
	Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
	debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
	maestro. La información que se recibe en los detalles es: código de producto y cantidad
	vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
	descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
	debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
	procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
	ventajas/desventajas en cada caso).

	Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
	puede venir 0 o N registros de un determinado producto.
}

program ejercicio5;
const
	valorAlto = 999;
	dimF = 3;
type
	
	rango = 1..dimF;

	maestro = record
		id: integer;
		nombre: string[20];
		descripcion: string[50];
		stockDisp: integer;
		stockMin: integer;
		precio: real;
	end;
	registro = record
		id: integer;
		cantVendida: integer;
	end;
	archivoMaestro = file of maestro;
	archivoDetalle = file of registro;
	
	vectDetalles = array[rango] of archivoDetalle;
	vectRegistros = array[rango] of registro;
	vectString = array[rango] of string;
procedure leerMaestroTxt (var arch: Text; var M: maestro);
begin
	readln(arch,M.id);
	readln(arch,M.nombre);
	readln(arch,M.descripcion);
	readln(arch,M.stockDisp,M.stockMin,M.precio);
	writeln('ID: ', M.id);
	writeln('Nombre: ', M.nombre);
	writeln('Descripcion: ', M.descripcion);
	writeln('Stock disponible: ', M.stockDisp);
	writeln('Stock minimo: ', M.stockMin);
	writeln('Precio: ', M.precio:0:2);
	writeln();
end;
procedure generarArchivoMaestro(var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestroTxt(txt,M);
		write(arch,M);
	end;	
	close(arch);
	close(txt);
end;
procedure leerDetalleTxt (var arch: Text ; var R: registro);
begin
	if not eof(arch) then begin 
		readln(arch,R.id);
		readln(arch,R.cantVendida);
		writeln('id: ', R.id);
		writeln('cantidad: ', R.cantVendida);
	end;
end;
procedure generarDetalle ( var arch: archivoDetalle; nombre: string);
var
	dat,txt: string;
	detalleTxt: Text;
	R: registro;
begin
	txt := nombre + '.txt';
	assign(detalleTxt,txt);
	reset(detalleTxt);
	dat := nombre + '.dat';
	assign(arch,dat);
	rewrite(arch);
	while not eof(detalleTxt) do begin
		leerDetalleTxt(detalleTxt,R);
        write(arch,R);
    end;
    writeln('Archivo detalle ',dat,' exitosamente creado');
    close(detalleTxt);
    close(arch);
end;
procedure generarArchivosDetalles(var V: vectDetalles );
var
	i: rango;
	vNombres: vectString;
begin
	vNombres[1]:= 'detalleUno';
	vNombres[2]:= 'detalleDos';
	vNombres[3]:= 'detalleTres';
	for i:= 1 to dimF do
		generarDetalle(V[i],vNombres[i]);
	writeln('Se han generado todos los detalles.')
end;

procedure imprimirMaestro( var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		writeln('ID: ', M.id);
		writeln('Nombre: ', M.nombre);
		writeln('Descripcion: ', M.descripcion);
		writeln('Stock disponible: ', M.stockDisp);
		writeln('Stock minimo: ', M.stockMin);
		writeln('Precio: ', M.precio:0:2);
		writeln();
	end;
	close(arch);
end;
procedure leerDetalle (var arch:archivoDetalle; var R: registro);
begin
	if(not eof(arch)) then
        read(arch, R)
    else
        R.id := valoralto;

end;
procedure minimo (var V: vectDetalles; var vectDet: vectRegistros ; var Rmin: registro);
var
	pos,i: integer;
begin
	Rmin.id:= valorAlto;
	for i:= 1 to dimF do 
		if(vectDet[i].id < Rmin.id) then begin
			Rmin:= vectDet[i];
			pos:= i;
		end;
	if(Rmin.id <> valorAlto) then
        leerDetalle(V[pos],vectDet[pos]);
end;
procedure actualizarMaestro ( var archM: archivoMaestro ; var V: vectDetalles);
var
	vectDet: vectRegistros;
	i: rango;
	aux,cant: integer;
	M: maestro;
	Rmin: registro;
begin
	reset(archM);
	for i:= 1 to dimF do begin
		reset(V[i]);
		leerDetalle(V[i],vectDet[i]);
	end;
	minimo(V, vectDet, Rmin);
	while(Rmin.id <> valorAlto) do begin
		//writeln('ID PRODUCTO ---> ',Rmin.id);
		//writeln('CANTIDAD VENDIDA ---> ',Rmin.cantVendida);
		aux:= Rmin.id;
        cant:= 0;
		while(Rmin.id<>valorAlto)and(Rmin.id=aux) do begin
			cant:= cant + Rmin.cantVendida;
			minimo(V, vectDet, Rmin);
		end;
		read(archM,M);
		while(aux<>M.id) do begin
			read(archM,M);
		end;
		M.stockDisp:= M.stockDisp - cant;
		seek(archM,filepos(archM)-1);
		write(archM,M);
		//if not eof(archM) then
			//read(archM,M);
	end;
	close(archM);
	for i:= 1 to dimF do 
		close(V[i]);
end;
procedure listarStockMinimo(var arch: archivoMaestro);
var
	txt: Text;
	M: maestro;
	ruta: string;
begin
	ruta:= 'stockMinimo.txt';
	assign(txt,ruta);
	rewrite(txt);
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		if(M.stockDisp<M.stockMin) then begin
			writeln('**',M.nombre,' - ', M.descripcion,' - ', M.stockDisp,' - ', M.precio:0:2);
			writeln(txt,'Producto: ',M.nombre);
			writeln(txt,' - Descripcion: ', M.descripcion);
			writeln(txt,' - Stock disponible: ', M.stockDisp);
			writeln(txt,' - Precio: ', M.precio:0:2);
			writeln(txt);
		end;
	end;
	writeln('Se ha generado el archivo ',ruta,' con los productos con stock menor al permitido.');
	close(arch);
	close(txt);
end;
var
	datMaestro: archivoMaestro;
	txtMaestro: Text;
	V: vectDetalles;
begin
	assign(txtMaestro,'maestro.txt');
	assign(datMaestro,'maestro.dat');
	rewrite(datMaestro);
	writeln('----- Archivo Maestro -----');
	writeln();
	generarArchivoMaestro(txtMaestro,datMaestro);
	writeln('---------------------------');
	writeln();
	generarArchivosDetalles(V);
		
	actualizarMaestro(datMaestro,V);
	imprimirMaestro(datMaestro);
	listarStockMinimo(datMaestro);
end.
