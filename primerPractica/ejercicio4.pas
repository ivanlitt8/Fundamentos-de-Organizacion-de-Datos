{
	Agregar al menú del programa del ejercicio 3, opciones para:
	
	a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
	teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
	un número de empleado ya registrado (control de unicidad).

	b. Modificar la edad de un empleado dado.
	
	c. Exportar el contenido del archivo a un archivo de texto llamado
	“todos_empleados.txt”.

	d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
	que no tengan cargado el DNI (DNI en 00).

	NOTA: Las búsquedas deben realizarse por número de empleado.   
}

program ejercicio4;

type
    str = string[15];
    empleado = record
        id: integer;
        apellido: str;
        nombre: str;
        edad: integer;
        dni: integer;
    end;
    archivo_empleado = file of empleado;

procedure leerEmpleado(var E: empleado);
begin    
    writeln('Ingrese apellido de empleado: ');
    readln(E.apellido);
    writeln('Ingrese nombre de empleado: ');
    readln(E.nombre);
    writeln('Ingrese ID de empleado: ');
    readln(E.id);
    writeln('Ingrese edad de empleado: ');
    readln(E.edad);
    writeln('Ingrese dni de empleado: ');
    readln(E.dni);
end;

procedure agregarEmpleado(var archivo: archivo_empleado);
var
    E: empleado;
begin
	reset(archivo);
    leerEmpleado(E);
    seek(archivo, FileSize(archivo));
    write(archivo, E);
    close(archivo);
end;
procedure exportarATexto(var empleados: archivo_empleado);
var
    archivoTexto: Text;
    E: empleado;
begin
    assign(archivoTexto, 'todos_empleados.txt');
    rewrite(archivoTexto);
    
    reset(empleados);
    while not eof(empleados) do
    begin
        read(empleados, E);
        writeln(archivoTexto, 'id: ', E.id);
        writeln(archivoTexto, 'apellido: ', E.apellido);
        writeln(archivoTexto, 'nombre: ', E.nombre);
        writeln(archivoTexto, 'edad: ', E.edad);
        writeln(archivoTexto, 'dni: ', E.dni);
        writeln(archivoTexto, '------------');
    end;
    
    close(archivoTexto);
    close(empleados);
    
    writeln('Contenido exportado a "todos_empleados.txt".');
end;
procedure exportarFaltaDNI(var empleados: archivo_empleado);
var
    archivoTexto: Text;
    E: empleado;
begin
    assign(archivoTexto, 'faltaDNIEmpleado.txt');
    rewrite(archivoTexto);
    
    reset(empleados);
    while not eof(empleados) do
    begin
        read(empleados, E);
        if E.dni = 0 then // Verificar si el DNI es 0
        begin
            writeln(archivoTexto, 'id: ', E.id);
            writeln(archivoTexto, 'apellido: ', E.apellido);
            writeln(archivoTexto, 'nombre: ', E.nombre);
            writeln(archivoTexto, 'edad: ', E.edad);
            writeln(archivoTexto, 'dni: ', E.dni);
            writeln(archivoTexto, '------------');
        end;
    end;
    
    close(archivoTexto);
    close(empleados);
    
    writeln('Empleados sin DNI exportados correctamente a "faltaDNIEmpleado.txt".');
end;
procedure cambiarEdad(var archivo: archivo_empleado; idEmpleado: integer; nuevaEdad: integer);
var
    E: empleado;
    encontrado: boolean;
begin
    encontrado := false;
    reset(archivo);
    while not eof(archivo) and not encontrado do
    begin
        read(archivo, E);
        if E.id = idEmpleado then begin
            encontrado := true;
            E.edad := nuevaEdad;
            seek(archivo, filepos(archivo) - 1);
            write(archivo, E);
        end;
    end;
    close(archivo);

    if encontrado then
        writeln('Edad del empleado actualizada correctamente.')
    else
        writeln('Empleado con ID ', idEmpleado, ' no encontrado.');
end;

procedure imprimirArchivo(var empleados: archivo_empleado);
var
    E: empleado;
begin
    reset(empleados);
    while not eof(empleados) do
    begin
        read(empleados, E);
        writeln('id: ', E.id);
        writeln('apellido: ', E.apellido);
        writeln('nombre: ', E.nombre);
        writeln('edad: ', E.edad);
        writeln('dni: ', E.dni);
        writeln('------------');
    end;
    close(empleados);
end;

var
    empleados: archivo_empleado;
    opcion: char;
    ID, nuevaEdad: integer;
begin
    assign(empleados, 'empleados.dat');
    reset(empleados);

    repeat
        writeln('Seleccione una opcion:');
        writeln('1. Agregar empleado');
        writeln('2. Cambiar edad de empleado');
        writeln('3. Imprimir lista de empleados');
        writeln('4. Exportar empleados');
        writeln('5. Exportar empleados sin DNI a texto');
        writeln('6. Salir');
        readln(opcion);
        
        case opcion of
            '1': agregarEmpleado(empleados);
            '2': begin
                    writeln('Ingrese ID empleado: ');
                    readln(ID);
                    writeln('Ingrese nueva edad: ');
                    readln(nuevaEdad);
                    cambiarEdad(empleados, ID, nuevaEdad);
                end;
            '3': imprimirArchivo(empleados);
            '4': exportarATexto(empleados);
            '5': exportarFaltaDNI(empleados);
            '6': writeln('Saliendo del programa...');
        else
            writeln('Opcion inválida.');
        end;
    until opcion = '6';
end.


