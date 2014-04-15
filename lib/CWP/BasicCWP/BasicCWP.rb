#! /usr/bin/env ruby -w

#! /usr/bin/env ruby
# encoding: utf-8

require_relative 'c_basic_cwp'

## El modulo CWP engloba a todas las clases pertenecientes al problema
## CWP
module CWP

	# BasicCWP establece la estructura básica para el problema Cut Width problem
	# el cual trata de ordenar usa serie de nodos de un grafo no dirigido de manera
	# se produzca el menor numero de cortes entre ellos.
	#
	# La implementación de BasicCWP es muy básica (como el nombre indica), y es
	# por ello que no proporciona una solución optima, ni siquiera cercana a la
	# optima, pero puede ser usada por otras clases para acercarse a una solución
	# que si sea optima o cercana a la solución optima
	class BasicCWP
		# El atributo grafo guarda una tabla de hash con cada
		# uno de los nodos del grafo. La tabla usara como
		# llave el nodo del grafo, y el valor que devolverá sera
		# un vector con todas las posiciones a las que se puede
		# ir a partir de dicho nodo
		attr_reader :grafo
		
		# Constructor de BasicCWP. Recibe como parámetro la localización
		# del archivo de texto que debe de leer para cargar la base
		# de datos.
		def initialize(path_db)
			leer_instancia(path_db)
		end
		
		# Lee una instancia de la base de datos y la almacena internamente
		#
		# Recibe como parámetro la localización de dicha instancia.
		# Este método cambia el contenido de :grafo
		def leer_instancia(path_db)
			raise TypeError, "path_db must be a string" unless path_db.kind_of? String
			
			@grafo = Hash.new(Array.new(0))
			
			File.open(path_db, "r") do |file|
				# La primera linea se desecha, ya que no me sirve
				file.gets
				
				# Ahora leemos el resto del fichero tranquilamente
				file.each do |linea|
					linea = linea.chomp.upcase
					nodoA, nodoB = linea.split(/ +/)
					@grafo[nodoA] = @grafo[nodoA].dup << nodoB
					@grafo[nodoB] = @grafo[nodoB].dup << nodoA
				end
			end
		end
		
		# Devuelve el numero total de nodos que hay en el grafo
		def total_nodes
			# En Ruby no es necesario usar la palabra return en una función
			# ya que siempre se devuelve la ultima expresión evaluada. Es
			# por ello que en esta función (y en otras), no se usa dicha
			# palabra
			@grafo.keys.length
		end
		
		# Devuelve el total de aristas que hay en el grafo
		def total_aristas
			count = 0
			@grafo.values.each do |value|
				count += value.length
			end
			
			count/2
		end
		
		# Genera una solución aleatoria y devuelve dicha solución
		# junto con el numero de cortes que se producen en dicha
		# solución.
		#
		# La solución se devuelve en forma de vector.
		def generar_solucion_aleatoria
			lista_nodos = @grafo.keys
			solucion = lista_nodos.sample(lista_nodos.length)
			coste = funcion_objetivo(solucion)
			return solucion, coste
		end
	end
end
