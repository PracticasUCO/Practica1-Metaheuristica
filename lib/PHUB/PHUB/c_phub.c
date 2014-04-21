#include <ruby.h>
#include <stdlib.h>
#include <stdio.h>
#include "c_phub.h"
#include "../CapacitedPHubNode/c_basic_phub_node.h"

/*
Genera un valor aleatorio entre 0 y 1
*/
VALUE phub_random_number(VALUE self)
{
	return DBL2NUM(rb_genrand_real());
}

/*
Separa los nodos concentradores de una solución de los nodos
que actúan como clientes. Se devuelven en dos vectores el primero
con los nodos concentradores y el segundo con los nodos cliente.
*/
VALUE phub_separar_nodos(VALUE self, VALUE solucion)
{
	VALUE concentradores;
	VALUE clientes;
	VALUE empaquetado;
	VALUE sym_concentrador = ID2SYM(rb_intern("concentrador"));
	int i; //Auxiliar
	
	Check_Type(solucion, T_ARRAY);
	
	if(RARRAY_LEN(solucion) == 0)
	{
		rb_raise(rb_eTypeError, "No se puede procesar una solución vacía.\n");
	}
	
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
método ejecutara un torneo injusto a través del cual puede ser que aparezcan individuos
repetidos.

Este método devuelve un conjunto de individuos de la lista de soluciones seleccionados al azar
mediante torneo, con la particularidad de que el conjunto devuelto no tiene elementos repetidos.

Esto significa que si se trata de obtener un conjunto de individuos mediante torneo igual al
conjunto de individuos de la lista_soluciones proporcionada el resultado final sera igual
a la lista_soluciones proporcionada.
*/
VALUE phub_operador_seleccion_torneo(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos)
{
	VALUE lista_seleccionados;

	Check_Type(lista_soluciones, T_ARRAY);
	Check_Type(fitness_soluciones, T_HASH);
	
	if(TYPE(n_elementos) != T_FIXNUM)
	{
		rb_raise(rb_eTypeError, "n_elementos debe de ser un número entero.\n");
	}
	
	if(RARRAY_LEN(lista_soluciones) == 0)
	{
		rb_raise(rb_eTypeError, "No hay elementos sobre los cuales hacer un torneo.\n");
	}
	
	lista_seleccionados = rb_ary_new();

	if(RARRAY_LEN(lista_soluciones) > NUM2INT(n_elementos))
	{
		int indice_loco;
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
			VALUE competidor_a;
			VALUE fitness_a;
			int indice_a;
			
			VALUE competidor_b;
			VALUE fitness_b;
			int indice_b;
			int individuo;
			
			cuenta--;
			
			//Selección del primer individuo al azar
			indice_loco = rb_genrand_ulong_limited(RARRAY_LEN(numeros_disponibles) - 1);
			individuo = NUM2INT(rb_ary_entry(numeros_disponibles, indice_loco));
			indice_a = individuo;
			rb_ary_delete(numeros_disponibles, INT2NUM(individuo));
			
			//Selección del segundo individuo al azar
			indice_loco = rb_genrand_ulong_limited(RARRAY_LEN(numeros_disponibles) - 1);
			individuo = NUM2INT(rb_ary_entry(numeros_disponibles, indice_loco));
			indice_b = individuo;
			rb_ary_delete(numeros_disponibles, INT2NUM(individuo));
			
			//Carga del competidor A
			competidor_a = rb_ary_entry(lista_soluciones, indice_a);
			fitness_a = rb_hash_aref(fitness_soluciones, competidor_a);
			
			//Carga del competidor B		
			competidor_b = rb_ary_entry(lista_soluciones, indice_b);
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
				rb_ary_push(numeros_disponibles, INT2NUM(indice_b));
			}
			else
			{
				rb_ary_push(lista_seleccionados, competidor_b);
				rb_ary_push(numeros_disponibles, INT2NUM(indice_a));
			}
		}
	}
	else if(RARRAY_LEN(lista_soluciones) == NUM2INT(n_elementos))
	{
		lista_seleccionados = rb_ary_dup(lista_soluciones);
	}
	else
	{
		//No se aplican las reglas de torneo convencionales ya que no hay
		//suficientes individuos
		return phub_operador_seleccion_torneo_injusto(self, lista_soluciones, fitness_soluciones, n_elementos);
	}
	
	return lista_seleccionados;
}

