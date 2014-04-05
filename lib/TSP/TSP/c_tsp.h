#ifndef __TSP_C__
#define __TSP_C__

#include <ruby.h>
#include "../BasicTSP/c_basic_tsp.h" //Esto habra que cambiarlo

VALUE class_tsp;
void Init_c_tsp();

// Methods
VALUE method_tsp_initialize(VALUE self, VALUE path);
#endif