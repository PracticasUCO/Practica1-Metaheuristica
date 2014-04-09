#! /usr/bin/env ruby -w
# encoding: utf-8

require_relative("../BasicMMDP/BasicMMDP")
require_relative("c_mmdp")
require_relative("../../ES/ES/ES")

# El modulo MMDP engloba a todas las clases relacionadas con el problema
# MaxMinDiversityProblem
module MMDP
=begin rdoc
	La clase MMDP define una interfaz para el problema Max Min Diversity Problem
	propuesto en clase. Se usa las funcionalidades ya definidas en BasicMMDP
	para tratar de conseguir una solucion mejor a traves de la heuristica
=end
	class MMDP < BasicMMDP
		# El punto de ruptura representa el valor maximo de busqueda
		# dentro de la busqueda local. Si este valor es igual a 2
		# significara que se buscara localmente a través de la mitad
		# del vector solucion dado por la busqueda global. Si es
		# tres, sera a través de la tercera parte, y asi sucesivamente
		attr_reader :punto_ruptura

		# Inicializa la clase para que carge los valores de la base de datos
		# Recibe como parametro un string indicando el lugar de donde
		# leer la base de datos
		def initialize(path_db)
			super

			if solution_nodes > 2
				@punto_ruptura = Math.log2(solution_nodes).to_i
			else
				@punto_ruptura = 1
			end
		end


		# Realiza una busqueda global para tratar de obtener un
		# vector con la maxima distancia entre nodos posible
		def busqueda_global
			return generar_solucion_aleatoria
		end

		# Genera una solución de forma aleatoria y trata de mejorarla mediante
		# las tecnicas de búsqueda local. 
		#
		# Puede recibir como parametro el tipo
		# de busqueda local a recibir que puede ser :best_improvement para
		# realizar una búsqueda local en la cual se seleccione al mejor de
		# los vecinos o mediante :first_improvement para seleccionar a la
		# primera mejora de los vecinos. Tambien puede usar como tipo
		# el valor :enfriamiento_simulado para activar el algoritmo de
		# enfriamiento simulado
		#
		# Si no se especifica el tipo de busqueda se asume que se prefiere
		# la técnica Best improvement
		def generar_solucion_busqueda_local(tipo = :first_improvement)
			raise TypeError, "Tipo debe de ser un simbolo" unless tipo.kind_of? Symbol

			unless tipo == :best_improvement or tipo == :first_improvement or tipo == :enfriamiento_simulado
				raise TypeError, "Los valores admitidos para tipo son: :best_improvement, :first_improvement y :enfriamiento_simulado"
			end

			solucion, coste_actual = busqueda_global

			if tipo == :best_improvement
				solucion, coste_actual = busqueda_local_best_improvement(solucion, coste_actual, solution_nodes * total_nodes)
			elsif tipo == :first_improvement
				solucion, coste_actual = busqueda_local_first_improvement(solucion, coste_actual, solution_nodes * total_nodes)
			else
				es = ES::ES.new(coste_actual * total_nodes, 0.75);

				solucion, coste_actual = busqueda_local_enfriamiento_simulado(solucion, coste_actual, es, 0.5)
			end

			return solucion, coste_actual
		end

		protected :busqueda_global
	end
end