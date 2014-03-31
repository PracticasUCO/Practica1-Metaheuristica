#include "c_mmdp.h"

/*
Devuelve la diferencia entre dos arrays
*/
VALUE method_ary_diff(VALUE ary1, VALUE ary2)
{
	VALUE solution = rb_ary_new();
	int i; //Auxiliar

	for(i = 0; i < RARRAY_LEN(ary1); i++)
	{
		VALUE item = rb_ary_entry(ary1, i);

		if(!rb_ary_includes(ary2, item))
		{
			rb_ary_push(solution, item);
		}
	}

	return solution;
}


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
														VALUE nodo_eliminar, VALUE new_node)
{
	VALUE particion_eliminar;
	VALUE coste_nodo_eliminado;
	VALUE coste_nuevo_nodo;
	VALUE vector_auxiliar;
	VALUE coste_final;
	
	// Aquí van a ir todas las comprobaciones
		// solucion_actual debe ser un array --> Ok
		// coste_actual debe ser un numero --> Not yet
		// nodo_eliminar debe de estar en la solucion --> Not yet
		// new_ndde debe de estar en la lista de nodos de la solucion --> Not yet
	solucion_actual = rb_check_array_type(solucion_actual);

	// Algoritmo
	particion_eliminar = rb_ary_new();
	rb_ary_push(particion_eliminar, nodo_eliminar);

	vector_auxiliar = method_ary_diff(solucion_actual, particion_eliminar);
	coste_nuevo_nodo = method_merge_diversidad_minima(self, vector_auxiliar, new_node);
	coste_nodo_eliminado = method_merge_diversidad_minima(self, vector_auxiliar, nodo_eliminar);

	coste_final = DBL2NUM(NUM2DBL(coste_actual) - NUM2DBL(coste_nodo_eliminado) + NUM2DBL(coste_nuevo_nodo));

	return coste_final;
}

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
VALUE method_busqueda_local_first_improvement(VALUE self, VALUE solucion, VALUE coste_solucion, VALUE limite)
{
	VALUE nodos_lista; //Copia de lista_nodos
	VALUE nuevo_coste;
	VALUE origen;
	VALUE destino;
   int i, j; //Auxiliares
	int limite_inicio = 0;
	int salir_interno = 0; //Si se termina la ejecucion del bucle se pone a uno
	int salir_externo = 0;

	//Aquí va la comprobacion de variables
		//Solucion debe de ser un array --> Ok
		//Coste_solucion debe de ser un valor numerico --> Not yet
		//limite debe de ser un entero --> Not yet
	solucion = rb_check_array_type(solucion);

	nodos_lista = rb_iv_get(self, "@lista_nodos");
	nodos_lista = rb_ary_dup(nodos_lista);

	while((salir_externo == 0) && (limite_inicio < NUM2INT(limite)))
	{
		limite_inicio++;
		salir_interno = 0;

		for(i = 0; ((i < RARRAY_LEN(solucion)) && (salir_interno == 0)); i++)
		{
			origen = rb_ary_entry(solucion, i);

			for(j = 0; ((j < RARRAY_LEN(nodos_lista)) && (salir_interno == 0)); j++)
			{
				destino = rb_ary_entry(nodos_lista, j);

				nuevo_coste = method_obtener_diferencia_soluciones(self, solucion, coste_solucion, origen, destino);

				if(NUM2DBL(nuevo_coste) > NUM2DBL(coste_solucion))
				{
					coste_solucion = nuevo_coste;
					rb_ary_delete(solucion, origen);
					rb_ary_push(solucion, destino);
					salir_interno = 1;
					break;
				}
				

				if(j == RARRAY_LEN(nodos_lista) - 1)
				{
					salir_externo = 1;
					break;
				}
			}
		}
	}

	return solucion;
}


void Init_c_mmdp()
{
	module_mmdp = rb_define_module("MMDP");
	class_mmdp = rb_define_class_under(module_mmdp, "MMDP", class_basic_mmdp);
	rb_define_method(class_mmdp, "obtener_diferencia_soluciones", method_obtener_diferencia_soluciones, 4);
	rb_define_method(class_mmdp, "busqueda_local_first_improvement", method_busqueda_local_first_improvement, 3);
}