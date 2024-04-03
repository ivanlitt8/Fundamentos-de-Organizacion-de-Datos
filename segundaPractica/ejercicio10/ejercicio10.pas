{
	Se tiene información en un archivo de las horas extras realizadas por los empleados de una
	empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
	división, número de empleado, categoría y cantidad de horas extras realizadas por el
	empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
	división y, por último, por número de empleado. Presentar en pantalla un listado con el
	siguiente formato:

	Departamento
	División
	Número de Empleado 		Total de Hs. 		Importe a cobrar
		........			  ....... 				........
		........			  ....... 				........
	
	Total de horas división: ____
	Monto total por división: ____

	División
	.................
	Total horas departamento: ____
	Monto total departamento: ____

	Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
	iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
	de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
	de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
	posición del valor coincidente con el número de categoría.
}

program ejercicio10;
const
	valorAlto = 'ZZZZ';
	dimF = 15;
type
	maestro = record
		dto: string[15];
		division: string[15];
		idEmp: integer;
		cat: integer;
		horas: integer;
	end;
	
	archivoMaestro = file of maestro;
	vectValores = array [1..dimF] of real;
		
procedure leerMaestrotxt(var txt: Text ; var M: Maestro );
begin
	readln(txt,M.dto);
	readln(txt,M.division);
	readln(txt,M.idEmp,M.cat,M.horas);

	writeln('Departamento: ',M.dto);
	writeln('Division: ',M.division);
	writeln('ID empleado: ',M.idEmp);
	writeln('Categoria: ',M.cat);
	writeln('Cantidad horas: ',M.horas);
	writeln();

end;
procedure generarMaestro(var txt: Text ; var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(txt);
	while not eof(txt) do begin
		leerMaestrotxt(txt,M);
		write(arch,M);
	end;
	close(txt);
	close(arch)
end;

procedure leerMaestro ( var arch: archivoMaestro; var M: maestro);
begin
	if not eof(arch) then
		read(arch,M)
	else
		M.dto:= valorAlto;
end;
procedure reporte(var arch: archivoMaestro; V: vectValores);
var
	M: maestro;
	divHoras,idAct,horas,dtoHoras: integer;
	divMonto,monto,dtoMonto: real;
	dtoAct,divAct: string;
begin
	reset(arch);
	leerMaestro(arch,M);
	while(M.dto<>valorAlto)do begin
		dtoAct:= M.dto;
		dtoHoras:= 0;
		dtoMonto:= 0;
		writeln('DEPARTAMENTO ',M.dto);
		writeln();
		while(dtoAct = M.dto)do begin
			divAct:= M.division;
			divHoras:= 0;
			divMonto:= 0;
			writeln('** Division ',divAct,':');
			while(dtoAct = M.dto)and(divAct = M.division)do begin
				idAct:= M.idEmp;
				horas:= 0;
				monto:= 0;
				while(dtoAct = M.dto)and(divAct = M.division)and(M.idEmp = idAct)do begin
					horas:= horas + M.horas;
					monto:= monto + (V[M.cat] * M.horas);
					leerMaestro(arch,M);
				end;
				writeln('Numero empleado ',idAct,' total hs ',horas,' importe a cobrar ',monto:0:2);
				divHoras:= divHoras + horas;
				divMonto:= divMonto + monto;
			end;					
			writeln(' --- Total de horas division ',divHoras);
			writeln(' --- Total monto division ',divMonto:0:2);
			writeln();	
			dtoHoras:= dtoHoras + divHoras;
			dtoMonto:= dtoMonto + divMonto;
		end;
		writeln('Total horas departamento: ',dtoHoras);
		writeln('Monto total departamento: ',dtoMonto:0:2);
		writeln('--------------------------------');
		writeln();
	end;
	close(arch);
end;
{
	Departamento
	División
	Número de Empleado 		Total de Hs. 		Importe a cobrar
		........			  ....... 				........
		........			  ....... 				........
	
	Total de horas división: ____
	Monto total por división: ____

	División
	.................
	Total horas departamento: ____
	Monto total departamento: ____
}
procedure cargarVector(var V: vectValores ; var txt:Text);
var
	cat: integer;
	valor: real;
begin
	reset(txt);
	while not eof(txt) do begin
		readln(txt,cat,valor);
		V[cat]:= valor;
		//writeln('categoria: ',cat);
		//writeln('valor: ',valor:0:2);
	end;
	close(txt);
end;
var
	archTxt,archVect: Text;
	archDat: archivoMaestro;
	V: vectValores;
begin
	assign(archTxt,'maestro.txt');
	assign(archDat,'maestro.dat');
	rewrite(archDat);
	generarMaestro(archTxt,archDat);
	assign(archVect,'valoresCategoria.txt');
	cargarVector(V,archVect);
	reporte(archDat,V);
end.
