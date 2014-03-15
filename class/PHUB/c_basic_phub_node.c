// Include the Ruby headers and goodies
#include "ruby.h"
#include <math.h>

// Defining a space for information and references about the module to be stored internally
VALUE CBasicPHubNode = Qnil;

// Prototype for our method 'distancia' - methods are prefixed by 'method_' here
VALUE method_distancia(VALUE self, VALUE propias, VALUE vecino);

// Prototype for the initialization method - Ruby calls this, not you
void Init_c_basic_capacited_phub_node() {
	CBasicPHubNode = rb_define_class("CapacitedPHubNode", rb_cObject);
	rb_define_method(CBasicPHubNode, "distancia", method_distancia, 2);
};

// The initialization method for this module
/*void Init_distancia() {
	CBasicPHubNode = rb_define_module("CBasicPHubNode");
	rb_define_method(CBasicPHubNode, "distancia", method_distancia, 0);
}*/

// Our 'test1' method.. it simply returns a value of '10' for now.
VALUE method_distancia(VALUE self, VALUE propias, VALUE vecino) {
	
	propias = rb_check_array_type(propias);
	vecino = rb_check_array_type(vecino);
	
	if((propias != Qnil) && (vecino != Qnil))
	{
		propias = rb_ary_dup(propias);
		vecino = rb_ary_dup(vecino);
		double vecinoX;
		double vecinoY;
		double propiaX;
		double propiaY;
		double resultado;
		
		vecinoX = NUM2DBL(rb_ary_shift(vecino));
		vecinoY = NUM2DBL(rb_ary_shift(vecino));
		propiaX = NUM2DBL(rb_ary_shift(propias));
		propiaY = NUM2DBL(rb_ary_shift(propias));
		
		resultado = sqrt(((vecinoX-propiaX) * (vecinoX-propiaX)) + ((vecinoY - propiaY) * (vecinoY - propiaY)));
		
		rb_ary_free(propias);
		rb_ary_free(vecino);
		
		return DBL2NUM(resultado);
	}
	else
	{
		return Qnil;
	}
} 
