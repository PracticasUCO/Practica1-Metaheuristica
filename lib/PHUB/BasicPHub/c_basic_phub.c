#include "ruby.h"
#include "c_basic_phub.h"

/*
funcion_objetivo devuelve la suma de las distancias de todos
los nodos clientes al concentrador al que están conectados.
*/
VALUE rb_funcion_objetivo(VALUE self, VALUE solucion)
{
	VALUE tipoParametro = TYPE(solucion);
	ID conectado_a_method = rb_intern("conectado_a");

	double suma = 0;
	long int i;
	unsigned int desconectados = 0;
	double valor_por_desconexiones = NUM2DBL(rb_iv_get(self, "@max_cost"));

	if(tipoParametro != T_ARRAY)
	{
		rb_raise(rb_eTypeError, "Solución debe de ser un Array\n");
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
			else
			{
				desconectados++;
			}
		}	
	}
	
	/*if(desconectados > 0)
	{
		suma += valor_por_desconexiones * (desconectados + 1);
	}*/

	return DBL2NUM(suma);
}

void Init_c_basic_phub()
{
	CBasicPHub = rb_define_class_under(phub_module, "BasicPHub", rb_cObject);
	rb_define_method(CBasicPHub, "funcion_objetivo", rb_funcion_objetivo, 1);
}
