# Este script precisa que esté definida la estructura «A» a entrenar y también
# las cantidades «ventana_entrada», «ventana_salida» y «N_iteraciones», por ejemplo 
# 	ventana_entrada = 1:A.estructura_perceptron(1);
# 	N_iteraciones = length(audio.clean)-length(ventana_entrada)+1;
# También se precisa que esté definido «audio.clean» para procesar.
# En el caso de que haya más de una neurona en la capa de salida, la señal se construye utilizando
# siempre la neurona "más del medio". Por ejemplo, si la capa de salida tiene 3 neuronas, la señal 
# de salida se construye utilizando la segunda neurona.


wbar = waitbar(0, sprintf("%.2f %%", 0));
porcentaje = CONF.salto_porcentaje;
for (k = 1:N_iteraciones)
	entrada = audio.clean(ventana_entrada++);
	salida_red(k) = forward_propagation(A.w,entrada)(A.ii{end}(end));
	% SHOW PROGRESS --------------------------------------------------------
	wbar = waitbar(k/N_iteraciones, wbar, sprintf("Procesando audio «%s»: %.2f %%", A.proc.fecha{end}, k/N_iteraciones*100));
	if (k/N_iteraciones > porcentaje)
#		printf("%i %%", round(porcentaje*100));
		% Guardar audio ------------------------------------------------
		wavwrite(salida_red, audio.fs, strrep(strcat(CONF.ruta.audio_procesado, A.proc.fecha{end}, sprintf(" audio %i.wav", A.proc.archivos(end))), " ", "_"));
		file = fopen(strrep(strcat(CONF.ruta.audio_procesado, A.proc.fecha{end}), " ", "_"), "w");
		fprintf(file, "Audio procesado por la red «%s»\n\n", A.nombre);
		fprintf(file, "Estructura de la red --> "); fprintf(file, "%i ", A.estructura_perceptron); fprintf(file, "\n\n");
		fprintf(file, "La ventana procesada es --> %i:%i\n\n", A.proc.ventana{end});
		fprintf(file, "El historial de archivos de entrenamiento de la red actual es --> "); fprintf(file, "%i ", A.train.archivos); fprintf(file, "\n\n");
		fclose(file);
#		printf(" | audio guardado en «%s.wav»", A.proc.fecha{end});
#		printf("\n");
		porcentaje += CONF.salto_porcentaje;
	endif
endfor
close(wbar); clear("wbar");