/*
Realiza un torneo entre lista_soluciones para seleccionar a n_elementos de forma al azar. El resultado puede
incluir a la misma solución varias veces.

Recibe como argumentos:
- lista_soluciones: Un vector con todas las soluciones por las que debatirse
- fitness_soluciones: Una tabla de hash que contiene el coste de cada una de las soluciones
- n_elementos: Numero de elementos a elegir
*/
VALUE phub_operador_seleccion_torneo_injusto(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos)
{
	VALUE lista_seleccionados;
	VALUE indice_loco;
	int i; //Auxiliar
	
	/*lista_soluciones = rb_check_array_type(lista_soluciones);	
	fitness_soluciones = rb_check_hash_type(fitness_soluciones);*/
	Check_Type(lista_soluciones, T_ARRAY);
	Check_Type(fitness_soluciones, T_HASH);
	
	if(TYPE(n_elementos) != T_FIXNUM)
	{
		rb_raise(rb_eTypeError, "n_elementos debe de ser un valor entero\n");
	}
	
	if(RARRAY_LEN(lista_soluciones) == 0)
	{
		rb_raise(rb_eTypeError, "No se puede realizar un torneo sin participantes.\n");
	}
	
	lista_seleccionados = rb_ary_new();
	
	for(i = 0; i < NUM2INT(n_elementos); i++)
	{
		VALUE competidor_a;
		VALUE fitness_a;
		
		VALUE competidor_b;
		VALUE fitness_b;
		
		//Selección del competidor A
		
		indice_loco = INT2NUM(rb_genrand_ulong_limited(RARRAY_LEN(lista_soluciones) - 1));
		competidor_a = rb_ary_entry(lista_soluciones, NUM2INT(indice_loco));
		fitness_a = rb_hash_aref(fitness_soluciones, competidor_a);
		
		//Selección del competidor B
		
		indice_loco = INT2NUM(rb_genrand_ulong_limited(RARRAY_LEN(lista_soluciones) - 1));
		competidor_b = rb_ary_entry(lista_soluciones, NUM2INT(indice_loco));
		fitness_b = rb_hash_aref(fitness_soluciones, competidor_b);
		
		//Comprobación de la veracidad del fitness
		if((TYPE(fitness_b) != T_FLOAT) && (TYPE(fitness_b) != T_FIXNUM))
		{
			rb_raise(rb_eTypeError, "Se ha descubierto un fitness no valido\n");
		}
		
		if((TYPE(fitness_a) != T_FLOAT) && (TYPE(fitness_a) != T_FIXNUM))
		{
			rb_raise(rb_eTypeError, "Se ha descubierto un fitness no valido\n");
		}
		
		//Torneo entre los participantes
		if(NUM2DBL(fitness_a) <= NUM2DBL(fitness_b))
		{
			rb_ary_push(lista_seleccionados, competidor_a);
		}
		else
		{
			rb_ary_push(lista_seleccionados, competidor_b);
		}
	}
	
	return lista_seleccionados;
}

