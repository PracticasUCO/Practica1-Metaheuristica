#ifndef __LOCAL_SEARCH_SYMBOLS
#define __LOCAL_SEARCH_SYMBOLS
// Global Syms
VALUE symbol_first_improvement = ID2SYM(rb_intern("first_improvemnt"));
VALUE symbol_best_improvement = ID2SYM(rb_intern("best_improvement"));
VALUE symbol_enfriamiento_simulado = ID2SYM(rb_intern("enfriamiento_simulado"));
#endif

#ifndef __TSP_C__
#define __TSP_C__

#include <ruby.h>
#include "../BasicTSP/c_basic_tsp.h" //Esto habra que cambiarlo

VALUE class_tsp;
void Init_c_tsp();

// Methods
VALUE method_tsp_mejora_solucion(VALUE self, VALUE solucion_a, VALUE costeA, VALUE nodo_a, VALUE nodo_b);
VALUE method_tsp_busqueda_local_first_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite);
VALUE method_tsp_busqueda_local_best_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite);
VALUE method_tsp_busqueda_local(VALUE self);

#endif