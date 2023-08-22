# Esta función computa la propagación del patrón de entrada «x» a lo largo de la red de perceptrones
# cuya matriz de pesos es «w» y retorna el estado de la red en «n». Se asume que NO HAY FEEDBACK, es
# decir que la matriz «w(1:end-1,:)» es TRIANGULAR SUPERIOR. Se admiten conexiones que salteen capas,
# como por ejemplo una conexión que va desde la capa 2 a la capa 4 de una. 

function [n,h] = forward_propagation(w, x)
	n = zeros(length(w)-1,1); % Inicializo el vector de estados de la red
	
	input_neurons = find(w(end,:)==0); % Las neuronas que no tienen un bias conectado son las de entrada
	n(input_neurons) = x; % Fijamos el estado de las neuronas de entrada con el patrón de entrada
	
	for (k = (max(input_neurons)+1):length(n))
		h(k,1) = (n')*w(1:end-1,k) + w(end,k); % net neuron input
		n(k) = tanh( h(k) ); % feedforward rule
	endfor
endfunction
