#ifndef __C_MMDP__
#define __C_MMDP__

#include <ruby.h>
#include "../BasicMMDP/c_basic_mmdp.h"

// Inicializador de la clase
void Init_c_mmdp();

// Espacio para la clase MMDP
VALUE class_mmdp;

/*
Este metodo calcula la diferencia entre la solucion actual y otra solucion
obtenida como resultado de eliminar un nodo y añadir otro

Los parametros de esta funcion son:
	- solucion_actual: pasa como argumento la solucion actual
	- coste_actual: pasa como argumento el coste actual
	- nodo_eliminar: pasa como argumento el nodo que se borrara de la solucion,
 	  si el nodo no pertenece a la solucion se lanzara una excepcion TypeError
	- new_node: el nodo nuevo que va a entrar en la solucion
*/
VALUE method_obtener_diferencia_soluciones(VALUE self, VALUE solucion_actual, VALUE coste_actual, 
														VALUE nodo_eliminar, VALUE new_node);

/*
Devuelve la diferencia entre dos arrays
*/
VALUE method_ary_diff(VALUE ary1, VALUE ary2);

#endif