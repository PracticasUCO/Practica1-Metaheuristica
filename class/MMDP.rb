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
	
	# Constructor de MMDP. Recibe como parametro un string
	# con la direccion de la base de datos que se deseea leer
	def initialize(path_db)
		self.leerInstancia(path_db)
	end

	# Lee una base de datos nueva y la carga dentro del fichero
	def leerInstancia(path_db)
		@nodes = Hash.new

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
	def generar_solucion_aleatoria(seed = 0)
		raise TypeError, "El tipo del parametro seed es incorrecto" unless seed.is_a? Fixnum or seed.is_a? Bignum

		if seed == 0
			srand
		else
			srand seed
		end

		solucion = Array.new
		elementosRestringidos = Array.new(self.total_nodes) {|index| index}
		coste_actual = 0.0
		index = 0

		while solucion.size < self.solution_nodes
			posicion_elegida = rand elementosRestringidos.size
			coste_actual += obtener_suma_costes(solucion, elementosRestringidos[posicion_elegida])
			solucion << elementosRestringidos[posicion_elegida]
			elementosRestringidos.delete_at(posicion_elegida)
			index += 1
		end

		return solucion, coste_actual	
	end

	# Devuelve la distancia o coste entre dos nodos o nil en caso contrario
	def obtener_coste_entre(nodo_a, nodo_b)
		signature = Array.new
		signature << nodo_a.to_s << nodo_b.to_s
		signature.sort!

		return @nodes[signature] if @nodes.has_key? signature
	end

	# Devuelve la suma de costes de añadir un nuevo nodo a la solucion
	# El parametro solucion representa un array con la lista de
	# de nodos ya escogidos y el parametro nuevo_nodo representa
	# un nodo que se desea introduccir en la solucion.
	#
	# Tanto los nodos escogidos del array solucion, como el 
	# nuevo nodo deben de ser nodos leidos anteriormente de
	# la base de datos, de lo contrario el comportamiento
	# no esta definido.
	def obtener_suma_costes(solucion, nuevo_nodo)
		raise TypeError, "El parametro solucion debe de ser un array" unless solucion.class.name == "Array"

		if solucion.empty?
			return 0.0
		end

		coste = 0.0

		for nodo in solucion
			coste += obtener_coste_entre(nodo, nuevo_nodo)
		end

		return coste
	end
end

m = MMDP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/MMDP/GKD-Ia_1_n10_m2.txt")
m.generar_solucion_aleatoria()