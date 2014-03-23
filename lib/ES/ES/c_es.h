#ifndef __C_ENFRIAMIENTO_SIMULADO__
#define __C_ENFRIAMIENTO_SIMULADO__

#include <ruby.h>

// Constructor de la clase ES
void Init_ES();

// Modulo ES
VALUE module_es = Qnil;

// Clase ES
VALUE class_es = Qnil;

/*
Constructor de la clase, recibe como parametros una tabla de hash con
los siguientes atributos:
- valor_inicio: Indica el valor de inicio de la temperatura, debe de ser
  numerico y solo puede oscilar entre 0-1 (ambos inclusive)
- tipo: Indica el tipo de función que se usara para disminuir la temperatura
  Actualmente solo puede ser :geometrica
- coeficiente: Indica el valor del coeficiente usado en la función de disminución
  de la temperatura
*/
VALUE method_initialize;

/*
Este metodo devuelve la temperatura actual del algoritmo
*/
VALUE method_temperatura;

/*
Este metodo devuelve un valor booleano True o False de forma aleatoria.
La probabilidad de que devuelva True sera mayor contra más alta sea
la temperatura.
*/
VALUE method_probabilidad;

/*
Disminuye la temperatura interna de la clase de manera que haya menor
probabilidad de conseguir un valor True.

La funcion de disminución de la temperatura viene determinada por el
tipo y por el coeficiente de cambio determinado en la clase
*/
VALUE method_enfriar;

/*
Devuelve el valor de inicio de la temperatura de la clase
*/
VALUE method_valor_inicio;

/*
Devuelve el tipo de funcion de disminución de la temperatura,
actualmente este valor solo puede ser :geometrica
*/
VALUE method_tipo;

/*
Devuelve el coeficiente de cambio usado en la funcion de temperatura
*/
VALUE method_coeficiente;

/*
Restaura la temperatura a su punto inicial
*/
VALUE method_reset;
#endif