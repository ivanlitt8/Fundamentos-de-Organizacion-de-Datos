{
	La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
	correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
	fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
	y total de ejemplares vendido.

	Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
	país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
	cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
	procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
	actualización del archivo maestro en función de las ventas registradas. Además deberá
	informar fecha y semanario que tuvo más ventas y la misma información del semanario con
	menos ventas.
	
	Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
	ventas de semanarios si no hay ejemplares para hacerlo.

}

// CONSULTAR , acualizar maestro no funciona como deberia
// falta el punto de informar maximo y minimo, tambien consultar orden de archivos

program ejercicio14;
const
	valorAlto = 9999;
	dimF = 3;
type
	rango = 1..dimF;
	rangoMes = 1..12;
	rangoDia = 1..31;
	
	data = record
		mes: rangoMes;
		dia: rangoDia;
	end;
	
	maestro = record
		fecha: data;
		id: integer;
		nombre: string[20];
		desc: string[30];
		precio: real;
		stock: integer;
		vendidos: integer;
	end;
	
	detalle = record
		fecha: data;
		id: integer;
		vendidos: integer;
	end;
	
	archivoMaestro = file of maestro;
	archivoDetalle = file of detalle;
	
	vectDetalles = array [rango] of archivoDetalle;
	vectRegistro = array [rango] of  detalle;
	vectStrings = array [rango] of  string;
	

procedure leerMaestroTxt(var txt: Text ; var M: maestro );
begin
	readln(txt,M.fecha.mes,M.fecha.dia,M.id);
	readln(txt,M.nombre);
	readln(txt,M.desc);
	readln(txt,M.precio,M.stock,M.vendidos);

	writeln('Fecha: ',M.fecha.mes,'-',M.fecha.dia);
	writeln('Codigo: ', M.id);
	writeln('Nombre: ', M.nombre);
	writeln('Descripcion: ', M.desc);
	writeln('Precio: ', M.precio:0:2);
	writeln('Stock: ', M.stock);
	writeln('Vendidos: ', M.vendidos);
	writeln();
end;
procedure leerDetalleTxt(var txt: Text ; var D: detalle );
begin
	readln(txt,D.fecha.mes,D.fecha.dia,D.id,D.vendidos);

	writeln('Fecha: ',D.fecha.mes,'-',D.fecha.dia);
	writeln('Codigo Seminario: ', D.id);
	writeln('Vendidos: ', D.vendidos);
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
	close(arch)
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
procedure generarDetalles ( var V: vectDetalles);
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
	///comparar por id
		if (vectReg[i].fecha.mes < Dmin.fecha.mes) or ((vectReg[i].fecha.mes = Dmin.fecha.mes) and 
			(vectReg[i].fecha.dia < Dmin.fecha.dia)) or ((vectReg[i].fecha.mes = Dmin.fecha.mes) and 
			(vectReg[i].fecha.dia = Dmin.fecha.dia) and (vectReg[i].id = Dmin.id)) then begin
			Dmin:= vectReg[i];
			pos:= i;
		end;
	if(Dmin.id <> valorAlto)then
		leerDetalle(V[pos],vectReg[pos]);
end;
{
procedure actualizarMaestro (var V: vectDetalles; var archM: archivoMaestro);
var
	vectReg: vectRegistro;
	i: rango;
	Dmin: detalle;
	M: maestro;
begin
	reset(archM);
	for i:=1 to dimF do begin
		reset(V[i]);
		leerDetalle(V[i],vectReg[i]);
	end;
	minimo(V,vectReg,Dmin);
	read(archM, M);
	while(Dmin.id<>valorAlto) do begin
		while(Dmin.fecha.mes <> M.fecha.mes) and (Dmin.fecha.dia<>M.fecha.dia) do
			read(archM, M);
		while(Dmin.fecha.mes = M.fecha.mes) and (Dmin.fecha.dia = M.fecha.dia) do begin
			while(Dmin.id<>M.id) do
				read(archM,M);
			while(Dmin.fecha.mes = M.fecha.mes) and (Dmin.fecha.dia = M.fecha.dia) and (Dmin.id = M.id) do begin
				M.stock:= M.stock - Dmin.vendidos;
				M.vendidos:= M.vendidos + Dmin.vendidos;
				minimo(V,vectReg,Dmin);
			end;
			seek(archM, filepos(archM)-1);
			write(archM,M);
		end;
	end;
	close(archM);
	for i:=1 to dimF do begin
		close(V[i]);
	end;
end;
}
procedure actualizarMaestro (var V: vectDetalles; var archM: archivoMaestro);
var
	vectReg: vectRegistro;
	i: rango;
	Dmin: detalle;
	M: maestro;
begin
	reset(archM);
	for i:=1 to dimF do begin
		reset(V[i]);
		leerDetalle(V[i],vectReg[i]);
	end;
	minimo(V,vectReg,Dmin);
	read(archM, M);
	writeln('BANDERA 1, id D:',Dmin.id);
	while(Dmin.id <> valorAlto) do begin
		writeln('BANDERA 2, id D:',Dmin.id);
		while(Dmin.fecha.mes <> M.fecha.mes) do
			read(archM, M);
		while(Dmin.fecha.mes = M.fecha.mes) do begin
			writeln('BANDERA 3, id D:',Dmin.id);
			while(Dmin.fecha.dia <> M.fecha.dia) do 
				read(archM,M);
			while(Dmin.fecha.mes = M.fecha.mes) and (Dmin.fecha.dia = M.fecha.dia) do begin
				writeln('BANDERA 4, id D:',Dmin.id);
				while(Dmin.id <> M.id) do 
					read(archM,M);
				while(Dmin.fecha.mes = M.fecha.mes) and (Dmin.fecha.dia = M.fecha.dia) and (Dmin.id = M.id) do begin
					writeln('BANDERA 5, id D:',Dmin.id);
					M.stock:= M.stock - Dmin.vendidos;
					M.vendidos:= M.vendidos + Dmin.vendidos;
					minimo(V,vectReg,Dmin);
				end;
				seek(archM, filepos(archM)-1);
				write(archM,M);
			end;
		end;
	end;
	close(archM);
	for i:=1 to dimF do begin
		close(V[i]);
	end;
end;

procedure imprimirMaestro( var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	writeln('----- Maestro Actualizado -----');
	while not eof(arch) do begin
		read(arch,M);
		writeln('Fecha: ',M.fecha.mes,'-',M.fecha.dia);
		writeln('Codigo: ', M.id);
		writeln('Nombre: ', M.nombre);
		writeln('Descripcion: ', M.desc);
		writeln('Precio: ', M.precio:0:2);
		writeln('Stock: ', M.stock);
		writeln('Vendidos: ', M.vendidos);
		writeln();
	end;
	close(arch);
end;

var
	archTxt: Text;
	V: vectDetalles;
	archDat: archivoMaestro;
begin
	assign(archTxt,'maestro.txt');
	assign(archDat,'maestro.dat');
	rewrite(archDat);
	generarMaestro(archTxt,archDat);
	
	generarDetalles(V);
	
	actualizarMaestro(V,archDat);
	
	imprimirMaestro(archDat);
end.
