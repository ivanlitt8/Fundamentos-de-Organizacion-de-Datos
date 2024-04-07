{
	Se desea modelar la información de una ONG dedicada a la asistencia de personas con
	carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
	como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
	de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
	agua, # viviendas sin sanitarios.
	
	Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
	de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
	de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
	construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
	
	Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
	recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
	provincia y código de localidad.

	Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
		● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
		● Idem para viviendas sin agua, sin gas y sin sanitarios.
		● A las viviendas de chapa se le resta el valor recibido de viviendas construidas
		
	La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
	
	Realice las declaraciones necesarias, el programa principal y los procedimientos que
	requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
	chapa (las localidades pueden o no haber sido actualizadas).
	
}

program ejercicio14;
const
	valorAlto = 9999;
	dimF = 3;
type
	rango = 1..dimF;
	maestro = record
		idProv: integer;
		prov: string[15];
		idLoc: integer;
		loc: string[15];
		sinLuz: integer;
		sinGas: integer;
		sinAgua: integer;
		sinSanit: integer;
		conChapa: integer;
	end;
	
	detalle = record
		idProv: integer;
		idLoc: integer;
		conLuz: integer;
		construidas: integer;
		conAgua: integer;
		conGas: integer;
		entregaSanit: integer;
	end;
	
	archivoMaestro = file of maestro;
	archivoDetalle = file of detalle;
	
	vectDetalles = array [rango] of archivoDetalle;
	vectRegistro = array [rango] of  detalle;
	vectStrings = array [rango] of  string;
	
procedure leerMaestroTxt(var txt: Text ; var M: maestro );
begin
	readln(txt,M.idProv);
	readln(txt,M.prov);
	readln(txt,M.idLoc);
	readln(txt,M.loc);
	readln(txt,M.sinLuz,M.sinGas,M.sinAgua,M.sinSanit,M.conChapa);

	writeln('ID Provincia: ', M.idProv);
	writeln('Provincia: ', M.prov);
	writeln('ID Localidad: ', M.idLoc);
	writeln('Localidad: ', M.loc);
	writeln('Viviendas sin luz: ', M.sinLuz);
	writeln('Viviendas sin gas: ', M.sinGas);
	writeln('Viviendas sin agua: ', M.sinAgua);
	writeln('Viviendas sin sanitarios: ', M.sinSanit);
	writeln('Viviendas de chapa: ', M.conChapa);
	writeln();
end;
procedure leerDetalleTxt(var txt: Text ; var D: detalle );
begin
	readln(txt,D.idProv,D.idLoc,D.conLuz,D.construidas,D.conAgua,D.conGas,D.entregaSanit);

	writeln('ID Provincia: ', D.idProv);
	writeln('ID Localidad: ', D.idLoc);
	writeln('Viviendas con luz: ', D.conLuz);
	writeln('Viviendas construidas: ', D.construidas);
	writeln('Viviendas con agua: ', D.conAgua);
	writeln('Viviendas con gas: ', D.conGas);
	writeln('Entregas de sanitarios: ', D.entregaSanit);
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
		D.idProv:= valorAlto;
end;
procedure minimo(var V:vectDetalles ; var vectReg: vectRegistro ; var Dmin:detalle);
var
	pos,i: integer;
begin
	Dmin.idProv:= valorAlto;
	for i:= 1 to dimF do 
		if (vectReg[i].idProv < Dmin.idProv) or ((vectReg[i].idProv = Dmin.idProv) and (vectReg[i].idLoc < Dmin.idLoc)) then begin
			Dmin:= vectReg[i];
			pos:= i;
		end;
	if(Dmin.idProv <> valorAlto)then
		leerDetalle(V[pos],vectReg[pos]);
end;
procedure actualizarMaestro (var V: vectDetalles; var archM: archivoMaestro);
var
	vectReg: vectRegistro;
	i: rango;
	Dmin: detalle;
	M: maestro;
	cantLocSinChapa: integer;
begin
	reset(archM);
	for i:=1 to dimF do begin
		reset(V[i]);
		leerDetalle(V[i],vectReg[i]);
	end;
	minimo(V,vectReg,Dmin);
	read(archM, M);
	cantLocSinChapa:= 0;
	while(Dmin.idProv<>valorAlto) do begin
		while(Dmin.idProv<>M.idProv) do
			read(archM, M);
		while(Dmin.idProv = M.idProv) do begin
			while(Dmin.idLoc<>M.idLoc) do
				read(archM,M);
			while(Dmin.idProv = M.idProv)and(Dmin.idLoc=M.idLoc) do begin
				M.sinLuz:= M.sinLuz - Dmin.conLuz;
				M.sinAgua:= M.sinAgua - Dmin.conAgua;
				M.sinGas:= M.sinGas - Dmin.conGas;
				M.sinSanit:= M.sinSanit - Dmin.entregaSanit;
				M.conChapa:= M.conChapa - Dmin.construidas;
				minimo(V,vectReg,Dmin);
			end;
			if(M.conChapa = 0) then
				cantLocSinChapa:= cantLocSinChapa + 1;
			seek(archM, filepos(archM)-1);
			write(archM,M)
		end;
	end;
	writeln('La cantidad de localidades sin viviendas de chapa es ', cantLocSinChapa);
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
		writeln('ID Provincia: ', M.idProv);
		writeln('Provincia: ', M.prov);
		writeln('ID Localidad: ', M.idLoc);
		writeln('Localidad: ', M.loc);
		writeln('Viviendas sin luz: ', M.sinLuz);
		writeln('Viviendas sin gas: ', M.sinGas);
		writeln('Viviendas sin agua: ', M.sinAgua);
		writeln('Viviendas sin sanitarios: ', M.sinSanit);
		writeln('Viviendas de chapa: ', M.conChapa);
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
