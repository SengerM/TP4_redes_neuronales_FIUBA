function ventana = get_ventana_salida(ventana_entrada, length_ventana)
	ventana = (1:length_ventana) + floor(mean(ventana_entrada)) - floor(mean(1:length_ventana));
endfunction
