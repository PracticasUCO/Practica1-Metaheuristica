#ifndef __C_BASIC_MMDP__
#define __C_BASIC_MMDP__

#include <ruby.h>

// Espacio para el modulo MMDP
VALUE module_mmdp = Qnil;

// Espacio para la clase BasicMMDP
VALUE class_basic_mmdp = Qnil;

// Inicializa la clase
void Init_c_basic_mmdp();

/*
Devuelve la distancia o coste entre dos nodos.
Si no encuentra los nodos, devolvera cero.

Recibe como parametros el nodo origen y el nodo
destino
*/
VALUE method_obtener_coste_entre(VALUE self, VALUE origen, VALUE destino);

/*
Este metodo devuelve la diversidad minima que existe en una solucion
*/
VALUE method_diversidad_minima(VALUE self, VALUE solucion);

/*
Este metodo devuelve la diversidad minima que existiria en una solucion
si se añadiese un nuevo nodo */
VALUE method_merge_diversidad_minima(VALUE self, VALUE solucion, VALUE nuevo_nodo);

/*
funcion_objetivo es un sinonimo de diversidad minima
*/
VALUE method_funcion_objetivo(VALUE self, VALUE solucion);

#endif
