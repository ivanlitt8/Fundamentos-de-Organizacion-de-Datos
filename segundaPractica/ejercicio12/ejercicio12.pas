{
	Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
	mismo (información guardada acerca de los movimientos que ocurren en el server) que se
	encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
	nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
	servidor de correo genera un archivo con la siguiente información: nro_usuario,
	cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
	usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
	sabe que un usuario puede enviar cero, uno o más mails por día.

	a. Realice el procedimiento necesario para actualizar la información del log en un
	día particular. Defina las estructuras de datos que utilice su procedimiento.
	
	b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
	detalle de un día determinado:
		
		nro_usuarioX…………..cantidadMensajesEnviados
		.........
		nro_usuarioX+n………..cantidadMensajesEnviados

		Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
		existen en el sistema. Considere la implementación de esta opción de las
		siguientes maneras:

			i- Como un procedimiento separado del punto a).

			ii- En el mismo procedimiento de actualización del punto a). Qué cambios
				se requieren en el procedimiento del punto a) para realizar el informe en
				el mismo recorrido?
}

program ejercicio12;
const
	valorAlto = 9999;
type
	maestro = record
		id: integer;
		nombreUser: string[10];
		nombre: string[15];
		apellido: string[15];
		cantMails: integer;
	end;
	
	detalle = record
		id: integer;
		destino: string[20];
		cuerpo: string[50];
	end;
	
	archivoMaestro = file of maestro;
	archivoDetalle = file of detalle;
		
procedure leerMaestrotxt(var txt: Text ; var M: Maestro );
begin
	readln(txt,M.id);
	readln(txt,M.nombreUser);
	readln(txt,M.nombre);
	readln(txt,M.apellido);
	readln(txt,M.cantMails);
	writeln('ID: ',M.id);
	writeln('Nombre Usuario: ',M.nombreUser);
	writeln('Nombre: ',M.nombre);
	writeln('Apellido: ',M.apellido);
	writeln('Cantidad de Mails: ',M.cantMails);
	writeln();

end;
procedure leerDetalletxt(var txt: Text ; var D: detalle );
begin
	readln(txt,D.id);
	readln(txt,D.destino);
	readln(txt,D.cuerpo);
{
	writeln('ID: ',D.id);
	writeln('Destinatario: ',D.destino);
	writeln('Cuerpo: ',D.cuerpo);
	writeln();
}
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
procedure generarDetalle(var txt: Text ; var arch: archivoDetalle);
var
	D: detalle;
begin
	reset(txt);
	while not eof(txt) do begin
		leerDetalletxt(txt,D);
		write(arch,D);
	end;
	close(txt);
	close(arch)
end;
procedure leerDetalle(var arch: archivoDetalle ; var D : detalle);
begin
	if not eof(arch) then
		read(arch,D)
	else
		D.id:= valorAlto;
end;
procedure actualizarLog (var archD: archivoDetalle ; var archM: archivoMaestro);
var
	D: detalle;
	M: maestro;
	txt: Text;
begin
	reset(archD);
	reset(archM);
	assign(txt,'users1.txt');
	rewrite(txt);
	leerDetalle(archD,D);
	while (D.id<>valorAlto) do begin
		read(archM,M);
		while (D.id <> M.id) do begin
			//writeln(M.nombreUser,' ', M.cantMails);
			writeln(txt,'Usuario: ',M.nombreUser,' - Cantidad de mails: ',M.cantMails);
			read(archM,M);
		end;
		while (D.id = M.id) do begin
			M.cantMails:= M.cantMails + 1;
            leerDetalle(archD, D);
		end;
		writeln(txt,'Usuario: ',M.nombreUser,' - Cantidad de mails: ',M.cantMails);
		//writeln(M.nombreUser,' ', M.cantMails);
        seek(archM, filepos(archM)-1);
        write(archM, M);
	end;
	close(txt);
	close(archD);
	close(archM);
	writeln('Usuarios exportados a users1.txt ');
end;
procedure imprimirLogsActualizados(var arch: archivoMaestro);
var
	M: maestro;
begin
	reset(arch);
	while not eof (arch) do begin
		read(arch,M);
		writeln('ID: ',M.id);
		writeln('Nombre Usuario: ',M.nombreUser);
		writeln('Nombre: ',M.nombre);
		writeln('Apellido: ',M.apellido);
		writeln('Cantidad de Mails: ',M.cantMails);
		writeln();
	end;
	close(arch);
end;
procedure exportarUsuarios( var arch: archivoMaestro );
var
	txt: Text;
	M: maestro;
begin
	assign(txt,'users2.txt');
	rewrite(txt);
	reset(arch);
	while not eof(arch) do begin
		read(arch,M);
		writeln(txt,'Usuario: ',M.nombreUser,' - Cantidad de mails: ',M.cantMails);
	end;
	close(arch);
	close(txt);
	writeln('Usuarios exportados a users2.txt ');
end;
var
	logsTxt,usersTxt: Text;
	logsDat: archivoMaestro;
	usersDat: archivoDetalle;
begin
	assign(logsTxt,'logs.txt');
	assign(logsDat,'logs.dat');
	rewrite(logsDat);
	writeln('----- Archivo Maestro -----');
	generarMaestro(logsTxt,logsDat);
	writeln('---------------------------');
	writeln();
	
	assign(usersTxt,'usuarios.txt');
	assign(usersDat,'usuarios.dat');
	rewrite(usersDat);
	generarDetalle(usersTxt,usersDat);
	
	actualizarLog(usersDat,logsDat);
	writeln('-- Archivo Maestro Actualizado --');
	imprimirLogsActualizados(logsDat);
	writeln('---------------------------');
	
	exportarUsuarios(logsDat);
end.
