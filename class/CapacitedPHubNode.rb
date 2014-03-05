#! /usr/bin/env ruby -w

=begin rdoc
La clase CapacitedPHubNode representa a un nodo de problema Capacited P Hub.
Un nodo estara representado por sus coordenadas, su demanda y si es
concentrador o no.

Las coordenadas indican la posicion del espacio donde se encuentra
el nodo.

La demanda del nodo indica que recursos demanda este cuando actua como
cliente.

Un nodo puede ser de dos tipos:
- Cliente, lo cual significa que necesita conectarse a otro nodo, denominado
 concentrador para poder realizar sus funciones
- Concentrador, es autosuficiente y puede realizar sus funciones, además
de recibir las peticiones de los demás nodos.

Cada nodo concentrador tiene ademas una capacidad maxima de servicio que
no puede ser sobrepasada
=end
class CapacitedPHubNode
	# Constructor de nodo. Recibe como parametros
	# coordenadas: indica las coordenadas en el plano del vector, por
	# defecto en el (0,0)
	# 
	# demanda: Necesidad de recursos a ser satisfecha por un nodo cuando
	# actua como cliente
	#
	# tipo: Indica si el nodo es de tipo cliente o de tipo concentrador
	# valdra :cliente cuando sea lo primero y :concentrador cuando sea
	# lo segundo
	#
	# capacidad_servicio: Indica la cantidad de recursos maxima que puede
	# servir el nodo cuando actua como concentrador
	#
	# Todos los parametros tiene valores por defecto, los cuales son:
	# Coordenadas: [0, 0]
	# Demanda: 0
	# Tipo: :cliente
	# capacidad_servicio: 0
	def initialize(coordenadas: [0, 0], demanda: 0, tipo: :cliente, capacidad_servicio: 0)
		raise TypeError, "Las coordenadas deben de ser un Array" unless coordenadas.kind_of? Array
		raise TypeError, "Solo se aceptan coordenadas del plano" unless coordenadas.length.eql? 2
		raise TypeError, "La demanda debe de ser un numero" unless demanda.kind_of? Numeric
		raise TypeError, "El cliente debe de ser de tipo Symbol" unless tipo.kind_of? Symbol
		raise TypeError, "El tipo debe de ser :cliente o :concentrador" unless tipo.eql? :cliente or tipo.eql? :concentrador
		raise TypeError, "La capacidad de servicio debe de ser un numero" unless capacidad_servicio.kind_of? Numeric
		
		raise TypeError, "La demanda debe de ser un numero positivo o cero" unless demanda.>= 0
		raise TypeError, "La capacidad del servicio debe de ser positiva o cero" unless capacidad_servicio.>= 0
	end
	
	
end