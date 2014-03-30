#include "c_mmdp.h"

void Init_mmdp()
{
	if(module_mmdp == Qnil)
	{
		module_mmdp = rb_define_module("MMDP");
	}

	class_mmdp = rb_define_class_under(module_mmdp, "MMDP", rb_cObject);
}