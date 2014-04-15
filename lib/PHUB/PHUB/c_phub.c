#include <ruby.h>
#include <stdlib.h>
#include "c_phub.h"

/*
Genera un valor aleatorio entre 0 y 1
*/
VALUE random_number(VALUE self)
{
	double random_number = drand48();
	return DBL2NUM(random_number);
}
