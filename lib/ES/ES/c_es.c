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

VALUE method_probabilidad(VALUE self)
{
	ID method_rand = rb_intern("rand");
	double valorTemperatura = NUM2DBL(rb_iv_get(self, "temperatura"));
	double valorAleatorio = NUM2DBL(rb_funcall(rb_cObject, method_rand, 0));

	if(valorTemperatura >= valorAleatorio)
	{
		return Qtrue;
	}
	else
	{
		return Qfalse;
	}
}

VALUE method_enfriar(VALUE self)
{
	VALUE coeficiente;
	VALUE temperaturaActual;
	ID tipo;
	ID tipo_geometrica;

	coeficiente = rb_iv_get(self, "coeficiente");
	temperaturaActual = rb_iv_get(self, "temperatura");
	tipo = rb_iv_get(self, "tipo");
	tipo_geometrica = rb_intern("geometrica");

	if(tipo == tipo_geometrica)
	{
		temperaturaActual = DBL2NUM(NUM2DBL(temperaturaActual) * coeficiente);
		rb_iv_set(self, "temperatura", temperaturaActual);
	}
	else
	{
		rb_raise(rb_eTypeError, "El tipo de la clase ES no es correcto");
	}
	return Qnil;
}

VALUE method_valor_inicio(VALUE self)
{
	return rb_iv_get(self, "valor_inicio");
}

VALUE method_tipo(VALUE self)
{
	return rb_iv_get(self, "tipo");
}

VALUE method_coeficiente(VALUE self)
{
	return rb_iv_get(self, "coeficiente");
}