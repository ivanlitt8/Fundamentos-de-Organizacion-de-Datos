//	Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
//	agregándole una opción para realizar bajas copiando el último registro del archivo en
//	la posición del registro a borrar y luego truncando el archivo en la posición del último
//	registro de forma tal de evitar duplicados.   

Program ejercicio1;

Type 
  str = string[15];
  empleado = Record
    id: integer;
    apellido: str;
    nombre: str;
    edad: integer;
    dni: integer;
  End;
  archivo_empleado = file Of empleado;

Procedure leerEmpleado(Var E: empleado);
Begin
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
End;

Procedure agregarEmpleado(Var archivo: archivo_empleado);

Var 
  E: empleado;
Begin
  reset(archivo);
  leerEmpleado(E);
  seek(archivo, FileSize(archivo));
  write(archivo, E);
  close(archivo);
End;
Procedure imprimirArchivo(Var empleados: archivo_empleado);

Var 
  E: empleado;
Begin
  reset(empleados);
  While Not eof(empleados) Do
    Begin
      read(empleados, E);
      writeln('id: ', E.id);
      writeln('apellido: ', E.apellido);
      writeln('nombre: ', E.nombre);
      writeln('edad: ', E.edad);
      writeln('dni: ', E.dni);
      writeln('------------');
    End;
  close(empleados);
End;
Procedure hacerBaja(Var archivo: archivo_empleado);

Var 
  E, ultimo: empleado;
  id: integer;
  encontrado: boolean;
Begin
  reset(archivo);
  write('Ingrese id de empleado: ');
  readln(id);
  encontrado := false;
  seek(archivo, fileSize(archivo)-1);
  read(archivo, ultimo);
  seek(archivo, 0);
  read(archivo, e);
  While (Not eof(archivo) And (Not encontrado)) Do
    Begin
      read(archivo, E);
      If (E.id = id) Then
        Begin
          encontrado := true;
          // Reemplazar el registro con el último registro del archivo
          seek(archivo, filePos(archivo) - 1);
          write(archivo, ultimo);
        End;
    End;
  // Truncar el archivo para eliminar el último registro duplicado
  If encontrado Then
    Begin
      seek(archivo, fileSize(archivo) - 1);
      truncate(archivo);
      writeln('Se realizo la baja correctamente');
    End
  Else
    writeln('Ese ID no corresponde a un empleado en el registro');

  close(archivo);
End;
Procedure exportarATexto(Var empleados: archivo_empleado);

Var 
  archivoTexto: Text;
  E: empleado;
Begin
  assign(archivoTexto, 'todos_empleados.txt');
  rewrite(archivoTexto);

  reset(empleados);
  While Not eof(empleados) Do
    Begin
      read(empleados, E);
      writeln(archivoTexto, 'id: ', E.id);
      writeln(archivoTexto, 'apellido: ', E.apellido);
      writeln(archivoTexto, 'nombre: ', E.nombre);
      writeln(archivoTexto, 'edad: ', E.edad);
      writeln(archivoTexto, 'dni: ', E.dni);
      writeln(archivoTexto, '------------');
    End;

  close(archivoTexto);
  close(empleados);

  writeln('Contenido exportado a "todos_empleados.txt".');
End;
Procedure exportarFaltaDNI(Var empleados: archivo_empleado);

Var 
  archivoTexto: Text;
  E: empleado;
Begin
  assign(archivoTexto, 'faltaDNIEmpleado.txt');
  rewrite(archivoTexto);

  reset(empleados);
  While Not eof(empleados) Do
    Begin
      read(empleados, E);
      If E.dni = 0 Then // Verificar si el DNI es 0
        Begin
          writeln(archivoTexto, 'id: ', E.id);
          writeln(archivoTexto, 'apellido: ', E.apellido);
          writeln(archivoTexto, 'nombre: ', E.nombre);
          writeln(archivoTexto, 'edad: ', E.edad);
          writeln(archivoTexto, 'dni: ', E.dni);
          writeln(archivoTexto, '------------');
        End;
    End;

  close(archivoTexto);
  close(empleados);

  writeln('Empleados sin DNI exportados correctamente a "faltaDNIEmpleado.txt".');
End;
Procedure cambiarEdad(Var archivo: archivo_empleado; idEmpleado: integer; nuevaEdad: integer);

Var 
  E: empleado;
  encontrado: boolean;
Begin
  encontrado := false;
  reset(archivo);
  While Not eof(archivo) And Not encontrado Do
    Begin
      read(archivo, E);
      If E.id = idEmpleado Then
        Begin
          encontrado := true;
          E.edad := nuevaEdad;
          seek(archivo, filepos(archivo) - 1);
          write(archivo, E);
        End;
    End;
  close(archivo);

  If encontrado Then
    writeln('Edad del empleado actualizada correctamente.')
  Else
    writeln('Empleado con ID ', idEmpleado, ' no encontrado.');
End;

Var 
  empleados: archivo_empleado;
  opcion: char;
  ID, nuevaEdad: integer;
Begin
  assign(empleados, 'empleados.dat');
  reset(empleados);

  Repeat
    writeln('Seleccione una opcion:');
    writeln('1. Agregar empleado');
    writeln('2. Cambiar edad de empleado');
    writeln('3. Imprimir lista de empleados');
    writeln('4. Exportar empleados');
    writeln('5. Exportar empleados sin DNI a texto');
    writeln('6. Realizar baja');
    writeln('7. Salir');
    readln(opcion);

    Case opcion Of 
      '1': agregarEmpleado(empleados);
      '2':
           Begin
             writeln('Ingrese ID empleado: ');
             readln(ID);
             writeln('Ingrese nueva edad: ');
             readln(nuevaEdad);
             cambiarEdad(empleados, ID, nuevaEdad);
           End;
      '3': imprimirArchivo(empleados);
      '4': exportarATexto(empleados);
      '5': exportarFaltaDNI(empleados);
      '6': hacerBaja(empleados);
      '7': writeln('Saliendo del programa...');
      Else
        writeln('Opcion inválida.');
    End;
  Until opcion = '7';
End.
