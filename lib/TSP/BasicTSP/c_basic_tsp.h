#ifndef __BASIC_TSP_C__
#define __BASIC_TSP_C__

// Espacio para el modulo TSP y la clase BasicTSP
VALUE module_tsp;
VALUE class_basic_tsp;

//Methods
VALUE method_btsp_each(VALUE self);
VALUE method_btsp_accesor(VALUE self, VALUE index);
VALUE method_btsp_coste_solucion(VALUE self, VALUE ciudades);
void Init_c_basic_tsp();

#endif