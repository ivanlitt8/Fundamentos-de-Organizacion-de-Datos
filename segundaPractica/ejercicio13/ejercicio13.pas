{
	Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
	próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
	cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
	para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
	y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
	más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
	uno del maestro. Se pide realizar los módulos necesarios para:

		a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
		sin asiento disponible.
		
		b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
		tengan menos de una cantidad específica de asientos disponibles. La misma debe
		ser ingresada por teclado.

	NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

// CONSULTAR

program ejercicio13;
const
	valorAlto = 'ZZZZ';
type

	fyh = record
		anio, mes, dia, hs, min: Integer;
	end;

	maestro = record
		destino: string[15];
		fechaHora: fyh;
		boletosDisp: integer;
	end;
	
	detalle = record
		destino: string[15];
		fechaHora: string;
		boletosComprados: integer;
		
		A < B true 
		
		14 de marzo 20 de febrero
		20220306 20210405
	end;
	
	archivoMaestro = file of maestro;
	archivoDetalle = file of detalle;
		
procedure leerMaestrotxt(var txt: Text ; var M: maestro );
begin
	readln(txt,M.destino);
	readln(txt,M.fechaHora.anio,M.fechaHora.mes,M.fechaHora.dia);
	readln(txt,M.fechaHora.hs,M.fechaHora.min);
	readln(txt,M.boletosDisp);
	writeln('Destino: ',M.destino);
	writeln('Fecha: ',M.fechaHora.anio,'-',M.fechaHora.mes,'-',M.fechaHora.dia);
	writeln('Hora viaje: ',M.fechaHora.hs,':',M.fechaHora.min);
	writeln('Asientos disponibles: ',M.boletosDisp);
	writeln();
end;
procedure leerDetalletxt(var txt: Text ; var D: detalle );
begin
	readln(txt,D.destino);
	readln(txt,D.fechaHora.anio,D.fechaHora.mes,D.fechaHora.dia);
	readln(txt,D.fechaHora.hs,D.fechaHora.min);
	readln(txt,D.boletosComprados);
	writeln('Destino: ',D.destino);
	writeln('Fecha: ',D.fechaHora.anio,'-',D.fechaHora.mes,'-',D.fechaHora.dia);
	writeln('Hora viaje: ',D.fechaHora.hs,':',D.fechaHora.min);
	writeln('Asientos comprados: ',D.boletosComprados);
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
procedure generarDetalle(var txt: Text ; var arch: archivoDetalle);
var
	D: detalle;
begin
	reset(txt);
	while not eof(txt) do begin
		leerDetalletxt(txt,D);
		write(arch,D);
	end;
	close(txt);
	close(arch)
end;
procedure leerDetalleDat( var arch: archivoDetalle ; var D: detalle);
begin
	if not eof(arch) then
		read(arch,D)
	else
		D.destino:= valorAlto;
end;
procedure compararFechas(D1, D2: detalle; var Daux: detalle);
begin
  if (D1.fechaHora.anio < D2.fechaHora.anio) or
     ((D1.fechaHora.anio = D2.fechaHora.anio) and (D1.fechaHora.mes < D2.fechaHora.mes)) or
     ((D1.fechaHora.anio = D2.fechaHora.anio) and (D1.fechaHora.mes = D2.fechaHora.mes) and (D1.fechaHora.dia < D2.fechaHora.dia)) or
     ((D1.fechaHora.anio = D2.fechaHora.anio) and (D1.fechaHora.mes = D2.fechaHora.mes) and (D1.fechaHora.dia = D2.fechaHora.dia) and (D1.fechaHora.hs < D2.fechaHora.hs)) or
     ((D1.fechaHora.anio = D2.fechaHora.anio) and (D1.fechaHora.mes = D2.fechaHora.mes) and (D1.fechaHora.dia = D2.fechaHora.dia) and (D1.fechaHora.hs = D2.fechaHora.hs) and (D1.fechaHora.min < D2.fechaHora.min)) then
    Daux:= D1
  else
    Daux:= D2;
end;
procedure minimo(var D1,D2,Dmin: detalle ; var detUno,detDos: archivoDetalle);
var
	Daux: detalle;
begin
	compararFechas(D1,D2,Daux);
	if(Daux.destino = D1.destino) then begin
		Dmin:= D1;
		leerDetalleDat(detUno,Dmin);
	end
	else if (Daux.destino = D2.destino) then begin
		Dmin:= D2;
		leerDetalleDat(detDos,Dmin);
	end;
end;

procedure actualizarMaestro(var archM: archivoMaestro ; var detUno,detDos: archivoDetalle);
var
	M: maestro;
	D1,D2,Dmin: detalle;
	//cantidad,asientosMin: integer;
	//txt: Text;
begin
	//writeln('Ingrese cantidad de asientos minimos');
    //readln(asientosMin);
    //assign(txt,'listado.txt');
    //rewrite(txt);
	reset(archM);
	reset(detUno);
	reset(detDos);
	leerDetalleDat(detUno, D1);
    leerDetalleDat(detDos, D2);
	minimo(D1,D2,Dmin,detUno,detDos);
	while(Dmin.destino<>valorAlto) do begin
		read(archM,M);
		while(Dmin.destino <> M.destino) do
			read(archM,M);
		while(Dmin.destino = M.destino) do begin
			while(M.fechahora.anio <> Dmin.fechahora.anio) do
				read(archM, M);
			while(Dmin.destino = M.destino) and (Dmin.fechahora.anio = M.fechahora.anio) do begin
				while(M.fechahora.mes <> Dmin.fechahora.mes) do
					read(archM, M);
				while(Dmin.destino = M.destino) and (Dmin.fechahora.anio = M.fechahora.anio) and (M.fechahora.mes = Dmin.fechahora.mes) do begin
					while(M.fechahora.dia <> Dmin.fechahora.dia) do 
						read(archM, M);
					while(M.destino = Dmin.destino) and (M.fechahora.anio = Dmin.fechahora.anio) and (M.fechahora.mes = Dmin.fechahora.mes) and (M.fechahora.dia = Dmin.fechahora.dia) do begin 
						while(M.fechahora.hs <> Dmin.fechahora.hs) do 
							read(archM, M);
						while(M.destino = Dmin.destino) and (M.fechahora.anio = Dmin.fechahora.anio) and (M.fechahora.mes = Dmin.fechahora.mes) and (M.fechahora.dia = Dmin.fechahora.dia) and (M.fechahora.hs = Dmin.fechahora.hs) do begin 
							while(M.fechahora.min <> Dmin.fechahora.min) do
								read(archM, M);
							//cantidad:= 0;
							while(M.destino = Dmin.destino) and (M.fechahora.anio = Dmin.fechahora.anio) and (M.fechahora.mes = Dmin.fechahora.mes) and (M.fechahora.dia = Dmin.fechahora.dia) and (M.fechahora.hs = Dmin.fechahora.hs) and (M.fechahora.min = Dmin.fechahora.min) do begin 
								M.boletosDisp:= M.boletosDisp - Dmin.boletosComprados;
								minimo(D1,D2,Dmin,detUno,detDos);
							end;
							//if(M.boletosDisp < asientosMin) then
								//writeln(txt, M.destino, ' ',M.fechahora.anio,'-',M.fechahora.mes,'-',M.fechahora.dia);
							
							seek(archM, filepos(archM)-1);
							write(archM, M);
						end;
					end;
                end;
			end;
		end;
	end;
	close(archM);
	close(detUno);
	close(detDos);
end;
procedure imprimirMaestro(var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		writeln('Destino: ',M.destino);
		writeln('Fecha: ',M.fechaHora.anio,'-',M.fechaHora.mes,'-',M.fechaHora.dia);
		writeln('Hora viaje: ',M.fechaHora.hs,':',M.fechaHora.min);
		writeln('Asientos disponibles: ',M.boletosDisp);
		writeln();
	end;
	close(arch);
end;
var
	archTxt,detUnoTxt,detDosTxt: Text;
	detUnoDat,detDosDat: archivoDetalle;
	archDat: archivoMaestro;
begin
	assign(archTxt,'maestro.txt');
	assign(archDat,'maestro.dat');
	rewrite(archDat);
	writeln('------- Maestro -------');
	generarMaestro(archTxt,archDat);
	
	writeln('------- Detalle 1 -------');
	assign(detUnoTxt,'detalleUno.txt');
	assign(detUnoDat,'detalleUno.dat');
	rewrite(detUnoDat);
	generarDetalle(detUnoTxt,detUnoDat);
	
	writeln('------- Detalle 2 -------');
	assign(detDosTxt,'detalleDos.txt');
	assign(detDosDat,'detalleDos.dat');
	rewrite(detDosDat);
	generarDetalle(detDosTxt,detDosDat);
	
	actualizarMaestro(archDat,detUnoDat,detDosDat);
	writeln('------- Maestro Actualizado-------');
	imprimirMaestro(archDat);
end.
