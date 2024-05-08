//  4. Dada la siguiente estructura:
//    type
//      reg_flor = record
//      nombre: String[45];
//      codigo:integer;
//    end;
//    tArchFlores = file of reg_flor;

//  Las bajas se realizan apilando registros borrados y las altas reutilizando registros
//  borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
//  número 0 en el campo código implica que no hay registros borrados y -N indica que el
//  próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

//    a. Implemente el siguiente módulo:

//    (Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política
//    descrita anteriormente)

//    procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

//    b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
//    considere necesario para obtener el listado.

//  5.Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
//    (Abre el archivo y elimina la flor recibida como parámetro manteniendo la política
//    descripta anteriormente}
//procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);

Program ejercicio4y5;

Type 

  reg_flor = Record
    nombre: String[45];
    codigo: integer;
  End;

  tArchFlores = file Of reg_flor;

Procedure leerFlor(Var F: reg_flor);
Begin
  write('Ingrese codigo de flor: ');
  readln(F.codigo);
  If (F.codigo<>0) Then
    Begin
      write('Ingrese nombre de flor: ');
      readln(F.nombre);
    End;
End;

Procedure agregarFlor(Var arch: tArchFlores ; nombre: String; codigo:integer);

Var 
  F, cabecera: reg_flor;
Begin
  reset(arch);
  read(arch, cabecera);
  F.nombre := nombre;
  F.codigo := codigo;
  If (cabecera.codigo <> 0) Then
    Begin
      seek(arch, -cabecera.codigo);
      // Me paro en la pos recuperable
      read(arch, cabecera);
      // Leo el registro y lo asigno a cabecera
      seek(arch, filepos(arch)-1);
      // Retrocedo por la lectura
      write(arch, F);
      // Escribo el nuevo archivo en la posicion
      seek(arch, 0);
      // Vuelvo a la posicion 0
      write(arch, cabecera);
      // actualizo la cabecera
    End
  Else
    Begin
      seek(arch, filesize(arch));
      //Voy a la ult posicion
      write(arch, F);
      // Cargo el nuevo registro
    End;
  close(arch);
End;

Procedure eliminarFlor (Var arch: tArchFlores; FReg:reg_flor);

Var 
  cabecera, F: reg_flor;
  encontrado: Boolean;
Begin
  Reset(arch);
  Read(arch,cabecera);
  encontrado := false;
  While (Not eof(arch) And (Not encontrado)) Do
    Begin
      read(arch, F);
      If (F.codigo = FReg.codigo) Then
        Begin
          encontrado := true;
          seek(arch, filepos(arch)-1);
          write(arch, cabecera);
          cabecera.codigo := -(filepos(arch)-1);
          seek(arch, 0);
          write(arch, cabecera);
          writeln('Flor eliminada exitosamente.');
        End;
    End;
  If Not encontrado Then
    Writeln('No existe una flor con el codigo ',FReg.codigo);
  Close(arch);
End;
Procedure imprimirArchivo(Var arch: tArchFlores);

Var 
  F: reg_flor;
Begin
  reset(arch);
  While Not eof(arch) Do
    Begin
      read(arch, F);
      writeln('codigo: ', F.codigo);
      writeln('nombre: ', F.nombre);
      writeln('------------');
    End;
  close(arch);
End;
Procedure eliminarFlores (Var arch: tArchFlores);

Var 
  cod: integer;
  encontrado: Boolean;
  F,FEliminar: reg_flor;
Begin
  imprimirArchivo(arch);
  Writeln('Ingrese codigo de flor a eliminar');
  Readln(cod);
  encontrado := false;
  Reset(arch);
  While (Not Eof(arch)) And (Not encontrado) Do
    Begin
      read(arch,F);
      If (F.codigo=cod) Then
        Begin
          encontrado := true;
          FEliminar := F;
        End;
    End;
  Close(arch);
  If (encontrado) Then
    eliminarFlor(arch,FEliminar);
End;
Procedure agregarFlores (Var arch: tArchFlores);

Var 
  F: reg_flor;
Begin
  leerFlor(F);
  While (F.codigo<>0) Do
    Begin
      agregarFlor(arch,F.nombre,F.codigo);
      leerFlor(F);
    End;
End;

Procedure exportarATexto(Var arch: tArchFlores);

Var 
  archivoTexto: Text;
  F: reg_flor;
Begin
  assign(archivoTexto, 'flores.txt');
  rewrite(archivoTexto);
  reset(arch);
  While Not eof(arch) Do
    Begin
      read(arch, F);
      writeln(archivoTexto, 'id: ', F.codigo);
      writeln(archivoTexto, 'nombre: ', F.nombre);
      writeln(archivoTexto, '------------');
    End;
  close(archivoTexto);
  close(arch);
  writeln('Contenido exportado a "flores.txt".');
End;
Procedure crearArchivo( Var arch: tArchFlores);

Var 
  F: reg_flor;
Begin
  assign(arch, 'flores.dat');
  rewrite(arch);
  F.codigo := 0;
  F.nombre := '';
  write(arch,F);
  close(arch);
  writeln('Archivo flores.dat generado');
End;

Var 
  flores: tArchFlores;
  opcion: char;
Begin
  crearArchivo(flores);
  Repeat
    writeln('Seleccione una opcion:');
    writeln('1. Agregar flores');
    writeln('2. Eliminar flores');
    writeln('3. Imprimir flores');
    writeln('4. Exportar flores');
    writeln('5. Salir');
    readln(opcion);
    Case opcion Of 
      '1': agregarFlores(flores);
      '2': eliminarFlores(flores);
      '3': imprimirArchivo(flores);
      '4': exportarATexto(flores);
      '5': writeln('Saliendo del programa...');
      Else
        writeln('Opcion inválida.');
    End;
  Until opcion = '5';
End.
