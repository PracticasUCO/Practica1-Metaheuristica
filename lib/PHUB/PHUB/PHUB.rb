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
	end
end
