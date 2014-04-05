#include "c_mmdp.h"
#include "../../ES/ES/ES.h"
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
VALUE method_mejora_solucion(VALUE self, VALUE solucion_actual, VALUE nodo_eliminar, VALUE new_node)
{
	VALUE coste_nuevo_nodo;
	VALUE vector_auxiliar;
	VALUE coste_nodo_eliminar;
	
	// Aquí van a ir todas las comprobaciones
		// solucion_actual debe ser un array --> Ok
		// coste_actual debe ser un numero --> Not yet
		// nodo_eliminar debe de estar en la solucion --> Not yet
		// new_node debe de estar en la lista de nodos de la solucion --> Not yet
	solucion_actual = rb_check_array_type(solucion_actual);
	// Algoritmo
	
	vector_auxiliar = rb_ary_dup(solucion_actual);
	rb_ary_delete(vector_auxiliar, nodo_eliminar);
	coste_nuevo_nodo = method_diversidad_minima_parcial(self, vector_auxiliar, new_node);
	coste_nodo_eliminar = method_diversidad_minima_parcial(self, vector_auxiliar, nodo_eliminar);

	if(NUM2DBL(coste_nuevo_nodo) > NUM2DBL(coste_nodo_eliminar))
	{
		return Qtrue;
	}
	else
	{
		return Qfalse;
	}
}

