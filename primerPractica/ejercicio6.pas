{
    Agregar al menú del programa del ejercicio 5, opciones para:
	
	a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
	teclado.

	b. Modificar el stock de un celular dado.

	c. Exportar el contenido del archivo binario a un archivo de texto denominado:
	”SinStock.txt”, con aquellos celulares que tengan stock 0.

	NOTA: Las búsquedas deben realizarse por nombre de celular.   
}
program ejercicio6;

type
    celular = record
        codigo: integer;
        precio: real;
        marca: string[50];
        stockMinimo: integer;
        stockDisponible: integer;
        nombre: string[50];
        descripcion: string[100];
    end;
	archivoCelulares = file of celular;
procedure leerTxt(var arch: Text; var cel: celular);
begin
    readln(arch, cel.codigo, cel.precio, cel.marca);
    readln(arch, cel.stockDisponible, cel.stockMinimo, cel.descripcion);
    readln(arch, cel.nombre);
end;
procedure leerDat(var arch: Text; var cel: celular);
begin
    readln(arch, cel.codigo, cel.precio, cel.marca);
    readln(arch, cel.stockDisponible, cel.stockMinimo, cel.descripcion);
    readln(arch, cel.nombre);
end;
procedure exportarArchivo(var arch: archivoCelulares);
var
    txtCelulares: Text;
    cel: celular;
begin
    assign(txtCelulares, 'celulares.txt');
    rewrite(txtCelulares);
	reset(arch);
    while not eof(arch) do begin
        read(arch, cel);
        writeln(txtCelulares, cel.codigo, ' ', cel.precio:0:2, cel.marca);
        writeln(txtCelulares, cel.stockDisponible, ' ', cel.stockMinimo, cel.descripcion);
        writeln(txtCelulares, cel.nombre);
    end;
	close(arch);
    close(txtCelulares);
    writeln('El archivo "celulares.txt" se ha exportado correctamente.');
end;

procedure imprimirStockMenor(var arch: archivoCelulares);
var
    cel: celular;
begin
    reset(arch);
    writeln('Los celulares con stock menor al minimo son:');
    writeln();
    while not eof(arch) do begin
        read(arch, cel);
        if(cel.stockDisponible < cel.stockMinimo) then begin
            writeln('Codigo de celular:', cel.codigo);
            writeln('Precio:', cel.precio:0:2);
            writeln('Marca:', cel.marca);
            writeln('Stock disponible:', cel.stockDisponible);
            writeln('Stock minimo:', cel.stockMinimo);
            writeln('Descripcion:', cel.descripcion);
            writeln('Nombre:', cel.nombre);
            writeln('-------------------------');
        end;
    end;
    close(arch);
end;

procedure imprimirCelulares(var arch: archivoCelulares);
var
    cel: celular;
begin
    reset(arch);
    writeln('Imprimiendo celulares leidos:');
    writeln();
    while not eof(arch) do begin
        read(arch, cel);
        writeln('Codigo de celular: ', cel.codigo);
        writeln('Precio: ', cel.precio:0:2);
        writeln('Marca: ', cel.marca);
        writeln('Stock disponible: ', cel.stockDisponible);
        writeln('Stock minimo: ', cel.stockMinimo);
        writeln('Descripcion: ', cel.descripcion);
        writeln('Nombre: ', cel.nombre);
        writeln('-------------------------');
    end;
    close(arch);
end;
procedure crearNuevoArchivo (var txtCelulares: Text ; var regCelulares: archivoCelulares);
var
	cel: celular;
begin
	reset(txtCelulares);
    while not eof(txtCelulares) do begin
        leerTxt(txtCelulares, cel);
        write(regCelulares, cel);
    end;
    close(regCelulares);
    close(txtCelulares);
end;
procedure leerCelular( var C: celular);
begin
	writeln('Ingrese ID de celular: ');
	readln(C.codigo);
	writeln('Ingrese precio: ');
	readln(C.precio);
	writeln('Ingrese marca: ');
	readln(C.marca);
	writeln('Ingrese stock disponible: ');
	readln(C.stockDisponible);
	writeln('Ingrese stock minimo: ');
	readln(C.stockMinimo);
	writeln('Ingrese descripcion: ');
	readln(C.descripcion);
	writeln('Ingrese modelo: ');
	readln(C.nombre);
end;
procedure agregarCelulares (var arch: archivoCelulares);
var
	C: celular;
	opcion: char;
begin
	writeln('Agregar celular? (Y/N)');
	readln(opcion);
	while(opcion<>'N') do begin
		reset(arch);
		leerCelular(C);
		seek(arch, FileSize(arch));
		write(arch, C);
		close(arch);
		writeln('Agregar celular? (Y/N)');
		readln(opcion);
	end;
end;
procedure exportarArchivoSinStock(var arch: archivoCelulares);
var
	txt: Text;
	cel: celular;
begin
	assign(txt, 'SinStock.txt');
	rewrite(txt);
	reset(arch);
    while not eof(arch) do begin
        read(arch, cel);
        if(cel.stockDisponible = 0) then begin
			writeln(txt, cel.codigo, ' ', cel.precio:0:2, cel.marca);
			writeln(txt, cel.stockDisponible, ' ', cel.stockMinimo, ' ', cel.descripcion);
			writeln(txt, cel.nombre);
		end;
    end;
    close(arch);
    close(txt);
    writeln('El archivo "SinStock.txt" se ha exportado correctamente.');
end;
procedure cambiarStock( var arch: archivoCelulares; ID: integer ; nuevoStock: integer);
var
	encontrado: boolean;
	cel: celular;
begin
	encontrado:= false;
	reset(arch);
    while not eof(arch) and not encontrado do begin
        read(arch, cel);
        if(cel.codigo = ID) then begin
			cel.stockDisponible:= nuevoStock;
			seek(arch, filepos(arch)-1);
			write(arch, cel);
			encontrado:= true;
		end;
    end;
    close(arch);
    if(encontrado)then
		writeln('Stock de celular actualizado correctamente.')
    else
		writeln('Celular con codigo ', ID, ' no encontrado.');
end;
var
    datCelulares: archivoCelulares;
    opcion: char;
    ID,nuevoStock: integer;
begin
    assign(datCelulares, 'celulares.dat'); 
        
    repeat
		writeln('Seleccione una opcion: ');
		writeln('1. Imprimir listado de celulares');
        writeln('2. Imprimir celulares con stock menor al minimo');
        writeln('3. Modificar skock de celular');
        writeln('4. Agregar celulares');
        writeln('5. Exportar listado celulares sin stock');
        writeln('6. Exportar listado celulares');
        writeln('7. Salir');
        readln(opcion);
        
        case opcion of
			'1': imprimirCelulares(datCelulares);
            '2': imprimirStockMenor(datCelulares);
            '3': begin
                    writeln('Ingrese codigo de celular: ');
                    readln(ID);
                    writeln('Ingrese nuevo stock: ');
                    readln(nuevoStock);
                    cambiarStock(datCelulares, ID, nuevoStock);
				 end;
            '4': agregarCelulares(datCelulares);
            '5': exportarArchivoSinStock(datCelulares);
            '6': exportarArchivo(datCelulares);
            '7': writeln('Saliendo del programa...');
        else
            writeln('Opcion invalida.');
        end;
    until opcion = '7';
end.
