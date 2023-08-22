close all
clear all
more off % Esto es para que muestre los printf(), disp() y resultados a medida que los ejecuta y no todo junto al final
set(0,'defaultlinelinewidth',2); % Setea el 'LineWidth' predeterminado en 2.

imprimir_separador();

CONF = load_conf();

A.nombre = get_time();
A.estructura_perceptron = input("Estructura de la red = ");
A.train.fecha{1} = 0;
A.proc.fecha{1} = 0;

[A.w, A.ii, A.jj] = crear_perceptron_de_capas(A.estructura_perceptron,1);
printf("Se ha creado una nueva red con exito.\n");

plot_NN(A.w);

save(strcat(CONF.ruta.data, A.nombre, ".data"), "A");
printf("Red guardada en --> «%s»\n", strcat(CONF.ruta.data, A.nombre, ".data"));

imprimir_separador();
