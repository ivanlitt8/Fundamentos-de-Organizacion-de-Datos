{
	A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
	toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
	información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
	en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
	reuniendo dicha información.
	
	Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
	nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
	del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
	padre.
	
	En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
	apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
	lugar.
	
	Realizar un programa que cree el archivo maestro a partir de toda la información de los
	archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
	apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
	apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
	además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
	deberá, además, listar en un archivo de texto la información recolectada de cada persona.

}

program ejercicio17;
const
	valorAlto = 'ZZZZ';
	dimF = 15;
type
	fallecido = record
		nroPartida: integer;
		dni: integer;
		nombreApellido: string[50];
		matMed: integer;
		fechaDeceso: string[10];
		horaDeceso: string[5];
		lugarDeceso: string[15];
	end;
	
	nacido = record
		nroPartida: integer;
		nombreApellido: string[50];
		direccion: string[50];
		matMed: integer;
		nombreApellidoMadre: string[50];
		dniMadre: integer;
		nombreApellidoPadre: string[50];
		dniPadre: integer;
	end;
	
	maestro = record
		nroPartida: integer;
		nombreApellido: string[50];
		direccion: string[50];
		matMed: integer;
		nombreApellidoMadre: string[50];
		dniMadre: integer;
		nombreApellidoPadre: string[50];
		dniPadre: integer;
		fallecido: boolean; // Indica si la persona está fallecida
		matMedDeceso: string[10]; // Matrícula del médico que firmó el deceso
		fechaDeceso: string[10];
		horaDeceso: string[5];
		lugarDeceso: string[15];
	end;
	
	archivoMaestro = file of maestro;
	archivoFallec = file of fallecido;
	archivoNac = file of nacido;
		
procedure leerFallecTxt(var txt: Text ; var F: fallecido );
begin
	readln(txt,F.nroPartida,F.dni);
	readln(txt,F.nombreApellido);
	readln(txt,F.matMed);
	readln(txt,F.fechaDeceso);
	readln(txt,F.horaDeceso);
	readln(txt,F.lugarDeceso);

	writeln('Numero de partida de nacimiento: ', F.nroPartida);
	writeln('DNI: ', F.dni);
	writeln('Nombre y apellido: ', F.nombreApellido);
	writeln('Matricula del medico: ', F.matMed);
	writeln('Fecha de deceso: ', F.fechaDeceso);
	writeln('Hora de deceso: ', F.horaDeceso);
	writeln('Lugar de deceso: ', F.lugarDeceso);
	writeln();
end;
procedure leerNacTxt(var txt: Text ; var N: nacido );
begin
	readln(txt,N.nroPartida);
	readln(txt,N.nombreApellido);
	readln(txt,N.direccion);
	readln(txt,N.matMed);
	readln(txt,N.nombreApellidoMadre);
	readln(txt,N.dniMadre);
	readln(txt,N.nombreApellidoPadre);
	readln(txt,N.dniPadre);

	writeln('Numero de partida de nacimiento: ', N.nroPartida);
	writeln('Nombre y apellido: ', N.nombreApellido);
	writeln('Direccion: ', N.direccion);
	writeln('Matricula del medico: ', N.matMed);
	writeln('Nombre y apellido de la madre: ', N.nombreApellidoMadre);
	writeln('DNI de la madre: ', N.dniMadre);
	writeln('Nombre y apellido del padre: ', N.nombreApellidoPadre);
	writeln('DNI del padre: ', N.dniPadre);
	writeln();
end;
procedure generarDetalleN (var txt: Text; var arch:archivoNac);
var
	N: nacido;
begin
	reset(txt);
	while not eof(txt) do begin
		leerNacTxt(txt,N);
		write(arch,N);
	end;
	close(txt);
	close(arch);
end;
procedure generarDetalleF (var txt: Text; var arch:archivoFallec);
var
	F: fallecido;
begin
	reset(txt);
	while not eof(txt) do begin
		leerFallecTxt(txt,F);
		write(arch,F);
	end;
	close(txt);
	close(arch);
end;
var
	txtNac,txtFallec: Text;
	datFallec: archivoFallec;
	datNac: archivoNac;
	archDat: archivoMaestro;
begin
	assign(txtNac,'nacidos.txt');
	assign(datNac,'nacidos.dat');
	rewrite(datNac);
	generarDetalleN(txtNac,datNac);
	
	assign(txtFallec,'fallecidos.txt');
	assign(datFallec,'fallecidos.dat');
	rewrite(datFallec);
	generarDetalleF(txtFallec,datFallec);
	
	assign(archDat,'maestro.dat');
	rewrite(archDat);
	generarMaestro(datNac,datFallec,archDat);
end.
