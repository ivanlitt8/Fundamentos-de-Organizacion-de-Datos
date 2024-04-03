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
const
	valorAlto = 9999;
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

	writeln('ID Provincia: ',M.idProv);
	writeln('ID Provincia: ',M.idLoc);
	writeln('Numero Mesa: ',M.mesa);
	writeln('Cantidad Votos: ',M.cant);
	writeln();

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
procedure leerMaestro ( var arch: archivoMaestro; var M: maestro);
begin
	if not eof(arch) then
		read(arch,M)
	else
		M.idProv:= valorAlto;
end;
procedure reporte(var arch: archivoMaestro);
var
	M: maestro;
	votosTotal,votosProv,votosLoc,idProv,idLoc: integer;
begin
	reset(arch);
	leerMaestro(arch,M);
	votosTotal:= 0;
	while(M.idProv<>valorAlto)do begin
		idProv:= M.idProv;
		votosProv:= 0;
		while(M.idProv<>valorAlto)and(idProv = M.idProv)do begin
			idLoc:= M.idLoc;
			votosLoc:= 0;
			while(idProv = M.idProv)and(idLoc = M.idLoc)do begin
				votosLoc:= votosLoc + M.cant;
				leerMaestro(arch,M);
			end;
			votosProv:= votosProv + votosLoc;
			writeln('Codigo Localidad: ',idLoc, ' total de votos localidad: ',votosLoc);
		end;
		votosTotal:= votosTotal + votosProv;
		writeln('Codigo Provincia: ',idProv, ' total de votos provincia: ',votosProv);
		writeln();
	end;
	writeln('Total General de Votos: ',votosTotal);
	close(arch);
end;
{
	Código de Provincia
	Código de Localidad 		Total de Votos
	...................			...............
	...................			...............
	Total de Votos Provincia: ____
	
	Total General de Votos: ___
}
	
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
