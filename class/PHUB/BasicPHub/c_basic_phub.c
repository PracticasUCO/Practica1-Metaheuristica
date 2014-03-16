#include "ruby.h"
#include <stdio.h>
#include "../CapacitedPHubNode/c_basic_phub_node.c"
VALUE CBasicPHub = Qnil;

/*
 * funcion_objetivo devuelve el coste de la solucion
 */
VALUE rb_funcion_objetivo(VALUE self, VALUE solucion);

VALUE rb_funcion_objetivo(VALUE self, VALUE solucion)
{
	VALUE tipoParametro = TYPE(solucion);
	
	if(tipoParametro != T_ARRAY)
	{
		rb_raise(rb_eTypeError, "Solucion debe de ser un Array\n");
	}
	
	double suma = 0;
	long int i, j;
	int p = 0;

	ID conectado_a_method = rb_intern("conectado_a");
	
	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		VALUE nodo = rb_ary_entry(solucion, i);
		VALUE type = rb_iv_get(nodo, "@tipo");	
		VALUE c = ID2SYM(rb_intern("cliente"));
		if (type == c)
		{
			VALUE destino = rb_funcall(nodo, conectado_a_method, 0);
			destino = rb_ary_entry(destino,0);
			
			double dis = NUM2DBL(method_distancia(nodo, destino));
			suma += dis;
		}	
	}
	
	suma /= RARRAY_LEN(solucion);
	
	return DBL2NUM(suma);
}

void Init_c_basic_phub()
{
	CBasicPHub = rb_define_class("BasicPHub", rb_cObject);
	rb_define_method(CBasicPHub, "funcion_objetivo", rb_funcion_objetivo, 1);
}