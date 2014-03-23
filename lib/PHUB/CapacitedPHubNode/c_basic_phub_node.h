#ifndef __C_BASIC_PHUB_NODE__
#define __C_BASIC_PHUB_NODE__

#include <ruby.h>

// Defining a space for information and references about the module to be stored internally
VALUE CBasicPHubNode = Qnil;

/*
	Este metodo devuelve la distancia euclidea entre dos nodos CapacitedPHubNode
*/
VALUE method_distancia(VALUE self, VALUE vecino);

/*
Devuelve true cuando se pude realizar la conexion entre dos nodos y false en
caso contrario.

Se puede realizar la conexion entre dos nodos cuando uno de ellos esta actuando como
concentrador y el otro como cliente, y además, la demanda del que actua como cliente
es inferior o igual a la reserva del concentrador.
*/
VALUE method_se_puede_conectar(VALUE self, VALUE otro);

/*
Devuelve true cuando el nodo esta conectado a otro nodo y false en caso contrario
*/
VALUE method_esta_conectado(VALUE self);

/*
Realiza la conexion entre dos nodos. No se comprueba si se llega o no a saturar a
otro nodo. Si no se puede realizar la conexion (por ejemplo por que uno de los extremos
no sea un CapacitedPHubNode se lanzara una excepción de tipo TypeError)
*/
VALUE method_conectar_a(VALUE self, VALUE otro);

void Init_c_basic_capacited_phub_node();
#endif