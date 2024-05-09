//  Se cuenta con un archivo que almacena información sobre especies de aves en vía
//  de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
//  descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
//  un programa que elimine especies de aves, para ello se recibe por teclado las
//  especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
//  todos los procedimientos que requiera y una alternativa para borrar los registros. Para
//  ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
//  posteriormente otro procedimiento que compacte el archivo, quitando los registros
//  marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
//  posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
//  de evitar registros duplicados.

//  Nota: Las bajas deben finalizar al recibir el código 500000

Program ejercicio7;

Const 
  fin = 9999;

Type 
  especie = Record
    codigo: integer;
    nombre: string[50];
    familia: string[25];
    descripcion: string[100];
    zona_geografica: string[50];
  End;
  arch_especies = file Of especie;

Procedure leerEspecie(Var arch:Text ; Var E: especie);
Begin
  readln(arch, E.codigo);
  readln(arch, E.nombre);
  readln(arch, E.familia);
  readln(arch, E.descripcion);
  readln(arch, E.zona_geografica);
  writeln();
End;
Procedure convertirArchivo(Var txt: Text; Var arch: arch_especies);

Var 
  E: especie;
Begin
  Reset(txt);
  Assign(arch,'maestro.dat');
  Rewrite(arch);
  While Not Eof(txt) Do
    Begin
      leerEspecie(txt,E);
      Write(arch,E);
    End;
  Close(txt);
End;
Procedure imprimirArchivo(Var arch: arch_especies);

Var 
  E: especie;
Begin
  Reset(arch);
  While Not Eof(arch) Do
    Begin
      Read(arch,E);
      writeln('Codigo: ', E.codigo);
      writeln('Nombre: ', E.nombre);
      writeln('Familia: ', E.familia);
      writeln('Descripcion: ', E.descripcion);
      writeln('Zona: ', E.zona_geografica);
      writeln('--------------');
    End;
  Close(arch);
End;
Procedure marcarEspecie(cod: Integer; Var arch: arch_especies; Var marcada: Boolean);

Var 
  encontrado: Boolean;
  E: especie;
Begin
  Reset(arch);
  encontrado := false;
  marcada := False;
  While Not Eof(arch) And (Not encontrado) Do
    Begin
      Read(arch,E);
      If (E.codigo = cod) Then
        Begin
          encontrado := True;
          Seek(arch, FilePos(arch)-1);
          E.codigo := -1;
          marcada := true;
          Write(arch,E);
        End;
    End;
  Close(arch);
End;

Procedure eliminarEspecie(cod: integer; Var arch: arch_especies);

Var 
  ult,E: especie;
  encontrado: Boolean;
Begin
  Reset(arch);
  // Abro el archivo
  Seek(arch, FileSize(arch)-1);
  // Me paro en la anteultima pos
  Read(arch,ult);
  // Leo el ult registro 
  encontrado := false;
  Seek(arch,0);
  // Me paro pos inicial del archivo
  While Not Eof(arch) And (Not encontrado) Do
    Begin
      Read(arch,E);
      If (E.codigo = -1) Then       // Si esta marcado
        Begin
          encontrado := True;
          Seek(arch, FilePos(arch)-1);
          // Retrocedo una posicion
          Write(arch,ult);
          // Sobrescribo la posicion con el ultimo registro
        End;
    End;
  Seek(arch, FileSize(arch)-1);
  // Me paro en la anteultima pos
  Truncate(arch);
  // Trunc en la anteultima pos para evitar duplicados
End;

Procedure eliminarEspecies(Var arch: arch_especies);

Var 
  cod: Integer;
  marcada: Boolean;
  delet: Text;
Begin
  Write('Ingrese codigo de especie a eliminar: ');
  ReadLn(cod);
  marcada := False;
  While (cod <> fin)  Do
    Begin
      marcarEspecie(cod,arch,marcada);
      If marcada Then
        Begin
          eliminarEspecie(cod,arch);
          Writeln('Se ha eliminado la especie con el codigo ',cod);
        End
      Else
        Writeln('El codigo ',cod,' no pertenece a una especie existente');
      Write('Ingrese codigo de especie a eliminar: ');
      ReadLn(cod);
    End;
End;

Var 
  txtMaestro: Text;
  datMaestro: arch_especies;
Begin
  Assign(txtMaestro,'maestro.txt');
  convertirArchivo(txtMaestro,datMaestro);
  WriteLn('---- ARCHIVO ORIGINAL ----');
  imprimirArchivo(datMaestro);
  WriteLn('Comenzado proceso de borrado...');
  eliminarEspecies(datMaestro);
  WriteLn('---- ARCHIVO CON ELIMINACIONES ----');
  imprimirArchivo(datMaestro);
End.
