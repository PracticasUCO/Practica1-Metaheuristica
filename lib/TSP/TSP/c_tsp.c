#include "c_tsp.h"
#include "../BasicTSP/c_basic_tsp.h"
#include "../BasicTSP/c_basic_tsp.c"

/*
Este metodo realiza el intercambio de dos nodos en una posicion concreta
del vector solucion. Recibe como parametros el vector con la solucion
a intercambiar y los dos indices a intercambiar (nodo_a y nodo_b).

Ejemplo:
Si solucion = [1,2,3,4,5,6] y escribimos
TSP.opt(solucion, 1,3) => [1,4,3,2,5,6]
*/
VALUE method_tsp_opt(VALUE self, VALUE solucion, VALUE nodo_a, VALUE nodo_b)
{
	VALUE value_at_a;
	VALUE value_at_b;

	solucion = rb_check_array_type(solucion);

	if((TYPE(nodo_a) != T_FIXNUM) || (TYPE(nodo_b) != T_FIXNUM))
	{
		rb_raise(rb_eTypeError, "nodo_a and nodo_b must be an integer\n");
	}

	if((NUM2INT(nodo_a) < 0) || (NUM2INT(nodo_a) >= RARRAY_LEN(solucion)))
	{
		rb_raise(rb_eTypeError, 
			"nodo_a excede el rango %d-%d. Actual %d\n", 0, RARRAY_LEN(solucion) - 1, NUM2INT(nodo_a));
	}

	if((NUM2INT(nodo_b) < 0) || (NUM2INT(nodo_b) >= RARRAY_LEN(solucion)))
	{
		rb_raise(rb_eTypeError, 
			"nodo_b excede el rango %d-%d. Actual %d\n", 0, RARRAY_LEN(solucion) - 1, NUM2INT(nodo_b));
	}

	value_at_a = rb_ary_entry(solucion, NUM2INT(nodo_a));
	value_at_b = rb_ary_entry(solucion, NUM2INT(nodo_b));

	rb_ary_store(solucion, NUM2INT(nodo_a), value_at_b);
	rb_ary_store(solucion, NUM2INT(nodo_b), value_at_a);

	return Qnil;
}

/*
Devuelve el entorno en un vector ary alrededor de index.
Por ejemplo
a = [2,3,4,5,8,6]
TSP.entorno_de(a, 3) => [4, 5, 8]
*/
VALUE method_tsp_entorno(VALUE self, VALUE ary, VALUE index)
{
	VALUE empaquetado;
	VALUE item_anterior;
	VALUE item_actual;
	VALUE item_posterior;
	int anterior;
	int posterior;
	int actual;

	actual = NUM2INT(index);

	if(actual == 0)
	{
		anterior = RARRAY_LEN(ary) - 1;
	}
	else
	{
		anterior = actual - 1;
	}

	if(actual == RARRAY_LEN(ary) - 1)
	{
		posterior = 0;
	}
	else
	{
		posterior = actual + 1;
	}

	item_anterior = rb_ary_entry(ary, anterior);
	item_actual = rb_ary_entry(ary, actual);
	item_posterior = rb_ary_entry(ary, posterior);

	empaquetado = rb_ary_new();
	rb_ary_push(empaquetado, item_anterior);
	rb_ary_push(empaquetado, item_actual);
	rb_ary_push(empaquetado, item_posterior);

	return empaquetado;
}

