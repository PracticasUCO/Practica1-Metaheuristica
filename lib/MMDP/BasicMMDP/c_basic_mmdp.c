#include "c_basic_mmdp.h"

/*
Devuelve la distancia o coste entre dos nodos.
Si no encuentra los nodos, devolvera cero.

Recibe como parametros el nodo origen y el nodo
destino
*/
VALUE method_obtener_coste_entre(VALUE self, VALUE origen, VALUE destino)
{
	VALUE signature = rb_ary_new();
	VALUE nodes = rb_iv_get(self, "@nodes");

	origen = rb_check_string_type(origen);
	destino = rb_check_string_type(destino);

	rb_ary_push(signature, origen);
	rb_ary_push(signature, destino);
	rb_ary_sort_bang(signature);

	if(rb_hash_aref(nodes, signature) != Qnil)
	{
		return rb_hash_aref(nodes, signature);
	}
	else
	{
		return 0;
	}
}

/*
Este metodo devuelve la diversidad minimia que existe en una solucion
Puede recibir una serie de nodos, en cuyo caso devolveria la diversidad
minima que habría despues de añadir dichos nodos
*/
VALUE method_diversidad_minima(VALUE self, VALUE solucion)
{
	VALUE minimo = DBL2NUM(0);
	VALUE origen;
	VALUE destino;
	VALUE valor_actual; //Valor actual de la diversidad minima
	long int i, j; //Auxiliares
	int count_minimo = 0; //Si vale 1 se empieza a tener en cuenta el valor del minimo

	solucion = rb_check_array_type(solucion);

	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		origen = rb_ary_entry(solucion, i);

		for(j = 0; j < RARRAY_LEN(solucion); j++)
		{
			if(i == j)
			{
				continue;
			}

			destino = rb_ary_entry(solucion, j);

			valor_actual = method_obtener_coste_entre(self, origen, destino);

			if((count_minimo != 0) && (NUM2DBL(valor_actual) < NUM2DBL(minimo)))
			{
				minimo = valor_actual;
			}
		}
	}

	return minimo;

}

VALUE method_merge_diversidad_minima(VALUE self, VALUE solucion, VALUE nuevo_nodo)
{
	VALUE minimo = DBL2NUM(0);
	VALUE origen;
	VALUE destino;
	VALUE valor_actual;
	VALUE valor_nuevo_nodo;
	long int i, j; //Auxiliares
	int count_minimo = 0;

	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		origen = rb_ary_entry(solucion, i);

		valor_nuevo_nodo = method_obtener_coste_entre(self, origen, nuevo_nodo);

		if((count_minimo != 0) && (NUM2DBL(valor_nuevo_nodo) < NUM2DBL(minimo)))
		{
			minimo = valor_nuevo_nodo;
		}

		for(j = 0; j < RARRAY_LEN(solucion); j++)
		{
			if(i == j)
			{
				continue;
			}

			destino = rb_ary_entry(solucion, j);

			valor_actual = method_obtener_coste_entre(self, origen, destino);

			if((count_minimo != 0) && (NUM2DBL(valor_actual) < NUM2DBL(minimo)))
			{
				minimo = valor_actual;
			}
		}
	}

	return minimo;
}

void Init_c_basic_mmdp()
{
	module_mmdp = rb_define_module("MMDP");
	class_mmdp = rb_define_class_under(module_mmdp, "BasicMMDP", rb_cObject);
	rb_define_method(class_mmdp, "obtener_coste_entre", method_obtener_coste_entre, 2);
	rb_define_method(class_mmdp, "diversidad_minima", method_diversidad_minima, 1);
	rb_define_method(class_mmdp, "merge_diversidad_minima", method_merge_diversidad_minima, 2);
}