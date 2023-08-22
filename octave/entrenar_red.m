close all
clear all
more off % Esto es para que muestre los printf(), disp() y resultados a medida que los ejecuta y no todo junto al final
set(0,'defaultlinelinewidth',2); % Setea el 'LineWidth' predeterminado en 2.

imprimir_separador();

CONF = load_conf();

load(strcat(CONF.ruta.data, input("Archivo de red neuronal a cargar --> "), ".data"));

print_estructura_red(A);
print_train_hist(A);	
if (A.train.fecha{1}!=0)
	A.train.fecha{end+1} = get_time();
else
	A.train.fecha{1} = get_time();
endif

% ARCHIVOS --------------------------------------------------------
A.train.archivos(length(A.train.fecha)) = input("Audio a enseñar = ");
% Cargar archivos de audio ----------------------------------------
[audio.clean,audio.fs,audio.bps] = wavread(strcat(CONF.ruta.audio_original,sprintf("clean%i.wav", A.train.archivos(end))));
audio.dist = wavread(strcat(CONF.ruta.audio_original,sprintf("dist%i.wav", A.train.archivos(end))));

% Elegir ventana a enseñar ----------------------------------------
if (input("¿Graficar vista preliminar para elegir la ventana? --> "))
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%% PLANTILLA PARA GRAFICOS %%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	COLORES = {[1 0 0], [0 .7 0], [0 0 1], [1 .5 0], [0 .7 .7], [.7 0 .7]};
	% TAMAÑO DE LA IMAGEN ----------------------------------------
	X_mm = 170; % ancho de la imagen en milímetros
	PROPORCION = [1 0.4];
					x_pixels = X_mm*3.779527559*PROPORCION(1);
					y_pixels = round(PROPORCION(2)*x_pixels);
	% -----------------------------------------------------------
	figure('Position',[0,0,x_pixels,y_pixels]); hold on;
		plot(audio.clean);
endif
A.train.ventana{length(A.train.fecha)}(1) = input("Empezar en la muestra --> ");
A.train.ventana{length(A.train.fecha)}(2) = input("Terminar en la muestra --> ");
close all

% CONFIGURACION DEL ENTRENAMIENTO DE LA RED -----------------------
A.train.eta(length(A.train.fecha)) = input("ETA = ");
A.train.momentum(length(A.train.fecha)) = input("MOMENTUM = ");

% Entrenar a la red neuronal --------------------------------------
printf("Entrenando la red...");
ventana_entrada = (1:A.estructura_perceptron(1)) + A.train.ventana{end}(1) - 1;
ventana_salida = get_ventana_salida(ventana_entrada,A.estructura_perceptron(end));
N_iteraciones = (A.train.ventana{end}(2) - A.train.ventana{end}(1) + 1) - length(ventana_entrada) + 1;
entrenar_red_subscript



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% PLANTILLA PARA GRAFICOS %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#COLORES = {[1 0 0], [0 .7 0], [0 0 1], [1 .5 0], [0 .7 .7], [.7 0 .7]};
#% TAMAÑO DE LA IMAGEN ----------------------------------------
#X_mm = 170; % ancho de la imagen en milímetros
#PROPORCION = [1 0.4];		x_pixels = X_mm*3.779527559*PROPORCION(1); y_pixels = round(PROPORCION(2)*x_pixels);
#% -----------------------------------------------------------
#figure('Position',[0,0,x_pixels,y_pixels]); hold on; clear("leyenda"); clear("graf");
#	graf(1) = plot();
#		leyenda{1} = "Leyenda1";
#	graf(2) = plot();
#		leyenda{2} = "Leyenda2";

#	for (k = find(graf!=0))
#		set(graf(k), 
#			'LineWidth', 2,
#			'Color', COLORES{k});
#	endfor
#
% CONFIGURACION DEL GRAFICO ---------------------------------------------
#		TITULO_GRAFICO = "Difraccion con red de 500 lineas por cm";
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
#		leyendaa = legend(graf(find(graf!=0)), leyenda{find(graf!=0)}, 'Location', 'SouthOutside');
#		set(leyendaa, 'FontSize', LEGEND_FONT_SIZE);
#		% ---------------------------------------------------------
#		grid on;
#		% ---------------------------------------------------------
#		tics	('x',
#			[-90   -45    0   45     90],
#			{"0c" "0.7c" "1" "0.7i" "0i"}
#			);
#		% VENTANA DEL GRAFICO -------------------------------------
#			X_MIN = min(Y_VEC);
#			X_MAX = max(Y_VEC);
#			Y_MIN = 0;
#			Y_MAX = 120;
#		axis ([[X_MIN X_MAX] [Y_MIN Y_MAX]]);
#		axis ('tight');
#	 	% IMAGEN DE SALIDA ----------------------------------------
#		XY_RATIO = sprintf("-S%i,%i", x_pixels, y_pixels); ARCHIVO_IMAGEN = strrep(TITULO_GRAFICO, " ", "_");
#		print(sprintf("%s.svg", ARCHIVO_IMAGEN),'-dsvg', XY_RATIO);
#		print(sprintf("%s.png", ARCHIVO_IMAGEN),'-dpng', '-r200', XY_RATIO);
% -------------------------------------------------------------------------------------
#		close all


% GUARDAR SIMULACION -------------------------------------------
if (input("¿Guardar simulacion? (1=Si,0=No)\n\t--> "))
	save(strcat(CONF.ruta.data, A.nombre, ".data"), "A");
	printf("Simulacion guardada en --> «%s»\n", strcat(CONF.ruta.data, A.nombre, ".data"));
endif


imprimir_separador();
