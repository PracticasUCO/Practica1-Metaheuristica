#! /usr/bin/env ruby -w

require_relative 'CapacitedPHubNode'
require 'set'

=begin rdoc
La clase BasicPHub es la responsable de leer el fichero de base de datos
del problema proporcionado y conservar una representancion de todos
los nodos del problema.

Además de esto, debe dar un solución basica generada de forma aleatoria
=end
class BasicPHub
	# nodos guarda una representacion vectorial de todos los nodos
	# que hay en la base de datos. Estos nodos puede estar ya conectados
	# o no, dependiendo de si ha elegido conectarlos o no
	attr_reader :nodos
end
