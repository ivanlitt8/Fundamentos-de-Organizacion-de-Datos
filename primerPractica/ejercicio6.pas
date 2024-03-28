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

procedure leerCelular(var arch: Text; var cel: celular);
begin
    readln(arch, cel.codigo, cel.precio, cel.marca);
    readln(arch, cel.stockDisponible, cel.stockMinimo, cel.descripcion);
    readln(arch, cel.nombre);
end;
procedure exportarArchivo(var archRegistros: archivoCelulares; var archTexto: Text);
var
    cel: celular;
begin
    rewrite(archTexto);
    reset(archRegistros);

    while not eof(archRegistros) do
    begin
        read(archRegistros, cel);
        writeln(archTexto, cel.codigo,' ', cel.precio:0:2,' ', cel.marca);
        writeln(archTexto, cel.stockDisponible,' ', cel.stockMinimo,' ', cel.descripcion);
        writeln(archTexto, cel.nombre);
        writeln(archTexto);
    end;

    close(archRegistros);
    close(archTexto);

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
			writeln('Codigo de celular: ', cel.codigo);
			writeln('Precio: ', cel.precio:0:2);
			writeln('Marca: ', cel.marca);
			writeln('Stock disponible: ', cel.stockDisponible);
			writeln('Stock minimo: ', cel.stockMinimo);
			writeln('Descripcion: ', cel.descripcion);
			writeln('Nombre: ', cel.nombre);
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
    writeln('Celulares cargados:');
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
var
    txtCelulares: Text;
    regCelulares: archivoCelulares;
    cel: celular;
begin
    assign(txtCelulares, 'celulares.txt');
    reset(txtCelulares);

    assign(regCelulares, 'celulares.dat');
    rewrite(regCelulares);

    while not eof(txtCelulares) do
    begin
        leerCelular(txtCelulares, cel);
        write(regCelulares, cel);
    end;

    close(txtCelulares);
    close(regCelulares);

    writeln('Los celulares se han cargado correctamente en el archivo "celulares.dat".');
	writeln();
	writeln('Imprimiendo celulares cargados:');
	imprimirCelulares(regCelulares);
	imprimirStockMenor(regCelulares);
	exportarArchivo(regCelulares, txtCelulares);
end.
