#ifndef __TSP_C__
#define __TSP_C__

#include <ruby.h>
#include "../BasicTSP/c_basic_tsp.h" //Esto habra que cambiarlo

VALUE class_tsp;
void Init_c_tsp();

// Methods
VALUE method_tsp_grado_mejora_solucion(VALUE self, VALUE solucion, VALUE nodo_a, VALUE nodo_b);
VALUE method_tsp_opt(VALUE self, VALUE solucion, VALUE nodo_a, VALUE nodo_b);
VALUE method_tsp_busqueda_local_first_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite);
VALUE method_tsp_busqueda_local_best_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite);
VALUE method_tsp_entorno(VALUE self, VALUE ary, VALUE index);

#endif