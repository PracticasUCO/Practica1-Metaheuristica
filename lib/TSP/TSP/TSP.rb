#! /usr/bin/env ruby

require_relative '../BasicTSP/BasicTSP'
require_relative 'c_tsp'
require_relative '../../ES/ES/ES'

module TSP
	class TSP < BasicTSP
		def initialize(path)
			raise "path must be a string" unless path.kind_of? String
			super
		end

		def generar_solucion_busqueda_local(tipo)
			raise "tipo must be a symbol" unless tipo.kind_of? Symbol

			unless tipo == :first_improvement or tipo == :best_improvement or tipo == :enfriamiento_simulado
				raise "Valor de tipo desconocido: #{tipo}."
			end

			solucion, coste = generar_solucion_aleatoria()

			if tipo == :first_improvement
				solucion, coste = busqueda_local_first_improvement(solucion, coste, 0);
			elsif tipo == :best_improvement
				solucion, coste = busqueda_local_best_improvement(solucion, coste, 0);
			else
				es = ES::ES.new(coste * numero_ciudades, 0.7)
				solucion, coste = busqueda_local_enfriamiento_simulado(solucion, coste, es, 0.01)
			end

			return solucion, coste
		end
	end
end