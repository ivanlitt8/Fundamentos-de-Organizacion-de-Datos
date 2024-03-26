{
	Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
	creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
	promedio de los números ingresados. El nombre del archivo a procesar debe ser
	proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
	contenido del archivo en pantalla   
}

program ejercicio2;
var
	totalNumeros,cantMenores,numero: integer;
	prom: real;
	nombreArchivo: string;
	archivo: file of integer;
begin
	cantMenores:= 0;
	totalNumeros:= 0;
	prom:= 0;
	writeln('Ingrese el nombre del archivo:');
	readln(nombreArchivo);
	assign(archivo, 'ejercicio1.dat');
	reset(archivo);
	while not EOF(archivo) do begin
		read(archivo, numero);
		writeln(numero);
		totalNumeros:= totalNumeros + 1;
		prom:= prom + numero;
		if(numero<1500)then
			cantMenores:= cantMenores + 1
	end;
	close(archivo);	
	if (totalNumeros > 0) then
		prom := prom / totalNumeros
    else
		prom := 0;
	writeln('La cantidad de numeros menores a 1500 es:', cantMenores);
	writeln('El promedio de es: ', prom:0:2);
end.
