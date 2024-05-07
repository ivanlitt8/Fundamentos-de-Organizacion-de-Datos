
//    Definir un programa que genere un archivo con registros de longitud fija conteniendo
//    información de asistentes a un congreso a partir de la información obtenida por
//    teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
//    nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
//    archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
//    asistente inferior a 1000.
//    Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
//    String a su elección. Ejemplo: ‘@Saldaño’.


Program ejercicio2;

Type 
  str = string[15];
  asistente = Record
    id: integer;
    apellido: str;
    nombre: str;
    email: str;
    telefono: integer;
    dni: integer;
  End;

  archivo_asis = file Of asistente;

Procedure leerAsistente(Var A: asistente);
Begin
  writeln('Ingrese ID de asistente: ');
  readln(A.id);
  writeln('Ingrese apellido de asistente: ');
  readln(A.apellido);
  writeln('Ingrese nombre de asistente: ');
  readln(A.nombre);
  writeln('Ingrese email de asistente: ');
  readln(A.email);
  writeln('Ingrese dni de asistente: ');
  readln(A.dni);
  writeln('Ingrese telefono de asistente: ');
  readln(A.telefono);
End;

Procedure hacerBajaLogica (Var archivo: archivo_asis);

Var 
  A: asistente;
Begin
  reset(archivo);
  While Not eof(archivo) Do
    Begin
      read(archivo, A);
      If (A.id<1000) Then
        Begin
          A.apellido := '*'+A.apellido;
          seek(archivo, filePos(archivo) - 1);
          write(archivo, A);
        End;
    End;
  close(archivo);
  writeln('Se han borrado logicamente los asistentes con ID menor a 1000');
End;

Procedure agregarAsistente(Var archivo: archivo_asis);

Var 
  A: asistente;
Begin
  reset(archivo);
  leerAsistente(A);
  seek(archivo, FileSize(archivo));
  write(archivo, A);
  close(archivo);
End;

Procedure imprimirArchivo(Var archivo: archivo_asis);

Var 
  A: asistente;
Begin
  reset(archivo);
  While Not eof(archivo) Do
    Begin
      read(archivo, A);
      writeln('id: ', A.id);
      writeln('apellido: ', A.apellido);
      writeln('nombre: ', A.nombre);
      writeln('dni: ', A.dni);
      writeln('email: ', A.email);
      writeln('telefono: ', A.telefono);
      writeln('------------');
    End;
  close(archivo);
End;

Procedure exportarATexto(Var arch: archivo_asis);

Var 
  archivoTexto: Text;
  A: asistente;
Begin
  assign(archivoTexto, 'asistentes.txt');
  rewrite(archivoTexto);
  reset(arch);
  While Not eof(arch) Do
    Begin
      read(arch, A);
      writeln(archivoTexto, 'id: ', A.id);
      writeln(archivoTexto, 'apellido: ', A.apellido);
      writeln(archivoTexto, 'nombre: ', A.nombre);
      writeln(archivoTexto, 'dni: ', A.dni);
      writeln(archivoTexto, 'telefono: ', A.telefono);
      writeln(archivoTexto, '------------');
    End;
  close(archivoTexto);
  close(arch);
  writeln('Contenido exportado a "asistentes.txt".');
End;

Var 
  asistentes: archivo_asis;
  opcion: char;
Begin
  assign(asistentes, 'asistentes.dat');
  rewrite(asistentes);
  Repeat
    writeln('Seleccione una opcion:');
    writeln('1. Agregar empleado');
    writeln('2. Imprimir lista de empleados');
    writeln('3. Exportar empleados');
    writeln('4. Realizar baja logica');
    writeln('5. Salir');
    readln(opcion);
    Case opcion Of 
      '1': agregarAsistente(asistentes);
      '2': imprimirArchivo(asistentes);
      '3': exportarATexto(asistentes);
      '4': hacerBajaLogica(asistentes);
      '5': writeln('Saliendo del programa...');
      Else
        writeln('Opcion inválida.');
    End;
  Until opcion = '5';
End.
