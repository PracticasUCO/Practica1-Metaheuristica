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

		# Realiza una busqueda local para tratar de mejorar lo maximo posible el
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
		#
		# Como parametros recibe el vector solución a mejorar y el coste
		# de dicho vector
		def busqueda_local_best_improvement(solucion, coste_actual)
			raise TypeError, "El parametro solucion debe ser un Array" unless solucion.kind_of? Array
			raise TypeError, "El parametro coste_actual debe de ser numerico" unless coste_actual.kind_of? Numeric

			alternativa = solucion.dup
			nodos_lista = lista_nodos().dup

			alternativa.each_with_index do |origen, index|
				break if index > solution_nodes / @punto_ruptura

				alternativa.each do |destino|
					next if origen == destino

					nueva_alternativa = alternativa.dup
					#nueva_alternativa.delete(destino)
					
					nodos_lista.each do |nodo_alternativo|
						next if nodo_alternativo == origen
						next if nodo_alternativo == destino
						next if nueva_alternativa.include? nodo_alternativo

						#nueva_alternativa << nodo_alternativo

						coste_alternativa = obtener_diferencia_soluciones(nueva_alternativa, coste_actual, destino, nodo_alternativo)

						if coste_alternativa > coste_actual
							coste_actual = coste_alternativa
							alternativa = nueva_alternativa.dup

							alternativa.delete(destino)
							alternativa.push(nodo_alternativo)
						end

						nueva_alternativa.delete(nodo_alternativo)
					end
				end
			end

			return alternativa, coste_actual
		end

		# Realiza una busqueda local a partir de una solucion aleatoria
		# utilizando un algoritmo de escalada basado en 
		# la tecnica de "first improvement", es decir, se acepta
		# la primera mejora conseguida y se continua de tratar
		# de mejorar a partir de ese punto. Se reciben tres
		# parametros que son:
		# - solucion generada de forma aleatoria
		# - coste_solucion generada de forma aleatoria
		def busqueda_local_first_improvement(solucion, coste_solucion)
			raise TypeError, "solucion debe de ser un Array" unless solucion.kind_of? Array
			raise TypeError, "coste_solucion debe de ser un valor numerico" unless coste_solucion.kind_of? Numeric
			#raise TypeError, "limite debe de ser un valor entero" unless limite.kind_of? Fixnum
			#raise TypeError, "El limite elegido es muy bajo, deberia de ser superior a #{total_nodes}" unless limite.>= total_nodes

			nodos_lista = lista_nodos.dup

			catch (:fin_busqueda) do
				loop do # Hasta el infinito y más alla
				#limite.times do
					catch (:new_solution) do # Permite volver a buscar en la nueva solucion
						solucion.each_with_index do |origen, index|
							nodos_lista.each do |destino|
								next if origen == destino

								nuevo_coste = obtener_diferencia_soluciones(solucion, coste_solucion, origen, destino)

								if nuevo_coste > coste_solucion
									coste_solucion = nuevo_coste
									solucion.delete(origen)
									solucion.push(destino)
									throw :new_solution
								end
							end

							# Si se llega a comprobar el ultimo nodo y no se ha lanzado
							# la excepcion :new_solution significa que no hay mejores
							# soluciones a las cuales acceder por lo que se termina el
							# ciclo de busqueda lanzando la excepcion :fin_busqueda
							if index == solucion.length - 1
								throw :fin_busqueda
							end
						end
					end
				end
			end

			return solucion, coste_solucion
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
				solucion , coste_actual = busqueda_local_best_improvement(solucion, coste_actual)
			elsif tipo == :first_improvement
				solucion, coste_actual = busqueda_local_first_improvement(solucion, coste_actual)
			else
				# Not implemented yet
			end
			return solucion, coste_actual
		end

		# Este metodo calcula la diferencia entre la solucion actual y otra solucion
		# obtenida como resultado de eliminar un nodo y añadir otro
		#
		# Los parametros de esta funcion son:
		# - solucion_actual: pasa como argumento la solucion actual
		# - coste_actual: pasa como argumento el coste actual
		# - nodo_eliminar: pasa como argumento el nodo que se borrara de la solucion,
		#   si el nodo no pertenece a la solucion se lanzara una excepcion TypeError
		# - new_node: el nodo nuevo que va a entrar en la solucion
		def obtener_diferencia_soluciones(solucion_actual, coste_actual, nodo_eliminar, new_node)
			raise TypeError, "solucion_actual debe de ser un Array" unless solucion_actual.kind_of? Array
			raise TypeError, "coste_actual debe de ser un valor numerico" unless coste_actual.kind_of? Numeric
			raise TypeError, "nodo_eliminar no se encuentra en la solucion_actual" unless solucion_actual.include? nodo_eliminar
			raise TypeError, "new node no ha sido reconocido dentro de los nodos leidos" unless lista_nodos.include? new_node

			particion_eliminar = Array.new
			particion_eliminar << nodo_eliminar
			solucion_actual = solucion_actual - particion_eliminar

			coste_nodo_eliminado = diversidad_minima(solucion_actual, nodo_eliminar)
			coste_nuevo_nodo = diversidad_minima(solucion_actual, new_node)

			coste_final = coste_actual - coste_nodo_eliminado + coste_nuevo_nodo

			# Se restaura solucion_actual ya que se ha cambiado en el proceso
			solucion_actual.push(nodo_eliminar)

			return coste_final
		end

		protected :busqueda_global, :busqueda_local_best_improvement, :obtener_diferencia_soluciones, :busqueda_local_first_improvement
	end
end