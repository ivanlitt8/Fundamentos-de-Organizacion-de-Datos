{
	
	A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
	archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
	alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
	agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
	localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
	necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
	
	NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
	pueden venir 0, 1 ó más registros por cada provincia.
}

program ejercicio4;
const
	valorAlto = 'ZZZ';
type
	maestro = record
		provincia: string[15];
		cantPersonas: integer;
		totalEncuestados: integer;
	end;
	registro = record
		provincia: string[15];
		idLocalidad: integer;
		cantPersonas: integer;
		totalEncuestados: integer;
	end;
	archivoMaestro = file of maestro;
	archivoDetalle = file of registro;
	
procedure leerMaestro (var arch: Text; var M: maestro);
begin
	readln(arch,M.provincia);
	readln(arch,M.cantPersonas,M.totalEncuestados);
	writeln(M.provincia,' - personas: ',M.cantPersonas,' - encuestados: ',M.totalEncuestados);
	writeln();
end;
procedure leerDetalleTxt(var arch: Text; var R: registro);
begin
	readln(arch,R.provincia);
	readln(arch,R.idLocalidad,R.cantPersonas,R.totalEncuestados);
	writeln(R.provincia,' id: ',R.idLocalidad,' - personas: ',R.cantPersonas,' - encuestados: ',R.totalEncuestados);
end;
procedure generarArchivoMaestro(var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestro(txt,M);
		write(arch,M);
	end;	
	close(arch);
	close(txt);
end;
procedure generarArchivoDetalle(var txt: Text ; var arch: archivoDetalle);
var
	R: registro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerDetalleTxt(txt,R);
		write(arch,R);
	end;	
	close(arch);
	close(txt);
end;
procedure leerDetalleDat ( var arch: archivoDetalle ; var R: registro);
begin
	if not eof (arch) then
		read(arch,R)
	else
		R.provincia:= valorAlto;
end;
procedure minimo(var RUno, RDos, Rmin: registro; var detUno, detDos: archivoDetalle);
begin
	if(RUno.provincia < RDos.provincia)then begin
		Rmin:= RUno;
		leerDetalleDat(detUno,RUno);
	end
	else begin
		Rmin:= RDos;
		leerDetalleDat(detDos,RDos);
	end;
end;
procedure actualizarMaestro ( var maestroDat: archivoMaestro ; var detUno,detDos: archivoDetalle);
var
	RUno,RDos,Rmin: registro;
	M: maestro;
begin
	reset(maestroDat);
	reset(detUno);
	reset(detDos);
	leerDetalleDat(detUno,RUno);
	leerDetalleDat(detDos,RDos);
	minimo(RUno,RDos,Rmin,detUno,detDos);
	while(RMin.provincia<>valorAlto) do begin
		//writeln(RMin.provincia,' ',RMin.idLocalidad,' ',RMin.cantPersonas,' ',RMin.totalEncuestados);
		read(maestroDat,M);
		while (M.provincia<>RMin.provincia) do
			read(maestroDat,M);
		while(RMin.provincia = M.provincia) do begin
			M.cantPersonas:= M.cantPersonas + RMin.cantPersonas;
			M.totalEncuestados:= M.totalEncuestados + RMin.totalEncuestados;
			
			//leerDetalleDat(detUno,RUno);
			//leerDetalleDat(detDos,RDos);
			minimo(RUno,RDos,Rmin,detUno,detDos);
		end;
		seek(maestroDat, filepos(maestroDat)-1);
		write(maestroDat, M);
		//if not eof(maestroDat) then
			//read(maestroDat,M);
	end;
	close(maestroDat);
	close(detUno);
	close(detDos);
end;
procedure imprimirMaestro( var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		writeln('Provincia: ',M.provincia);
		writeln('Cantida de personas: ',M.cantPersonas,' - Total encuestados: ',M.totalEncuestados);
		writeln();
	end;
	close(arch);
end;
var
	datDetalleUno,datDetalleDos: archivoDetalle;
	datMaestro: archivoMaestro;
	txtDetalleUno,txtDetalleDos,txtMaestro: Text;
begin
	assign(txtMaestro,'maestro.txt');
	assign(txtDetalleUno,'detalleUno.txt');
	assign(txtDetalleDos,'detalleDos.txt');
	
	assign(datMaestro,'maestro.dat');
	assign(datDetalleUno,'detalleUno.dat');
	assign(datDetalleDos,'detalleDos.dat');
	rewrite(datDetalleUno);
	rewrite(datDetalleDos);
	rewrite(datMaestro);
	
	writeln('----- Archivo Maestro -----');
	writeln();
	generarArchivoMaestro(txtMaestro,datMaestro);
	writeln('---------------------------');
	writeln();
	writeln('----- Archivo Detalle 1 -----');
	generarArchivoDetalle(txtDetalleUno,datDetalleUno);
	writeln('---------------------------');
	writeln();
	writeln();
	writeln('----- Archivo Detalle 2 -----');
	generarArchivoDetalle(txtDetalleDos,datDetalleDos);
	writeln('---------------------------');
	actualizarMaestro(datMaestro,datDetalleUno,datDetalleDos);
	imprimirMaestro(datMaestro);
	//listarStockMinimo(datMaestro);
end.
