{
	7. Realizar un programa que permita:

	a) Crear un archivo binario a partir de la información almacenada en un archivo de
	texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
	archivo de texto consiste en: código de novela, nombre, género y precio de
	diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
	líneas en el archivo de texto. La primera línea contendrá la siguiente información:
	código novela, precio y género, y la segunda línea almacenará el nombre de la
	novela.

	b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
	agregar una novela y modificar una existente. Las búsquedas se realizan por
	código de novela.

	NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
   
}


program ejercicio7;

type
	str = string[25];
	novela = record
		id: integer;
		nombre: str;
        genero: str;
        precio: real;
    end;
	archivoNovelas = file of novela;
procedure leerTxt( var arch: Text; var N: novela);
begin
	readln(arch, N.id, N.precio, N.genero);
    readln(arch, N.nombre);
end;
procedure generarArchivoDat(var datNovelas: archivoNovelas ; var txtNovelas: Text ; nombreBin: string);
var
	N: novela;
begin
    assign(datNovelas, nombreBin);
    rewrite(datNovelas);
	reset(txtNovelas);
    while not eof(txtNovelas) do begin
        leerTxt(txtNovelas, N);
        write(datNovelas, N);
    end;
	close(datNovelas);
    close(txtNovelas);
    writeln('El archivo ',nombreBin,' se ha exportado correctamente.');
end;
procedure leerNovela( var N: novela);
begin
	writeln('Ingrese codigo de novela: ');
	readln(N.id);
	writeln('Ingrese nombre de novela: ');
	readln(N.nombre);
	writeln('Ingrese genero: ');
	readln(N.genero);
	writeln('Ingrese precio: ');
	readln(N.precio);
end;
procedure imprimirNovelas(var arch: archivoNovelas);
var
    N: novela;
begin
    reset(arch);
    writeln('Imprimiendo lista de novelas: ');
    writeln();
    while not eof(arch) do begin
        read(arch, N);
        writeln('Codigo de novela: ', N.id);
        writeln('Precio: ', N.precio:0:2);
        writeln('Genero: ', N.genero);
        writeln('Nombre: ', N.nombre);
        writeln('-------------------------');
    end;
    close(arch);
end;
procedure agregarNovela (var arch: archivoNovelas);
var
	N: novela;
	opcion: char;
begin
	writeln('Agregar novela? (Y/N)');
	readln(opcion);
	while(opcion<>'N') do begin
		reset(arch);
		leerNovela(N);
		seek(arch, FileSize(arch));
		write(arch, N);
		close(arch);
		writeln('Agregar Novela? (Y/N)');
		readln(opcion);
	end;
end;
procedure modificarNovela (var arch: archivoNovelas ; ID: integer );
var
	encontrado: boolean;
	N: novela;
begin
	encontrado:= false;
	reset(arch);
	while not eof(arch) and not encontrado do begin
		read(arch,N);
		if(N.id = ID)then begin
			encontrado:= true;
			writeln('Ingrese nombre de novela: ');
			readln(N.nombre);
			writeln('Ingrese genero: ');
			readln(N.genero);
			writeln('Ingrese precio: ');
			readln(N.precio);
			seek(arch, filepos(arch)-1);
			write(arch, N);
		end;
	end;
	if eof(arch) and not encontrado then
		writeln('No se ha encontrado una novela con el codigo ', ID)
	else if (encontrado) then
		writeln('Se ha modificado la novela con el codigo ', ID);	
end;
var
    datNovelas: archivoNovelas;
    txtNovelas: Text;
    nombreBin: string;
    opcion: char;
    ID: integer;
begin
	writeln('Ingrese nombre del archivo binario: ');
	readln(nombreBin);
	nombreBin:= nombreBin + '.dat';
	assign(txtNovelas, 'novelas.txt'); 
    generarArchivoDat(datNovelas,txtNovelas,nombreBin);
    
    repeat
		writeln('Seleccione una opcion: ');
		writeln('1. Agregar novela');
        writeln('2. Modificar novela');
        writeln('3. Imprimir listado de novelas');
        writeln('4. Salir');
        readln(opcion);
        
        case opcion of
			'1': agregarNovela(datNovelas);
            '2': begin
                    writeln('Ingrese codigo de novela: ');
                    readln(ID);
                    modificarNovela(datNovelas, ID);
				 end;
            '3': imprimirNovelas(datNovelas);
            '4': writeln('Saliendo del programa...');
        else
            writeln('Opcion invalida.');
        end;
    until opcion = '4';
    
end.
