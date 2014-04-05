#include <ruby.h>
#include "c_basic_tsp.h"

/*
Iterador que accede a cada elemento de la matriz de costes
*/
VALUE method_btsp_each(VALUE self)
{
	VALUE caminos = rb_iv_get(self, "@caminos");
	long int i, j;

	for(i = 0; i < RARRAY_LEN(caminos); i++)
	{
		VALUE camino = rb_ary_entry(caminos, i);

		for(j = 0; j < RARRAY_LEN(camino); j++)
		{
			VALUE coste = rb_ary_entry(camino, j);
			rb_yield(coste);
		}
	}
	return Qnil;
}

VALUE method_btsp_reader(VALUE self, VALUE index)
{
	VALUE caminos;
	if(TYPE(index) != T_FIXNUM)
	{
		rb_raise(rb_eTypeError, "index must be an integer\n");
	}

	caminos = rb_iv_get(self, "@caminos");
	return rb_ary_entry(caminos, NUM2INT(index));
}

/*
Calcula el coste de una solucion dada

Recibe como parametro un Array con las ciudades que se van a visitar
*/

VALUE method_btsp_coste_solucion(VALUE self, VALUE ciudades)
{
	VALUE caminos = rb_iv_get(self, "@caminos");
	double coste = 0.0;
	int i;

	ciudades = rb_check_array_type(ciudades);

	for(i = 0; (i + 1) < RARRAY_LEN(ciudades); i++)
	{
		VALUE node_a = rb_ary_entry(ciudades, i);
		VALUE node_b = rb_ary_entry(ciudades, i + 1);
		coste += NUM2DBL(rb_ary_entry(rb_ary_entry(caminos, NUM2INT(node_a)), NUM2INT(node_b)));
	}

	coste += NUM2DBL(rb_ary_entry(rb_ary_entry(caminos, -1), 0));

	return DBL2NUM(coste);
}

void Init_c_basic_tsp()
{
	module_tsp = rb_define_module("TSP");
	class_basic_tsp = rb_define_class_under(module_tsp, "BasicTSP", rb_cObject);
	rb_define_method(class_basic_tsp, "each", method_btsp_each, 0);
	rb_define_method(class_basic_tsp, "coste_solucion", method_btsp_coste_solucion, 1);
	rb_define_method(class_basic_tsp, "[]", method_btsp_reader, 1);
}