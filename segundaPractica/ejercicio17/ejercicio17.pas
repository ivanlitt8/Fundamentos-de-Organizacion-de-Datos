{
	Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
	diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
	de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
	nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
	por localidad, luego por municipio y luego por hospital.
	
	Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
	listado con el siguiente formato:
	
	Nombre: Localidad 1
		Nombre: Municipio 1
			Nombre Hospital 1……………..Cantidad de casos Hospital 1
			..............
			Nombre Hospital N…………….Cantidad de casos Hospital N
		Cantidad de casos Municipio 1
		.........................................................
			Nombre Municipio N
			Nombre Hospital 1……………..Cantidad de casos Hospital 1
			..............
			NombreHospital N…………….Cantidad de casos Hospital N
		Cantidad de casos Municipio N
	Cantidad de casos Localidad 1
	--------------------------------------------------------------
	Nombre Localidad N
		Nombre Municipio 1
			Nombre Hospital 1……………..Cantidad de casos Hospital 1
			..............
			Nombre Hospital N…………….Cantidad de casos Hospital N
		Cantidad de casos Municipio 1
		.........................................................
		Nombre Municipio N
			Nombre Hospital 1……………..Cantidad de casos Hospital 1
			..............
			Nombre Hospital N…………….Cantidad de casos Hospital N
		Cantidad de casos Municipio N
	Cantidad de casos Localidad N
	
	Cantidad de casos Totales en la Provincia
	
	Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
	información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
	aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
	deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
	posibles.
	
	NOTA: El archivo debe recorrerse solo una vez.

}

program ejercicio17;
const
	valorAlto = 'ZZZZ';
type
	str = string[10];
	maestro = record
		idLoc: integer;
		idMuni: integer;
		idHospi: integer;
		casos: integer;
		localidad: str;
		municipio: str;
		hospital: str;
		fecha: str;
	end;
	
	archivoMaestro = file of maestro;
		
procedure leerMaestroTxt(var txt: Text ; var M: Maestro );
begin
	readln(txt,M.idLoc,M.idMuni,M.idHospi,M.casos);
	readln(txt,M.localidad);
	readln(txt,M.municipio);
	readln(txt,M.hospital);
	readln(txt,M.fecha);

	writeln('Fecha: ',M.fecha);
	writeln('ID Localidad: ',M.idLoc);
	writeln('Localidad: ',M.localidad);
	writeln('ID Municipio: ',M.idLoc);
	writeln('Municipio: ',M.municipio);
	writeln('ID Hospital: ',M.idHospi);
	writeln('Hospital: ',M.hospital);
	writeln('Casos: ',M.casos);
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
procedure leerMaestro ( var arch: archivoMaestro; var M: maestro);
begin
	if not eof(arch) then
		read(arch,M)
	else
		M.localidad:= valorAlto;
end;
procedure reporte(var arch: archivoMaestro);
var
	M: maestro;
	casosProvincia,casosLocalidad,casosMunicipio,casosHospital: integer;
	locAct,munAct,hospAct: string;
	txt: Text;
begin
	assign(txt, 'municipios.txt');
    rewrite(txt);
	reset(arch);
	leerMaestro(arch,M);
	casosProvincia:= 0;
	while(M.localidad<>valorAlto)do begin
		locAct:= M.localidad;
		casosLocalidad:= 0;
		writeln('Nombre: ',locAct);
		while(locAct = M.localidad) do begin
			munAct:= M.municipio;
			casosMunicipio:= 0;
			writeln('	Nombre: ',munAct);
			while(locAct = M.localidad) and (munAct = M.municipio) do begin
				hospAct:= M.hospital;
				casosHospital:= 0;
				write('		Nombre: ',hospAct,' ');
				while (locAct = M.localidad)and(munAct = M.municipio)and(hospAct = M.hospital) do begin
					casosHospital:= casosHospital + M.casos;
					leerMaestro(arch,M);
				end;
				writeln('.......Cantidad de casos Hospital: ',casosHospital);
				casosMunicipio:= casosMunicipio + casosHospital;			
			end;
			writeln('	Cantidad de casos Municipio: ',casosMunicipio);
			casosLocalidad:= casosLocalidad + casosMunicipio;
			if(casosMunicipio>1500) then begin
				writeln(txt, locAct);
                writeln(txt, casosMunicipio);
                writeln(txt, munAct);
            end;
		end;
		writeln('Cantidad de casos Localidad: ',casosLocalidad);
		writeln();
		casosProvincia:= casosProvincia + casosLocalidad;
	end;
	writeln('Cantidad de casos Totales en la Provincia: ',casosProvincia);
	close(arch);
	close(txt);
	writeln('-------------------------------------------');
	writeln('Municipios con mas de 1500 casos exportados en achivo municipios.txt');
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
