// Include the Ruby headers and goodies
#include "ruby.h"
#include <math.h>
#include "../phub.h"
#include "c_basic_phub_node.h"

// Prototype for the initialization method - Ruby calls this, not you
void Init_c_basic_capacited_phub_node() {
	phub_module = rb_define_module("PHUB");
	CBasicPHubNode = rb_define_class_under(phub_module, "CapacitedPHubNode", rb_cObject);
	rb_define_method(CBasicPHubNode, "distancia", method_distancia, 1);
	rb_define_method(CBasicPHubNode, "se_puede_conectar?", method_se_puede_conectar, 1);
	rb_define_method(CBasicPHubNode, "esta_conectado?", method_esta_conectado, 0);
	rb_define_method(CBasicPHubNode, "conectar_a=", method_conectar_a, 1);
};

/*
	Este método devuelve la distancia euclídea entre dos nodos CapacitedPHubNode
*/
VALUE method_distancia(VALUE self, VALUE vecino) {
	VALUE coordenadasPropias = rb_iv_get(self, "@coordenadas");
	VALUE coordenadasVecino = rb_iv_get(vecino, "@coordenadas");
	VALUE tipoP;
	VALUE tipoV;

	coordenadasPropias = rb_ary_dup(coordenadasPropias);
	coordenadasVecino = rb_ary_dup(coordenadasVecino);
	
	tipoP = TYPE(coordenadasPropias);
	tipoV = TYPE(coordenadasVecino);
	
	if((tipoP == T_ARRAY) && (tipoV == T_ARRAY))
	{
		double vecinoX;
		double vecinoY;
		double propiaX;
		double propiaY;
		double resultado;
		
		vecinoX = NUM2DBL(rb_ary_shift(coordenadasVecino));
		vecinoY = NUM2DBL(rb_ary_shift(coordenadasVecino));
		propiaX = NUM2DBL(rb_ary_shift(coordenadasPropias));
		propiaY = NUM2DBL(rb_ary_shift(coordenadasPropias));
		
		resultado = sqrt(((vecinoX-propiaX) * (vecinoX-propiaX)) + ((vecinoY - propiaY) * (vecinoY - propiaY)));
		
		return DBL2NUM(resultado);
	}
	else
	{
		rb_raise(rb_eRuntimeError, "No se pasaron las coordenadas correctas\n");
	}
}

/*
Devuelve true cuando se pude realizar la conexión entre dos nodos y false en
caso contrario.

Se puede realizar la conexión entre dos nodos cuando uno de ellos esta actuando como
concentrador y el otro como cliente, y además, la demanda del que actúa como cliente
es inferior o igual a la reserva del concentrador.
*/
VALUE method_se_puede_conectar(VALUE self, VALUE otro)
{
	ID get_tipo = rb_intern("tipo");
	ID get_reserva = rb_intern("reserva");
	ID get_demanda = rb_intern("demanda");
	VALUE tipo_concentrador = ID2SYM(rb_intern("concentrador")); 
	VALUE mi_tipo;
	VALUE otro_tipo;

	double demanda;
	double reserva;

	if(!rb_obj_is_kind_of(otro, CBasicPHubNode))
	{
		VALUE tipo = rb_funcall(otro, rb_intern("class"), 0);
		tipo = rb_funcall(tipo, rb_intern("name"), 0);
		rb_raise(rb_eTypeError, "otro debe de ser un CapacitedPHubNode actual: %s\n", StringValueCStr(tipo));
	}
	
	mi_tipo = rb_funcall(self, get_tipo, 0);
	otro_tipo = rb_funcall(otro, get_tipo, 0);
	
	if(mi_tipo == otro_tipo)
	{
		return Qfalse;
	}
	else
	{
		if(mi_tipo == tipo_concentrador)
		{
			reserva = rb_funcall(self, get_reserva, 0);
			demanda = rb_funcall(otro, get_demanda, 0);
		}
		else
		{
			demanda = NUM2DBL(rb_funcall(self, get_demanda, 0));
			reserva = NUM2DBL(rb_funcall(otro, get_reserva, 0));
		}
		
		if(reserva >= demanda)
		{
			return Qtrue;
		}
		else
		{
			return Qfalse;
		}
	}
}

/*
Devuelve true cuando el nodo esta conectado a otro nodo y false en caso contrario
*/
VALUE method_esta_conectado(VALUE self)
{
	VALUE conexion = rb_iv_get(self, "@connected");
	
	if(TYPE(conexion) == T_NIL)
	{
		conexion = rb_ary_new();
		rb_iv_set(self, "@connected", conexion);
		
		return Qfalse;
	}
	
	if(RARRAY_LEN(conexion) > 0)
	{
		return Qtrue;
	}
	else
	{
		return Qfalse;
	}
}

/*
Realiza la conexión entre dos nodos. No se comprueba si se llega o no a saturar a
otro nodo. Si no se puede realizar la conexión (por ejemplo por que uno de los extremos
no sea un CapacitedPHubNode se lanzara una excepción de tipo TypeError)
*/
VALUE method_conectar_a(VALUE self, VALUE otro)
{
	//Métodos
	VALUE get_tipo = rb_intern("tipo");
	VALUE get_demanda = rb_intern("demanda");
	VALUE get_id = rb_intern("id");
	VALUE metodo_desconectar = rb_intern("desconectar");
	VALUE conectado_a = rb_intern("conectado_a");
	VALUE connected;
	//VALUE id_concentrador;
	double reserva;
	VALUE mi_tipo;
	VALUE tipo_otro;
	VALUE tipo_cliente;

	if(!rb_obj_is_kind_of(otro, CBasicPHubNode))
	{
		rb_raise(rb_eTypeError, "otro debe de ser un CapacitedPHubNode");
	}
	
	//Variables
	connected = rb_iv_get(self, "@connected");
	//id_concentrador = rb_iv_get(self, "@id_concentrador");
	reserva = NUM2DBL(rb_iv_get(self, "@reserva"));
	
	mi_tipo = rb_funcall(self, get_tipo, 0);
	tipo_otro = rb_funcall(otro, get_tipo, 0);
	tipo_cliente = ID2SYM(rb_intern("cliente"));
	
	if(mi_tipo == tipo_otro)
	{
		rb_raise(rb_eTypeError, "No se puede conectar dos nodos iguales\n");
	}
	
	if(mi_tipo == tipo_cliente)
	{
		rb_funcall(self, metodo_desconectar, 0);
		rb_ary_push(connected, otro);
		
		rb_iv_set(self, "@id_concentrador", rb_funcall(otro, get_id, 0));
		rb_iv_set(self, "@connected", connected);
	}
	else
	{
		VALUE ya_existe = rb_funcall(self, conectado_a, 1, otro);
		
		if(ya_existe == Qfalse)
		{
			rb_ary_push(connected, otro);
			reserva -= NUM2DBL(rb_funcall(otro, get_demanda, 0));
			rb_iv_set(self, "@connected", connected);
			rb_iv_set(self, "@reserva", DBL2NUM(reserva));
		}
	}

	return Qnil;
}