/*
Devuelve un valor negativo cuando el coste de la solucion disminuye y un valor
positivo cuando el coste de la solucion aumenta. Si el coste de la solucion se
mantiene intacto simplemente devuelve cero. El grado en el que aumenta o
disminuye el coste de la solucion se puede calcular sumando el valor devuelto
a el coste que se tenía de la solucion.

Los parametros que recibe son:
- solucion: La solucion actual antes de realizar el intercambio
- nodo_a: Indice del nodo primero que se desea intercambiar
- nodo_b: Indice del segundo nodo a intercambiar

Atencion: Tanto nodo_a como nodo_b son los indices del vector a intercambiar, no el contenido de
los nodos.
*/
VALUE method_tsp_grado_mejora_solucion(VALUE self, VALUE solucion, VALUE nodo_a, VALUE nodo_b)
{
	VALUE coste_inicial;
	VALUE coste_final;
	VALUE entorno_a;
	VALUE entorno_b;

	solucion = rb_check_array_type(solucion);

	if((TYPE(nodo_a) != T_FIXNUM) || (TYPE(nodo_b) != T_FIXNUM))
	{
		rb_raise(rb_eTypeError, "nodo_a y nodo_b deben de ser valores enteros\n");
	}

	if((NUM2INT(nodo_a) > RARRAY_LEN(solucion) - 1) || (NUM2INT(nodo_a) < 0))
	{
		rb_raise(rb_eTypeError, "nodo_a se sale de rango: %d - max: %d\n", NUM2INT(nodo_a),
					RARRAY_LEN(solucion) - 1);
	}

	if((NUM2INT(nodo_b) > RARRAY_LEN(solucion) - 1) || (NUM2INT(nodo_b) < 0))
	{
		rb_raise(rb_eTypeError, "nodo_b se sale de rango: %d - max: %d\n", NUM2INT(nodo_b), 
					RARRAY_LEN(solucion) - 1);
	}

	if((NUM2INT(nodo_a) != 0) && (NUM2INT(nodo_a) != RARRAY_LEN(solucion) - 1) && (NUM2INT(nodo_b) != 0) && (NUM2INT(nodo_b) != RARRAY_LEN(solucion)- 1))
	{
		entorno_a = method_tsp_entorno(self, solucion, nodo_a);
		entorno_b = method_tsp_entorno(self, solucion, nodo_b);
		coste_inicial = DBL2NUM(NUM2DBL(method_btsp_coste_solucion(self, entorno_a)) + NUM2DBL(method_btsp_coste_solucion(self, entorno_b)));
		method_tsp_opt(self, solucion, nodo_a, nodo_b);

		entorno_a = method_tsp_entorno(self, solucion, nodo_a);
		entorno_b = method_tsp_entorno(self, solucion, nodo_b);
		coste_final = DBL2NUM(NUM2DBL(method_btsp_coste_solucion(self, entorno_a)) + NUM2DBL(method_btsp_coste_solucion(self, entorno_b)));
		method_tsp_opt(self, solucion, nodo_a, nodo_b);
	}
	else
	{
		coste_inicial = method_btsp_coste_solucion(self, solucion);
		method_tsp_opt(self, solucion, nodo_a, nodo_b);

		coste_final = method_btsp_coste_solucion(self, solucion);
		method_tsp_opt(self, solucion, nodo_a, nodo_b);
	}

	return DBL2NUM(NUM2DBL(coste_final) - NUM2DBL(coste_inicial));
}

/*
Este metodo es el encargado de realizar la busqueda local mediante el algoritmo de
first improvement. Recibe como parametros:
- solucion: La solución a mejorar
- coste_solucion: El coste de la solucion a mejorar (como es TSP se trata de minimizar dicho coste)
- limite: Numero de iteraciones máximas a dar. Si se pone a cero se establecera a solucion.length * 3
*/
VALUE method_tsp_busqueda_local_first_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite)
{
	VALUE coste_alternativa;
	double coste_actual = NUM2DBL(coste_solucion);
	double coste_anterior = coste_actual;
	VALUE empaquetado;
	long int i, j, l;

	solucion = rb_check_array_type(solucion);

	if((TYPE(coste_solucion) != T_FIXNUM) && (TYPE(coste_solucion) != T_FLOAT))
	{
		rb_raise(rb_eTypeError, "coste_solucion must be a number\n");
	}

	if(TYPE(limite) != T_FIXNUM)
	{
		rb_raise(rb_eTypeError, "limite must be an integer\n");
	}

	if(NUM2INT(limite) < 0)
	{
		rb_raise(rb_eTypeError, "limite must be a positive integer, or zero for auto\n");
	}

	if(NUM2INT(limite) == 0)
	{
		limite = INT2NUM(RARRAY_LEN(solucion) * RARRAY_LEN(solucion));
	}
	
	for(l = 0; l < NUM2INT(limite); l++)
	{
		for(i = 0; i < RARRAY_LEN(solucion); i++)
		{
			for(j = i + 1; j < RARRAY_LEN(solucion); j++)
			{
				//limite_actual = INT2NUM(NUM2INT(limite_actual) + 1);

				coste_alternativa = method_tsp_grado_mejora_solucion(self, solucion, INT2NUM(i), INT2NUM(j));

				if(NUM2DBL(coste_alternativa) < 0)
				{
					coste_actual += NUM2DBL(coste_alternativa);

					method_tsp_opt(self, solucion, INT2NUM(i), INT2NUM(j));
					j--;
				}
			}
		}

		if(coste_actual == coste_anterior)
		{
			break;
		}
		else
		{
			coste_anterior = coste_actual;
		}
	}

	empaquetado = rb_ary_new();
	rb_ary_push(empaquetado, solucion);
	rb_ary_push(empaquetado, DBL2NUM(coste_actual));
	return empaquetado;
}

