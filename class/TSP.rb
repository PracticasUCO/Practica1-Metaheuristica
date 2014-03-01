#! /usr/bin/env ruby -w

class TSP
	include Enumerable

	# caminos almacena los caminos almacenados de una ciudad a otra
	attr_reader :caminos

	# Numero de ciudades guardadas en la clase
	attr_reader :numero_ciudades

	# Lee el fichero de BD y lo carga en memoria
	def leer_intancia(path_db)
		raise TypeError, "path_db debe de ser un String" unless path_db.kind_of? String

		@caminos = Array.new

		File.open(path_db, "r") do |f|
			# La primera linea nos da información acerca del numero de ciudades que hay
			# almacenadas en el fichero
			#
			# Nosotros lo guardamos para poder consultarlo rapidamente en el futuro a
			# traves del metodo TSP#numero_ciudades
			@numero_ciudades = f.gets.to_i

			# Ahora podemos ir realizando una lectura completa del resto de la base de datos
			#
			# Uso el enumerador with_index para parar la ejecucion una vez que se haya leido
			# la mitad de la base de datos
			f.each_with_index do |linea, index|
				fila_costes = linea.chomp.split(/ +/)
				
				#Convertimos la fila de string a flotante
				fila_costes.each_with_index {|coste, index| fila_costes[index] = coste.to_f}

				#Añadimos la fila completa al array
				@caminos << fila_costes
			end
		end
	end

	# Accede a un elemento del la matriz de costes entre ciudades
	def [](index)
		@caminos[index]
	end

	# Iterador que accede a cada elemento de la matriz de costes
	def each
		@caminos.each do |ciudad|
			ciudad.each do |coste|
				yield coste
			end
		end
	end

	# Calcula el coste de una solucion dada
	#
	# Recibe como parametro un Array con las ciudades que se van a visitar
	def coste_solucion(ciudades)
		raise TypeError, "ciudades debe de ser un Array" unless ciudades.class.name == "Array"
		
		coste_actual = 0.0
		
		first = ciudades.each
		second = ciudades.each

		second.next

		loop do
			indexA = first.next
			indexB = second.next
			coste_actual += self[indexA][indexB]
		end

		coste_actual += self[ciudades[-1]][ciudades[0]]
		return coste_actual
	end

	# Calcula la solucion optima a base de calcular todas las permutaciones
	# entre las distinas ciudades. Devuelve la permutacion obtenida y
	# su coste
	#
	# No se recomienda el uso de este metodo, debido a que puede llegar a ser
	# bastante lento
	def solucion_optima
		coste_actual = Float::INFINITY # El coste inicial es infinito
		permutacion_optima = nil # De momento ninguna
		ciudades = Array.new(numero_ciudades) {|index| index}

		ciudades.permutation do |p|
			coste_permutacion = coste_solucion(p)

			if coste_permutacion < coste_actual
				coste_actual = coste_permutacion
				permutacion_optima = p.dup
			end
		end

		return permutacion_optima, coste_actual
	end

	# Genera una solucion aleatoria a traves de la heuristica
	# Recibe un parametro iteraciones que indica el numero maximo
	# de iteraciones a realizar para obtener dicha solucion.
	#
	# Si no se utiliza el parametro iteraciones, se asume que
	# vale 15_000 (quince mil)
	#
	# Devuelve la solucion generada, junto con el coste obtenido
	def generar_solucion_aleatoria(iteraciones = 15_000)
		coste_actual = Float::INFINITY # El coste inicial es infinito
		ciudades = Array.new(numero_ciudades) {|index| index}
		index = 0
		solucion_actual = nil # Aun no se ha almacenado ninguna solucion

		while index < iteraciones
			candidatos = ciudades.dup
			solucion = Array.new

			while not candidatos.empty?
				candidato_elegido = rand(candidatos.length)
				solucion << candidatos[candidato_elegido]
				candidatos.delete_at(candidato_elegido)
			end

			coste = coste_solucion(solucion)

			if coste < coste_actual
				coste_actual = coste
				solucion_actual = solucion
			end
			index += 1
		end

		return solucion_actual, coste_actual
	end

	# Constructor de la clase TSP. Recibe como argumento
	# el fichero del cual debe de leer la matriz de distancias
	def initialize(path_db)
		self.leer_intancia(path_db)
	end

	private :coste_solucion
end

a = TSP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/TSP/p01.txt")
lista, coste = a.generar_solucion_aleatoria
puts "Se ha encontrado la siguiente lista: #{lista} con un coste de #{coste}"