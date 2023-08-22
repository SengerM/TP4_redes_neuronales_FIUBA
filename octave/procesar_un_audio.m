close all
clear all
more off % Esto es para que muestre los printf(), disp() y resultados a medida que los ejecuta y no todo junto al final
set(0,'defaultlinelinewidth',2); % Setea el 'LineWidth' predeterminado en 2.

imprimir_separador();

CONF = load_conf();

load(strcat(CONF.ruta.data, input("Archivo de red neuronal a cargar --> "), ".data"));

printf("La estructura del perceptron es --> [ "); printf("%i ", A.estructura_perceptron); printf("]\n");
print_train_hist(A);
print_proc_hist(A);
if (A.proc.fecha{1}!=0)
	A.proc.fecha{end+1} = get_time();
else
	A.proc.fecha{1} = get_time();
endif

% ARCHIVOS --------------------------------------------------------
A.proc.archivos(length(A.proc.fecha)) = input("Audio a procesar --> ");
% Cargar archivos de audio ----------------------------------------
[audio.clean,audio.fs,audio.bps] = wavread(strcat(CONF.ruta.audio_original,sprintf("clean%i.wav", A.proc.archivos(end))));
audio.dist = wavread(strcat(CONF.ruta.audio_original,sprintf("dist%i.wav", A.proc.archivos(end))));

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
A.proc.ventana{length(A.proc.fecha)}(1) = input("Empezar en la muestra --> ");
A.proc.ventana{length(A.proc.fecha)}(2) = input("Terminar en la muestra --> ");
close all

% Procesar el audio -------------------------------------------------
printf("Procesando el audio...\n");
ventana_entrada = (1:A.estructura_perceptron(1)) + A.proc.ventana{end}(1) - 1;
N_iteraciones = (A.proc.ventana{end}(2) - A.proc.ventana{end}(1) + 1) - length(ventana_entrada) + 1;

procesar_audio_subscript;

printf("Audio procesado completo guardado en «%s»\n", A.proc.fecha{end});

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%% PLANTILLA PARA GRAFICOS %%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#COLORES = {[1 0 0], [0 .7 0], [0 0 1], [1 .5 0], [0 .7 .7], [.7 0 .7]};
#% TAMAÑO DE LA IMAGEN ----------------------------------------
#X_mm = 170; % ancho de la imagen en milímetros
#PROPORCION = [1 0.4];		x_pixels = X_mm*3.779527559*PROPORCION(1); y_pixels = round(PROPORCION(2)*x_pixels);
#% -----------------------------------------------------------
#figure('Position',[0,0,x_pixels,y_pixels]); hold on; clear("leyenda"); clear("graf");
#	ventana_procesada = (A.proc.ventana{end}(1)):(A.proc.ventana{end}(2));
#	graf(1) = plot(ventana_procesada, audio.dist(ventana_procesada));
#		leyenda{1} = "Audio original";
#	graf(2) = plot(ventana_procesada(1:length(salida_red)) + ceil(mean(1:A.estructura_perceptron(1))), salida_red);
#		leyenda{2} = "Audio procesado";

#	for (k = find(graf!=0))
#		set(graf(k), 
#			'LineWidth', 2,
#			'Color', COLORES{k});
#	endfor

#% CONFIGURACION DEL GRAFICO ---------------------------------------------
#		TITULO_GRAFICO = strcat(A.proc.fecha{end}, "_audio");
#		XLABEL = "Número de muestra";
#		YLABEL = "Amplitud WAV";
#		% TAMAÑOS DE FUENTE -------------------------------------
#		TITLE_FONT_SIZE = 13;
#		AXIS_LABEL_FONT_SIZE = 10;
#		AXIS_TICKS_FONT_SIZE = 10;
#		LEGEND_FONT_SIZE = 10;
#		% -------------------------------------------------------
##		title(TITULO_GRAFICO, "FontSize", TITLE_FONT_SIZE);
#		xlabel(XLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
#		ylabel(YLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
#		set(gca(),'FontSize', AXIS_TICKS_FONT_SIZE);
#		% LEYENDA -------------------------------------------------
#		leyendaa = legend(graf(find(graf!=0)), leyenda{find(graf!=0)}, 'Location', 'SouthOutside');
#		set(leyendaa, 'FontSize', LEGEND_FONT_SIZE);
##		% ---------------------------------------------------------
##		grid on;
##		% ---------------------------------------------------------
##		tics	('x',
##			[-90   -45    0   45     90],
##			{"0c" "0.7c" "1" "0.7i" "0i"}
##			);
##		% VENTANA DEL GRAFICO -------------------------------------
##			X_MIN = min(Y_VEC);
##			X_MAX = max(Y_VEC);
##			Y_MIN = 0;
##			Y_MAX = 120;
##		axis ([[X_MIN X_MAX] [Y_MIN Y_MAX]]);
##		axis ('tight');
#		if (input("Guardar grafico --> "))
#		 	% IMAGEN DE SALIDA ----------------------------------------
#			XY_RATIO = sprintf("-S%i,%i", x_pixels, y_pixels); ARCHIVO_IMAGEN = strrep(strcat(CONF.ruta.audio_procesado, A.proc.fecha{end}), " ", "_");
#			print(sprintf("%s.svg", ARCHIVO_IMAGEN),'-dsvg', XY_RATIO);
##			print(sprintf("%s.png", ARCHIVO_IMAGEN),'-dpng', '-r200', XY_RATIO);
#		endif
#% -------------------------------------------------------------------------------------
##		close all



