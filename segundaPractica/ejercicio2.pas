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
procedure leer( var arch: Text ; var C: comision);
begin
	if(not eof(arch)) then begin
		readln(arch,C.id,C.nombre);
		readln(arch,C.monto);
	end
	else
		C.id := valorAlto;
end;
procedure comprimir(var txtComisiones: Text ; var txtCompacto: archivoComisiones);
var
	C,Caux: comision;
begin	
	reset(txtComisiones);
	reset(txtCompacto);
	leer(txtComisiones,C);
	while (C.id <> valorAlto) do begin
		Caux.id:= C.id;
		Caux.nombre:= C.nombre;
		Caux.monto:= 0;
		while (C.id = Caux.id)  do begin
			Caux.monto:= Caux.monto + C.monto;
			leer(txtComisiones,C);
		end;
		write(txtCompacto, Caux);
	end;
	close(txtCompacto);
	close(txtComisiones);
end;
procedure imprimirComisiones (var arch: archivoComisiones);
var
	C: comision;
begin
	reset(arch);
    writeln('Imprimiendo comisiones comprimidas:');
    writeln();
    while not eof(arch) do begin
        read(arch, C);
        writeln('ID empleado: ', C.id);
        writeln('Nombre: ', C.nombre);
        writeln('Monto: ', C.monto:0:2);
        writeln('-------------------------');
    end;
    close(arch);
end;
var
	txtMaestro: Text;
	txtDetalle: Text;
begin
	assign(txtMaestro, 'alumnos.txt');
    assign(txtDetalle, 'detalle.txt');
    
	actualizarMaestro(txtMaestro,txtDetalle);
		
end.
