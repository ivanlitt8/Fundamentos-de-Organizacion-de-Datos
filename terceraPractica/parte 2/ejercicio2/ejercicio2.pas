//  Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
//  localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
//  siguiente información: código de localidad, número de mesa y cantidad de votos en
//  dicha mesa. Presentar en pantalla un listado como se muestra a continuación:

//        Código de Localidad               Total de Votos
//  ................................    ......................
//  ................................    ......................

//  Total General de Votos:             ......................

//  NOTAS:
//      ● La información en el archivo no está ordenada por ningún criterio.
//      ● Trate de resolver el problema sin modificar el contenido del archivo dado.
//      ● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
//        llevar el control de las localidades que han sido procesadas.

Program ejercicio2;

Const 
  fin = 'ZZZZ';

Type 
  linux = Record
    nombre: String;
    anioLanz: Integer;
    vKernel: real;
    cantDevs: Integer;
    descrip: String;
  End;
  arch_linux = File Of linux;

Procedure leerDistribucion(Var arch:Text ; Var L: linux);
Begin
  readln(arch, L.nombre);
  readln(arch, L.anioLanz, L.vKernel, L.cantDevs);
  readln(arch, L.descrip);
  writeln('Nombre: ', L.nombre);
  writeln('Anio Lanzamiento: ', L.anioLanz);
  writeln('Version Kernel: ', L.vKernel:0:2);
  writeln('Cantidad de desarrolladores: ', L.cantDevs);
  writeln('Descripcion: ', L.descrip);
  writeln();
End;
Procedure convertirArchivo(Var txt: Text; Var arch: arch_linux);

Var 
  L: linux;
Begin
  Reset(txt);
  Assign(arch,'maestro.dat');
  Rewrite(arch);
  L.nombre := '';
  L.anioLanz := 0;
  L.vKernel := 0.0;
  L.cantDevs := 0;
  L.descrip := '';
  Write(arch,L);
  While Not Eof(txt) Do
    Begin
      leerDistribucion(txt,L);
      Write(arch,L);
    End;
  Close(txt);
End;
Procedure imprimirArchivo(Var arch: arch_linux);

Var 
  L: linux;
Begin
  Reset(arch);
  While Not Eof(arch) Do
    Begin
      Read(arch,L);
      writeln('Nombre: ', L.nombre);
      writeln('Anio Lanzamiento: ', L.anioLanz);
      writeln('Version Kernel: ', L.vKernel:0:2);
      writeln('Cantidad de desarrolladores: ', L.cantDevs);
      writeln('Descripcion: ', L.descrip);
      writeln('--------------');
    End;
  Close(arch);
End;

Procedure existeDistribucion(Var arch: arch_linux ; Var encontrado: Boolean ; nombre: String);

Var 
  L: linux;
Begin
  encontrado := false;
  Reset(arch);
  While Not Eof(arch) And (Not encontrado) Do
    Begin
      read(arch,L);
      If (L.nombre = nombre) Then
        encontrado := true;
    End;
  Close(arch);
End;
Procedure borrarDistribucion(Var arch: arch_linux; nombre: String);

Var 
  L,cabecera: linux;
  encontrado: Boolean;
Begin
  encontrado := false;
  Reset(arch);
  Read(arch,cabecera);
  While (Not eof(arch)) And (Not encontrado) Do
    Begin
      read(arch, L);
      If (L.nombre = nombre) Then
        Begin
          encontrado := true;
          seek(arch, filepos(arch)-1);
          write(arch, cabecera);
          cabecera.cantDevs := -(filepos(arch)-1);
          seek(arch, 0);
          write(arch, cabecera);
          writeln('Se elimino exitosamente la distribucion ',nombre);
        End;
    End;
  Close(arch);
End;
Procedure bajaDistribucion(Var arch: arch_linux);

Var 
  nombre: String;
  existe: Boolean;
Begin
  Writeln('Iniciando proceso de eliminacion... Ingrese ZZZZ para finalizar');
  Write('Ingrese nombre de distribucion a eliminar: ');
  ReadLn(nombre);
  While (nombre<>fin) Do
    Begin
      existeDistribucion(arch,existe,nombre);
      If existe Then
        borrarDistribucion(arch,nombre)
      Else
        WriteLn('La distribucion con nombre ',nombre,' no existente');
      Write('Ingrese nombre de distribucion a eliminar: ');
      ReadLn(nombre);
    End;
End;
Procedure agregarDistribucion(Var arch: arch_linux ; L: linux);

Var 
  cabecera: linux;
Begin
  reset(arch);
  read(arch, cabecera);
  If (cabecera.cantDevs <> 0) Then
    Begin
      seek(arch, -cabecera.cantDevs);
      // Me paro en la pos recuperable
      read(arch, cabecera);
      // Leo el registro y lo asigno a cabecera
      seek(arch, filepos(arch)-1);
      // Retrocedo por la lectura
      write(arch, L);
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
      write(arch, L);
      // Cargo el nuevo registro
    End;
  close(arch);
End;
Procedure leerLinux(Var L: linux);
Begin
  write('Ingrese nombre de distribucion: ');
  ReadLn(L.nombre);
  write('Ingrese anio de lanzamiento: ');
  ReadLn(L.anioLanz);
  write('Ingrese version Kernel: ');
  ReadLn(L.vKernel);
  write('Ingrese cantidad de desarrolladores: ');
  ReadLn(L.cantDevs);
  write('Ingrese descripcion: ');
  ReadLn(L.descrip);
End;
Procedure altaDistribucion(Var arch:arch_linux);

Var 
  L: linux;
  existe: Boolean;
Begin
  leerLinux(L);
  existeDistribucion(arch,existe,L.nombre);
  If existe Then
    WriteLn('La distribucion con nombre ',L.nombre,' ya existente.')
  Else
    agregarDistribucion(arch,L);
End;

Var 
  txtMaestro: Text;
  datMaestro: arch_linux;
  encontrado: Boolean;
Begin
  Assign(txtMaestro,'maestro.txt');
  convertirArchivo(txtMaestro,datMaestro);
  WriteLn('---- ARCHIVO ORIGINAL ----');
  imprimirArchivo(datMaestro);
  bajaDistribucion(datMaestro);
  WriteLn('---- ARCHIVO CON BAJAS ----');
  imprimirArchivo(datMaestro);
  altaDistribucion(datMaestro);
  WriteLn('---- ARCHIVO CON ALTAS ----');
  imprimirArchivo(datMaestro);
End.
