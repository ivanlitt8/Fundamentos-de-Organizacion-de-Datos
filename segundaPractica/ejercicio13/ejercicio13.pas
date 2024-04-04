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
		hora: string[6];
		boletosDisp: integer;
	end;
	
	detalle = record
		destino: string[15];
		fechaHora: fyh;
		boletosComprados: integer;
	end;
	
	archivoMaestro = file of maestro;
	archivoDetalle = file of detalle;
		
procedure leerMaestrotxt(var txt: Text ; var M: maestro );
begin
	readln(txt,M.destino);
	readln(txt,M.fechaHora.anio,M.fechaHora.mes,M.fechaHora.dia);
	readln(txt,M.fechaHora.hs,M.fechaHora.min);
	readln(txt,M.boletosDisp);
{
	writeln('Destino: ',M.destino);
	writeln('Fecha: ',M.fechaHora.anio,'-',M.fechaHora.mes,'-',M.fechaHora.dia);
	writeln('Hora viaje: ',M.fechaHora.hs,':',M.fechaHora.min);
	writeln('Asientos disponibles: ',M.boletosDisp);
	writeln();
}
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
procedure minimo(var D1,D2,Dmin: detalle ; var detUnoDat,detDosDat: archivoDetalle);
begin
	if(D1.destino < D2.destino)then begin
		Dmin:= D1;
		leerDetalleDat(detUnoDat,D1);
	end
	else if (D1.destino = D2.destino) then begin
		//compararFecha y Hora
	else begin
		Dmin:= D2;
		leerDetalleDat(detDosDat,D2);
	end;
end;
procedure actualizarMaestro(var archM: archivoMaestro ; var detUno,detDos: archivoDetalle);
var
	M: maestro;
	D1,D2: detalle;
begin
	reset(archM);
	reset(detUno);
	reset(detDos);
	read(archM,M);
	minimo(D1,D2,Dmin);
	while(Dmin.destino<>valorAlto) do begin
	
	
	
	end;
	close(archM);
	close(detUno);
	close(detDos);
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
	
	actualizarMaestro(archDat,detUnoDat,detUnoDat);
end.
