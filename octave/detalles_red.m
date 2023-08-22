function detalles_red()
	CONF = load_conf();
	printf("Información de la red ---------------------------\n");
	load(strcat(CONF.ruta.data, input("Archivo de red neuronal para detallar --> "), ".data"));
	printf("Nombre de la red --> «%s»\n", A.nombre);
	print_estructura_red(A);
	print_train_hist(A);
	print_proc_hist(A);
	printf("-------------------------------------------------\n");
endfunction
