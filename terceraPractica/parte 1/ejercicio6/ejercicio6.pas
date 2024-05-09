//  Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
//  la información correspondiente a las prendas que se encuentran a la venta. De cada
//  prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
//  precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
//  prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
//  prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
//  ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
//  stock de la prenda correspondiente a valor negativo.

//  Adicionalmente, deberá implementar otro procedimiento que se encargue de
//  efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
//  información de las prendas a la venta. Para ello se deberá utilizar una estructura
//  auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
//  que no están marcadas como borradas. Al finalizar este proceso de compactación
//  del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
//  original.

Program ejercicio6;

Type 
  prenda = Record
    cod: integer;
    desc: string[50];
    colores: string[50];
    tipo: string[20];
    stock: integer;
    precio: real;
  End;
  arch_prendas = file Of prenda;
Procedure leerPrenda(Var arch:Text ; Var P: prenda);
Begin
  readln(arch, P.cod);
  readln(arch, P.desc);
  readln(arch, P.colores);
  readln(arch, P.tipo);
  readln(arch, P.stock, P.precio);
  writeln('Codigo: ', P.cod);
  writeln('Descripcion: ', P.desc);
  writeln('Colores: ', P.colores);
  writeln('Tipo: ', P.tipo);
  writeln('Stock: ', P.stock);
  writeln('Precio Unitario: ', P.precio:0:2);
  writeln();
End;
Procedure convertirArchivo(Var txt: Text; Var arch: arch_prendas);

Var 
  P: prenda;
Begin
  Reset(txt);
  Assign(arch,'maestro.dat');
  Rewrite(arch);
  P.cod := 0;
  P.desc := '';
  P.colores := '';
  P.tipo := '';
  P.stock := 0;
  P.precio := 0;
  Write(arch,P);
  While Not Eof(txt) Do
    Begin
      leerPrenda(txt,P);
      Write(arch,P);
    End;
  Close(txt);
End;
Procedure imprimirArchivo(Var arch: arch_prendas);

Var 
  P: prenda;
Begin
  Reset(arch);
  While Not Eof(arch) Do
    Begin
      Read(arch,P);
      writeln('Codigo: ', P.cod);
      writeln('Descripcion: ', P.desc);
      writeln('Colores: ', P.colores);
      writeln('Tipo: ', P.tipo);
      writeln('Stock: ', P.stock);
      writeln('Precio Unitario: ', P.precio:0:2);
      writeln('--------------');
    End;
  Close(arch);
End;
Procedure eliminarPrenda(Var arch: arch_prendas; cod: integer);

Var 
  encontrado: Boolean;
  P,cabecera: prenda;
Begin
  encontrado := False;
  Reset(arch);
  Read(arch,cabecera);
  While (Not eof(arch)) And (Not encontrado) Do
    Begin
      read(arch, P);
      If (P.cod = cod) Then
        Begin
          encontrado := true;
          seek(arch, filepos(arch)-1);
          write(arch, cabecera);
          cabecera.cod := -(filepos(arch)-1);
          seek(arch, 0);
          write(arch, cabecera);
          writeln('Prenda codigo ',cod,' eliminada exitosamente.');
        End;
    End;
  Close(arch);
End;
Procedure eliminarObsoletas(Var arch: arch_prendas);

Var 
  cod: Integer;
  delet: Text;
Begin
  Assign(delet,'detalle.txt');
  Reset(delet);
  While Not Eof(delet) Do
    Begin
      Read(delet,cod);
      eliminarPrenda(arch,cod);
    End;
  close(delet);
End;
Procedure compactarArchivo(Var archOrig,archCompact: arch_prendas);

Var 
  P: prenda;
Begin
  assign(archCompact, 'Temporal');
  rewrite(archCompact);
  reset(archOrig);
  While (Not eof(archOrig)) Do
    Begin
      read(archOrig, P);
      If (P.cod >= 0) Then
        write(archCompact, P);
    End;
  close(archOrig);
  close(archCompact);
  erase(archOrig);
  rename(archCompact, 'maestro.dat');
End;

Var 
  txtMaestro: Text;
  datMaestro,compactMaestro: arch_prendas;
Begin
  Assign(txtMaestro,'maestro.txt');
  convertirArchivo(txtMaestro,datMaestro);
  WriteLn('---- ARCHIVO ORIGINAL ----');
  imprimirArchivo(datMaestro);
  eliminarObsoletas(datMaestro);
  WriteLn('---- ARCHIVO CON BAJAS LOGICAS ----');
  imprimirArchivo(datMaestro);
  compactarArchivo(datMaestro,compactMaestro);
  WriteLn('---- ARCHIVO CON BAJAS FISICAS ----');
  imprimirArchivo(compactMaestro);
End.
