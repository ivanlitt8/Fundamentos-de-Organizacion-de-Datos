{
	Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
	de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
	modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
	información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
	detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
	Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
	detalles. Además se debe informar cuál fue la moto más vendida.
	
	NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
	ser recorrido sólo una vez y en forma simultánea con los detalles.
}

program ejercicio16;
const
	valorAlto = 9999;
	dimF = 3;
type
	rango = 1..dimF;

	maestro = record
		id: integer;
		nombre: string[20];
		desc: string[50];
		modelo: integer;
		marca: string[10];
		stock: integer;
	end;
	
	detalle = record
		id: integer;
		precio: real;
		fecha: string[10];
	end;
		
	archivoMaestro = file of maestro;	
	archivoDetalle = file of detalle;
	
	vectDetalles = array [rango] of archivoDetalle;
	vectRegistro = array [rango] of  detalle;
	vectStrings = array [rango] of  string;
		
procedure leerMaestroTxt(var txt: Text ; var M: Maestro );
begin
	readln(txt,M.id);
	readln(txt,M.nombre);
	readln(txt,M.desc);
	readln(txt,M.modelo);
	readln(txt,M.marca);
	readln(txt,M.stock);

	writeln('ID Moto: ',M.id);
	writeln('Nombre: ',M.nombre);
	writeln('Descripcion: ',M.desc);
	writeln('Modelo: ',M.modelo);
	writeln('Marca: ',M.marca);
	writeln('Stock: ',M.stock);
	writeln();

end;
procedure generarMaestro(var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestroTxt(txt,M);
		write(arch,M);
	end;
	close(txt);
	close(arch);
end;
procedure leerDetalleTxt(var txt: Text ; var D: detalle );
begin
	readln(txt,D.id,D.precio);
	readln(txt,D.fecha);

	writeln('ID: ',D.id);
	writeln('Precio: ', D.precio:0:2);
	writeln('Fecha: ', D.fecha);
	writeln();
end;
procedure cargarDetalle (var arch: archivoDetalle ; nombre : string );
var
	D: detalle;
	txt: Text;
begin
	assign(txt,nombre+'.txt');
	reset(txt);
	assign(arch,nombre+'.dat');
	rewrite(arch);
	while not eof(txt) do begin
		leerDetalleTxt(txt,D);
		writeln('-----');
		writeln();
		write(arch,D)
	end;
	writeln('***************');
	close(arch);
	close(txt);
end;
procedure leerMaestro ( var arch: archivoMaestro; var M: maestro);
begin
	if not eof(arch) then
		read(arch,M)
	else
		M.id:= valorAlto;
end;
procedure generarDetalles(var V: vectDetalles);
var
	i: integer;
	vNombres: vectStrings;
begin
	vNombres[1]:= 'detalleUno';
	vNombres[2]:= 'detalleDos';
	vNombres[3]:= 'detalleTres';
	for i:=1 to dimF do
		cargarDetalle(V[i],vNombres[i]);
end;
procedure leerDetalle(var arch: archivoDetalle; var D: detalle);
begin
	if not eof(arch) then
		read(arch,D)
	else
		D.id:= valorAlto;
end;
procedure minimo(var V:vectDetalles ; var vectReg: vectRegistro ; var Dmin:detalle);
var
	pos,i: integer;
begin
	Dmin.id:= valorAlto;
	for i:= 1 to dimF do 
		if (vectReg[i].id < Dmin.id) then begin
			Dmin:= vectReg[i];
			pos:= i;
		end;
	if(Dmin.id <> valorAlto)then
		leerDetalle(V[pos],vectReg[pos]);
end;
procedure actualizarMaestro (var V: vectDetalles; var archM: archivoMaestro);
var
	vectReg: vectRegistro;
	i: rango;
	Dmin: detalle;
	M: maestro;
	modMaxVentas: string;
	ventas,max: integer;
begin
	reset(archM);
	for i:=1 to dimF do begin
		reset(V[i]);
		leerDetalle(V[i],vectReg[i]);
	end;
	minimo(V,vectReg,Dmin);
	read(archM, M);
	modMaxVentas:= '';
	max:= 0;
	while(Dmin.id <> valorAlto) do begin
		while(Dmin.id <> M.id) do
			read(archM, M);
		ventas:= 0;
		while(Dmin.id = M.id) do begin
			M.stock:= M.stock - 1;
			ventas:= ventas + 1;
			minimo(V,vectReg,Dmin);
		end;
		if (ventas>max) then begin
			max:= ventas;
			modMaxVentas:= M.nombre;
		end;
		seek(archM, filepos(archM)-1);
		write(archM,M);
	end;
	close(archM);
	for i:=1 to dimF do begin
		close(V[i]);
	end;
	writeln('El modelo de moto mas vendida fue ', modMaxVentas ,' con ',max,' unidades.');
end;
procedure imprimirMaestro( var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	writeln('----- Maestro Actualizado -----');
	while not eof(arch) do begin
		read(arch,M);
		writeln('ID Moto: ',M.id);
		writeln('Nombre: ',M.nombre);
		writeln('Descripcion: ',M.desc);
		writeln('Modelo: ',M.modelo);
		writeln('Marca: ',M.marca);
		writeln('Stock: ',M.stock);
		writeln();
	end;
	close(arch);
end;
var
	archTxt: Text;
	archDat: archivoMaestro;
	V: vectDetalles;
begin
	assign(archTxt,'maestro.txt');
	assign(archDat,'maestro.dat');
	rewrite(archDat);
	generarMaestro(archTxt,archDat);
	
	generarDetalles(V);
	
	actualizarMaestro(V,archDat);
	
	imprimirMaestro(archDat);
end.
