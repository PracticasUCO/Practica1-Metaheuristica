#include "c_basic_mmdp.h"
#include <stdio.h>

/*
Devuelve la distancia o coste entre dos nodos.
Si no encuentra los nodos, devolverá cero.

Recibe como parámetros el nodo origen y el nodo
destino.

Si no encuentra el coste entre los dos nodos
indicados devuelve false
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
		return Qfalse;
	}
}

/*
Este método devuelve la diversidad mínima que existe en una solución
Puede recibir una serie de nodos, en cuyo caso devolvería la diversidad
mínima que habría después de añadir dichos nodos
*/
VALUE method_diversidad_minima(VALUE self, VALUE solucion)
{
	VALUE minimo = DBL2NUM(0);
	VALUE origen;
	VALUE destino;
	VALUE valor_actual; //Valor actual de la diversidad mínima
	long int i, j; //Auxiliares
	int count_minimo = 0; //Si vale 1 se empieza a tener en cuenta el valor del mínimo

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

			if(valor_actual == Qfalse)
			{
				continue;
			}

			if(count_minimo == 0)
			{
				minimo = valor_actual;
				count_minimo = 1;
			}
			else if(NUM2DBL(valor_actual) < NUM2DBL(minimo))
			{
				minimo = valor_actual;
			}
		}
	}

	return minimo;

}

VALUE method_merge_diversidad_minima(VALUE self, VALUE solucion, VALUE nuevo_nodo)
{
	VALUE minimo = DBL2NUM(10);
	VALUE origen;
	VALUE destino;
	VALUE valor_actual = DBL2NUM(15);
	VALUE valor_nuevo_nodo;
	long int i, j; //Auxiliares
	int count_minimo = 0;

	if(TYPE(nuevo_nodo) == T_NIL)
	{
		rb_raise(rb_eTypeError, "nuevo_nodo debe de ser un nodo, no nil\n");
	}

	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		origen = rb_ary_entry(solucion, i);

		valor_nuevo_nodo = method_obtener_coste_entre(self, origen, nuevo_nodo);
		
		if(valor_nuevo_nodo == Qfalse)
		{
			continue;
		}

		if(count_minimo != 0)
		{
			if(NUM2DBL(valor_nuevo_nodo) < NUM2DBL(minimo))
			{
				minimo = valor_nuevo_nodo;
			}
		}
		else
		{
			minimo = valor_nuevo_nodo;
			count_minimo = 1;
		}

		for(j = 0; j < RARRAY_LEN(solucion); j++)
		{
			if(i == j)
			{
				continue;
			}

			destino = rb_ary_entry(solucion, j);

			valor_actual = method_obtener_coste_entre(self, origen, destino);

			if(valor_actual == Qfalse)
			{
				continue;
			}

			if(count_minimo == 0)
			{
				minimo = valor_actual;
				count_minimo = 1;
			}
			else if(NUM2DBL(valor_actual) < NUM2DBL(minimo))
			{
				minimo = valor_actual;
			}
		}
	}

	return minimo;
}

VALUE method_diversidad_minima_parcial(VALUE self, VALUE solucion, VALUE nuevo_nodo)
{
	VALUE minimo = DBL2NUM(0);
	VALUE origen;
	VALUE valor_nuevo_nodo;
	long int i; //Auxiliares
	int count_minimo = 0;

	if(TYPE(nuevo_nodo) == T_NIL)
	{
		rb_raise(rb_eTypeError, "nuevo_nodo debe de ser un nodo, no nil\n");
	}

	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		origen = rb_ary_entry(solucion, i);

		valor_nuevo_nodo = method_obtener_coste_entre(self, origen, nuevo_nodo);
		
		if(valor_nuevo_nodo == Qfalse)
		{
			continue;
		}

		if(count_minimo == 0)
		{
			minimo = valor_nuevo_nodo;
			count_minimo = 1;
		}
		else if(NUM2DBL(valor_nuevo_nodo) < NUM2DBL(minimo))
		{
			minimo = valor_nuevo_nodo;
		}
	}

	return minimo;	
}

/*
funcion_objetivo es un sinónimo de diversidad mínima
*/
VALUE method_funcion_objetivo(VALUE self, VALUE solucion)
{
	return method_diversidad_minima(self, solucion);
}

void Init_c_basic_mmdp()
{

	module_mmdp = rb_define_module("MMDP");
	
	class_basic_mmdp = rb_define_class_under(module_mmdp, "BasicMMDP", rb_cObject);
	rb_define_method(class_basic_mmdp, "obtener_coste_entre", method_obtener_coste_entre, 2);
	rb_define_method(class_basic_mmdp, "diversidad_minima", method_diversidad_minima, 1);
	rb_define_method(class_basic_mmdp, "merge_diversidad_minima", method_merge_diversidad_minima, 2);
	rb_define_method(class_basic_mmdp, "funcion_objetivo", method_funcion_objetivo, 1);
	rb_define_method(class_basic_mmdp, "diversidad_minima_parcial", method_diversidad_minima_parcial, 2);
}
