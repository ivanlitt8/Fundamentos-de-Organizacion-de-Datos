{
	La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
	correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
	fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
	y total de ejemplares vendido.

	Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
	país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
	cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
	procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
	actualización del archivo maestro en función de las ventas registradas. Además deberá
	informar fecha y semanario que tuvo más ventas y la misma información del semanario con
	menos ventas.
	
	Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
	ventas de semanarios si no hay ejemplares para hacerlo.

}

program ejercicio15;
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
