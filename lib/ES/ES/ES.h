#ifndef __C_ENFRIAMIENTO_SIMULADO__
#define __C_ENFRIAMIENTO_SIMULADO__

#include <ruby.h>

// Constructor de la clase ES
void Init_c_es();

// Modulo ES
VALUE module_es = Qnil;

// Clase ES
VALUE class_es = Qnil;

VALUE method_es_initialize(VALUE self, VALUE temperatura, VALUE coeficiente)
{
	rb_iv_set(self, "@temperatura", temperatura);
	rb_iv_set(self, "@coeficiente", coeficiente);
	rb_iv_set(self, "@temperatura_inicio", temperatura);
}


/*
Este metodo devuelve la temperatura actual del algoritmo
*/
VALUE method_temperatura(VALUE self);

/*
Este metodo devuelve un valor booleano True o False de forma aleatoria.
La probabilidad de que devuelva True sera mayor contra más alta sea
la temperatura.

Recibe como parametro coste_solucion que indica el coste de una
solución dada.
*/
VALUE method_probabilidad(VALUE self);

/*
Disminuye la temperatura interna de la clase de manera que haya menor
probabilidad de conseguir un valor True.

La funcion de disminución de la temperatura viene determinada por el
tipo y por el coeficiente de cambio determinado en la clase
*/
VALUE method_enfriar(VALUE self);

/*
Devuelve el tipo de funcion de disminución de la temperatura,
actualmente este valor solo puede ser :geometrica
*/
VALUE method_tipo(VALUE self);

/*
Devuelve el coeficiente de cambio usado en la funcion de temperatura
*/
VALUE method_coeficiente(VALUE self);

/*
Restaura la temperatura a su punto inicial
*/
VALUE method_reset(VALUE self);
#endif