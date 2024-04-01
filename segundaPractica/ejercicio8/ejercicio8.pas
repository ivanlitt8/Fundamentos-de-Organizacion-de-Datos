{
	Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
	los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
	cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
	mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
	cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
	por la empresa.
	
	El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
	mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

	Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
	compras. No es necesario que informe tales meses en el reporte.   
}


program ejercicio8;
const
	valorAlto = 999;
type
	rangoMes = 1..12;
	rangoDia = 1..31;
	
	maestro = record
		id: integer;
		nombre: string[10];
		apellido: string[10];
		anio: integer;
		mes: rangoMes;
		dia: rangoDia;
		monto: real;
	end;
	
	archivoMaestro = file of maestro;
	
	vectorMontoMes = array [rangoMes] of real;
	
procedure leerMaestroTxt (var txt: Text ; var M: maestro);
begin
	readln(txt,M.id);
	readln(txt,M.nombre);
	readln(txt,M.apellido);
	readln(txt,M.anio,M.mes,M.dia,M.monto);

{
	writeln(M.id);
	writeln(M.nombre);
	writeln(M.apellido);
	writeln(M.anio);
	writeln(M.mes);
	writeln(M.dia);
	writeln(M.monto:0:2);
	writeln();
}

end;	
procedure generarMaestro ( var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestroTxt(txt, M);
		write(arch,M);
	end;
	close(txt);
	close(arch);
end;
procedure imprimirMaestro( var arch : archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		writeln('ID: ',M.id);
		writeln('- Nombre: ',M.nombre);
		writeln('- Fecha: ',M.anio,'-',M.mes,'-',M.dia);
		writeln('- Monto compra: ',M.monto:0:2);
		writeln();
	end;
	close(arch);
end;
procedure resetMontoMes( var vectMonto: vectorMontoMes );
var
	i: rangoMes;
begin
	for i:= 1 to 12 do 
		vectMonto[i]:= 0;
end;
procedure imprimirMeses ( Vm: vectorMontoMes );
var
	i: rangoMes;
begin
	for i:=1 to 12 do
		if(Vm[i]>0)then begin
			writeln('** El monto del mes ',i,' fue: ',Vm[i]:0:2);
			writeln();
		end;
end;
procedure leerMaestro(var arch: archivoMaestro ; var M: maestro);
begin
	if not eof(arch) then
		read(arch,M)
	else
		M.id:= valorAlto;
end;
procedure reporteMaestro(var arch: archivoMaestro);
var
	M,aux: maestro;
	vect: vectorMontoMes;
	totalEmpresa,totalCli: real;
begin
	reset(arch);
	leerMaestro(arch,M);
	totalEmpresa:= 0;
	while(M.id<>valorAlto) do begin
		resetMontoMes(vect);
		totalCli:= 0;
		aux:= M;
		while(aux.id <> M.id) do
			leerMaestro(arch,M);
		while(M.id<>valorAlto)and(aux.id = M.id) do begin
			totalCli:= totalCli + M.monto;
			vect[M.mes]:= vect[M.mes] + M.monto;
			leerMaestro(arch,M);
		end;
		writeln('Cliente: ',aux.nombre,' ',aux.apellido,' id: ',aux.id);
		writeln('Monto por mes: ');
		imprimirMeses(vect);
		writeln('Total: ',totalCli:0:2);
		writeln('-------------------------------');
		totalEmpresa:= totalEmpresa + totalCli; 
	end;
	writeln('El total recaudado por la empresa fue: ',totalEmpresa:0:2);
	close(arch);
end;
var
	maestroTxt: Text;
	maestroDat: archivoMaestro;
begin
	assign(maestroTxt,'maestro.txt');
	assign(maestroDat,'maestro.dat');
	rewrite(maestroDat);
	generarMaestro(maestroTxt, maestroDat);
	writeln('----- Archivo Maestro -----');
	writeln();
	imprimirMaestro(maestroDat);
	writeln('--------- REPORTE ---------');
	reporteMaestro(maestroDat);

end.
