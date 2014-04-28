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
VALUE phub_set_historical_connections(VALUE self, VALUE solucion, VALUE historical);
VALUE desconectar_solucion(VALUE self, VALUE solucion);
VALUE phub_set_random_connections(VALUE self, VALUE solucion);
VALUE phub_merge(VALUE self, VALUE solucion_a, VALUE solucion_b);
VALUE phub_mezclar_concentradores(VALUE self, VALUE solucion_a, VALUE solucion_b);
VALUE phub_evaluar_conjunto_soluciones(VALUE self, VALUE conjunto_soluciones);
VALUE phub_get_nodes(VALUE self, VALUE solucion);
VALUE phub_add_clients(VALUE self, VALUE solucion);
VALUE phub_convertir_a_concentradores(VALUE self, VALUE ary);
VALUE phub_get_coordenadas(VALUE self, VALUE solucion);
VALUE phub_diferencia_soluciones(VALUE self, VALUE solucionA, VALUE solucionB);
VALUE phub_convertir_a_clientes(VALUE self, VALUE solucion);
