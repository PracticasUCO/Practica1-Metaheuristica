#ifndef __C_BASIC_PHUB_NODE__
#define __C_BASIC_PHUB_NODE__

#include <ruby.h>

// Defining a space for information and references about the module to be stored internally
VALUE CBasicPHubNode = Qnil;

// Prototype for our method 'distancia' - methods are prefixed by 'method_' here
VALUE method_distancia(VALUE self, VALUE vecino);

// Prototipo para el metodo CapacitedPHubNode#se_puede_conectar?
VALUE method_se_puede_conectar(VALUE self, VALUE otro);

// Prototipo para el metodo CapacitedPHubNode#esta_conectado?
VALUE method_esta_conectado(VALUE self);

// Prototipo para el  metodo CapacitedPHubNode#conectar_a=
VALUE method_conectar_a(VALUE self, VALUE otro);

void Init_c_basic_capacited_phub_node();
#endif