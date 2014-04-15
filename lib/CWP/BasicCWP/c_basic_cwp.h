#ifndef __C_BASIC_CWP__
#define __C_BASIC_CWP__
#include <ruby.h>
// Valor de la clae CWP
VALUE c_basic_cwp = Qnil;

// Modulo CWP
VALUE module_cwp = Qnil;

// Prototipo para la inicialización de la clase
void Init_c_basic_cwp();

/*
La función objetivo devuelve el numero de cortes que se producen
al ordenar el grafo de forma lineal.
*/
VALUE method_funcion_objetivo(VALUE self, VALUE v_nodes);

// Realiza la diferencia entre dos arrays, ary1 - ary2
static VALUE diferencia_ary(VALUE ary1, VALUE ary2);

#endif