/*
Realiza una selección de +n_elementos+ de +lista_soluciones+ de manera aleatoria
de manera tal que tienen mayor probabilidad de ser seleccionados aquellas
soluciones que tengan menor fitness (ya que se trata de un problema de minimización).

Tenga en cuenta que los elementos seleccionados pueden estar repetidos.
*/
VALUE phub_operador_seleccion_ruleta(VALUE self, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos)
{
	double suma_fitness = 0;
	double numero_ruleta; //Número aleatorio de la ruleta
	VALUE fitness_ruleta; //Copia modificada de fitness_soluciones
	VALUE elementos_seleccionados;
	int i;
	
	Check_Type(lista_soluciones, T_ARRAY);
	Check_Type(fitness_soluciones, T_HASH);
	
	if(TYPE(n_elementos) != T_FIXNUM)
	{
		rb_raise(rb_eTypeError, "n_elementos debe de ser un número entero.\n");
	}
	
	if(RARRAY_LEN(lista_soluciones) == 0)
	{
		rb_raise(rb_eTypeError, "No hay participantes para la selección de la ruleta.\n");
	}
	
	elementos_seleccionados = rb_ary_new();
	
	//Creación y asignación de los valores de fitness ajustados a la ruleta
	//También se produce la suma de los fitness
	fitness_ruleta = rb_hash_new();
	
	for(i = 0; i < RARRAY_LEN(lista_soluciones); i++)
	{
		VALUE key = rb_ary_entry(lista_soluciones, i);
		VALUE value = rb_hash_aref(fitness_soluciones, key);
		
		if((TYPE(value) != T_FLOAT) && (TYPE(value) != T_FIXNUM))
		{
			rb_raise(rb_eTypeError, "Se hallo un fitness no valido.\n");
		}
		
		value = DBL2NUM(1/NUM2DBL(value));
		rb_hash_aset(fitness_ruleta, key, value);
		suma_fitness += NUM2DBL(value);
	}
	
	//Normalización del fitness entre 0 y 1
	for(i = 0; i < RARRAY_LEN(lista_soluciones); i++)
	{
		VALUE key = rb_ary_entry(lista_soluciones, i);
		VALUE value = rb_hash_aref(fitness_ruleta, key);
		
		value = DBL2NUM(NUM2DBL(value) / suma_fitness);
		
		rb_hash_aset(fitness_ruleta, key, value);
	}
	
	//Lanzamiento de la ruleta las veces necesarias
	for(i = 0; i < NUM2INT(n_elementos); i++)
	{
		double suma = 0;
		int j;
		numero_ruleta = rb_genrand_real();
		
		for(j = 0; j < RARRAY_LEN(lista_soluciones); j++)
		{
			VALUE key = rb_ary_entry(lista_soluciones, j);
			VALUE value = rb_hash_aref(fitness_ruleta, key);
			
			suma += NUM2DBL(value);
			
			if(suma >= numero_ruleta)
			{
				rb_ary_push(elementos_seleccionados, key);
				break;
			}
		}
	}
	
	//Devolviendo la solución
	return elementos_seleccionados;
}

/*
Selecciona +n_elementos+ entre +lista_soluciones+ al azar mediante
torneo o mediante la técnica de la ruleta.

+fitness_soluciones+ hace referencia a una tabla de hash que contiene
el valor objetivo de cada solución.

+sym_seleccion+ indica que tipo de selección realizar. Puede ser de dos
valores: :torneo y :ruleta dependiendo de si se desea una selección mediante
torneo o mediante ruleta respectivamente.
*/
VALUE phub_operador_seleccion(VALUE self, VALUE sym_seleccion, VALUE lista_soluciones, VALUE fitness_soluciones, VALUE n_elementos)
{
	VALUE sym_torneo = ID2SYM(rb_intern("torneo"));
	VALUE sym_ruleta = ID2SYM(rb_intern("ruleta"));
	
	//Los parámetros lista_soluciones, fitness_soluciones y n_elementos se comprueba en
	//los métodos PHUB#torneo => phub_operador_seleccion_torneo y PHUB#ruleta =>
	//phub_operador_seleccion_ruleta
	
	if(TYPE(sym_seleccion) != T_SYMBOL)
	{
		rb_raise(rb_eTypeError, "sym_seleccion debe de ser un símbolo.\n");
	}
	
	if((sym_seleccion != sym_torneo) && (sym_seleccion != sym_ruleta))
	{
		rb_raise(rb_eTypeError, "sym_seleccion debe de ser :torneo o :ruleta.\n");
	}
	
	if(sym_seleccion == sym_torneo)
	{
		return phub_operador_seleccion_torneo(self, lista_soluciones, fitness_soluciones, n_elementos);
	}
	else
	{
		return phub_operador_seleccion_ruleta(self, lista_soluciones, fitness_soluciones, n_elementos);
	}
}

