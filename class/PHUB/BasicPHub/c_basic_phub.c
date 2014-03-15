#include "ruby.h"
#include <stdio.h>

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
	return INT2NUM(18);
}

void Init_c_basic_phub()
{
	CBasicPHub = rb_define_class("BasicPHub", rb_cObject);
	rb_define_method(CBasicPHub, "funcion_objetivo", rb_funcion_objetivo, 1);
}