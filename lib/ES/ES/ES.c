#include "ES.h"
#include <stdlib.h>

/*
Este método devuelve la temperatura actual del algoritmo
*/
VALUE method_temperatura(VALUE self)
{
	return rb_iv_get(self, "@temperatura");
}

/*
Este método devuelve un valor booleano True o False de forma aleatoria.
La probabilidad de que devuelva True sera mayor contra más alta sea
la temperatura.
*/
VALUE method_probabilidad(VALUE self)
{
	//ID method_rand = rb_intern("rand");
	VALUE valorInicio = rb_iv_get(self, "@temperatura_inicio");
	VALUE valorTemperatura = rb_iv_get(self, "@temperatura");
	//VALUE valorAleatorio = rb_funcall(rb_cObject, method_rand, 1, valorInicio);
	double valorAleatorio = rb_genrand_real();
	
	if(valorAleatorio <= NUM2DBL(valorTemperatura) / NUM2DBL(valorInicio))
	{
		return Qtrue;
	}
	else
	{
		return Qfalse;
	}
}

/*
Disminuye la temperatura interna de la clase de manera que haya menor
probabilidad de conseguir un valor True.

La función de disminución de la temperatura viene determinada por el
tipo y por el coeficiente de cambio determinado en la clase
*/
VALUE method_enfriar(VALUE self)
{
	VALUE coeficiente;
	VALUE temperaturaActual;

	coeficiente = rb_iv_get(self, "@coeficiente");
	temperaturaActual = rb_iv_get(self, "@temperatura");

	temperaturaActual = DBL2NUM(NUM2DBL(temperaturaActual) * NUM2DBL(coeficiente));
	rb_iv_set(self, "@temperatura", temperaturaActual);
	
	return temperaturaActual;
}

/*
Devuelve el coeficiente de cambio usado en la función de temperatura
*/
VALUE method_coeficiente(VALUE self)
{
	return rb_iv_get(self, "@coeficiente");
}

/*
Restaura la temperatura a su punto inicial
*/
VALUE method_reset(VALUE self)
{
	VALUE valorInicial = rb_iv_get(self, "@temperatura_inicio");
	rb_iv_set(self, "@temperatura", valorInicial);
	return valorInicial;
}

/*
Constructor de la clase ES. Recibe como parámetros:
- temperatura: El valor de la temperatura inicial. Este valor debe de ser un numero positivo
- coeficiente: Valor del coeficiente. Este valor debe de ser un numero entre 0-1 exclusive
*/
VALUE method_es_initialize(VALUE self, VALUE temperatura, VALUE coeficiente)
{
	if((TYPE(temperatura) != T_FIXNUM) && (TYPE(temperatura) != T_FLOAT))
	{
		rb_raise(rb_eTypeError, "La temperatura de inicio debe de ser un numero\n");
	}

	if((TYPE(coeficiente) != T_FIXNUM) && (TYPE(coeficiente) != T_FLOAT))
	{
		rb_raise(rb_eTypeError, "El coeficiente debe de ser un flotante\n");
	}

	if(NUM2DBL(temperatura) < 1)
	{
		rb_raise(rb_eTypeError, "La temperatura no puede ser negativa\n");
	}

	if((NUM2DBL(coeficiente) <= 0) || (NUM2DBL(coeficiente) >= 1))
	{
		rb_raise(rb_eTypeError, "El coeficiente debe oscilar entre 0-1 (exclusive)\n");
	}

	rb_iv_set(self, "@temperatura", temperatura);
	rb_iv_set(self, "@coeficiente", coeficiente);
	rb_iv_set(self, "@temperatura_inicio", temperatura);
	return self;
}


void Init_ES()
{
	module_es = rb_define_module("ES");
	class_es = rb_define_class_under(module_es, "ES", rb_cObject);
	rb_define_method(class_es, "initialize", method_es_initialize, 2);
	rb_define_method(class_es, "temperatura", method_temperatura, 0);
	rb_define_method(class_es, "probabilidad", method_probabilidad, 0);
	rb_define_method(class_es, "enfriar", method_enfriar, 0);
	rb_define_method(class_es, "coeficiente", method_coeficiente, 0);
	rb_define_method(class_es, "reset", method_reset, 0);
}