#% Fourier transform -----------------------------------
#t = (1:2)./audio.fs;
#[frec.dist, FFT.dist] = FT_completa(t, audio.dist, [20,20e3]);
#[frec.red, FFT.red] = FT_completa(t, salida_red, [20,20e3]);


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%% PLANTILLA PARA GRAFICOS %%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#COLORES = {[1 0 0], [0 .7 0], [0 0 1], [1 .5 0], [0 .7 .7], [.7 0 .7]};
#% TAMAÑO DE LA IMAGEN ----------------------------------------
#X_mm = 170; % ancho de la imagen en milímetros
#PROPORCION = [1 0.4];		x_pixels = X_mm*3.779527559*PROPORCION(1); y_pixels = round(PROPORCION(2)*x_pixels);
#% -----------------------------------------------------------
#figure('Position',[0,0,x_pixels,y_pixels]); hold on; clear("leyenda"); clear("graf");
#	ventana_procesada = (A.proc.ventana{end}(1)):(A.proc.ventana{end}(2));
#	graf(1) = plot(frec.dist, abs(FFT.dist));
#		leyenda{1} = "Audio original";
#	graf(2) = plot(frec.red, abs(FFT.red));
#		leyenda{2} = "Audio procesado";

#	for (k = find(graf!=0))
#		set(graf(k), 
#			'LineWidth', 2,
#			'Color', COLORES{k});
#	endfor

#% CONFIGURACION DEL GRAFICO ---------------------------------------------
#		TITULO_GRAFICO = strcat(A.proc.fecha{end}, "_audio");
#		XLABEL = "Frecuencia";
#		YLABEL = "FFT";
#		% TAMAÑOS DE FUENTE -------------------------------------
#		TITLE_FONT_SIZE = 13;
#		AXIS_LABEL_FONT_SIZE = 10;
#		AXIS_TICKS_FONT_SIZE = 10;
#		LEGEND_FONT_SIZE = 10;
#		% -------------------------------------------------------
##		title(TITULO_GRAFICO, "FontSize", TITLE_FONT_SIZE);
#		xlabel(XLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
#		ylabel(YLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
#		set(gca(),'FontSize', AXIS_TICKS_FONT_SIZE);
#		% LEYENDA -------------------------------------------------
#		leyendaa = legend(graf(find(graf!=0)), leyenda{find(graf!=0)}, 'Location', 'SouthOutside');
#		set(leyendaa, 'FontSize', LEGEND_FONT_SIZE);
##		% ---------------------------------------------------------
##		grid on;
##		% ---------------------------------------------------------
##		tics	('x',
##			[-90   -45    0   45     90],
##			{"0c" "0.7c" "1" "0.7i" "0i"}
##			);
##		% VENTANA DEL GRAFICO -------------------------------------
##			X_MIN = min(Y_VEC);
##			X_MAX = max(Y_VEC);
##			Y_MIN = 0;
##			Y_MAX = 120;
##		axis ([[X_MIN X_MAX] [Y_MIN Y_MAX]]);
##		axis ('tight');
#		if (input("Guardar grafico --> "))
#		 	% IMAGEN DE SALIDA ----------------------------------------
#			XY_RATIO = sprintf("-S%i,%i", x_pixels, y_pixels); ARCHIVO_IMAGEN = strrep(strcat(CONF.ruta.audio_procesado, A.proc.fecha{end}), " ", "_");
#			print(sprintf("%s.svg", ARCHIVO_IMAGEN),'-dsvg', XY_RATIO);
##			print(sprintf("%s.png", ARCHIVO_IMAGEN),'-dpng', '-r200', XY_RATIO);
#		endif
#% -------------------------------------------------------------------------------------
##		close all





save(strcat(CONF.ruta.data, A.nombre, ".data"), "A");

imprimir_separador();
