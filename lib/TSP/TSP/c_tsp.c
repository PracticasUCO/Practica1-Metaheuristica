#include "c_tsp.h"
#include "../BasicTSP/c_basic_tsp.c"

void Init_c_tsp()
{
	Init_c_basic_tsp();
	class_tsp = rb_define_class_under(module_tsp, "TSP", class_basic_tsp);
}