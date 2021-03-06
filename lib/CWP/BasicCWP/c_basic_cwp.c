#include "c_basic_cwp.h"

// Inicialización de la clase
void Init_c_basic_cwp() {
	module_cwp = rb_define_module("CWP");
	c_basic_cwp = rb_define_class_under(module_cwp, "BasicCWP", rb_cObject);
	rb_define_method(c_basic_cwp, "funcion_objetivo", method_funcion_objetivo, 1);
}

static VALUE diferencia_ary(VALUE ary1, VALUE ary2)
{
	VALUE ary3 = rb_ary_new();
	int i = 0;
	int j = 0;
	
	for(i = 0; i < RARRAY_LEN(ary1); i++)
	{
		VALUE elemento1 = rb_ary_entry(ary1, i);
		int existe = 0;
		
		for(j = 0; ((j < RARRAY_LEN(ary2)) && (existe == 0)); j++)
		{
			VALUE elemento2 = rb_ary_entry(ary2, j);
			
			if(elemento1 == elemento2)
			{
				existe = 1;
			}
		}
		
		if(existe == 0)
		{
			rb_ary_push(ary3, elemento1);
		}
	}
	
	return ary3;
}
/*
La función objetivo devuelve el numero de cortes que se producen
al ordenar el grafo de forma lineal.
*/
VALUE method_funcion_objetivo(VALUE self, VALUE v_nodes) {
	VALUE procesados = rb_ary_new();
	VALUE para_cerrar = rb_hash_new();
	int opened = 0;
	int count = 0;
	
	//Creo a aberturas
	VALUE aberturas = rb_ary_new();
	
	//Leo la variable de instancia @grafo y compruebo que fue definida
	VALUE grafo = rb_iv_get(self, "@grafo");

	Check_Type(v_nodes, T_ARRAY);
	v_nodes = rb_ary_dup(v_nodes);
	
	
	Check_Type(grafo, T_HASH);
	
	while(RARRAY_LEN(v_nodes) > 0)
	{	
		//Cojo un nodo
		VALUE nodo = rb_ary_shift(v_nodes);
		VALUE cerrando;
		
		// Lo meto en procesados
		rb_ary_push(procesados, nodo);
		
		//Proceso aberturas
		//rb_ary_free(aberturas);
		aberturas = diferencia_ary(rb_hash_aref(grafo, nodo), procesados);
		
		//Sumo a opened la longitud de aberturas
		
		opened += RARRAY_LEN(aberturas); 
		
		//Leo para_cerrar
		cerrando = rb_hash_aref(para_cerrar, nodo);
		
		//Si había nodos que cerraban en esta posición, los resto de opened
		if(TYPE(cerrando) != T_NIL)
		{
			opened -= RARRAY_LEN(cerrando);
			rb_hash_delete(para_cerrar, nodo);
		}
		
		//Aumentamos la cuenta tantas veces como abiertos existan
		count += opened;
		
		//Procesamos todas las aberturas
		while(RARRAY_LEN(aberturas) > 0)
		{
			//Cojo el nodo de la abertura
			VALUE abertura = rb_ary_shift(aberturas);
			
			//Compruebo que existen en la tabla de hash para_cerrar
			VALUE valor = rb_hash_aref(para_cerrar, abertura);
			
			if(TYPE(valor) != T_NIL) //Existe
			{
				valor += INT2NUM(1);
				rb_hash_aset(para_cerrar, abertura, valor);
			}
		}
	}
	//rb_ary_free(procesados);
	//rb_ary_free(aberturas);
	//rb_hash_free(para_cerrar);
	
	return INT2NUM(count);
}
