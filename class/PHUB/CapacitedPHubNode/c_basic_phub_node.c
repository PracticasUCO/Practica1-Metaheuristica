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

// Prototype for the initialization method - Ruby calls this, not you
void Init_c_basic_capacited_phub_node() {
	CBasicPHubNode = rb_define_class("CapacitedPHubNode", rb_cObject);
	rb_define_method(CBasicPHubNode, "distancia", method_distancia, 1);
	rb_define_method(CBasicPHubNode, "se_puede_conectar?", method_se_puede_conectar, 1);
	rb_define_method(CBasicPHubNode, "esta_conectado?", method_esta_conectado, 0);
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