/*
Realiza una busqueda local guiada por el algoritmo de seleccion best improvement para
mejorar una solucion dada. Recibe como parametros:
- solucion: La solucion a mejorar
- coste_solucion: El coste actual de la solucion a mejorar
- limite: Numero maximo de iteraciones a dar. Si se especifica a cero se establece automaticamente
*/
VALUE method_tsp_busqueda_local_best_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite)
{
	VALUE alternativas; //Almacena en un vector las alternativas validas a la solucion
	VALUE coste_alternativas; //En una tabla de hash se almacena el coste de cada una de las alternativas
	VALUE empaquetado;
	VALUE coste_anterior; //Almacena el coste de la ultima vuelta para comprobar si hubo mejoras
	int i, j, l;

	alternativas = rb_ary_new();
	coste_alternativas = rb_hash_new();
	l = 0;

	solucion = rb_check_array_type(solucion);

	if((TYPE(coste_solucion) != T_FIXNUM) && (TYPE(coste_solucion) != T_FLOAT))
	{
		rb_raise(rb_eTypeError, "coste_solucion must be a number\n");
	}

	if(TYPE(limite) != T_FIXNUM)
	{
		rb_raise(rb_eTypeError, "limite must be an integer\n");
	}

	if(NUM2INT(limite) == 0)
	{
		limite = INT2NUM(RARRAY_LEN(solucion) * RARRAY_LEN(solucion));
	}

	coste_anterior = DBL2NUM(NUM2DBL(coste_solucion));

	for(l = 0; l < NUM2INT(limite); l++)
	{
		for(i = 0; i < RARRAY_LEN(solucion); i++)
		{
			for(j = i + 1; j < RARRAY_LEN(solucion); j++)
			{
				VALUE coste_alternativa;

				coste_alternativa = method_tsp_grado_mejora_solucion(self, solucion, INT2NUM(i), INT2NUM(j));

				if(NUM2DBL(coste_alternativa) < 0)
				{
					rb_ary_push(alternativas, INT2NUM(j));
					rb_hash_aset(coste_alternativas, INT2NUM(j), coste_alternativa);
				}
			}

			if(RARRAY_LEN(alternativas) > 0)
			{
				VALUE nodo_maximo;
				int sin_nodo_actualmente = 1;
				int h;

				for(h = 0; h < RARRAY_LEN(alternativas); h++)
				{
					VALUE item = rb_ary_entry(alternativas, h);

					if(sin_nodo_actualmente == 1)
					{
						nodo_maximo = item;
						sin_nodo_actualmente = 0;
					}
					else if(rb_hash_aref(coste_alternativas, item) > rb_hash_aref(coste_alternativas, nodo_maximo))
					{
						nodo_maximo = item;
					}
				}

				method_tsp_opt(self, solucion, INT2NUM(i), nodo_maximo);
				coste_solucion = DBL2NUM(NUM2DBL(coste_solucion) + NUM2DBL(rb_hash_aref(coste_alternativas, nodo_maximo)));
				rb_ary_clear(alternativas);
				rb_hash_clear(coste_alternativas);
			}
		}

		if(NUM2DBL(coste_solucion) == NUM2DBL(coste_anterior))
		{
			break;
		}
		else
		{
			coste_anterior = DBL2NUM(NUM2DBL(coste_solucion));
		}
	}

	empaquetado = rb_ary_new();
	rb_ary_push(empaquetado, solucion);
	rb_ary_push(empaquetado, coste_solucion);

	return empaquetado;
}

VALUE method_tsp_busqueda_local_enfriamiento_simulado(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE es, VALUE temperatura_minima)
{
	VALUE best_solution;
	VALUE best_cost;
	VALUE empaquetado;
	long int i, j;

	best_solution = rb_ary_dup(solucion);
	best_cost = coste_solucion;

	while(NUM2DBL(method_temperatura(es)) > NUM2DBL(temperatura_minima))
	{
		for(i = 0; i < RARRAY_LEN(solucion); i++)
		{
			VALUE item = rb_ary_entry(solucion, i);

			for(j = i + 1; j < RARRAY_LEN(solucion); j++)
			{
				VALUE alternativa = rb_ary_entry(solucion, j);
				VALUE coste;

				if(i == j)
				{
					continue;
				}

				coste = method_tsp_grado_mejora_solucion(self, solucion, item, alternativa);

				if((NUM2DBL(coste) < NUM2DBL(coste_solucion)) || (method_probabilidad(es) == Qtrue))
				{
					method_tsp_opt(self, solucion, INT2NUM(i), INT2NUM(j));
					coste_solucion = DBL2NUM(NUM2DBL(coste_solucion) + NUM2DBL(coste));
					j--;

					if(NUM2DBL(coste_solucion) < NUM2DBL(best_cost))
					{
						best_cost = coste_solucion;
						best_solution = rb_ary_dup(solucion);
					}
				}
			}
		}
		method_enfriar(es);
	}

	empaquetado = rb_ary_new();
	rb_ary_push(empaquetado, best_solution);
	rb_ary_push(empaquetado, best_cost);

	return empaquetado;
}

void Init_c_tsp()
{
	Init_c_basic_tsp();
	class_tsp = rb_define_class_under(module_tsp, "TSP", class_basic_tsp);
	rb_define_private_method(class_tsp, "opt", method_tsp_opt, 3);
	rb_define_private_method(class_tsp, "grado_mejora_solucion", method_tsp_grado_mejora_solucion, 3);
	rb_define_private_method(class_tsp, "busqueda_local_first_improvement", method_tsp_busqueda_local_first_improvement, 3);
	rb_define_private_method(class_tsp, "busqueda_local_best_improvement", method_tsp_busqueda_local_best_improvement, 3);
	rb_define_private_method(class_tsp, "entorno_de", method_tsp_entorno, 2);
	rb_define_private_method(class_tsp, "busqueda_local_enfriamiento_simulado", method_tsp_busqueda_local_enfriamiento_simulado, 4);
}