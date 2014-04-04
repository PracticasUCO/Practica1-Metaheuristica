#include <ruby.h>

VALUE module_tsp;
VALUE class_basic_tsp;

VALUE method_btsp_each(VALUE self)
{
	VALUE caminos = rb_iv_get(self, "@caminos");
	long int i, j;

	for(i = 0; i < RARRAY_LEN(caminos); i++)
	{
		VALUE camino = rb_ary_entry(caminos, i);

		for(j = 0; j < RARRAY_LEN(camino); j++)
		{
			VALUE coste = rb_ary_entry(camino, j);
			rb_yield(coste);
		}
	}
	return Qnil;
}

void Init_c_basic_tsp()
{
	module_tsp = rb_define_module("TSP");
	class_basic_tsp = rb_define_class_under(module_tsp, "BasicTSP", rb_cObject);
	rb_define_method(class_basic_tsp, "each", method_btsp_each, 0);
}