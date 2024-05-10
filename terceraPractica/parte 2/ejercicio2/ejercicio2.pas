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

Type 
  mesa = Record
    codLocalidad: integer;
    nroMesa: integer;
    cantVotos: integer;
  End;

  mesaAux = Record
    codLocalidad: integer;
    cantVotos: integer;
  End;

  arch_mesa = File Of mesa;
  arch_mesaAux = File Of mesaAux;

Procedure leerMesa(Var arch:Text ; Var M: mesa);
Begin
  readln(arch, M.codLocalidad, M.nroMesa, M.cantVotos);
  // writeln('Codigo ciudad: ', M.codLocalidad);
  // writeln('Numero de mesa: ', M.nroMesa);
  // writeln('Cantidad de votos: ', M.cantVotos);
  // writeln();
End;
Procedure convertirArchivo(Var txt: Text; Var arch: arch_mesa);

Var 
  M: mesa;
Begin
  Reset(txt);
  Assign(arch,'maestro.dat');
  Rewrite(arch);
  While Not Eof(txt) Do
    Begin
      leerMesa(txt,M);
      Write(arch,M);
    End;
  Close(txt);
End;
Procedure imprimirArchivo(Var arch: arch_mesa);

Var 
  M: mesa;
Begin
  Reset(arch);
  While Not Eof(arch) Do
    Begin
      Read(arch,M);
      writeln('Codigo ciudad: ', M.codLocalidad);
      writeln('Numero de mesa: ', M.nroMesa);
      writeln('Cantidad de votos: ', M.cantVotos);
      writeln('--------------');
    End;
  Close(arch);
End;
Procedure acumularDatos(Var archAux:arch_mesaAux ; Var archMae:arch_mesa);

Var 
  M: mesa;
  Maux: mesaAux;
  encontrado: Boolean;
Begin
  Reset(archMae);
  While Not eof(archMae) Do
    Begin
      Read(archMae, M);
      encontrado := false;
      Reset(archAux);
      // Posicionar el cursor al principio del archivo auxiliar
      While Not eof(archAux) Do
        // Buscar si ya hay información para la localidad actual
        Begin
          Read(archAux,Maux);
          If (M.codLocalidad = Maux.codLocalidad) Then
            Begin
              encontrado := true;
              Maux.cantVotos := Maux.cantVotos + M.cantVotos;
              Seek(archAux, FilePos(archAux) - 1);
              // Mover el puntero de lectura/escritura de nuevo al registro actual para actualizarlo
              Write(archAux, Maux);
            End;
        End;
      // Si no se encontró información, agregarla al archivo auxiliar
      If Not encontrado Then
        Begin
          Maux.cantVotos := M.cantVotos;
          Maux.codLocalidad := M.codLocalidad;
          Seek(archAux, FileSize(archAux));
          // Mover el puntero de lectura/escritura al final del archivo auxiliar
          Write(archAux, Maux);
          // Escribir un nuevo registro en el archivo auxiliar
        End;
    End;
End;

Procedure imprimirNuevoArchivo (Var arch:arch_mesaAux);

Var 
  Maux: mesaAux;
  totalVotos: Integer;
Begin
  Reset(arch);
  totalVotos := 0;
  WriteLn();
  WriteLn('Codigo de Localidad        Total de Votos');
  WriteLn();
  While Not Eof(arch) Do
    Begin
      Read(arch,Maux);
      writeln('         ',Maux.codLocalidad,'                   ',Maux.cantVotos);
      totalVotos := totalVotos + Maux.cantVotos;
    End;
  Close(arch);
  WriteLn();
  writeln('Total General de Votos:        ', totalVotos);
  WriteLn();
  WriteLn();
End;

Var 
  txtMaestro: Text;
  datMaestro: arch_mesa;
  archivoAuxiliar: arch_mesaAux;
Begin
  Assign(txtMaestro,'maestro.txt');
  Assign(archivoAuxiliar, 'archivo_auxiliar.dat');
  Rewrite(archivoAuxiliar);
  convertirArchivo(txtMaestro,datMaestro);
  //WriteLn('---- ARCHIVO ORIGINAL ----');
  //imprimirArchivo(datMaestro);
  acumularDatos(archivoAuxiliar,datMaestro);
  WriteLn();
  WriteLn();
  WriteLn('---- TOTAL DE VOTOS POR CODIGO DE CIUDAD ----');
  imprimirNuevoArchivo(archivoAuxiliar);
End.
