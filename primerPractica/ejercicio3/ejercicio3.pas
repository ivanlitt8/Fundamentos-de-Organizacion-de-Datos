{
	Realizar un programa que presente un menú con opciones para:
	a. Crear un archivo de registros no ordenados de empleados y completarlo con
	datos ingresados desde teclado. De cada empleado se registra: número de
	empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
	DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

	b. Abrir el archivo anteriormente generado y:
	
		i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
		determinado, el cual se proporciona desde el teclado.
		
		ii. Listar en pantalla los empleados de a uno por línea.
		
		iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
	
	NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}

program ejercicio3;

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
    if (E.apellido <> 'fin') then
    begin
        writeln('Ingrese nombre de empleado: ');
        readln(E.nombre);
        writeln('Ingrese ID de empleado: ');
        readln(E.id);
        writeln('Ingrese edad de empleado: ');
        readln(E.edad);
        writeln('Ingrese dni de empleado: ');
        readln(E.dni);
    end;
end;

procedure agregarEmpleados(var empleados: archivo_empleado);
var
    E: empleado;
begin
    leerEmpleado(E);
    while (E.apellido <> 'fin') do
    begin
        write(empleados, E);
        leerEmpleado(E);
    end;
end;

procedure buscarPorApellido(var empleados: archivo_empleado);
var
    E: empleado;
    apellido: str;
begin
    writeln('Ingrese apellido a buscar:');
    readln(apellido);
    reset(empleados);
    while not eof(empleados) do
    begin
        read(empleados, E);
        if (E.apellido = apellido) then
        begin
            writeln('****** EMPLEADO ******');
            writeln('id: ', E.id);
            writeln('apellido: ', E.apellido);
            writeln('nombre: ', E.nombre);
            writeln('edad: ', E.edad);
            writeln('dni: ', E.dni);
        end;
    end;
    close(empleados);
end;

procedure imprimirListaCompleta(var empleados: archivo_empleado);
var
    E: empleado;
begin
    reset(empleados);
    writeln('****** Listado Completo ******');
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

procedure imprimirProximosJubilacion(var empleados: archivo_empleado);
var
    E: empleado;
begin
    reset(empleados);
    writeln('****** Proximos Jubilacion ******');
    while not eof(empleados) do
    begin
        read(empleados, E);
        if (E.edad > 70) then
        begin
            writeln('id: ', E.id);
            writeln('apellido: ', E.apellido);
            writeln('nombre: ', E.nombre);
            writeln('edad: ', E.edad);
            writeln('dni: ', E.dni);
            writeln('------------');
        end;
    end;
    close(empleados);
end;

var
    empleados: archivo_empleado;
    opcion, ruta: string;
begin
    writeln('Ingrese nombre de archivo');
    readln(ruta);
    ruta:= ruta + '.dat';
    assign(empleados, ruta);
    rewrite(empleados);

    repeat
        writeln('Seleccione una opcion:');
        writeln('1. Agregar empleados');
        writeln('2. Buscar empleado por apellido');
        writeln('3. Imprimir lista completa de empleados');
        writeln('4. Imprimir empleados proximos a jubilacion');
        writeln('5. Salir');
        readln(opcion);
        
        case opcion of
            '1': agregarEmpleados(empleados);
            '2': buscarPorApellido(empleados);
            '3': imprimirListaCompleta(empleados);
            '4': imprimirProximosJubilacion(empleados);
            '5': writeln('Saliendo del programa...');
        else
            writeln('Opcion invalida.');
        end;
    until opcion = '5';
end.

