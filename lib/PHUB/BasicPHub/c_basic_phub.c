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
	ID conectado_a_method = rb_intern("conectado_a");

	double suma = 0;
	long int i;

	if(tipoParametro != T_ARRAY)
	{
		rb_raise(rb_eTypeError, "Solucion debe de ser un Array\n");
	}
	
	
	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		VALUE nodo = rb_ary_entry(solucion, i);
		VALUE type = rb_iv_get(nodo, "@tipo");	
		VALUE c = ID2SYM(rb_intern("cliente"));
		if (type == c)
		{
			VALUE destino = rb_funcall(nodo, conectado_a_method, 0);
			VALUE tipo_des;

			destino = rb_ary_entry(destino,0);
			
			tipo_des = TYPE(destino);
			if(tipo_des != T_NIL)
			{
				double dis = NUM2DBL(method_distancia(nodo, destino));
				suma += dis;
			}
		}	
	}

	suma /= RARRAY_LEN(solucion);
	return DBL2NUM(suma);
}

void Init_c_basic_phub()
{
	CBasicPHub = rb_define_class_under(phub_module, "BasicPHub", rb_cObject);
	rb_define_method(CBasicPHub, "funcion_objetivo", rb_funcion_objetivo, 1);
}