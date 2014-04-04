#ifndef __C_ENFRIAMIENTO_SIMULADO__
#define __C_ENFRIAMIENTO_SIMULADO__

#include <ruby.h>

// Constructor de la clase ES
void Init_ES();

// Modulo ES
VALUE module_es = Qnil;

// Clase ES
VALUE class_es = Qnil;

VALUE method_es_initialize(VALUE self, VALUE temperatura, VALUE coeficiente);
VALUE method_temperatura(VALUE self);
VALUE method_probabilidad(VALUE self);
VALUE method_enfriar(VALUE self);
VALUE method_coeficiente(VALUE self);
VALUE method_reset(VALUE self);

#endif