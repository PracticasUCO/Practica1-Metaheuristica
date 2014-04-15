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
Si no encuentra los nodos, devolverá cero.

Recibe como parámetros el nodo origen y el nodo
destino
*/
VALUE method_obtener_coste_entre(VALUE self, VALUE origen, VALUE destino);

/*
Este método devuelve la diversidad mínima que existe en una solución
*/
VALUE method_diversidad_minima(VALUE self, VALUE solucion);

/*
Este método devuelve la diversidad mínima que existiría en una solución
si se añadiese un nuevo nodo */
VALUE method_merge_diversidad_minima(VALUE self, VALUE solucion, VALUE nuevo_nodo);

/*
Este método devuelve la diversidad mínima que aportaría un nodo
a una solución se se añadiese
*/
VALUE method_diversidad_minima_parcial(VALUE self, VALUE solucion, VALUE nuevo_nodo);

/*
funcion_objetivo es un sinónimo de diversidad mínima
*/
VALUE method_funcion_objetivo(VALUE self, VALUE solucion);

#endif
