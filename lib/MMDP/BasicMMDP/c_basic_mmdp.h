#ifndef __C_BASIC_MMDP__
#define __C_BASIC_MMDP__

#include <ruby.h>

// Espacio para el modulo MMDP
VALUE module_mmdp = Qnil;

// Espacio para la clase BasicMMDP
VALUE class_mmdp = Qnil;

// Inicializa la clase
void Init_c_basic_mmdp();

/*
Devuelve la distancia o coste entre dos nodos.
Si no encuentra los nodos, devolvera cero.

Recibe como parametros el nodo origen y el nodo
destino
*/
VALUE method_obtener_coste_entre(VALUE self, VALUE origen, VALUE destino);

#endif
