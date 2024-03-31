{
	Se dispone de un archivo con información de los alumnos de la Facultad de Informática.
	Por cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
	(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
	un archivo detalle con el código de alumno e información correspondiente a una materia
	(esta información indica si aprobó la cursada o aprobó el final).
	
	Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
	haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
	programa con opciones para:
	
	a. Actualizar el archivo maestro de la siguiente manera:
		
		i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
		y se decrementa en uno la cantidad de materias sin final aprobado.
		
		ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
		final.
		
	b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
	aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
	es un reporte de salida (no se usa con fines de carga), debe informar todos los
	campos de cada alumno en una sola línea del archivo de texto.

	NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}

program ejercicio2;
const
	valorAlto = 9999;
type
	alumno = record
		id: integer;
		apellido: string[10];
		nombre: string[10];
		cursadas: integer;
		finales: integer;
	end;
	legajo = record
		id: integer;
		estado: string[20]
	end;
	archivoAlumnos = file of alumno;
	archivoDetalle = file of legajo;
procedure leerDetalle( var arch: archivoDetalle ; var L: legajo);
begin
	if not eof(arch)then begin
		read(arch,L);
	end
	else
		L.id := valorAlto;
end;
procedure leerTxtMaestro( var arch: Text ; var A: alumno);
begin
	readln(arch, A.id);
	readln(arch, A.apellido);
    readln(arch, A.nombre);
    readln(arch, A.cursadas, A.finales);
    writeln('Codigo: ', A.id);
	writeln('Apellido: ', A.apellido);
	writeln('Nombre: ', A.nombre);
	writeln('Cursadas: ', A.cursadas);
	writeln('Finales: ', A.finales);
	writeln();
end;
procedure leerTxtDetalle( var arch: Text ; var L: legajo);
begin
    readln(arch, L.id);
    readln(arch, L.estado);
    writeln('Codigo alumno: ', L.id);
	writeln('Estado: ', L.estado);
	writeln();
end;
procedure imprimirMaestro(var arch: archivoAlumnos);
var
	A: alumno;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,A);
		writeln('Codigo: ', A.id);
		writeln('Apellido: ', A.apellido);
		writeln('Nombre: ', A.nombre);
		writeln('Cursadas: ', A.cursadas);
		writeln('Finales: ', A.finales);
		writeln();
	end;
	close(arch);
end;
procedure actualizarMaestro( var maestro: archivoAlumnos ; var detalle: archivoDetalle);
var
	L: legajo;
	A: alumno;
begin
	reset(maestro);
	reset(detalle);
	leerDetalle(detalle, L);
	while(L.id <> valorAlto) do begin
		read(maestro, A);
		while(A.id <> L.id) do
			read(maestro, A);
		while(L.id <> valorAlto)and(A.id = L.id) do begin
			if (L.estado = 'Final') then begin
				A.finales:= A.finales + 1;
				A.cursadas:= A.cursadas - 1;
			end
			else if (L.estado = 'Cursada') then begin
				A.cursadas:= A.cursadas + 1;
			end;
			leerDetalle(detalle,L);
		end;		
		seek(maestro, filepos(maestro)-1);
		write(maestro, A);
	end;
	close(maestro);
	close(detalle);
end;
procedure generarArchivoMaestro( var txtMaestro: Text ; var datMaestro: archivoAlumnos);
var
	A: alumno;
begin
	reset(txtMaestro);
	while not eof(txtMaestro) do begin
        leerTxtMaestro(txtMaestro, A);
        write(datMaestro, A);
    end;
	close(datMaestro);
	close(txtMaestro);
end;
procedure generarArchivoDetalle( var txtDetalle: Text ; var datDetalle: archivoDetalle);
var
	L: legajo;
begin
	reset(txtDetalle);
	while not eof(txtDetalle) do begin
        leerTxtDetalle(txtDetalle, L);
        write(datDetalle, L);
    end;
	close(datDetalle);
	close(txtDetalle);
end;
procedure listarAlumnos ( var maestro: archivoAlumnos);
var
	A: alumno;
	listado: Text;
begin
	reset(maestro);
	assign(listado,'listadoAlumnos.txt');
	rewrite(listado);
	while not eof(maestro) do begin
		read(maestro,A);
		if(A.cursadas<A.finales) then begin
			writeln(listado, A.id,' ',A.apellido,' ',A.nombre,' ',A.cursadas,' ',A.finales);
			writeln('** El alumno con id: ', A.id,' tiene mas finales que cursadas.');
		end;
	end;
	close(maestro);
	close(listado);
	writeln('Los alumnos con mas finales que cursadas fueron exportados a listadoAlumnos.txt');
end;
var
	txtMaestro: Text;
	txtDetalle: Text;
	datDetalle: archivoDetalle;
	datMaestro: archivoAlumnos;
begin
	assign(txtMaestro,'alumnos.txt');
    assign(txtDetalle,'detalle.txt');
    assign(datMaestro,'alumnos.dat');
    assign(datDetalle,'detalle.dat');
    rewrite(datDetalle);
    rewrite(datMaestro);
    writeln('----- Archivo Maestro -----');
    writeln();
    generarArchivoMaestro(txtMaestro,datMaestro);
    writeln('---------------------------');
    writeln();
    writeln('----- Archivo Detalle -----');
    writeln();
    generarArchivoDetalle(txtDetalle,datDetalle);
	actualizarMaestro(datMaestro,datDetalle);
	writeln('---------------------------');
    writeln();
	writeln('Archivo Maestro actualizado: ');
    writeln();
	imprimirMaestro(datMaestro);
	writeln('---------------------------');
	listarAlumnos(datMaestro);
end.
