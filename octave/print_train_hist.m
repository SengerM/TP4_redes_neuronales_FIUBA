function retval = print_train_hist(A)
	if (A.train.fecha{1}!=0)
		printf("El historial de audios de entrenamiento de la red es\n");
		printf("\t#\tN° archivo\t\tVentana\t\tEta\t\tMomentum\n");
		for (k = 1:length(A.train.fecha))
			printf("\t%i\t%i\t\t\t%i:%i\t%2.3g\t\t%2.3g\n", k, A.train.archivos(k), A.train.ventana{k}(1), A.train.ventana{k}(2), A.train.eta(k), A.train.momentum(k));
		endfor
		A.train.fecha{end+1} = get_time();
	else
		A.train.fecha{1} = get_time();
		printf("La red aún no ha sido entrenada.\n");
	endif
endfunction
