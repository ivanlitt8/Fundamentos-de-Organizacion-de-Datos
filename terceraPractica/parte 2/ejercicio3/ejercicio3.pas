//  Suponga que trabaja en una oficina donde está montada una LAN (red local). La
//  misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
//  todas las máquinas se conectan con un servidor central. Semanalmente cada
//  máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
//  en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
//  los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento
//  que reciba los archivos detalle y genere un archivo maestro con los siguientes datos:
//  cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

//  Notas:
//    ● Los archivos detalle no están ordenados por ningún criterio.
//    ● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina,
//      o inclusive, en diferentes máquinas.

Program ejercicio3;

Const 
  dimF = 3;
  valoralto = 9999;

Type 

  rango = 1..dimF;

  sesion = Record
    codUsuario: integer;
    fecha: string;
    tiempoSesion: real;
  End;

  arch_sesion = File Of sesion;

  vectSesiones = array[rango] Of arch_sesion;
  vectRegistroSesiones = array[rango] Of sesion;
  vectString = array[rango] Of String;

Procedure leerSesion(Var arch:Text ; Var S: sesion);
Begin
  readln(arch, S.codUsuario);
  readln(arch, S.fecha);
  readln(arch, S.tiempoSesion);
  // writeln('Codigo: ', S.codUsuario);
  // writeln('Fecha: ', S.fecha);
  // writeln('Tiempo sesion: ', S.tiempoSesion:0:2);
  // writeln();
End;

Procedure imprimirArchivo(Var arch: arch_sesion);

Var 
  S: sesion;
Begin
  Reset(arch);
  While Not Eof(arch) Do
    Begin
      Read(arch,S);
      writeln('Codigo de usuario: ', S.codUsuario);
      writeln('Fecha: ', S.fecha);
      writeln('Tiempo total de sesion abiertas: ', S.tiempoSesion:0:2);
      writeln('--------------');
    End;
  Close(arch);
End;

Procedure generarDetalle ( Var arch: arch_sesion; nombre: String);

Var 
  dat,txt: string;
  detalleTxt: Text;
  S: sesion;
Begin
  txt := nombre + '.txt';
  assign(detalleTxt,txt);
  reset(detalleTxt);
  dat := nombre + '.dat';
  assign(arch,dat);
  rewrite(arch);
  While Not eof(detalleTxt) Do
    Begin
      leerSesion(detalleTxt,S);
      write(arch,S);
    End;
  writeln('Archivo ',dat,' exitosamente creado');
  WriteLn();
  close(detalleTxt);
  close(arch);
End;

Procedure cargarVectorDetalle(Var V:vectSesiones);

Var 
  i: rango;
  vNombres: vectString;
Begin
  vNombres[1] := 'detalleUno';
  vNombres[2] := 'detalleDos';
  vNombres[3] := 'detalleTres';
  For i:= 1 To dimF Do
    generarDetalle(V[i],vNombres[i]);
  writeln('Se han generado todos los detalles.')
End;

Procedure leerDetalle (Var arch:arch_sesion; Var S: sesion);
Begin
  If (Not eof(arch)) Then
    read(arch, S)
  Else
    S.codUsuario := valoralto;
End;

Procedure minimo (Var V: vectSesiones; Var vectDet: vectRegistroSesiones ; Var Smin: sesion);

Var 
  pos,i: integer;
Begin
  Smin.codUsuario := valorAlto;
  For i:= 1 To dimF Do
    If (vectDet[i].codUsuario < Smin.codUsuario) Then
      Begin
        Smin := vectDet[i];
        pos := i;
      End;
  If (Smin.codUsuario <> valorAlto) Then
    leerDetalle(V[pos],vectDet[pos]);
End;


Procedure generarMaestro(Var V:vectSesiones; Var arch: arch_sesion);

Var 
  i: integer;
  S, Saux: sesion;
  encontrado: boolean;
Begin
  reset(arch);
  For i:= 1 To dimF Do
    Begin
      reset(V[i]);
      While Not eof(V[i]) Do
        Begin
          read(V[i], S);
          encontrado := false;
          seek(arch, 0);
          While (Not eof(arch)) And (Not encontrado) Do
            Begin
              read(arch, Saux);
              If (Saux.codUsuario= S.codUsuario) Then
                encontrado := true;
            End;
          If (encontrado) Then
            Begin
              Saux.tiempoSesion := Saux.tiempoSesion + S.tiempoSesion;
              seek(arch, filepos(arch)-1);
              write(arch, Saux);
            End
          Else
            write(arch, S);
        End;
      close(V[i]);
    End;
  close(arch);
End;

Var 
  datMaestro: arch_sesion;
  V: vectSesiones;
Begin
  Assign(datMaestro,'maestro.dat');
  rewrite(datMaestro);
  cargarVectorDetalle(V);
  generarMaestro(V,datMaestro);
  imprimirArchivo(datMaestro);
End.
