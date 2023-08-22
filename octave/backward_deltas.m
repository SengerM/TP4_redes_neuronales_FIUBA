# Esta función calcula los vaores de delta para cada una de las neuronas y los devuelve por «d». 
# Los argumentos de la función son
# 	w --> matriz de pesos (se asume una red exclusivamente feedforward, es decir que la matriz 
#				«w(1:end-1,:)» es TRIANGULAR SUPERIOR).
#	n --> estado final de la red al propagar el patrón de entrada.
#	pout --> el patrón de salida deseado.

function d = backward_deltas(w, n, pout)
	d = zeros(length(w)-1,1);
	output_neurons = find(sum((w(1:end-1,:)'))==0); % Como la red es de feedforward, aquellas neuronas que no tienen conexión de salida hacia otras neuronas serán las de salida.
	
	d(output_neurons) = (1-n(output_neurons).^2).*(pout-n(output_neurons)); % se utilizó una simplificación del cálculo que es 100% equivalente presentada en la ecuación (6.14) (página 119) del libro de Hertz.
	
	for (k = (min(output_neurons)-1):-1:1)
		d(k) = (1-n(k)^2)*(w(k,:)*d); % se utilizó una simplificación del cálculo que es 100% equivalente presentada en la ecuación (6.14) (página 119) del libro de Hertz.
	endfor
endfunction
