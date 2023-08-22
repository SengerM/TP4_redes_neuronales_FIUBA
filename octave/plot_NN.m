function [l,m,t] = plot_NN(w)
	N_neurons = length(w)-1;
	output_layer = find(sum((w(1:end-1,:)'))==0);
	
	k_neuron = 1;
	k_n_layer = 1;
	k_layer = 1;
	pos(1) = min(find(w(1,:)!=0));
	while (k_neuron<length(w)-length(output_layer))
		pos(2) = min(find(w(k_neuron,:)!=0));
		if (pos(2) == pos(1))
			layer{k_layer}(k_n_layer) = k_neuron;
		else
			k_layer++;
			k_n_layer = 1;
			layer{k_layer}(k_n_layer) = k_neuron;
		endif
		pos(1) = pos(2);
		k_n_layer++;
		k_neuron++;
	endwhile
	layer{end+1} = output_layer; % output layer
	% En esta instancia el arreglo «layer{}» debería contener un vector por cada capa, con las correspondientes neuronas.
	
	k_layer = 1;
	k_n_layer = 1;
	for (k = 1:N_neurons)
		if (isempty(find(layer{k_layer}==k)))
			k_layer++;
			k_n_layer = 1;
		endif
		vector = (1:length(layer{k_layer}))-length(layer{k_layer})/2;
		coord{k} = [vector(k_n_layer),k_layer];
		k_n_layer++;
	endfor
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%% PLANTILLA PARA GRAFICOS %%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
COLORES = {[1 0 0], [0 .7 0], [0 0 1], [1 .5 0], [0 .7 .7], [.7 0 .7]};
% TAMAÑO DE LA IMAGEN ----------------------------------------
X_mm = 170; % ancho de la imagen en milímetros
PROPORCION = [1 0.6];
				x_pixels = X_mm*3.779527559*PROPORCION(1);
				y_pixels = round(PROPORCION(2)*x_pixels);
% -----------------------------------------------------------
figure('Position',[0,0,x_pixels,y_pixels]); hold on;
#	% Graficar conexiones entre neuronas ------
#	kgraf = 1;
#	for (k = 1:N_neurons)
#		connections = find(w(k,:)!=0);
#		for (kk = 1:length(connections))
#			graf.connect(kgraf) = plot([coord{k}(1),coord{connections(kk)}(1)],[coord{k}(2),coord{connections(kk)}(2)]);
#			kgraf++;
#		endfor
#	endfor
#	set(graf.connect(:),
#		'LineWidth', 1,
#		'Color', [0,0,0]);
	
	% Graficar neuronas -----------------------
	for (k = 1:length(coord))
		graf.neur(k) = plot(coord{k}(1),coord{k}(2));
	endfor
	set(graf.neur(:), 
		'LineWidth', 2,
		'Marker', '.',
		'MarkerSize', 20,
		'LineStyle', 'None',
		'Color', [0,0,0]);
	
	for (k = 1:length(layer))
		text(length(layer{k})-length(layer{k})/2+1,k, sprintf("%i", length(layer{k})));
	endfor

% CONFIGURACION DEL GRAFICO ---------------------------------------------
		TITULO_GRAFICO = "perceptron";
#		XLABEL = "Distancia (m)";
#		YLABEL = "Intensidad luminica (LUX)";
#		% TAMAÑOS DE FUENTE -------------------------------------
#		TITLE_FONT_SIZE = 13;
#		AXIS_LABEL_FONT_SIZE = 10;
#		AXIS_TICKS_FONT_SIZE = 10;
#		LEGEND_FONT_SIZE = 10;
#		% -------------------------------------------------------
#		title(TITULO_GRAFICO, "FontSize", TITLE_FONT_SIZE);
#		xlabel(XLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
#		ylabel(YLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
#		set(gca(),'FontSize', AXIS_TICKS_FONT_SIZE);
#		% LEYENDA -------------------------------------------------
#		leyendaa = legend(graf(:), leyenda{:}, 'Location', 'SouthEast');
#		set(leyendaa, 'FontSize', LEGEND_FONT_SIZE);
#		% ---------------------------------------------------------
#		grid on;
#		% ---------------------------------------------------------
#		tics	('x',
#			[-90   -45    0   45     90],
#			{"0c" "0.7c" "1" "0.7i" "0i"}
#			);
		% VENTANA DEL GRAFICO -------------------------------------
			maxx = 0;
			minx = 0;
			for (k = 1:N_neurons)
				if (maxx<coord{k}(1))
					maxx = coord{k}(1);
				endif
				if (minx>coord{k}(1))
					minx = coord{k}(1);
				endif
			endfor
			X_MIN = minx-1;
			X_MAX = maxx+2;
			Y_MIN = 1;
			Y_MAX = length(layer);
		axis ([[X_MIN X_MAX] [Y_MIN Y_MAX]]);
		axis off;
#		axis ('tight');
#	 	% IMAGEN DE SALIDA ----------------------------------------
#		XY_RATIO = sprintf("-S%i,%i", x_pixels, y_pixels);
#		ARCHIVO_IMAGEN = strrep(TITULO_GRAFICO, " ", "_");
#		print(sprintf("%s.svg", ARCHIVO_IMAGEN),'-dsvg', XY_RATIO);
#		print(sprintf("%s.png", ARCHIVO_IMAGEN),'-dpng', '-r200', XY_RATIO);
% -------------------------------------------------------------------------------------
#		close all
	
endfunction
