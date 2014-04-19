#include <ruby.h>
#include "../phub.h"
#include "../CapacitedPHubNode/c_basic_phub_node.h"
#include "../BasicPHub/c_basic_phub.h"

// Clase PHUB
VALUE class_phub = Qnil;

//Metodos
VALUE phub_random_number(VALUE self);
VALUE phub_separar_nodos(VALUE self, VALUE solucion);
VALUE phub_operador_seleccion_torneo(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos);
VALUE phub_operador_seleccion_torneo_injusto(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos);
VALUE phub_operador_seleccion_ruleta(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos);
VALUE phub_operador_seleccion(VALUE self, VALUE sym_seleccion, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos);
VALUE phub_operador_cruce(VALUE self, VALUE solucion_a, VALUE solucion_b);
VALUE phub_operador_mutacion(VALUE self, VALUE solucion);

//Auxiliares
VALUE phub_get_connections(VALUE self, VALUE solucion);
VALUE phub_get_types(VALUE self, VALUE solucion);
VALUE phub_set_historical_connections(VALUE self, VALUE solucion, VALUE historical, VALUE concentradores);
VALUE phub_set_random_connections(VALUE self, VALUE solucion);
