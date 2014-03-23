#ifndef __C_BASIC_PHUB__
#define __C_BASIC_PHUB__

#include <ruby.h>
#include "../phub.h"
#include "../CapacitedPHubNode/c_basic_phub_node.h"

// Clase BasicPHub
VALUE CBasicPHub = Qnil;

/*
 * funcion_objetivo devuelve la suma de las distancias de todos
 * los nodos clientes al concentrador al que están conectados.
 */
VALUE rb_funcion_objetivo(VALUE self, VALUE solucion);

void Init_c_basic_phub();

#endif