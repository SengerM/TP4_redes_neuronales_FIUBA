# «A» es un vector tal que cada elemento representa la cantidad de neuronas en cada capa.
# Por ejemplo, si A==[10,12,1] entonces se crea una red con 10 neuronas (o terminales)
# de entrada, 12 neuronas en la capa oculta y 1 neurona de salida.
# Los retornos «ii» y «jj» son los respectivos índices para obtener las matrices «w» de cada capa
# del perceptrón. Por ejemplo, la matriz de la capa "k" es w(ii{k},jj{k}).

function [w, ii, jj] = crear_perceptron_de_capas(A, amplitud)
	if (nargin == 1)
		a = 1; % Los pesos se crean entre +-a con distribución uniforme
	else
		a = amplitud;
	endif
	if (length(A) < 2)
		error("El perceptron a crear debe tener al menos dos capas (una de entrada y una de salida).");
	endif
	
	w = zeros(sum(A)+1, sum(A));
	
	w(end,A(1)+1:end) = 2*a.*(rand(1,size(w)(2)-A(1))-0.5); % El bias se conecta a todas las neuronas menos las de entrada
	
	i1 = 1;
	i2 = A(1);
	j1 = A(1)+1;
	j2 = A(1)+A(2);
	w(i1:i2,j1:j2) = 2*a.*(rand(i2-i1+1,j2-j1+1)-.5);
	ii{1} = i1:i2;
	jj{1} = j1:j2;
	if (length(A) == 2)
		ii{2} = max((ii{1})+1):(length(w)-1);
		return
	endif
	
	for (k = 2:length(A)-1)
		i1 = sum(A(1:k-1))+1;
		i2 = sum(A(1:k));
		j1 = sum(A(1:k))+1;
		j2 = sum(A(1:k+1));
		w(i1:i2,j1:j2) = 2*a.*(rand(i2-i1+1,j2-j1+1)-.5);
		ii{k} = i1:i2;
		jj{k} = j1:j2;
	endfor
	ii{k+1} = max((ii{k})+1):(length(w)-1);
endfunction
