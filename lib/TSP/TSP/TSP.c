#include "TSP.h"

void Init_TSP()
{
	module_tsp = rb_define_module("TSP");
	class_tsp = rb_define_class_under(module_tsp, "TSP", class_basic_tsp);
}