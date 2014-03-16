// Include the Ruby headers and goodies
#include "ruby.h"
#include <math.h>
#include <stdio.h>

// Defining a space for information and references about the module to be stored internally
VALUE CBasicPHubNode = Qnil;

// Prototype for our method 'distancia' - methods are prefixed by 'method_' here
VALUE method_distancia(VALUE self, VALUE vecino);

// Prototipo para el metodo CapacitedPHubNode#se_puede_conectar?
VALUE method_se_puede_conectar(VALUE self, VALUE otro);

// Prototipo para el metodo CapacitedPHubNode#esta_conectado?
VALUE method_esta_conectado(VALUE self);

// Prototipo para el  metodo CapacitedPHubNode#conectar_a=
VALUE method_conectar_a(VALUE self, VALUE otro);

// Prototype for the initialization method - Ruby calls this, not you
void Init_c_basic_capacited_phub_node() {
	CBasicPHubNode = rb_define_class("CapacitedPHubNode", rb_cObject);
	rb_define_method(CBasicPHubNode, "distancia", method_distancia, 1);
	rb_define_method(CBasicPHubNode, "se_puede_conectar?", method_se_puede_conectar, 1);
	rb_define_method(CBasicPHubNode, "esta_conectado?", method_esta_conectado, 0);
	rb_define_method(CBasicPHubNode, "conectar_a=", method_conectar_a, 1);
};

// The initialization method for this module
void Init_distancia() {
	CBasicPHubNode = rb_define_module("CBasicPHubNode");
	rb_define_method(CBasicPHubNode, "distancia", method_distancia, 0);
}

// Our 'test1' method.. it simply returns a value of '10' for now.
VALUE method_distancia(VALUE self, VALUE vecino) {
	VALUE coordenadasPropias = rb_iv_get(self, "@coordenadas");
	VALUE coordenadasVecino = rb_iv_get(vecino, "@coordenadas");
	
	coordenadasPropias = rb_ary_dup(coordenadasPropias);
	coordenadasVecino = rb_ary_dup(coordenadasVecino);
	
	VALUE tipoP = TYPE(coordenadasPropias);
	VALUE tipoV = TYPE(coordenadasVecino);
	
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

VALUE method_se_puede_conectar(VALUE self, VALUE otro)
{
	if(!rb_obj_is_kind_of(otro, CBasicPHubNode))
	{
		rb_raise(rb_eTypeError, "otro debe de ser un CapacitedPHubNode");
	}
	
	ID get_tipo = rb_intern("tipo");
	ID get_reserva = rb_intern("reserva");
	ID get_demanda = rb_intern("demanda");
	
	VALUE mi_tipo = rb_funcall(self, get_tipo, 0);
	VALUE otro_tipo = rb_funcall(otro, get_tipo, 0);
	VALUE tipo_concentrador = ID2SYM(rb_intern("concentrador")); 
	double demanda;
	double reserva;
	
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

VALUE method_esta_conectado(VALUE self)
{
	VALUE conexion = rb_iv_get(self, "@connected");
	
	if(RARRAY_LEN(conexion) > 0)
	{
		return Qtrue;
	}
	else
	{
		return Qfalse;
	}
}

VALUE method_conectar_a(VALUE self, VALUE otro)
{
	if(!rb_obj_is_kind_of(otro, CBasicPHubNode))
	{
		rb_raise(rb_eTypeError, "otro debe de ser un CapacitedPHubNode");
	}
	
	//Metodos
	VALUE get_tipo = rb_intern("tipo");
	VALUE get_demanda = rb_intern("demanda");
	VALUE get_id = rb_intern("id");
	VALUE metodo_desconectar = rb_intern("desconectar");
	VALUE conectado_a = rb_intern("conectado_a");
	
	//Variables
	VALUE connected = rb_iv_get(self, "@connected");
	VALUE id_concentrador = rb_iv_get(self, "@id_concentrador");
	double reserva = NUM2DBL(rb_iv_get(self, "@reserva"));
	
	VALUE mi_tipo = rb_funcall(self, get_tipo, 0);
	VALUE tipo_otro = rb_funcall(otro, get_tipo, 0);
	VALUE tipo_cliente = ID2SYM(rb_intern("cliente"));
	
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
}