{
	Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
	provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
	provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
	Presentar en pantalla un listado como se muestra a continuación:
	 
	Código de Provincia
	Código de Localidad 		Total de Votos
	...................			...............
	...................			...............
	Total de Votos Provincia: ____
	
	Código de Provincia
	Código de Localidad 		Total de Votos
	...................			...............
	...................			...............
	Total de Votos Provincia: ____
	
	Total General de Votos: ___
	
	NOTA: La información está ordenada por código de provincia y código de localidad.  
}


program ejercicio9;
type
	maestro = record
		idProv: integer;
		idLoc: integer;
		mesa: integer;
		cant: integer;
	end;
	
	archivoMaestro = file of maestro;
		
procedure leerMaestrotxt(var txt: Text ; var M: Maestro );
begin
	readln(txt,M.idProv,M.idLoc,M.mesa,M.cant);
{
	writeln(M.idProv);
	writeln(M.idLoc);
	writeln(M.mesa);
	writeln(M.cant);
}
end;
procedure generarMaestro(var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestrotxt(txt,M);
		write(arch,M);
	end;
	close(txt);
	close(arch)
end;
procedure reporte(var arch: archivoMaestro);
begin
end;
var
	archTxt: Text;
	archDat: archivoMaestro;
begin
	assign(archTxt,'maestro.txt');
	assign(archDat,'maestro.dat');
	rewrite(archDat);
	generarMaestro(archTxt,archDat);
	reporte(archDat);
end.
