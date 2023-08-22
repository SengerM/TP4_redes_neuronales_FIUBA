close all
clear all
more off % Esto es para que muestre los printf(), disp() y resultados a medida que los ejecuta y no todo junto al final
set(0,'defaultlinelinewidth',2); % Setea el 'LineWidth' predeterminado en 2.

imprimir_separador();

CONF = load_conf();

load(strcat(CONF.ruta.data, input("Archivo de red neuronal a cargar --> "), ".data"));

print_estructura_red(A);
print_train_hist(A);
print_proc_hist(A);
	
% Cargar archivos de audio ----------------------------------------
KK = input("Número a comparar (columna indicada con «#» en el cuadro anterior) --> ");
[audio.clean,audio.fs,audio.bps] = wavread(strcat(CONF.ruta.audio_original,sprintf("clean%i.wav", A.proc.archivos(KK) )));
audio.dist = wavread(strcat(CONF.ruta.audio_original,sprintf("dist%i.wav", A.proc.archivos(KK))));
audio.red = wavread(strrep(strcat(CONF.ruta.audio_procesado, A.proc.fecha{KK}, sprintf(" audio %i.wav", A.proc.archivos(KK))), " ", "_"));
% Rellenar con ceros el audio.red hasta que quede del mismo largo que audio.dist para comparar
ventana_procesada = (A.proc.ventana{KK}(1)):(A.proc.ventana{KK}(2));
audio.red( (1:length(audio.red)) + ventana_procesada(1) + ceil(mean(1:A.estructura_perceptron(1))) ) = audio.red(1:length(audio.red));
audio.red( 1:(ventana_procesada(1) + ceil(mean(1:A.estructura_perceptron(1))) - 1) ) = 0;
audio.red( length(audio.red):length(audio.dist) ) = 0;

printf("El error cuadrático medio cometido en la ventana %i:%i es --> %2.3g\n", ventana_procesada(1), ventana_procesada(end), ecm(audio.dist(ventana_procesada), audio.red(ventana_procesada)));

t = (1:length(audio.dist))./audio.fs;

