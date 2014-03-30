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

void Init_c_basic_mmdp()
{
	module_mmdp = rb_define_module("MMDP");
	class_mmdp = rb_define_class_under(module_mmdp, "BasicMMDP", rb_cObject);
	rb_define_method(class_mmdp, "obtener_coste_entre", method_obtener_coste_entre, 2);
}