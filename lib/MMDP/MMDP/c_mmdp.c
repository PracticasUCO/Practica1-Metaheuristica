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

	return DBL2NUM(NUM2DBL(coste_actual) - NUM2DBL(coste_nodo_eliminado) + NUM2DBL(coste_nuevo_nodo));
}


void Init_mmdp()
{
	if(module_mmdp == Qnil)
	{
		module_mmdp = rb_define_module("MMDP");
	}

	class_mmdp = rb_define_class_under(module_mmdp, "MMDP", class_basic_mmdp);
	rb_define_method(class_mmdp, "obtener_diferencia_soluciones", method_obtener_diferencia_soluciones, 4);
}