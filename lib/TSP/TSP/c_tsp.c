#include "c_tsp.h"
#include "../BasicTSP/c_basic_tsp.h"
#include "../BasicTSP/c_basic_tsp.c"
#include <stdio.h>

void show_vector(VALUE ary)
{
	int i;
	for(i = 0; i < RARRAY_LEN(ary); i++)
	{
		fprintf(stderr, "%d - ", NUM2INT(rb_ary_entry(ary, i)));
	}
	fprintf(stderr, "\n");
}

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

	rb_ary_delete_at(solucion, NUM2INT(nodo_a));
	rb_ary_delete_at(solucion, NUM2INT(nodo_b));

	rb_ary_store(solucion, NUM2INT(nodo_a), value_at_b);
	rb_ary_store(solucion, NUM2INT(nodo_b), value_at_a);

	return Qnil;
}

/*
Devuelve un valor negativo cuando el coste de la solucion disminuye y un valor
positivo cuando el coste de la solucion aumenta. Si el coste de la solucion se
mantiene intacto simplemente devuelve cero. El grado en el que aumenta o
disminuye el coste de la solucion se puede calcular sumando el valor devuelto
a el coste que se tenía de la solucion.

Este metodo es más eficiente que calcular el coste de dos soluciones diferentes
ya que hara en la mayoría de las ocasiones menos iteraciones.

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
	VALUE anterior_a;
	VALUE posterior_a;
	VALUE anterior_b;
	VALUE posterior_b;
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

	if(NUM2INT(nodo_a) == 0)
	{
		anterior_a = INT2NUM(RARRAY_LEN(solucion) - 1);
	}
	else
	{
		anterior_a = INT2NUM(NUM2INT(nodo_a) - 1);
	}

	if(NUM2INT(nodo_a) == RARRAY_LEN(solucion) - 1)
	{
		posterior_a = INT2NUM(0);
	}
	else
	{
		posterior_a = INT2NUM(NUM2INT(nodo_a) + 1);
	}

	if(NUM2INT(nodo_b) == 0)
	{
		anterior_b = INT2NUM(RARRAY_LEN(solucion) - 1);
	}
	else
	{
		anterior_b = INT2NUM(NUM2INT(nodo_b) - 1);
	}

	if(NUM2INT(nodo_b) == RARRAY_LEN(solucion) - 1)
	{
		posterior_b = INT2NUM(0);
	}
	else
	{
		posterior_b = INT2NUM(NUM2INT(nodo_b) + 1);
	}

	coste_inicial = DBL2NUM(NUM2DBL(method_btsp_reader_2(self, anterior_a, nodo_a)) + NUM2DBL(method_btsp_reader_2(self, nodo_a, posterior_a)));
	coste_inicial = DBL2NUM(NUM2DBL(coste_inicial) + NUM2DBL(method_btsp_reader_2(self, anterior_b, nodo_b)) + NUM2DBL(method_btsp_reader_2(self, nodo_b, posterior_b)));

	method_tsp_opt(self, solucion, nodo_a, nodo_b);

	coste_final = DBL2NUM(NUM2DBL(method_btsp_reader_2(self, anterior_a, nodo_a)) + NUM2DBL(method_btsp_reader_2(self, nodo_a, posterior_a)));
	coste_final = DBL2NUM(NUM2DBL(coste_inicial) + NUM2DBL(method_btsp_reader_2(self, anterior_b, nodo_b)) + NUM2DBL(method_btsp_reader_2(self, nodo_b, posterior_b)));

	method_tsp_opt(self, solucion, nodo_a, nodo_b);
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
	VALUE limite_actual = INT2NUM(0);
	VALUE empaquetado;
	long int i, j;

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
		limite = INT2NUM(RARRAY_LEN(solucion) * 3);
	}

	for(i = 0; ((i < RARRAY_LEN(solucion)) && (NUM2INT(limite_actual) < NUM2INT(limite))); i++)
	{
		for(j = i; ((j < RARRAY_LEN(solucion)) && (NUM2INT(limite_actual) < NUM2INT(limite))); j++)
		{
			limite_actual = INT2NUM(NUM2INT(limite_actual) + 1);
			coste_alternativa = method_tsp_grado_mejora_solucion(self, solucion, INT2NUM(i), INT2NUM(j));

			if(NUM2DBL(coste_alternativa) < 0)
			{
				coste_solucion = NUM2DBL(coste_solucion) + NUM2DBL(coste_alternativa);
				method_tsp_opt(self, solucion, INT2NUM(i), INT2NUM(j));
			}
		}
	}

	empaquetado = rb_ary_new();
	rb_ary_push(empaquetado, solucion);
	rb_ary_push(empaquetado, coste_solucion);
	return empaquetado;
}

void Init_c_tsp()
{
	Init_c_basic_tsp();
	class_tsp = rb_define_class_under(module_tsp, "TSP", class_basic_tsp);
	rb_define_private_method(class_tsp, "opt", method_tsp_opt, 3);
	rb_define_private_method(class_tsp, "grado_mejora_solucion", method_tsp_grado_mejora_solucion, 3);
	rb_define_private_method(class_tsp, "busqueda_local_first_improvement", method_tsp_busqueda_local_first_improvement, 3);
}