/*
Devuelve una tabla de hash que indica los nodos a los que estaba conectado
a cada nodo.
*/
VALUE phub_get_connections(VALUE self, VALUE solucion)
{
	VALUE table = rb_hash_new();
	long i;
	
	Check_Type(solucion, T_ARRAY);
	
	if(RARRAY_LEN(solucion) == 0)
	{
		rb_raise(rb_eTypeError, "No se puden procesar una solución vacía\n");
	}
	
	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		VALUE nodo = rb_ary_entry(solucion, i);
		VALUE connected = rb_iv_get(nodo, "@connected");
			
		//Comprobar si es necesario
		if(TYPE(connected) == T_ARRAY)
		{
			connected = rb_ary_dup(connected);
		}
		else
		{
			connected = rb_ary_new();
		}
		rb_hash_aset(table, nodo, connected);
	
	}
	
	return table;
}

/*
Devuelve una tabla de hash con todos los nodos del vector solución como llave.
La tabla indica si estos nodos estan actuando como concentradores o como
clientes. Si actuan como concentradores devuelve true y en caso
contrario false
*/
VALUE phub_get_types(VALUE self, VALUE solucion)
{
	VALUE types = rb_hash_new();
	int i;
	
	Check_Type(solucion, T_ARRAY);
	
	if(RARRAY_LEN(solucion) == 0)
	{
		rb_raise(rb_eTypeError, "No se pueden clasificar nodos en una solución vacía.\n");
	}
	
	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		VALUE nodo = rb_ary_entry(solucion, i);
		
		if(rb_funcall(nodo, rb_intern("tipo"), 0) == ID2SYM(rb_intern("cliente")))
		{
			rb_hash_aset(types, nodo, Qfalse);
		}
		else
		{
			rb_hash_aset(types, nodo, Qtrue);
		}
	}
	
	return types;
}

/*
Desconecta completamente una solución
*/
VALUE desconectar_solucion(VALUE self, VALUE solucion)
{
	long int i;
	
	Check_Type(solucion, T_ARRAY);
	
	if(RARRAY_LEN(solucion) == 0)
	{
		rb_raise(rb_eTypeError, "No se puede desconectar una solución vacía.\n");
	}
	
	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		VALUE node = rb_ary_entry(solucion, i);
		
		rb_funcall(node, rb_intern("desconectar"), 0);
	}
	
	return Qnil;
}

/*
Conecta los nodos de la +solucion+ a los nodos concentradores que sea necesario según
la información que haya en +historical+. +historical+ se trata de una tabla de hash
que tiene como llave un nodo y devuelve un Array con los nodos a los que estaba
conectado dicho nodo.

Los nodos que no puedan conectarse se dejan sin conectar.
*/
VALUE phub_set_historical_connections(VALUE self, VALUE solucion, VALUE historical)
{
	VALUE types;
	long int i;
	
	Check_Type(solucion, T_ARRAY);
	Check_Type(historical, T_HASH);
	
	if(RARRAY_LEN(solucion) == 0)
	{
		rb_raise(rb_eTypeError, "No se pueden establecer conexiones en una solución nula.\n");
	}
	
	types = phub_get_types(self, solucion);
	desconectar_solucion(self, solucion);
	
	for(i = 0; i < RARRAY_LEN(solucion); i++)
	{
		VALUE nodo = rb_ary_entry(solucion, i);
		VALUE concentrador_destino;
		
		if(rb_hash_aref(types, nodo) == Qtrue) //El nodo es un concentrador
		{
			continue;
		}
		
		if(TYPE(rb_hash_aref(historical, nodo)) == T_NIL)
		{
			continue;
		}
		
		//El nodo es un cliente
		concentrador_destino = rb_hash_aref(historical, nodo);
		concentrador_destino = rb_ary_entry(concentrador_destino, 0);
		
		if(method_se_puede_conectar(nodo, concentrador_destino) == Qtrue)
		{
			method_conectar_a(nodo, concentrador_destino);
			method_conectar_a(concentrador_destino, nodo);
		}
	}
	
	return Qnil;
}

