#include <ruby.h>
#include <stdlib.h>
#include "c_phub.h"

/*
Genera un valor aleatorio entre 0 y 1
*/
VALUE random_number(VALUE self)
{
	//double random_number = drand48();
	return random_f_rand(0, Qnil, rb_cObject);
	//return DBL2NUM(random_number);
}

/*
Separa los nodos concentradores de una solución de los nodos
que actúan como clientes. Se devuelven en dos vectores el primero
con los nodos concentradores y el segundo con los nodos cliente.
*/
VALUE separar_nodos(VALUE self, VALUE solucion)
{
	VALUE concentradores;
	VALUE clientes;
	VALUE empaquetado;
	VALUE sym_concentrador = ID2SYM(rb_intern("concentrador"));
	int i; //Auxiliar
	
	concentradores = rb_ary_new();
	clientes = rb_ary_new();
	empaquetado = rb_ary_new();
	
	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		VALUE item = rb_ary_entry(solucion, i);
		VALUE tipo = rb_funcall(item, rb_intern("tipo"), 0);
		
		if(tipo == sym_concentrador)
		{
			rb_ary_push(concentradores, item);
		}
		else
		{
			rb_ary_push(clientes, item);
		}
	}
	
	rb_ary_push(empaquetado, concentradores);
	rb_ary_push(empaquetado, clientes);
	
	return empaquetado;
}

/*
Realiza una selección de n_elementos de una serie de soluciones mediante torneo.
Recibe como argumentos:
- lista_soluciones: Un vector con todas las soluciones por las que debatirse
- fitness_soluciones: Una tabla de hash que contiene el coste de cada una de las soluciones
- n_elementos: Numero de elementos a elegir

Si n_elementos en más pequeño que el número de elementos que hay en la lista_soluciones el
método devolverá false.

Este método devuelve un conjunto de individuos de la lista de soluciones seleccionados al azar
mediante torneo, con la particularidad de que el conjunto devuelto no tiene elementos repetidos.

Esto significa que si se trata de obtener un conjunto de individuos mediante torneo igual al
conjunto de individuos de la lista_soluciones proporcionada el resultado final sera igual
a la lista_soluciones proporcionada.
*/
VALUE operador_seleccion_torneo(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos)
{
	VALUE lista_seleccionados;

	lista_soluciones = rb_check_array(lista_soluciones);
	fitness_soluciones = rb_check_hash(fitness_soluciones);
	
	if(TYPE(n_elementos) != T_FIXNUM)
	{
		rb_raise(rb_eTypeError, "n_elementos debe de ser un número entero.\n");
	}
	
	lista_seleccionados = rb_ary_new();

	if(RARRAY_LEN(lista_soluciones) > NUM2INT(n_elementos))
	{
		VALUE indice_loco;
		VALUE numeros_disponibles = rb_ary_new();
		int cuenta = NUM2INT(n_elementos);
		int i;
		
		//Inicialización del vector de números disponibles
		for(i = 0; i < RARRAY_LEN(lista_soluciones); i++)
		{
			rb_ary_push(numeros_disponibles, INT2NUM(i));
		}
		
		// Inicio de la selección de individuos
		while(cuenta > 0)
		{
			VALUE indice_ganador;
			
			VALUE competidor_a;
			VALUE fitness_a;
			VALUE indice_a;
			
			VALUE competidor_b;
			VALUE fitness_b;
			VALUE indice_b;
			
			cuenta--;
			
			//Selección del primer individuo al azar
			indice_loco = rb_f_rand(1, INT2NUM(RARRAY_LEN(numeros_disponibles)), rb_cObject);
			indice_loco = rb_ary_entry(numeros_disponibles, NUM2INT(indice_loco));
			indice_a = indice_loco;
			rb_ary_delete(numeros_disponibles, indice_loco);
			
			//Selección del segundo individuo al azar
			indice_loco = rb_f_rand(1, INT2NUM(RARRAY_LEN(numeros_disponibles)), rb_cObject);
			indice_loco = rb_ary_entry(numeros_disponibles, NUM2INT(indice_loco));
			indice_b = indice_loco;
			rb_ary_delete(numeros_disponibles, indice_loco);
			
			//Carga del competidor A
			competidor_a = rb_ary_entry(lista_soluciones, NUM2INT(indice_a));
			fitness_a = rb_hash_aref(fitness_soluciones, competidor_a);
			
			//Carga del competidor B
			competidor_b = rb_ary_entry(lista_soluciones, NUM2INT(indice_b));
			fitness_b = rb_hash_aref(fitness_soluciones, competidor_b);
			
			//Comprobando que el fitness sea correcto para A y B
			if((TYPE(fitness_a) != T_FLOAT) && (TYPE(fitness_a) != T_FIXNUM))
			{
				rb_raise(rb_eTypeError, "Se hallo un fitness no numérico.\n");
			}
			
			if((TYPE(fitness_b) != T_FLOAT) && (TYPE(fitness_b) != T_FIXNUM))
			{
				rb_raise(rb_eTypeError, "Se hallo un fitness no numérico.\n");
			}
			
			//Torneo entre las dos soluciones
			if(NUM2DBL(fitness_a) <= NUM2DBL(fitness_b))
			{
				rb_ary_push(lista_seleccionados, competidor_a);
				rb_ary_push(numeros_disponibles, indice_b);
			}
			else
			{
				rb_ary_push(lista_seleccionados, competidor_b);
				rb_ary_push(numeros_disponibles, indice_a);
			}
		}
	}
	else if(RARRAY_LEN(lista_soluciones) == NUM2INT(n_elementos))
	{
		int i;
		for(i = 0; i < RARRAY_LEN(lista_soluciones); i++)
		{
			VALUE item = rb_ary_entry(lista_soluciones, i);
			rb_ary_push(lista_seleccionados, item);
		}
	}
	else
	{
		//No se puede realizar un torneo de ningún tipo por lo
		//que se devuelve Qfalse
		return Qfalse;
	}
	
	return lista_seleccionados;
}

void Init_c_phub()
{
	phub_module = rb_define_module("PHUB");
	class_phub = rb_define_class_under(phub_module, "PHUB", CBasicPHub);
	rb_define_private_method(class_phub, "random_number", random_number, 0);
	rb_define_private_method(class_phub, "separar_nodos", separar_nodos, 1);
	rb_define_private_method(class_phub, "torneo", operador_seleccion_torneo, 3);
}
