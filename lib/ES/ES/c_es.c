#include "c_es.h"

void Init_ES()
{
	module_es = rb_define_module("ES");
	class_es = rb_define_class_under(module_es, "ES", rb_cObject);
	rb_define_method(class_es, "initialize", method_initialize, 1);
	rb_define_method(class_es, "temperatura", method_temperatura, 0);
	rb_define_method(class_es, "probabilidad", method_probabilidad, 0);
	rb_define_method(class_es, "enfriar", method_enfriar, 0);
	rb_define_method(class_es, "valor_inicio", method_valor_inicio, 0);
	rb_define_method(class_es, "tipo", method_tipo, 0);
	rb_define_method(class_es, "coeficiente", method_coeficiente, 0);
	rb_define_method(class_es, "reset", method_reset, 0);
}

VALUE method_temperatura(VALUE self)
{
	return rb_iv_get(self, "temperatura");
}