{
	Una empresa posee un archivo con información de los ingresos percibidos por diferentes
	empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
	nombre y monto de la comisión. La información del archivo se encuentra ordenada por
	código de empleado y cada empleado puede aparecer más de una vez en el archivo de
	comisiones.
	
	Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
	consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
	única vez con el valor total de sus comisiones.

	NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
	recorrido una única vez.
}


program ejercicio1;
const
	valorAlto = 9999;
type
	comision = record
		id: integer;
		nombre: string[15];
		monto: real;
	end;
	archivoComisiones = file of comision;
procedure leer( var arch: Text ; var C: comision);
begin
	if(not eof(arch)) then begin
		readln(arch,C.id,C.nombre);
		readln(arch,C.monto);
	end
	else
		C.id := valorAlto;
end;
procedure comprimir(var txtComisiones: Text ; var txtCompacto: archivoComisiones);
var
	C,Caux: comision;
begin	
	reset(txtComisiones);
	reset(txtCompacto);
	leer(txtComisiones,C);
	while (C.id <> valorAlto) do begin
		Caux.id:= C.id;
		Caux.nombre:= C.nombre;
		Caux.monto:= 0;
		while (C.id = Caux.id)  do begin
			Caux.monto:= Caux.monto + C.monto;
			leer(txtComisiones,C);
		end;
		write(txtCompacto, Caux);
	end;
	close(txtCompacto);
	close(txtComisiones);
end;
procedure imprimirComisiones (var arch: archivoComisiones);
var
	C: comision;
begin
	reset(arch);
    writeln('Imprimiendo comisiones comprimidas:');
    writeln();
    while not eof(arch) do begin
        read(arch, C);
        writeln('ID empleado: ', C.id);
        writeln('Nombre: ', C.nombre);
        writeln('Monto: ', C.monto:0:2);
        writeln('-------------------------');
    end;
    close(arch);
end;
var
	txtComisiones: Text;
	regComisiones: archivoComisiones;
begin
	assign(txtComisiones, 'comisiones.txt');
    assign(regComisiones, 'comisiones.dat');
    rewrite(regComisiones);
    
	comprimir(txtComisiones,regComisiones);
	
    imprimirComisiones(regComisiones);
	
end.
