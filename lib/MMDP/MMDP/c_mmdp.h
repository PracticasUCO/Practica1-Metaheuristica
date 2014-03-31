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
Realiza una busqueda local a partir de una solucion aleatoria
utilizando un algoritmo de escalada basado en 
la tecnica de "first improvement", es decir, se acepta
la primera mejora conseguida y se continua de tratar
de mejorar a partir de ese punto. Se reciben tres
parametros que son:
	- solucion generada de forma aleatoria
	- coste_solucion generada de forma aleatoria
*/
VALUE method_busqueda_local_first_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite);

/*
Realiza una busqueda local para tratar de mejorar lo maximo posible el
vector solucion

Recibe como parametros el array con la soluciones escogidas y
Devuelve un vector solucion optimizado
 
Este metodo sigue un algoritmo de busqueda local mediante la tecnica
de best improvement, optimizado mediante un parametro de corte para
no llegar a explorar todas las soluciones vecinas.

El metodo de parada es cuando se hayan explorado más soluciones que
solution_nodes / @punto_ruptura

@punto_ruptura usualmente se configura a log2(solution_nodes)

Como parametros recibe el vector solución a mejorar y el coste
de dicho vector
*/
VALUE method_busqueda_local_best_improvement(VALUE self, VALUE solucion, VALUE coste_actual, VALUE limite);

/*
Devuelve la diferencia entre dos arrays
*/
VALUE method_ary_diff(VALUE ary1, VALUE ary2);

#endif