if (input("¿Graficar dominio del tiempo? --> "))
	% Graficar dominio del tiempo ----------------------------------------------
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%% PLANTILLA PARA GRAFICOS %%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	COLORES = {[1 0 0], [0 .7 0], [0 0 1], [1 .5 0], [0 .7 .7], [.7 0 .7]};
	% TAMAÑO DE LA IMAGEN ----------------------------------------
	X_mm = 170; % ancho de la imagen en milímetros
	PROPORCION = [1 0.4];		x_pixels = X_mm*3.779527559*PROPORCION(1); y_pixels = round(PROPORCION(2)*x_pixels);
	% -----------------------------------------------------------
	figure('Position',[0,0,x_pixels,y_pixels]); hold on; clear("leyenda"); clear("graf");
		graf(1) = plot(t, audio.dist);
			leyenda{1} = "Distorsión original";
		graf(2) = plot(t, audio.red);
			leyenda{2} = "Distorsión de la red";

		for (k = find(graf!=0))
			set(graf(k), 
				'LineWidth', 2,
				'Color', COLORES{k});
		endfor

	% CONFIGURACION DEL GRAFICO ---------------------------------------------
			TITULO_GRAFICO = sprintf("%s dominio del tiempo", A.proc.fecha{KK});
			XLABEL = "Tiempo (s)";
			YLABEL = "Amplitud WAV";
			% TAMAÑOS DE FUENTE -------------------------------------
			TITLE_FONT_SIZE = 13;
			AXIS_LABEL_FONT_SIZE = 10;
			AXIS_TICKS_FONT_SIZE = 10;
			LEGEND_FONT_SIZE = 10;
			% -------------------------------------------------------
	#		title(TITULO_GRAFICO, "FontSize", TITLE_FONT_SIZE);
			xlabel(XLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
			ylabel(YLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
			set(gca(),'FontSize', AXIS_TICKS_FONT_SIZE);
			% LEYENDA -------------------------------------------------
			leyendaa = legend(graf(find(graf!=0)), leyenda{find(graf!=0)}, 'Location', 'SouthOutside', 'Orientation', 'Horizontal');
			set(leyendaa, 'FontSize', LEGEND_FONT_SIZE);
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
			if (input("Guardar gráfico en el dominio del tiempo --> "))
	#	 	% IMAGEN DE SALIDA ----------------------------------------
				XY_RATIO = sprintf("-S%i,%i", x_pixels, y_pixels); ARCHIVO_IMAGEN = strrep(strcat(CONF.ruta.audio_procesado, TITULO_GRAFICO), " ", "_");
				print(sprintf("%s.svg", ARCHIVO_IMAGEN),'-dsvg', XY_RATIO);
	#			print(sprintf("%s.png", ARCHIVO_IMAGEN),'-dpng', '-r200', XY_RATIO);
			endif
	% -------------------------------------------------------------------------------------
	#		close all
endif



if (input("¿Graficar dominio de la frecuencia? --> "))
	% Dominio de la frecuencia ------------------------------------------------------------
	N_PUNTITOS = 10e3;
	[frec.clean, FFT.clean] = FT_completa(t, audio.clean, [20, 20e3], N_PUNTITOS);
	[frec.dist, FFT.dist] = FT_completa(t, audio.dist, [20,20e3], N_PUNTITOS);
	[frec.red, FFT.red] = FT_completa(t, audio.red, [20,20e3], N_PUNTITOS);

	FFT.error = abs(FFT.dist - FFT.red);

	% Pasabajos para la FFT ------------------
	mean_length = 500;
	for (k = 1:length(FFT.dist))
		puntos = (k-mean_length):(k+mean_length);
		puntos = puntos(find(puntos>0));
		puntos = puntos(puntos<=length(FFT.dist));
		FFT.clean(k) = mean(FFT.clean(puntos));
		FFT.dist(k) = mean(FFT.dist(puntos));
		FFT.red(k) = mean(FFT.red(puntos));
	endfor

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%% PLANTILLA PARA GRAFICOS %%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	COLORES = {[1 0 0], [0 .7 0], [0 0 1], [1 .5 0], [0 .7 .7], [.7 0 .7]};
	% TAMAÑO DE LA IMAGEN ----------------------------------------
	X_mm = 170; % ancho de la imagen en milímetros
	PROPORCION = [1 0.4];		x_pixels = X_mm*3.779527559*PROPORCION(1); y_pixels = round(PROPORCION(2)*x_pixels);
	% -----------------------------------------------------------
	figure('Position',[0,0,x_pixels,y_pixels]); hold on; clear("leyenda"); clear("graf");
		plotfunc = @semilogy;
		graf(1) = plotfunc(frec.dist, abs(FFT.dist));
			leyenda{1} = "Distorisón original";
		graf(2) = plotfunc(frec.red, abs(FFT.red));
			leyenda{2} = "Distorsión de la red";
		graf(3) = plotfunc(frec.red, abs(FFT.clean));
			leyenda{3} = "Señal limpia";

		for (k = find(graf!=0))
			set(graf(k), 
				'LineWidth', 2,
				'Color', COLORES{k});
		endfor
	
	#	set (graf(2), 'LineWidth', .5);

	% CONFIGURACION DEL GRAFICO ---------------------------------------------
			TITULO_GRAFICO = sprintf("%s dominio de la frecuencia", A.proc.fecha{KK});
			XLABEL = "Frecuencia (Hz)";
			YLABEL = "FFT";
			% TAMAÑOS DE FUENTE -------------------------------------
			TITLE_FONT_SIZE = 13;
			AXIS_LABEL_FONT_SIZE = 10;
			AXIS_TICKS_FONT_SIZE = 10;
			LEGEND_FONT_SIZE = 10;
			% -------------------------------------------------------
	#		title(TITULO_GRAFICO, "FontSize", TITLE_FONT_SIZE);
			xlabel(XLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
			ylabel(YLABEL, 'FontSize', AXIS_LABEL_FONT_SIZE);
			set(gca(),'FontSize', AXIS_TICKS_FONT_SIZE);
			% LEYENDA -------------------------------------------------
			leyendaa = legend(graf(find(graf!=0)), leyenda{find(graf!=0)}, 'Location', 'SouthOutside', 'Orientation', 'Horizontal');
			set(leyendaa, 'FontSize', LEGEND_FONT_SIZE);
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
			if (input("Guardar gráfico en el dominio de la frecuencia --> "))
	#	 	% IMAGEN DE SALIDA ----------------------------------------
				XY_RATIO = sprintf("-S%i,%i", x_pixels, y_pixels); ARCHIVO_IMAGEN = strrep(strcat(CONF.ruta.audio_procesado, TITULO_GRAFICO), " ", "_");
				print(sprintf("%s.svg", ARCHIVO_IMAGEN),'-dsvg', XY_RATIO);
	#			print(sprintf("%s.png", ARCHIVO_IMAGEN),'-dpng', '-r200', XY_RATIO);
			endif
	% -------------------------------------------------------------------------------------
	#		close all
endif
imprimir_separador();
