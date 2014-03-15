#! /usr/bin/env ruby -w

require_relative("../BasicMMDP/BasicMMDP")

=begin rdoc
La clase MMDP define una interfaz para el problema Max Min Diversity Problem
propuesto en clase. Se usa las funcionalidades ya definidas en BasicMMDP
para tratar de conseguir una solucion mejor a traves de la heuristica
=end
class MMDP < BasicMMDP
	# Inicializa la clase para que carge los valores de la base de datos
	# Recibe como parametro un string indicando el lugar de donde
	# leer la base de datos
	def initialize(path_db)
		super
	end

	# Realiza una busca local para tratar de mejorar lo maximo posible el
	# vector solucion
	# 
	# Recibe como parametros el array con la soluciones escogidas y
	#
	# Devuelve un vector solucion optimizado
	def busqueda_local(solucion)
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
		solucion = lista_nodos().dup.sample(solution_nodes)
		coste_actual = obtener_suma_costes(solucion)

		return solucion, coste_actual
	end

	# Genera una solución aleatoriamente a partir de la base de datos
	# que se ha leido previamente. La solucion generada trata que
	# el coste sea el maximo posible. 
	#
	# Recibe como parametro el valor de seed, que indicara con que
	# valor se inicializa una secuencia aleatoria, en caso de
	# no introduccir ningún valor o de introduccir el valor cero
	# se usara el valor de Random.new_seed
	# 
	# Devuelve un vector con los nodos
	# seleccionados y un valor flotante con la suma de costes
	def generar_solucion_aleatoria
		solucion, coste_actual = busqueda_global
		solucion, coste_actual = busqueda_local(solucion)

		return solucion, coste_actual	
	end

	protected :busqueda_global, :busqueda_local
end