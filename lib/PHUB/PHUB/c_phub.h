#include <ruby.h>
#include "../phub.h"
#include "../CapacitedPHubNode/c_basic_phub_node.h"
#include "../BasicPHub/c_basic_phub.h"

// Clase PHUB
VALUE class_phub = Qnil;

//Metodos
VALUE random_number(VALUE self);
VALUE separar_nodos(VALUE self, VALUE solucion);
VALUE operador_seleccion_torneo(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_selecciones);
VALUE operador_seleccion_ruleta(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_selecciones);
VALUE operador_seleccion(VALUE self, VALUE id_seleccion, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_selecciones);
VALUE operador_cruce(VALUE self, VALUE solucion_a, VALUE solucion_b);
VALUE operador_mutacion(VALUE self, VALUE solucion);
