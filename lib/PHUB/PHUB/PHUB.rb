#! /usr/bin/env ruby
# enconding: utf-8

require_relative '../BasicPHub/BasicPHub'
require_relative '../CapacitedPHubNode/CapacitedPHubNode'
require_relative 'c_phub'

module PHUB
	# La clase PHUB esta encargada de encontrar una buena solución para el problema
	# de CapacitedPHub.
	class PHUB < BasicPHub
		# Constructor de la clase PHUB. Recibe un string con la dirección de la base
		# de datos a leer
		def initialize(path)
			super
		end
		
		# Ordena los elementos de una lista de soluciones según su fitness
		def sort_by_fitness(lista_soluciones, fitness_soluciones)
			raise TypeError, "lista_soluciones debe de ser un Array" unless lista_soluciones.kind_of? Array
			raise TypeError, "fitness_soluciones debe de ser una tabla de hash" unless fitness_soluciones? Hash
			
			lista_soluciones.sort_by! {|solucion| fitness_soluciones[solucion]}
		end
		
		private :sort_by_fitness
	end
end
