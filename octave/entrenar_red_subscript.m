# Este script precisa que esté definida la estructura «A» a entrenar y también
# las cantidades «ventana_entrada», «ventana_salida» y «N_iteraciones», por ejemplo 
# 	ventana_entrada = 1:A.estructura_perceptron(1);
# 	ventana_salida = get_ventana_salida(ventana_entrada,A.estructura_perceptron(end));
# 	N_iteraciones = length(audio.clean)-length(ventana_entrada)+1;
# También se precisa que estén definidos «audio.clean» y «audio.dist» con los audios para enseñar.

wbar = waitbar(0, sprintf("%.2f %%", 0));
deltaw{1} = A.w.*0;
deltaw{2} = A.w.*0;
porcentaje = CONF.salto_porcentaje;
for (k = 1:N_iteraciones)
	entrada = audio.clean(ventana_entrada++);
	salida_deseada = audio.dist(ventana_salida++);
	n = forward_propagation(A.w,entrada);
	d = backward_deltas(A.w,n,salida_deseada);
	deltaw{1} = deltaw{2};
	deltaw{2} = calcular_delta_w(A.w, n, d, entrada, salida_deseada);
	A.w += A.train.eta(end).*(deltaw{2}+A.train.momentum(end).*deltaw{1});
	% SHOW PROGRESS --------------------------------------------------------
	wbar = waitbar(k/N_iteraciones, wbar, sprintf("Entrenando red «%s»: %.2f %%", A.nombre, k/N_iteraciones*100));
endfor
close(wbar); clear("wbar");