/*
Une dos soluciones en una. Devuelve el resultado.
*/
VALUE phub_merge(VALUE self, VALUE solucion_a, VALUE solucion_b)
{
	VALUE resultado = rb_ary_new();
	VALUE mayor;
	VALUE menor;
	int i;
	
	Check_Type(solucion_a, T_ARRAY);
	Check_Type(solucion_b, T_ARRAY);
	
	if(RARRAY_LEN(solucion_a) >= RARRAY_LEN(solucion_b))
	{
		mayor = solucion_a;
		menor = solucion_b;
	}
	else
	{
		mayor = solucion_b;
		menor = solucion_a;
	}
	
	for(i = 0; i < RARRAY_LEN(menor); i++)
	{
		VALUE item_mayor = rb_ary_entry(mayor, i);
		VALUE item_menor = rb_ary_entry(menor, i);
		
		rb_ary_push(resultado, item_mayor);
		rb_ary_push(resultado, item_menor);
	}
	
	for(i = RARRAY_LEN(menor); i < RARRAY_LEN(mayor); i++)
	{
		VALUE item = rb_ary_entry(mayor, i);
		
		rb_ary_push(resultado, item);
	}
	
	return resultado;
}

/*
Conecta los nodos clientes desconectados a los concentradores que puedan
mantenerlos.
*/
VALUE phub_set_random_connections(VALUE self, VALUE solucion)
{
	VALUE conjunto;
	VALUE concentradores;
	VALUE clientes;
	long int i;
	Check_Type(solucion, T_ARRAY);
	
	conjunto = phub_separar_nodos(self, solucion);
	
	concentradores = rb_ary_entry(conjunto, 0);
	clientes = rb_ary_entry(conjunto, 1);
	
	for(i = 0; i < RARRAY_LEN(clientes); i++)
	{
		VALUE cliente = rb_ary_entry(clientes, i);
		VALUE number_concentrador = rb_ary_new();
		long int j;
		long int numero_afortunado;
		
		if(method_esta_conectado(cliente) == Qtrue)
		{
			continue;
		}
		
		for(j = 0; j < RARRAY_LEN(concentradores); j++)
		{
			VALUE concentrador = rb_ary_entry(concentradores, j);
			
			if(method_se_puede_conectar(cliente, concentrador) == Qtrue)
			{
				rb_ary_push(number_concentrador, INT2NUM(j));
			}
		}
		
		if(RARRAY_LEN(number_concentrador) > 0)
		{
			VALUE concentrador_afortunado;
			numero_afortunado = rb_genrand_ulong_limited(RARRAY_LEN(number_concentrador) - 1);
			concentrador_afortunado = rb_ary_entry(concentradores, NUM2INT(numero_afortunado));
			
			method_conectar_a(cliente, concentrador_afortunado);
			method_conectar_a(concentrador_afortunado, cliente);
			
			rb_ary_store(clientes, i, cliente);
			rb_ary_store(concentradores, j, NUM2INT(numero_afortunado));
		}
	}
	
	return phub_merge(self, clientes, concentradores);
}