/*
Devuelve cuanto de más prometedora es un cambio en una solucion
*/
VALUE method_grado_mejora_solucion(VALUE self, VALUE solucion_actual, VALUE nodo_eliminar, VALUE new_node)
{
	VALUE coste_nuevo_nodo;
	VALUE vector_auxiliar;
	VALUE coste_nodo_eliminar;
	VALUE resultado;
	
	// Aquí van a ir todas las comprobaciones
		// solucion_actual debe ser un array --> Ok
		// coste_actual debe ser un numero --> Not yet
		// nodo_eliminar debe de estar en la solucion --> Not yet
		// new_node debe de estar en la lista de nodos de la solucion --> Not yet
	solucion_actual = rb_check_array_type(solucion_actual);
	// Algoritmo
	
	vector_auxiliar = rb_ary_dup(solucion_actual);
	rb_ary_delete(vector_auxiliar, nodo_eliminar);
	coste_nuevo_nodo = method_diversidad_minima_parcial(self, vector_auxiliar, new_node);
	coste_nodo_eliminar = method_diversidad_minima_parcial(self, vector_auxiliar, nodo_eliminar);

	resultado = DBL2NUM(NUM2DBL(coste_nuevo_nodo) - NUM2DBL(coste_nodo_eliminar));

	return resultado;
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
	VALUE hash_inclusion; //Indica que valores estan en la solucion y cuales no
	VALUE empaquetado; //Se trata de un Array con la solucion final y su coste
   int i, j; //Auxiliares
	int limite_inicio = 0;
	int salir_externo = 0;
	int limite_busqueda; // Indica cuando se ha terminado de observar la solucion actual

	//Aquí va la comprobacion de variables
		//Solucion debe de ser un array --> Ok
		//Coste_solucion debe de ser un valor numerico --> Not yet
		//limite debe de ser un entero --> Not yet
	solucion = rb_check_array_type(solucion);

	nodos_lista = rb_iv_get(self, "@lista_nodos");
	nodos_lista = rb_ary_dup(nodos_lista);
	hash_inclusion = rb_hash_new();
	limite_busqueda = 3 * RARRAY_LEN(solucion);
	empaquetado = rb_ary_new();

	for(i = 0; i < RARRAY_LEN(nodos_lista); i++)
	{
		VALUE item = rb_ary_entry(nodos_lista, i);

		if(rb_ary_includes(solucion, item))
		{
			rb_hash_aset(hash_inclusion, item, Qtrue);
		}
		else
		{
			rb_hash_aset(hash_inclusion, item, Qfalse);
		}
	}

	while((NUM2INT(limite) > limite_inicio) && (salir_externo == 0) && (limite_busqueda > 0))
	{
		for(i = 0; ((i < RARRAY_LEN(solucion)) && (NUM2INT(limite) > limite_inicio) && (limite_busqueda > 0)); i++, limite_busqueda--)
		{
			VALUE item = rb_ary_entry(solucion, i);

			for(j = 0; ((j < RARRAY_LEN(nodos_lista)) && (NUM2INT(limite) > limite_inicio)); j++)
			{
				VALUE nodo_alternativo = rb_ary_entry(nodos_lista, j);

				if((rb_hash_aref(hash_inclusion, nodo_alternativo) == Qtrue) || (rb_hash_aref(hash_inclusion, item) == Qfalse))
				{
					continue;
				}
				//limite_inicio++;

				if(method_mejora_solucion(self, solucion, item, nodo_alternativo) == Qtrue)
				{
					i--; //Necesario para tener en cuenta otras soluciones
					rb_ary_delete(solucion, item);
					rb_ary_push(solucion, nodo_alternativo);
					rb_hash_aset(hash_inclusion, item, Qfalse);
					rb_hash_aset(hash_inclusion, nodo_alternativo, Qtrue);
					break;
				}

			}
		}
	}

	rb_ary_push(empaquetado, solucion);
	rb_ary_push(empaquetado, method_diversidad_minima(self, solucion));

	return empaquetado;
}

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
VALUE method_busqueda_local_best_improvement(VALUE self, VALUE solucion, VALUE coste_actual, VALUE limite)
{
	VALUE alternativa;
	VALUE nodos_lista;
	VALUE hash_inclusion;
	VALUE mejor_solucion;
	VALUE hash_mejor_solucion;
	VALUE coste_mejor_solucion;
	int i, j;
	int limite_inicio = 0;
	int bandera_mejor_solucion = 0;
	VALUE empaquetado; // Array que contendra la solucion y el coste para devolverlo

	solucion = rb_check_array_type(solucion);

	alternativa = rb_ary_dup(solucion);
	hash_inclusion = rb_hash_new();
	empaquetado = rb_ary_new();

	nodos_lista = rb_iv_get(self, "@lista_nodos");
	nodos_lista = rb_ary_dup(nodos_lista);

	for(i = 0; i < RARRAY_LEN(nodos_lista); i++)
	{
		VALUE item = rb_ary_entry(nodos_lista, i);

		if(rb_ary_includes(alternativa, item))
		{
			rb_hash_aset(hash_inclusion, item, Qtrue);
		}
		else
		{
			rb_hash_aset(hash_inclusion, item, Qfalse);
		}
	}

	for(i = 0; ((i < RARRAY_LEN(solucion)) && (NUM2INT(limite) > limite_inicio)); i++)
	{
		VALUE item = rb_ary_entry(solucion, i);

		for(j = 0; ((j < RARRAY_LEN(nodos_lista)) && (NUM2INT(limite) > limite_inicio)); j++)
		{
			VALUE nodo_alternativo = rb_ary_entry(nodos_lista, j);

			if((rb_hash_aref(hash_inclusion, item) == Qfalse) || (rb_hash_aref(hash_inclusion, nodo_alternativo) == Qtrue))
			{
				continue;
			}

			if(method_mejora_solucion(self, alternativa, item, nodo_alternativo) == Qtrue)
			{
				VALUE hash_alternativa;
				alternativa = rb_ary_dup(solucion);
				hash_alternativa = rb_hash_dup(hash_inclusion);

				rb_ary_delete(alternativa, item);
				rb_ary_push(alternativa, nodo_alternativo);
				rb_hash_aset(hash_alternativa, item, Qfalse);
				rb_hash_aset(hash_alternativa, nodo_alternativo, Qtrue);


				if(bandera_mejor_solucion == 0)
				{
					bandera_mejor_solucion = 1;
					hash_mejor_solucion = hash_alternativa;
					mejor_solucion = alternativa;
					coste_mejor_solucion = method_grado_mejora_solucion(self, solucion, item, nodo_alternativo);
				}
				else
				{
					VALUE coste_alternativa = method_grado_mejora_solucion(self, solucion, item, nodo_alternativo);
					
					if(NUM2DBL(coste_alternativa) > NUM2DBL(coste_mejor_solucion))
					{
						hash_mejor_solucion = hash_alternativa;
						mejor_solucion = alternativa;
						coste_mejor_solucion = coste_alternativa;
					}
				}
			}
		}

		if(bandera_mejor_solucion == 1)
		{
			solucion = rb_ary_dup(mejor_solucion);
			hash_inclusion = rb_hash_dup(hash_mejor_solucion);
			bandera_mejor_solucion = 0;
		}
	}

	rb_ary_push(empaquetado, solucion);
	rb_ary_push(empaquetado, method_diversidad_minima(self, solucion));

	return empaquetado;
}



void Init_c_mmdp()
{
	module_mmdp = rb_define_module("MMDP");
	class_mmdp = rb_define_class_under(module_mmdp, "MMDP", class_basic_mmdp);
	rb_define_method(class_mmdp, "mejora_solucion", method_mejora_solucion, 3);
	rb_define_method(class_mmdp, "grado_mejora_solucion", method_grado_mejora_solucion, 3);
	rb_define_method(class_mmdp, "busqueda_local_first_improvement", method_busqueda_local_first_improvement, 3);
	rb_define_method(class_mmdp, "busqueda_local_best_improvement", method_busqueda_local_best_improvement, 3);
}