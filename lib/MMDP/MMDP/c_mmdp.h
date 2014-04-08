#ifndef __C_MMDP__
#define __C_MMDP__

#include <ruby.h>
#include "../BasicMMDP/c_basic_mmdp.h"

// Inicializador de la clase
void Init_c_mmdp();

// Espacio para la clase MMDP
VALUE class_mmdp;

VALUE method_mejora_solucion(VALUE self, VALUE solucion_actual, VALUE nodo_eliminar, VALUE new_node);
VALUE method_grado_mejora_solucion(VALUE self, VALUE solucion_actual, VALUE nodo_eliminar, VALUE new_node);
VALUE method_busqueda_local_first_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite);
VALUE method_busqueda_local_best_improvement(VALUE self, VALUE solucion, VALUE coste_actual, VALUE limite);
VALUE method_busqueda_local_enfriamiento_simulado(VALUE self, VALUE solucion, VALUE coste_actual, VALUE es,
																	VALUE temperatura_minima);
VALUE method_ary_diff(VALUE ary1, VALUE ary2);

#endif