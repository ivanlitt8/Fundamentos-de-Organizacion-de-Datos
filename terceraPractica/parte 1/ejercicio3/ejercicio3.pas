
//  Realizar un programa que genere un archivo de novelas filmadas durante el presente
//  año. De cada novela se registra: código, género, nombre, duración, director y precio.
//  El programa debe presentar un menú con las siguientes opciones:

//  a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
//    utiliza la técnica de lista invertida para recuperar espacio libre en el
//    archivo. Para ello, durante la creación del archivo, en el primer registro del
//    mismo se debe almacenar la cabecera de la lista. Es decir un registro
//    ficticio, inicializando con el valor cero (0) el campo correspondiente al
//    código de novela, el cual indica que no hay espacio libre dentro del
//    archivo.

//  b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
//    inciso a., se utiliza lista invertida para recuperación de espacio. En
//    particular, para el campo de ´enlace´ de la lista, se debe especificar los
//    números de registro referenciados con signo negativo, (utilice el código de
//    novela como enlace).Una vez abierto el archivo, brindar operaciones para:

//      i. Dar de alta una novela leyendo la información desde teclado. Para
//      esta operación, en caso de ser posible, deberá recuperarse el
//      espacio libre. Es decir, si en el campo correspondiente al código de
//      novela del registro cabecera hay un valor negativo, por ejemplo -5,
//      se debe leer el registro en la posición 5, copiarlo en la posición 0
//      (actualizar la lista de espacio libre) y grabar el nuevo registro en la
//      posición 5. Con el valor 0 (cero) en el registro cabecera se indica
//      que no hay espacio libre.

//      ii. Modificar los datos de una novela leyendo la información desde
//      teclado. El código de novela no puede ser modificado.

//      iii. Eliminar una novela cuyo código es ingresado por teclado. Por
//      ejemplo, si se da de baja un registro en la posición 8, en el campo
//      código de novela del registro cabecera deberá figurar -8, y en el
//      registro en la posición 8 debe copiarse el antiguo registro cabecera.

// c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
// representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
// NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
// proporcionado por el usuario.

Program ejercicio3;

Type 
  str = string[15];
  novela = Record
    id: integer;
    genero: str;
    nombre: str;
    duracion: integer;
    director: str;
    precio: real;
    enlace: integer;
  End;

  archivo_novelas = file Of novela;

Procedure leerNovela(Var N: novela);
Begin
  write('Ingrese ID de novela: ');
  readln(N.id);
  write('Ingrese genero de novela: ');
  readln(N.genero);
  write('Ingrese nombre de novela: ');
  readln(N.nombre);
  write('Ingrese duracion de novela: ');
  readln(N.duracion);
  write('Ingrese nombre director: ');
  readln(N.director);
  write('Ingrese precio de entrada: ');
  readln(N.precio);
End;

Procedure agregarNovela(Var archivo: archivo_novelas);

Var 
  N: novela;
Begin
  reset(archivo);
  leernovela(N);
  seek(archivo, FileSize(archivo));
  write(archivo, N);
  close(archivo);
End;

Procedure imprimirArchivo(Var archivo: archivo_novelas);

Var 
  N: novela;
Begin
  reset(archivo);
  While Not eof(archivo) Do
    Begin
      read(archivo, N);
      writeln('id: ', N.id);
      writeln('genero: ', N.genero);
      writeln('nombre: ', N.nombre);
      writeln('duracion: ', N.duracion);
      writeln('director: ', N.director);
      writeln('precio: ', N.precio:0:2);
      writeln('------------');
    End;
  close(archivo);
End;

Procedure exportarATexto(Var arch: archivo_novelas);

Var 
  archivoTexto: Text;
  N: novela;
Begin
  assign(archivoTexto, 'novelas.txt');
  rewrite(archivoTexto);
  reset(arch);
  While Not eof(arch) Do
    Begin
      read(arch, N);
      writeln(archivoTexto, 'id: ', N.id);
      writeln(archivoTexto, 'genero: ', N.genero);
      writeln(archivoTexto, 'nombre: ', N.nombre);
      writeln(archivoTexto, 'duracion: ', N.duracion);
      writeln(archivoTexto, 'director: ', N.director);
      writeln(archivoTexto, 'precio: ', N.precio:0:2);
      writeln(archivoTexto, '------------');
    End;
  close(archivoTexto);
  close(arch);
  writeln('Contenido exportado a "novelas.txt".');
End;
Procedure crearArchivo();

Var 
  archivo: archivo_novelas;
  N: novela;
  nombre: string;
  id: integer;
Begin
  write('Nombre del archivo');
  readln(nombre);
  assign(archivo, nombre);
  rewrite(archivo);
  N.id := 0;
  // Indica que no hay espacio libre
  N.enlace := 0;
  // No hay más registros después del primero
  Repeat
    writeln('Ingrese el codigo de la novela (0 para salir): ');
    readln(codigo);
    If codigo <> 0 Then
      Begin
        nuevaNovela.codigo := codigo;
        writeln('Ingrese el genero: ');
        readln(nuevaNovela.genero);
        writeln('Ingrese el nombre: ');
        readln(nuevaNovela.nombre);
        writeln('Ingrese la duracion en minutos: ');
        readln(nuevaNovela.duracion);
        writeln('Ingrese el director: ');
        readln(nuevaNovela.director);
        writeln('Ingrese el precio: ');
        readln(nuevaNovela.precio);

        // Escribimos la nueva novela en el archivo
        Write(archivo, nuevaNovela);
      End;
  Until codigo = 0;
  close(archivo);
  writeln('Archivo '+nombre+' generado');
End;

Var 
  novelas: archivo_novelas;
  opcion: char;
Begin
  Repeat
    writeln('Seleccione una opcion:');
    writeln('1. Crear archivo de novelas');
    writeln('3. Imprimir lista de novelas');
    writeln('4. Exportar novelas');
    writeln('5. Realizar baja logica');
    writeln('6. Salir');
    readln(opcion);
    Case opcion Of 
      '1': crearArchivo(novelas);
      '3': imprimirArchivo(novelas);
      '4': exportarATexto(novelas);
      //'5': hacerBajaLogica(novelas);
      '6': writeln('Saliendo del programa...');
      Else
        writeln('Opcion inválida.');
    End;
  Until opcion = '6';
End.
