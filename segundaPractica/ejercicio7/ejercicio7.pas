{
	Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
	para el ministerio de salud de la provincia de buenos aires.
	
	Diariamente se reciben archivos provenientes de los distintos municipios, la información
	contenida en los mismos es la siguiente: 
	
	Detalle: 
	código de localidad, código cepa, cantidad de
	casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
	fallecidos.
	
	El ministerio cuenta con un archivo maestro con la siguiente información: 
	
	Maestro:
	código localidad, nombre localidad, código cepa, nombre cepa, cantidad de casos activos,
	cantidad de casos nuevos, cantidad de recuperados y cantidad de fallecidos
	
	Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
	recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
	localidad y código de cepa.
	
	Para la actualización se debe proceder de la siguiente manera:
		
		1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
		2. Idem anterior para los recuperados.
		3. Los casos activos se actualizan con el valor recibido en el detalle.
		4. Idem anterior para los casos nuevos hallados.
	
	Realice las declaraciones necesarias, el programa principal y los procedimientos que
	requiera para la actualización solicitada e informe cantidad de localidades con más de 50
	casos activos (las localidades pueden o no haber sido actualizadas).
   
}


program ejercicio7;
const
	dimF = 3;
	valorAlto = 999;
type
	rango = 1..dimF;
	
	maestro = record
		id: integer;
		nombre: string[15];
		cepa: integer;
		nombreCepa: string[10];
		activos: integer;
		nuevos: integer;
		recup: integer;
		fallec: integer;
	end;
	detalle = record
		id: integer;
		cepa: integer;
		activos: integer;
		nuevos: integer;
		recup: integer;
		fallec: integer;
	end;
	
	archivoDetalle = file of detalle;
	archivoMaestro = file of maestro;
	
	vectDetalle = array [rango] of  archivoDetalle;
	vectRegistro = array [rango] of  detalle;
	vectStrings = array [rango] of  string;
	
procedure leerMaestroTxt (var txt: Text ; var M: maestro);
begin
	readln(txt,M.id);
	readln(txt,M.nombre);
	readln(txt,M.cepa);
	readln(txt,M.nombreCepa);
	readln(txt,M.activos,M.nuevos,M.recup,M.fallec);
{
	writeln(M.id);
	writeln(M.nombre);
	writeln(M.cepa);
	writeln(M.nombreCepa);
	writeln(M.activos);
	writeln(M.nuevos);
	writeln(M.recup);
	writeln(M.fallec);
	writeln();
}
end;	
procedure generarMaestro ( var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestroTxt(txt, M);
		write(arch,M);
	end;
	close(txt);
	close(arch);
end;
procedure leerDetalleTxt(var txt: Text ; var D: detalle);
begin
	readln(txt,D.id,D.cepa);
	readln(txt,D.activos,D.nuevos,D.recup,D.fallec);
	writeln('ID:',D.id);
	writeln('CEPA:',D.cepa);
	writeln('ACTIVOS:',D.activos);
	writeln('NUEVOS:',D.nuevos);
	writeln('RECUPERADOS:',D.recup);
	writeln('FALLECIDOS:',D.fallec);
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
procedure generarDetalles ( var V: vectDetalle);
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
procedure leerDetalle(var arch: archivoDetalle; var R: detalle);
begin
	if not eof(arch) then
		read(arch,R)
	else
		R.id:= valorAlto;
end;
procedure minimo(var V:vectDetalle ; var vectReg:vectRegistro ; var Dmin:detalle);
var
	pos,i: integer;
begin
	Dmin.id:= valorAlto;
	for i:= 1 to dimF do 
		if (vectReg[i].id < Dmin.id) or ((vectReg[i].id = Dmin.id) and (vectReg[i].cepa < Dmin.cepa)) then begin
			Dmin:= vectReg[i];
			pos:= i;
		end;
	if(Dmin.id <> valorAlto)then
		leerDetalle(V[pos],vectReg[pos]);
end;
procedure actualizarDetalle(var V:vectDetalle ; var archM: archivoMaestro);
var
	vectReg: vectRegistro;
	i: rango;
	Dmin: detalle;
	loc50,locCasos: integer;
	M: maestro;
begin
	reset(archM);
	for i:=1 to dimF do begin
		reset(V[i]);
		leerDetalle(V[i],vectReg[i]);
	end;
	loc50:= 0;
	minimo(V,vectReg,Dmin);
	while (Dmin.id<>valorAlto) do begin
		locCasos:= 0;
		read(archM, M);
		while(Dmin.id<>valorAlto)and(Dmin.id = M.id) and (M.cepa = Dmin.cepa) do begin
			M.fallec:= M.fallec + Dmin.fallec;
			M.recup:= M.recup + Dmin.recup;
			locCasos:= locCasos + Dmin.activos;
			M.nuevos:= Dmin.nuevos;
			M.activos:= Dmin.activos;
			minimo(V,vectReg,Dmin);
		end;
		seek(archM,filepos(archM)-1);
		write(archM,M);
		writeln('Cantidad de casos en la localidad ', M.id, ' con cepa ', M.cepa, ': ', locCasos);
        if(locCasos > 50) then
			loc50:= loc50 + 1;
	end;
	for i:=1 to dimF do
		close(V[i]);
	close(archM);
	writeln();
	writeln('** La cantidad de localidades con mas de 50 casos activos es: ', loc50);
	writeln('--------------------------------------------------------------');
	writeln();
end;
procedure imprimirMaestro( var arch : archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		writeln('Ciudad: ',M.nombre);
		writeln('- id: ',M.id);
		writeln('- cepa: ',M.cepa);
		writeln('- nombre cepa: ',M.nombreCepa);
		writeln('- cantidad activos: ',M.activos);
		writeln('- cantidad nuevos: ',M.nuevos);
		writeln('- cantidad recuperados: ',M.recup);
		writeln('- cantidad fallecidos: ',M.fallec);
		writeln();
	end;
	close(arch);
end;
var
	maestroTxt: Text;
	maestroDat: archivoMaestro;
	V: vectDetalle;
begin
	assign(maestroTxt,'maestro.txt');
	assign(maestroDat,'maestro.dat');
	rewrite(maestroDat);
	generarMaestro(maestroTxt, maestroDat);
	writeln('----- Archivo Maestro -----');
	writeln();
	imprimirMaestro(maestroDat);
	writeln('---------------------------');
	writeln();
	generarDetalles(V);
	actualizarDetalle(V, maestroDat);
	writeln('----- Archivo Maestro Actualizado -----');
	writeln();
	imprimirMaestro(maestroDat);
	writeln('---------------------------------------');
	writeln();
end.
