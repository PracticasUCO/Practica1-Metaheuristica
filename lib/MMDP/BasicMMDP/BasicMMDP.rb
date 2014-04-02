#! /usr/bin/env ruby -w
#! /usr/bin/env ruby
# encoding: utf-8

require_relative 'c_basic_mmdp'

## El modulo MMDP engloba a todas las clases pertenecientes a MMDP
module MMDP
	# La clase BasicMMDP proporciona la funcionalidad basica para la
	# resolucion del problema Max Min Diversity Problem, el cual trata.
	#
	# En este problema se tiene un conjunto de N individuos, de los
	# cuales se trata de escoger M individuos (siendo M < N) de manera
	# que se maximize la diversidad entre los individuos elegidos
	#
	# La clase BasicMMDP solo proporciona una funcionalidad basica a
	# este problema, no alcanzado por ello la solucion optima
	class BasicMMDP
		# El atributo total_nodes indica el numero total de nodos que
		# hay en la base de datos
		attr_reader :total_nodes 

		# El atributo solution_nodes indica el numero maximo de nodos
		# que debe aparecer en la solucion
		attr_reader :solution_nodes

		# El atributo lista_nodos indica la lista de nodos que se ha
		# leido de la base de datos
		attr_reader :lista_nodos
		
		# Constructor de MMDP. Recibe como parametro un string
		# con la direccion de la base de datos que se deseea leer

		def initialize(path_db)
			leer_instancia(path_db)
		end

		# Lee una base de datos nueva y la carga dentro del fichero
		def leer_instancia(path_db)
			raise TypeError, "path_db must be a string" unless path_db.kind_of? String

			@nodes = Hash.new
			@lista_nodos = Array.new

			File.open(path_db, "r") do |file|
				m, n = file.gets.chomp.split(/ +/)

				if n.to_i > m.to_i
					error_string = <<-END_ERROR
					Error en la base de datos
					Numero total de nodos: #{m}
					Numero maximo de nodos: #{n}

					El numero maximo de nodos no puede ser mayour que
					el numero total de nodos.

					No se puede continuar
					END_ERROR
					error_string.gsub!(/\t/, "")

					raise error_string
				end

				@total_nodes = m.to_i
				@solution_nodes = n.to_i

				file.each_with_index do |linea, index|
					origen, destino, coste = linea.split(/ +/)
					signature = Array.new
					signature << origen << destino
					signature.sort!

					if index == 1
						@lista_nodos.push(origen)
					end
					@lista_nodos.push(destino) if not @lista_nodos.include? destino
					

					@nodes[signature] = coste.to_f if not @nodes.has_key? signature
				end
			end
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
			solucion = lista_nodos.sample(solution_nodes)
			coste_actual = diversidad_minima(solucion)

			return solucion, coste_actual	
		end

		# Definicion de los metodos privados de la clase
		private :obtener_coste_entre, :diversidad_minima
	end
end