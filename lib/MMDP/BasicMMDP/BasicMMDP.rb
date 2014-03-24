#! /usr/bin/env ruby -w
#! /usr/bin/env ruby
# encoding: utf-8

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

		# El atributo clasificador indica que tipo de evaluación se
		# usara para la funcion objetivo. Estos valores pueden ser
		# :minima para realizar una evaluacion de la distancia minima
		# :media para realizar una clasificacion media
		attr_reader :clasificador
		
		# Constructor de MMDP. Recibe como parametro un string
		# con la direccion de la base de datos que se deseea leer
		#
		# Tambien recibe como parametro el tipo de clasificador de
		# la funcion objetivo, que por defecto sera :minima
		def initialize(path_db, clasificador = :minima)
			raise TypeError, "clasificador debe de ser un simbolo" unless clasificador.kind_of? Symbol
			raise TypeError, "clasificador solo admite los valores :minima y :media" unless clasificador.eql? :minima or clasificador.eql? :media
			leer_instancia(path_db)
			@clasificador = clasificador
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

				file.each do |linea|
					origen, destino, coste = linea.split(/ +/)
					signature = Array.new
					signature << origen << destino
					signature.sort!

					@lista_nodos.push(origen) if not @lista_nodos.include? origen

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
			coste_actual = obtener_suma_costes(solucion)

			return solucion, coste_actual	
		end

		# Devuelve la distancia o coste entre dos nodos.
		# Si no encuentra los nodos, devolvera cero
		def obtener_coste_entre(nodo_a, nodo_b)
			raise TypeError, "nodo_a must be a String" unless nodo_a.kind_of? String
			raise TypeError, "nodo_b must be a String" unless nodo_b.kind_of? String
			
			signature = Array.new
			signature << nodo_a << nodo_b
			signature.sort!

			return @nodes[signature] if @nodes.has_key? signature
			return 0 unless @nodes.has_key? signature
		end

		# Devuelve la suma de distancias o costes de un vector
		# solucion.
		#
		# Como parametros recibe un Array con lo elementos
		# que forman parte de la solucion.
		#
		# Opcionalmente puede recibir una serie de nuevos nodos
		# a añadir, en cuyo caso devolvera la cantidad total
		# que esos nodos contribuiran a la suma de costes (no 
		# la suma total del vector, sino la suma de los nuevos nodos)
		def obtener_suma_costes(solucion, *nuevo_nodo)
			raise TypeError, "El parametro solucion debe de ser un array" unless solucion.kind_of? Array

			if solucion.empty?
				return 0.0
			end

			coste = 0.0

			if nuevo_nodo.empty?
				solucion.each do |origen|
					solucion.each do |destino|
						next if origen == destino
						coste += obtener_coste_entre(origen, destino)
					end
				end

				# Se divide el coste entre dos ya que se ha sumado cada nodo dos veces
				coste /= 2 

			else
				solucion.each do |nodo|
					nuevo_nodo.each do |nuevo|
						coste += obtener_coste_entre(nodo, nuevo) unless solucion.include? nuevo
					end
				end
			end

			return coste
		end

		# Este metodo devuelve la diversidad minimia que existe en una solucion
		# Puede recibir una serie de nodos, en cuyo caso devolveria la diversidad
		# minima que habría despues de añadir dichos nodos
		def diversidad_minima(solucion, *nuevo_nodo)
			raise TypeError, "El parametro solucion debe de ser un array" unless solucion.kind_of? Array

			if solucion.empty?
				return 0.0
			end

			minimo = 0.0

			solucion.each do |origen|
				solucion.each do |destino|
					next if origen == destino
					valor = obtener_coste_entre(origen, destino)
					minimo = valor if valor < minimo
				end
			end
			
			unless nuevo_nodo.empty?
				solucion.each do |nodo|
					nuevo_nodo.each do |nuevo|
						valor = obtener_coste_entre(nodo, nuevo)
						minimo = obtener_coste_entre(nodo, nuevo) if minimo > valor
					end
				end
			end

			return minimo
		end

		# funcion_objetivo es un sinonimo de diversidad minima
		def funcion_objetivo(solucion, *nodo)
			if clasificador == :minima
				return diversidad_minima(solucion, nodo)
			else
				return obtener_suma_costes(solucion, nodo)
			end
		end

		# Definicion de los metodos privados de la clase
		private :obtener_coste_entre, :obtener_suma_costes, :diversidad_minima
	end
end