function retval = print_estructura_red(A)
	printf("La estructura del perceptrón es --> [");
	for (k = 1:(length(A.estructura_perceptron)-1))
		printf("%i,", A.estructura_perceptron(k));
	endfor
	printf("%i]\n", A.estructura_perceptron(end));
endfunction
