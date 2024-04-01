{
	
	Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
	construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
	máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
	archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
	cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
	cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
	detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
	tiempo_total_de_sesiones_abiertas.

	Notas:
	
	● Cada archivo detalle está ordenado por cod_usuario y fecha.
	● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
	inclusive, en diferentes máquinas.
	● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program ejercicio6;
const
	valorAlto = 999;
	dimF = 3;
type
	
	rango = 1..dimF;

	maestro = record
		id: integer;
		fecha: string[10];
		tiempoTotal: integer;
	end;
	detalle = record
		id: integer;
		fecha: string[10];
		tiempoSesion: integer;
	end;

	archivoMaestro = file of maestro;
	archivoDetalle = file of detalle;
	
	vectDetalles = array[rango] of archivoDetalle;
	vectRegistros = array[rango] of detalle;
	vectString = array[rango] of string;
	

procedure leerDetalleTxt (var arch: Text ; var D: detalle);
begin
	if not eof(arch) then begin 
		readln(arch,D.id);
		readln(arch,D.fecha,D.tiempoSesion);
		writeln('Id: ', D.id);
		writeln('Fecha: ', D.fecha);
		writeln('Tiempo: ', D.tiempoSesion);
		writeln();
	end;
end;
procedure generarDetalle ( var arch: archivoDetalle; nombre: string);
var
	dat,txt: string;
	detalleTxt: Text;
	D: detalle;
begin
	txt := nombre + '.txt';
	assign(detalleTxt,txt);
	reset(detalleTxt);
	dat := nombre + '.dat';
	assign(arch,dat);
	rewrite(arch);
	while not eof(detalleTxt) do begin
		leerDetalleTxt(detalleTxt,D);
        write(arch,D);
    end;
    writeln('Archivo detalle ',dat,' exitosamente creado');
    writeln();
    writeln('-------------------------------------------');
    writeln();
    close(detalleTxt);
    close(arch);
end;
procedure generarArchivosDetalles(var V: vectDetalles );
var
	i: rango;
	vNombres: vectString;
begin
	vNombres[1]:= 'detalleUno';
	vNombres[2]:= 'detalleDos';
	vNombres[3]:= 'detalleTres';
	for i:= 1 to dimF do
		generarDetalle(V[i],vNombres[i]);
	writeln('Se han generado todos los detalles.')
end;

procedure imprimirMaestro( var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		writeln('USER ID: ', M.id);
		writeln('- FECHA: ', M.fecha);
		writeln('- MINUTOS: ', M.tiempoTotal);
		writeln();
	end;
	close(arch);
end;
procedure leerDetalle (var arch:archivoDetalle; var D: detalle);
begin
	if(not eof(arch)) then
        read(arch, D)
    else
        D.id := valoralto;

end;
procedure minimo (var V: vectDetalles; var vectorDetalles: vectRegistros ; var Dmin: detalle);
var
	pos,i: integer;
begin
	Dmin.id:= valorAlto;
	for i:= 1 to dimF do 
		if(vectorDetalles[i].id < Dmin.id) then begin
			Dmin:= vectorDetalles[i];
			pos:= i;
		end;
	if(Dmin.id <> valorAlto) then
        leerDetalle(V[pos],vectorDetalles[pos]);
end;
procedure crearMaestro ( var archM: archivoMaestro ; var V: vectDetalles);
var
	vectDet: vectRegistros;
	i: rango;
	M: maestro;
	Dmin: detalle;
begin
	for i:= 1 to dimF do begin
		reset(V[i]);
		leerDetalle(V[i],vectDet[i]);
	end;
	minimo(V, vectDet, Dmin);
	while(Dmin.id <> valorAlto) do begin
		//writeln('ID USER ---> ',Dmin.id);
		//writeln('TIEMPO SESION ---> ',Dmin.tiempoSesion);
		M.id := Dmin.id;
        M.fecha := Dmin.fecha;
        M.tiempoTotal := 0;
		while(Dmin.id<>valorAlto)and(Dmin.id=M.id) do begin
			M.tiempoTotal := M.tiempoTotal + Dmin.tiempoSesion;
            minimo(V, vectDet, Dmin);
		end;
		write(archM,M);
		if not eof(archM) then
			read(archM,M);
	end;
	close(archM);
	for i:= 1 to dimF do 
		close(V[i]);
end;

var
	datMaestro: archivoMaestro;
	V: vectDetalles;
begin
	generarArchivosDetalles(V);
	
	assign(datMaestro,'maestro.dat');
	rewrite(datMaestro);
	
	crearMaestro(datMaestro,V);
	
	imprimirMaestro(datMaestro);
end.
