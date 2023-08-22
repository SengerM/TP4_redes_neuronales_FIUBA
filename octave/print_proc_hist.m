function retval = print_proc_hist(A)
	if (A.proc.fecha{1} != 0)
		printf("El historial de audios procesados por la red es\n");
		printf("\t#\tN° archivo\t\tVentana\t\tNombre del audio de salida\n");
		for (k = 1:length(A.proc.fecha))
			nombre_archivo_audio = strrep(strcat(A.proc.fecha{k}, sprintf(" audio %i.wav", A.proc.archivos(k))), " ", "_");
			printf("\t%i\t%i\t\t\t%i:%i\t%s\n", k, A.proc.archivos(k), A.proc.ventana{k}(1), A.proc.ventana{k}(2), nombre_archivo_audio);
		endfor
	else
		printf("La red aún no ha procesado ningún archivo de audio.\n");
	endif
endfunction
