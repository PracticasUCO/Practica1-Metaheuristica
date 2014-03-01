#! /usr/bin/env ruby -w

=begin rdoc
La clase MMDP define una interfaz para el problema Max Min Diversity Problem
propuesto en clase.
=end
class MMDP
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

	# Realiza una busca local para tratar de mejorar lo maximo posible el
	# vector solucion
	# 
	# Recibe como parametros el array con la soluciones escogidas y
	#
	# Devuelve un vector solucion optimizado
	def busqueda_local(solucion)
		raise TypeError, "El parametro solucion debe ser un Array" unless solucion.kind_of? Array

		alternativa = solucion.dup
		nodos_lista = lista_nodos()
		coste_actual = obtener_suma_costes(solucion)

		solucion.each do |origen|
			solucion.each do |destino|
				next if origen == destino

				nueva_alternativa = alternativa.dup
				nueva_alternativa.delete(destino)
				
				nodos_lista.each do |nodo_alternativo|
					next if nodo_alternativo == origen
					next if nodo_alternativo == destino

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
		solucion = Array.new
		elementosRestringidos = lista_nodos().dup
		coste_actual = 0.0

		while solucion.size < self.solution_nodes
			posicion_elegida = rand elementosRestringidos.size
			coste_actual += obtener_suma_costes(solucion, elementosRestringidos[posicion_elegida])
			solucion << elementosRestringidos[posicion_elegida]
			elementosRestringidos.delete_at(posicion_elegida)
		end

		return solucion, coste_actual
	end

	# Devuelve la solucion optima del problema
	def solucion_optima
		coste = -1.0
		candidatos = lista_nodos().combination(solution_nodes())
		candidato_seleccionado = nil

		candidatos.each do |candidato|
			coste_candidato = obtener_suma_costes(candidato)
			if coste_candidato > coste
				coste = coste_candidato
				candidato_seleccionado = candidato
			end
		end

		return candidato_seleccionado, coste
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

	# Definicion de los metodos privados de la clase
	private :obtener_coste_entre, :obtener_suma_costes, :busqueda_global, :busqueda_local
end