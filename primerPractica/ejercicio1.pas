{
	Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
	incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
	cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
	archivo debe ser proporcionado por el usuario desde teclado.   
}

program ejercicio1;
type
	archivo_enteros = file of integer;
var
	archivo: archivo_enteros;
	numero: integer;
begin
  // Crear el archivo para escritura
  assign(archivo, 'ejercicio1.dat');
  rewrite(archivo);
  writeln('Ingrese los numeros enteros (ingrese 30000 para finalizar):');
   
  // Leer números enteros desde el teclado y escribirlos en el archivo
  repeat
    readln(numero);
    if (numero <> 30000) then
      write(archivo, numero);
  until numero = 30000;
  
  // Cerrar el archivo
  close(archivo);
  writeln('Archivo creado.');
  
  reset(archivo);
  writeln('Los numeros guardados son:');
  while (not eof(archivo)) do begin 
	read(archivo,numero);
    writeln(numero);
  end;
  close(archivo);
end.

