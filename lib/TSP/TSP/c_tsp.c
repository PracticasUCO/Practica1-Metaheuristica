#include "c_tsp.h"
#include "../BasicTSP/c_basic_tsp.c"

VALUE method_tsp_opt(VALUE self, VALUE solucion, VALUE nodo_a, VALUE nodo_b)
{
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
VALUE method_tsp_grado_mejora_solucion(VALUE self, VALUE solucion, VALUE coste, VALUE nodo_a, VALUE nodo_b)
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

	coste_inicial = DBL2NUM(NUM2DBL(method_bstp_reader_2(self, anterior_a, nodo_a)) + NUM2DBL(method_bstp_reader_2(self, nodo_a, posterior_a)));
	coste_inicial = DBL2NUM(NUM2DBL(coste_inicial) + NUM2DBL(method_bstp_reader_2(self, anterior_b, nodo_b)) + NUM2DBL(method_bstp_reader_2(self, nodo_b, posterior_b)));

	method_tsp_opt(self, solucion, nodo_a, nodo_b);

	coste_final = DBL2NUM(NUM2DBL(method_bstp_reader_2(self, anterior_a, nodo_a)) + NUM2DBL(method_bstp_reader_2(self, nodo_a, posterior_a)));
	coste_final = DBL2NUM(NUM2DBL(coste_inicial) + NUM2DBL(method_bstp_reader_2(self, anterior_b, nodo_b)) + NUM2DBL(method_bstp_reader_2(self, nodo_b, posterior_b)));

	method_tsp_opt(self, solucion, nodo_a, nodo_b);
	return DBL2NUM(NUM2DBL(coste_final) - NUM2DBL(coste_inicial));
}

void Init_c_tsp()
{
	Init_c_basic_tsp();
	class_tsp = rb_define_class_under(module_tsp, "TSP", class_basic_tsp);
}