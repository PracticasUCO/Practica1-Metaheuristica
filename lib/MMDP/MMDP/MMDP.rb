#! /usr/bin/env ruby -w
# encoding: utf-8

require_relative("../BasicMMDP/BasicMMDP")

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

		# Realiza una busca local para tratar de mejorar lo maximo posible el
		# vector solucion
		# 
		# Recibe como parametros el array con la soluciones escogidas y
		# Devuelve un vector solucion optimizado
		# 
		# Este metodo sigue un algoritmo de busqueda local mediante la tecnica
		# de best improvement, optimizado mediante un parametro de corte para
		# no llegar a explorar todas las soluciones vecinas.
		#
		# El metodo de parada es cuando se hayan explorado más soluciones que
		# solution_nodes / @punto_ruptura
		#
		# @punto_ruptura usualmente se configura a log2(solution_nodes)
		def busqueda_local_best_improvement(solucion)
			raise TypeError, "El parametro solucion debe ser un Array" unless solucion.kind_of? Array

			alternativa = solucion.dup
			nodos_lista = lista_nodos().dup
			coste_actual = obtener_suma_costes(solucion)

			alternativa.each_with_index do |origen, index|
				break if index > solution_nodes / @punto_ruptura
				alternativa.each do |destino|
					next if origen == destino

					nueva_alternativa = alternativa.dup
					nueva_alternativa.delete(destino)
					
					nodos_lista.each do |nodo_alternativo|
						next if nodo_alternativo == origen
						next if nodo_alternativo == destino
						next if nueva_alternativa.include? nodo_alternativo

						nueva_alternativa << nodo_alternativo

						coste_alternativa = obtener_suma_costes(nueva_alternativa)

						if coste_alternativa > coste_actual
							coste_actual = coste_alternativa
							alternativa = nueva_alternativa.dup
						end

						nueva_alternativa.delete(nodo_alternativo)
					end
				end
			end

			return alternativa, coste_actual
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
		# primera mejora de los vecinos.
		#
		# Si no se especifica el tipo de busqueda se asume que se prefiere
		# la técnica Best improvement
		def generar_solucion_busqueda_local(tipo: :best_improvement)
			solucion, coste_actual = busqueda_global
			solucion , coste_actual = busqueda_local_best_improvement(tipo)
			return solucion, coste_actual
		end

		protected :busqueda_global, :busqueda_local_best_improvement
	end
end