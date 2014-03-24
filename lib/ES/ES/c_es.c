#include "c_es.h"
#include <math.h>
#include <stdio.h>

/*
Este metodo devuelve la temperatura actual del algoritmo
*/
VALUE method_temperatura(VALUE self)
{
	return rb_iv_get(self, "@temperatura");
}

/*
Este metodo devuelve un valor booleano True o False de forma aleatoria.
La probabilidad de que devuelva True sera mayor contra más alta sea
la temperatura.
*/
VALUE method_probabilidad(VALUE self, VALUE coste_solucion)
{
	ID method_rand = rb_intern("rand");
	ID method_abs = rb_intern("abs");
	VALUE objetivo_max = ID2SYM(rb_intern("maximizar"));
	VALUE coste_actual = rb_iv_get(self, "@coste_solucion_actual");
	VALUE tipoCosteSolucion = TYPE(coste_solucion);
	VALUE objetivo = rb_iv_get(self, "@objetivo");
	double valorTemperatura = NUM2DBL(rb_iv_get(self, "@temperatura"));
	double valorAleatorio = NUM2DBL(rb_funcall(rb_cObject, method_rand, 0));
	double diferencia;
	double umbral;

	if((tipoCosteSolucion != T_FIXNUM) && (tipoCosteSolucion != T_FLOAT))
	{
		rb_raise(rb_eTypeError, "coste_solucion debe de ser un valor numerico");
	}

	diferencia = NUM2DBL(coste_actual) - NUM2DBL(coste_solucion);
	diferencia = NUM2DBL(rb_funcall(DBL2NUM(diferencia), method_abs, 0));

	umbral = 1 / (exp((diferencia / valorTemperatura)));

	if(objetivo == objetivo_max)
	{
		if(umbral > valorAleatorio)
		{
			return Qtrue;
		}
		else
		{
			return Qfalse;
		}
	}
	else
	{
		if(umbral < valorAleatorio)
		{
			return Qtrue;
		}
		else
		{
			return Qfalse;
		}
	}
}

/*
Disminuye la temperatura interna de la clase de manera que haya menor
probabilidad de conseguir un valor True.

La funcion de disminución de la temperatura viene determinada por el
tipo y por el coeficiente de cambio determinado en la clase
*/
VALUE method_enfriar(VALUE self)
{
	VALUE coeficiente;
	VALUE temperaturaActual;
	ID tipo;
	ID tipo_geometrica;

	coeficiente = rb_iv_get(self, "@coeficiente");
	temperaturaActual = rb_iv_get(self, "@temperatura");
	tipo = rb_iv_get(self, "@tipo");
	tipo_geometrica = ID2SYM(rb_intern("geometrica"));

	if(tipo == tipo_geometrica)
	{
		temperaturaActual = DBL2NUM(NUM2DBL(temperaturaActual) * NUM2DBL(coeficiente));
		rb_iv_set(self, "@temperatura", temperaturaActual);
	}
	else
	{
		rb_raise(rb_eTypeError, "El tipo de la clase ES no es correcto");
	}
	return Qnil;
}

/*
Devuelve el valor de inicio de la temperatura de la clase
*/
VALUE method_valor_inicio(VALUE self)
{
	return rb_iv_get(self, "@valor_inicio");
}

/*
Devuelve el tipo de funcion de disminución de la temperatura,
actualmente este valor solo puede ser :geometrica
*/
VALUE method_tipo(VALUE self)
{
	return rb_iv_get(self, "@tipo");
}

/*
Devuelve el coeficiente de cambio usado en la funcion de temperatura
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
	VALUE valorInicial = rb_iv_get(self, "@valor_inicio");
	rb_iv_set(self, "@temperatura", valorInicial);
	return Qnil;
}

void Init_c_es()
{
	module_es = rb_define_module("ES");
	class_es = rb_define_class_under(module_es, "ES", rb_cObject);
	rb_define_method(class_es, "temperatura", method_temperatura, 0);
	rb_define_method(class_es, "probabilidad", method_probabilidad, 1);
	rb_define_method(class_es, "enfriar", method_enfriar, 0);
	rb_define_method(class_es, "valor_inicio", method_valor_inicio, 0);
	rb_define_method(class_es, "tipo", method_tipo, 0);
	rb_define_method(class_es, "coeficiente", method_coeficiente, 0);
	rb_define_method(class_es, "reset", method_reset, 0);
}