/*
Devuelve el cruce entre los concentradores de +solucion_a+ y +solucion_b+. Tenga
en cuenta que devuelve dos vectores en lugar de uno.

Tambien desconecta todos los nodos en dichas soluciones
*/
VALUE phub_mezclar_concentradores(VALUE self, VALUE solucion_a, VALUE solucion_b)
{
	VALUE conjunto_a;
	VALUE conjunto_b;
	
	VALUE concentradores_a;
	VALUE concentradores_b;
	
	VALUE mezcla_a;
	VALUE mezcla_b;
	
	VALUE empaquetado;
	
	unsigned long int particion_a;
	unsigned long int particion_b;
	
	unsigned long int i;
	
	Check_Type(solucion_a, T_ARRAY);
	Check_Type(solucion_b, T_ARRAY);
	
	if(RARRAY_LEN(solucion_a) == 0)
	{
		rb_raise(rb_eTypeError, "No se puede mezclar una solucion vacía.\n");
	}
	
	if(RARRAY_LEN(solucion_b) == 0)
	{
		rb_raise(rb_eTypeError, "No se puede mezclar una solución vacía\n");
	}
	
	//Desconexion de las soluciones
	desconectar_solucion(self, solucion_a);
	desconectar_solucion(self, solucion_b);
	
	//Separación de los clientes y concentradores
	conjunto_a = phub_separar_nodos(self, solucion_a);
	conjunto_b = phub_separar_nodos(self, solucion_b);
	
	concentradores_a = rb_ary_entry(conjunto_a, 0);
	concentradores_b = rb_ary_entry(conjunto_b, 0);
	
	//Elección de los limites de las particiones
	particion_a = RARRAY_LEN(concentradores_a) / 2;
	particion_b = particion_a;
	
	//Preparando las soluciones
	mezcla_a = rb_ary_new();
	mezcla_b = rb_ary_new();
	
	//Mezclando
	for(i = 0; i < (unsigned long int) RARRAY_LEN(concentradores_a); i++)
	{
		VALUE concentrador = rb_ary_entry(concentradores_a, i);
		
		if(i < particion_a)
		{
			rb_ary_push(mezcla_a, concentrador);
		}
		else
		{
			rb_ary_push(mezcla_b, concentrador);
		}
	}
	
	for(i = 0; i < (unsigned long int) RARRAY_LEN(concentradores_b); i++)
	{
		VALUE concentrador = rb_ary_entry(concentradores_b, i);
		
		if(i < particion_b)
		{
			rb_ary_push(mezcla_a, concentrador);
		}
		else
		{
			rb_ary_push(mezcla_b, concentrador);
		}
	}
	
	//Construyendo solucion
	empaquetado = rb_ary_new();
	rb_ary_push(empaquetado, mezcla_a);
	rb_ary_push(empaquetado, mezcla_b);
	
	return empaquetado;
}

void Init_c_phub()
{
	phub_module = rb_define_module("PHUB");
	class_phub = rb_define_class_under(phub_module, "PHUB", CBasicPHub);
	rb_define_private_method(class_phub, "random_number", phub_random_number, 0);
	rb_define_private_method(class_phub, "separar_nodos", phub_separar_nodos, 1);
	rb_define_private_method(class_phub, "torneo", phub_operador_seleccion_torneo, 3);
	rb_define_private_method(class_phub, "torneo_injusto", phub_operador_seleccion_torneo_injusto, 3);
	rb_define_private_method(class_phub, "ruleta", phub_operador_seleccion_ruleta, 3);
	rb_define_private_method(class_phub, "seleccion", phub_operador_seleccion, 4);
	//rb_define_private_method(class_phub, "cruce", phub_operador_cruce, 2);
	rb_define_private_method(class_phub, "get_connections", phub_get_connections, 1);
	rb_define_private_method(class_phub, "get_types", phub_get_types, 1);
	rb_define_private_method(class_phub, "desconectar_solucion", desconectar_solucion, 1);
	rb_define_private_method(class_phub, "set_historical_connections", phub_set_historical_connections, 2);
	rb_define_private_method(class_phub, "merge", phub_merge, 2);
	rb_define_private_method(class_phub, "set_random_connections", phub_set_random_connections, 1);
	rb_define_private_method(class_phub, "mezclar_concentradores", phub_mezclar_concentradores, 2);
}
